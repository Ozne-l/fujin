import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/expected_item.dart';
import 'package:fujin/domain/comparison/placement.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/entry_planning.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/own_copy_draft.dart';
import 'package:fujin/domain/sending/plan_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/retained_weight.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:fujin/domain/sending/send_mode.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/domain/sending/step_state.dart';
import 'package:fujin/domain/sending/unit_weight.dart';

typedef _OwnCopyKey = (String foodId, String unit);
typedef _Update = ({
  PlannedEntry planned,
  LinkedItem item,
  ExpectedItem expected,
});
typedef _Work = (SendStep step, Future<void> Function() run);
typedef _Linked = ({Entry sent, String ekkloMealId, String ekkloItemId});

_OwnCopyKey _ownCopyKey(LoggedEntry entry) =>
    (entry.entry.foodId, entry.entry.servingUnit);

final class SendService {
  const SendService({
    required this._journal,
    required this._ekklo,
    required this._memory,
    required this._entries,
    required this._database,
    required this._clock,
  });

  final JournalService _journal;
  final EkkloClient _ekklo;
  final MemoryRepository _memory;
  final EntryRepository _entries;
  final FujinDatabase _database;
  final DateTime Function() _clock;

  Future<SendPlan> plan(
    DateTime date, {
    required void Function(SendPlan plan) onProgress,
  }) async {
    final day = await _journal.readDay(date);
    final memory = _memory.load();
    final toPlan = [
      for (final compared in day.entries)
        if ((compared.entryId, compared.status) case (
          _?,
          ToSend() || ToUpdate(),
        ))
          (
            compared.logged,
            switch (compared.status) {
              ToUpdate(:final link) => link,
              InEkklo() || ToSend() => null,
            },
          ),
    ];
    var plan = SendPlan(
      date: date,
      pending: [for (final (entry, _) in toPlan) entry],
      inEkklo: [
        for (final compared in day.entries)
          if (compared.status is InEkklo) compared,
      ],
    );
    onProgress(plan);
    for (final (entry, replacing) in toPlan) {
      final planned = await _planOne(
        (food, results) => planEntry(
          entry: entry,
          memory: memory,
          replacing: replacing,
          rememberedFood: food,
          searchResults: results,
        ),
      );
      plan = plan.copyWith(
        entries: [...plan.entries, planned],
        pending: plan.pending.skip(1).toList(),
      );
      onProgress(plan);
    }
    return plan;
  }

  Future<PlannedEntry> planOne(LoggedEntry entry) {
    final memory = _memory.load();
    return _planOne(
      (food, results) => planEntry(
        entry: entry,
        memory: memory,
        rememberedFood: food,
        searchResults: results,
      ),
    );
  }

  Future<Object?> sendOne(PlannedEntry planned) async {
    try {
      await send(
        SendPlan(date: planned.entry.entry.date, entries: [planned]),
        mode: SendMode.reviewed,
        onProgress: (_) {},
      );
    } on SendInterruption catch (interruption) {
      return interruption.cause;
    } on Object catch (error) {
      return error;
    }
    return switch (_entries.find(planned.entryId)?.ekkloLink?.item) {
      _? => null,
      null => StateError('Entry ${planned.entryId} is not linked'),
    };
  }

  Future<void> removeLinked(EkkloLink link) async {
    if (link.item case final item?) {
      await _ekklo.meals.removeItem(
        mealId: item.ekkloMealId,
        itemId: item.ekkloItemId,
      );
      _entries.unlinkItem(link.entryId);
    }
  }

  Future<List<EkkloCandidate>> search(
    PlannedEntry planned,
    String query,
  ) async => rankCandidates(
    await _ekklo.foods.search(query),
    planned.entry,
    gramsPerUnit: planned.rememberedGramsPerUnit,
  );

  Future<SendReport> send(
    SendPlan plan, {
    required SendMode mode,
    required void Function(SendProgress progress) onProgress,
  }) async {
    final day = await _journal.readDay(plan.date);
    final statuses = {
      for (final compared in day.entries) ?compared.entryId: compared.status,
    };
    final active = [
      for (final planned in plan.entries)
        if (planned.sends)
          ?switch (statuses[planned.entryId]) {
            ToSend() => planned.copyWith(replacing: null),
            ToUpdate(:final link) => planned.copyWith(replacing: link),
            InEkklo() || null => null,
          },
    ];
    if (mode == SendMode.reviewed) _remember(active);
    final ownCopyIds = <_OwnCopyKey, String>{
      for (final planned in active)
        if (planned.choice case SendAsOwnCopy(reuse: final OwnCopy copy))
          _ownCopyKey(planned.entry): copy.ekkloFoodId,
    };
    final createdCopies = <String>[];
    final work = _work(
      plan.date,
      mode,
      active,
      day.ekkloMeals,
      ownCopyIds,
      createdCopies,
    );
    var progress = SendProgress(steps: [for (final (step, _) in work) step]);
    onProgress(progress);
    for (final (index, (_, run)) in work.indexed) {
      progress = progress.marking(index, StepState.running);
      onProgress(progress);
      try {
        await run();
      } on Object catch (error) {
        progress = progress.marking(index, StepState.failed);
        onProgress(progress);
        throw SendInterruption(progress, error);
      }
      progress = progress.marking(index, StepState.done);
      onProgress(progress);
    }
    return _report(plan.date, mode, active, createdCopies);
  }

  Future<void> keep(PlannedEntry planned) async {
    if (planned.choice case SendAsOwnCopy()) await _ownCopy(planned.entry);
    _remember([planned]);
    if ((
          ExpectedItem.forEntry(planned.entry, _memory.load()),
          _entries.find(planned.entryId)?.ekkloLink?.unattended,
        )
        case (
          final expected?,
          final sent?,
        ) when expected.sameAs(ExpectedItem.unattended(sent))) {
      _entries.forgetExpectations([planned.entryId]);
    }
  }

  Future<PlannedEntry> _planOne(
    EntryPlanning Function(EkkloFood? food, List<EkkloFood>? results) plan, [
    EkkloFood? food,
    List<EkkloFood>? results,
  ]) async => switch (plan(food, results)) {
    Planned(:final planned) => planned,
    NeedsEkkloFood(:final ekkloFoodId) => _planOne(
      plan,
      await _ekklo.foods.byId(ekkloFoodId),
      results,
    ),
    NeedsSearch(:final terms) => _planOne(plan, food, switch (terms) {
      '' => const [],
      _ => await _ekklo.foods.search(terms),
    }),
  };

  void _remember(List<PlannedEntry> active) {
    final memory = _memory.load();
    _memory.remember(
      meals: [
        for (final planned in active)
          if (memory.ekkloMealName(planned.entry.mealName) == null)
            MealMapping(
              mfpMealName: planned.entry.mealName,
              ekkloMealName: planned.ekkloMealName,
            ),
      ],
      foods: [
        for (final planned in active)
          if ((planned.entry.mfpFoodId, planned.choice) case (
            final mfpFoodId?,
            SendToEkkloFood(
              :final ekkloFoodId,
              :final ekkloFoodName,
              remembered: false,
            ),
          ))
            MatchedFood(
              mfpFoodId: mfpFoodId,
              mfpDescription: productName(planned.entry),
              ekkloFoodId: ekkloFoodId,
              ekkloFoodName: ekkloFoodName,
            ),
      ],
      units: [
        for (final planned in active)
          if ((planned.entry.mfpFoodId, planned.choice) case (
            final mfpFoodId?,
            SendToEkkloFood(
              weight: UnitWeight.estimated || UnitWeight.confirmed,
              gramsPerUnit: final double grams,
            ),
          ))
            RememberedUnit(
              mfpFoodId: mfpFoodId,
              mfpUnit: planned.entry.entry.servingUnit,
              grams: grams,
            ),
      ],
    );
  }

  List<_Work> _work(
    DateTime date,
    SendMode mode,
    List<PlannedEntry> active,
    List<EkkloDailyMeal> before,
    Map<_OwnCopyKey, String> ownCopyIds,
    List<String> createdCopies,
  ) {
    final placements = placementsOf(before);
    final ownCopies = <_OwnCopyKey, LoggedEntry>{
      for (final planned in active)
        if (planned.choice case SendAsOwnCopy(reuse: null))
          _ownCopyKey(planned.entry): planned.entry,
    };
    final updates = <String, _Update>{
      for (final planned in active)
        if (_inPlace(planned, placements) case final _Update update)
          planned.entryId: update,
    };
    final meals = <String, List<PlannedEntry>>{};
    for (final planned in active) {
      if (!updates.containsKey(planned.entryId)) {
        meals.putIfAbsent(planned.ekkloMealName, () => []).add(planned);
      }
    }
    return [
      for (final MapEntry(:key, value: entry) in ownCopies.entries)
        (
          OwnCopyStep(
            foodId: entry.entry.foodId,
            unit: entry.entry.servingUnit,
            name: productName(entry),
          ),
          () async {
            final (ekkloFoodId, created) = await _ownCopy(entry);
            ownCopyIds[key] = ekkloFoodId;
            if (created) createdCopies.add(productName(entry));
          },
        ),
      for (final update in updates.values)
        (
          QuantityUpdateStep(
            entryId: update.planned.entryId,
            name: productName(update.planned.entry),
          ),
          () => _updateQuantity(mode, update),
        ),
      for (final MapEntry(key: name, value: entries) in meals.entries)
        (
          MealStep(
            ekkloMealName: name,
            entryIds: [for (final planned in entries) planned.entryId],
          ),
          () => _sendMeal(mode, date, name, entries, before, ownCopyIds),
        ),
    ];
  }

  _Update? _inPlace(PlannedEntry planned, Map<String, Placement> placements) =>
      switch ((planned.replacing?.item, _knownTarget(planned))) {
        (final linked?, final expected?) =>
          switch (placements[linked.ekkloItemId]) {
            (:final meal, :final item)
                when meal.name == expected.ekkloMealName &&
                    item.foodId == expected.ekkloFoodId &&
                    item.quantityType == expected.quantityType =>
              (planned: planned, item: linked, expected: expected),
            _ => null,
          },
        _ => null,
      };

  ExpectedItem? _knownTarget(PlannedEntry planned) => switch (planned.choice) {
    SendToEkkloFood(:final ekkloFoodId) => planned.expectedIn(
      ekkloFoodId,
      EkkloQuantityType.grams,
    ),
    SendAsOwnCopy(reuse: final OwnCopy copy) => planned.expectedIn(
      copy.ekkloFoodId,
      ownCopyQuantityType(planned.entry.entry.servingUnit),
    ),
    SendAsOwnCopy() || SkipEntry() => null,
  };

  ExpectedItem _target(
    PlannedEntry planned,
    Map<_OwnCopyKey, String> ownCopyIds,
  ) =>
      switch ((_knownTarget(planned), ownCopyIds[_ownCopyKey(planned.entry)])) {
        (final expected?, _) => expected,
        (null, final ekkloFoodId?) => planned.expectedIn(
          ekkloFoodId,
          ownCopyQuantityType(planned.entry.entry.servingUnit),
        ),
        (null, null) => throw StateError(
          'No Ekklo food for entry ${planned.entryId}',
        ),
      };

  Future<(String, bool)> _ownCopy(LoggedEntry entry) async {
    final unit = entry.entry.servingUnit;
    switch (switch (entry.mfpFoodId) {
      final mfpFoodId? => _memory.load().food(mfpFoodId, unit),
      null => null,
    }) {
      case final OwnCopy copy when isFresh(copy, entry):
        return (copy.ekkloFoodId, false);
      case OwnCopy() || MatchedFood() || null:
        final created = await _ekklo.foods.createOwn(ownCopyDraft(entry));
        if (entry.mfpFoodId case final mfpFoodId?) {
          _memory.saveFood(
            OwnCopy(
              mfpFoodId: mfpFoodId,
              mfpDescription: productName(entry),
              ekkloFoodId: created.id,
              ekkloFoodName: created.name,
              mfpUnit: unit,
              mfpFoodVersion: entry.mfpLink?.foodVersion,
            ),
          );
        }
        return (created.id, true);
    }
  }

  List<String> _expect(
    SendMode mode,
    List<(PlannedEntry, ExpectedItem)> targets,
  ) {
    final memory = _memory.load();
    final unattended = {
      for (final (planned, target) in targets)
        if (switch (mode) {
          SendMode.reviewed => false,
          SendMode.automatic =>
            planned.reviewed ||
                !(ExpectedItem.forEntry(
                      planned.entry,
                      memory,
                    )?.sameAs(target) ??
                    false),
        })
          planned.entryId: target.asUnattended,
    };
    _entries.expect(unattended);
    return [
      for (final (planned, _) in targets)
        if (!unattended.containsKey(planned.entryId)) planned.entryId,
    ];
  }

  Future<void> _updateQuantity(SendMode mode, _Update update) async {
    final (:planned, :item, :expected) = update;
    final attended = _expect(mode, [(planned, expected)]);
    final updated = await _ekklo.meals.updateItemQuantity(
      mealId: item.ekkloMealId,
      itemId: item.ekkloItemId,
      quantity: expected.quantity,
      quantityType: expected.quantityType,
    );
    _database.transaction(() {
      switch (updated.id == item.ekkloItemId) {
        case true:
          _entries.refreshLink(planned.entryId, sent: planned.entry.entry);
        case false:
          _entries.linkItem(
            planned.entryId,
            ekkloMealId: item.ekkloMealId,
            ekkloItemId: updated.id,
            sent: planned.entry.entry,
          );
      }
      _entries.forgetExpectations(attended);
    });
  }

  Future<void> _sendMeal(
    SendMode mode,
    DateTime date,
    String ekkloMealName,
    List<PlannedEntry> entries,
    List<EkkloDailyMeal> before,
    Map<_OwnCopyKey, String> ownCopyIds,
  ) async {
    final expected = [
      for (final planned in entries) (planned, _target(planned, ownCopyIds)),
    ];
    final attended = _expect(mode, expected);
    for (final planned in entries) {
      if (planned.replacing case final link?) await removeLinked(link);
    }
    final known = {
      for (final meal in before)
        if (meal.name == ekkloMealName)
          for (final item in meal.items) item.id,
    };
    final meal = await _ekklo.meals.appendItems(
      date: date,
      name: ekkloMealName,
      items: [
        for (final (_, item) in expected)
          EkkloMealItemDraft.food(
            foodId: item.ekkloFoodId,
            quantity: item.quantity,
            quantityType: item.quantityType,
          ),
      ],
    );
    final added = [
      for (final item in meal.items)
        if (!known.contains(item.id)) item,
    ];
    final claimed = <String>{};
    final linked = <_Linked>[];
    for (final (planned, item) in expected) {
      if (added
              .where(
                (candidate) =>
                    !claimed.contains(candidate.id) &&
                    item.matches(meal, candidate),
              )
              .firstOrNull
          case final match?) {
        claimed.add(match.id);
        linked.add((
          sent: planned.entry.entry,
          ekkloMealId: meal.id,
          ekkloItemId: match.id,
        ));
      }
    }
    _database.transaction(() {
      for (final (:sent, :ekkloMealId, :ekkloItemId) in linked) {
        _entries.linkItem(
          sent.id,
          ekkloMealId: ekkloMealId,
          ekkloItemId: ekkloItemId,
          sent: sent,
        );
      }
      _entries.forgetExpectations(attended);
    });
  }

  SendReport _report(
    DateTime date,
    SendMode mode,
    List<PlannedEntry> active,
    List<String> createdCopies,
  ) {
    final weights = <(String, String), RetainedWeight>{
      for (final planned in active)
        if (planned.choice case SendToEkkloFood(
          weight: UnitWeight.estimated || UnitWeight.confirmed,
          gramsPerUnit: final double grams,
        ))
          (
            planned.entry.entry.foodId,
            planned.entry.entry.servingUnit,
          ): RetainedWeight(
            unit: planned.entry.entry.servingUnit,
            grams: grams,
          ),
    };
    return SendReport(
      date: date,
      sentAt: _clock(),
      mode: mode,
      sent: active.length,
      reused: active
          .where(
            (planned) =>
                !planned.reviewed &&
                switch (planned.choice) {
                  SendAsOwnCopy(reuse: null) => false,
                  SendToEkkloFood() || SendAsOwnCopy() || SkipEntry() => true,
                },
          )
          .length,
      updated: active.where((planned) => planned.replacing != null).length,
      newAssociations: {
        for (final planned in active)
          if (planned.choice case SendToEkkloFood(remembered: false))
            productName(planned.entry),
      }.toList(),
      weights: weights.values.toList(),
      ownCopies: createdCopies,
      unattended: switch (mode) {
        SendMode.reviewed => const [],
        SendMode.automatic => [
          for (final planned in active)
            if (planned.reviewed) planned,
        ],
      },
    );
  }
}
