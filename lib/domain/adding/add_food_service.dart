import 'dart:async';

import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/known_food.dart';
import 'package:fujin/domain/adding/remembered_serving.dart';
import 'package:fujin/domain/adding/rescale_planned.dart';
import 'package:fujin/domain/adding/scan_outcome.dart';
import 'package:fujin/domain/memory/memory_rules.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class AddFoodService {
  AddFoodService({
    required this._mfp,
    required this._sending,
    required this._memory,
    required this._foods,
    required this._recents,
    required this._writer,
    required this._background,
    required this._clock,
  });

  final MyFitnessPalClient _mfp;
  final SendService _sending;
  final MemoryRepository _memory;
  final FoodRepository _foods;
  final RecentFoodRepository _recents;
  final EntryWriter _writer;
  final BackgroundWriter _background;
  final DateTime Function() _clock;

  Future<List<MfpFood>> search(
    String query, {
    required bool verifiedOnly,
  }) async => [
    for (final food in await _mfp.foods.search(
      query,
      verifiedOnly: verifiedOnly,
    ))
      if (food.servingSizes.isNotEmpty) _filled(food),
  ];

  Future<MfpBarcodeResult> byBarcode(String barcode) async =>
      switch (await _mfp.foods.byBarcode(barcode)) {
        MfpBarcodeFound(:final food) when food.servingSizes.isEmpty =>
          MfpBarcodeUnresolved(
            barcode,
            foodId: food.id,
            description: food.description,
            brandName: food.brandName,
          ),
        MfpBarcodeFound(:final food) => MfpBarcodeFound(barcode, _filled(food)),
        final result => result,
      };

  Future<ScanOutcome> scan(String barcode) async {
    if (_memory.barcodeFood(barcode) case final foodId?) {
      if (await knownFood(foodId, mfp: _mfp, foods: _foods) case final food?
          when food.servingSizes.isNotEmpty) {
        return ScanFound(barcode, _filled(food), remembered: true);
      }
    }
    return switch (await byBarcode(barcode)) {
      MfpBarcodeFound(:final food) => ScanFound(
        barcode,
        food,
        remembered: false,
      ),
      MfpBarcodeUnresolved(:final description, :final brandName) =>
        ScanUnresolved(
          barcode,
          description: description,
          brandName: brandName,
        ),
      MfpBarcodeUnknown() => ScanUnknown(barcode),
    };
  }

  List<RecentFood> recents() => _recents.latest();

  Future<AddDraft?> reopen(
    RecentFood recent, {
    required String mfpMealName,
    required DateTime date,
  }) => _open(
    recent.mfpFoodId,
    mfpMealName: mfpMealName,
    date: date,
    serving: (_) => (recent.servingSize, recent.servings),
  );

  Memory memory() => _memory.load();

  List<MfpFood> onPhone(String query) =>
      foodsOnPhone(_foods.onPhoneFoods(), query);

  Future<AddDraft?> openRemembered(
    RememberedFood remembered, {
    required String mfpMealName,
    required DateTime date,
  }) => _open(
    remembered.mfpFoodId,
    mfpMealName: mfpMealName,
    date: date,
    serving: (food) => (
      rememberedServing(
        food,
        remembered: remembered,
        memory: _memory.load(),
        recents: _recents.latest(),
      ),
      AddDraft.oneServing,
    ),
  );

  Future<AddDraft?> _open(
    String mfpFoodId, {
    required String mfpMealName,
    required DateTime date,
    required (MfpServingSize?, double) Function(MfpFood food) serving,
  }) async => switch (await knownFood(mfpFoodId, mfp: _mfp, foods: _foods)) {
    final food? => switch (serving(_filled(food))) {
      (final servingSize, final servings) => AddDraft.of(
        food,
        mfpMealName: mfpMealName,
        date: date,
        servingSize: servingSize,
        servings: servings,
      ),
    },
    null => null,
  };

  Future<PlannedEntry> plan(AddDraft draft, {PlannedEntry? previous}) async {
    final entry = draft.entry;
    return switch (previous) {
      final previous? when _sameServing(previous.entry, entry) =>
        rescalePlanned(previous, entry, _memory.load()),
      _ => _sending.planOne(entry),
    };
  }

  AddedFood add(
    AddDraft draft,
    PlannedEntry? planned, {
    String? barcodeToLink,
  }) {
    final stored = _writer.store(
      draft,
      entryId: _writer.newEntryId(),
      alongside: () {
        _recents.record(
          RecentFood.forEntry(draft.mfpEntry, addedAt: _clock()),
        );
        _foods.fill(draft.food);
        if (barcodeToLink case final barcode?) {
          _memory.saveBarcodeLink(
            BarcodeLink(barcode: barcode, mfpFoodId: draft.food.id),
          );
        }
      },
    );
    final added = AddedFood(
      entry: stored,
      planned: switch (planned) {
        final planned? => rescalePlanned(planned, stored, _memory.load()),
        null => null,
      },
    );
    if (added.planned case final planned? when planned.sends) {
      _background.hold(added.entryId, EkkloSend(planned));
    }
    unawaited(_background.run());
    return added;
  }

  static bool _sameServing(LoggedEntry before, LoggedEntry after) =>
      before.mfpFoodId == after.mfpFoodId &&
      before.foodName == after.foodName &&
      before.brand == after.brand &&
      before.mfpLink?.foodVersion == after.mfpLink?.foodVersion &&
      before.entry.servingValue == after.entry.servingValue &&
      before.entry.servingUnit == after.entry.servingUnit &&
      before.entry.nutritionMultiplier == after.entry.nutritionMultiplier;

  MfpFood _filled(MfpFood food) {
    _foods.fill(food);
    return food;
  }
}
