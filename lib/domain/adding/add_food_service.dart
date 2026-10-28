import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/add_stage.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/remembered_serving.dart';
import 'package:fujin/domain/adding/rescale_planned.dart';
import 'package:fujin/domain/adding/scan_outcome.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class AddFoodService {
  AddFoodService({
    required this._mfp,
    required this._ekklo,
    required this._sending,
    required this._memory,
    required this._recents,
    required this._clock,
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final SendService _sending;
  final MemoryRepository _memory;
  final RecentFoodRepository _recents;
  final DateTime Function() _clock;

  Future<AddOutcome>? _writing;

  Future<List<MfpFood>> search(
    String query, {
    required bool verifiedOnly,
  }) async => [
    for (final food in await _mfp.foods.search(
      query,
      verifiedOnly: verifiedOnly,
    ))
      if (food.servingSizes.isNotEmpty) food,
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
        final result => result,
      };

  Future<ScanOutcome> scan(String barcode) async {
    if (_memory.barcodeFood(barcode) case final foodId?) {
      if (await _mfp.foods.byId(foodId) case final food?
          when food.servingSizes.isNotEmpty) {
        return ScanFound(barcode, food, remembered: true);
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
  }) async => switch (await _mfp.foods.byId(mfpFoodId)) {
    final food? => switch (serving(food)) {
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
      final previous?
          when previous.entry.food == entry.food &&
              previous.entry.servingSize == entry.servingSize =>
        rescalePlanned(previous, entry, _memory.load()),
      _ => _sending.planOne(entry, entryId: AddDraft.pendingEntryId),
    };
  }

  Future<AddOutcome> add(
    AddDraft draft,
    PlannedEntry planned, {
    void Function(AddStage stage)? onStage,
    String? barcodeToLink,
  }) => _writing ??= _add(
    draft,
    planned,
    onStage,
    barcodeToLink,
  ).whenComplete(() => _writing = null);

  Future<AddOutcome> retryEkklo(AddedFood added) =>
      _writing ??= _toEkklo(added).whenComplete(() => _writing = null);

  Future<AddOutcome> _add(
    AddDraft draft,
    PlannedEntry planned,
    void Function(AddStage stage)? onStage,
    String? barcodeToLink,
  ) async {
    final String entryId;
    try {
      final current = await _mfp.foods.byId(draft.food.id);
      await _ekklo.meals.forDate(draft.date);
      if (current case final current?
          when current.version != draft.food.version) {
        return FoodChanged(before: draft.food, after: current);
      }
      onStage?.call(AddStage.mfp);
      entryId =
          await _mfp.diary.addFood(
            date: draft.date,
            mealName: draft.mfpMealName,
            food: draft.food,
            servingSize: draft.servingSize,
            servings: draft.servings,
          ) ??
          (throw StateError('MyFitnessPal returned no entry id'));
    } on Object catch (error) {
      return NotAdded(error);
    }
    final entry = draft.entry.copyWith(id: entryId);
    _recents.record(RecentFood.forEntry(entry, addedAt: _clock()));
    if (barcodeToLink case final barcode?) {
      _memory.saveBarcodeLink(
        BarcodeLink(barcode: barcode, mfpFoodId: draft.food.id),
      );
    }
    final added = AddedFood(
      planned: rescalePlanned(
        planned,
        entry,
        _memory.load(),
      ).copyWith(entryId: entryId),
      ekkloWritten: false,
    );
    onStage?.call(AddStage.ekklo);
    return _toEkklo(added);
  }

  Future<AddOutcome> _toEkklo(AddedFood added) async =>
      switch (await _sending.sendOne(added.planned)) {
        null => Added(added.copyWith(ekkloWritten: true)),
        final error => EkkloFailed(added, error),
      };
}
