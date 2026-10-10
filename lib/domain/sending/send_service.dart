import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
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
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/domain/sending/step_state.dart';
import 'package:fujin/domain/sending/unit_weight.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

typedef _OwnCopyKey = (String mfpFoodId, String mfpUnit);
typedef _Update = ({
  PlannedEntry planned,
  SentLink link,
  ExpectedItem expected,
});
typedef _Work = (SendStep step, Future<void> Function() run);

_OwnCopyKey _ownCopyKey(MfpFoodEntry entry) =>
    (entry.food.id, entry.servingSize.unit);

final class SendService {
  const SendService({
    required this._journal,
    required this._ekklo,
    required this._memory,
    required this._links,
    required this._clock,
  });

  final JournalService _journal;
  final EkkloClient _ekklo;
  final MemoryRepository _memory;
  final SentLinkRepository _links;
  final DateTime Function() _clock;

  Future<SendPlan> plan(
    DateTime date, {
    required void Function(SendPlan plan) onProgress,
  }) async {
    final day = await _journal.readDay(date);
    final memory = _memory.load();
    final toPlan = [
      for (final compared in day.comparison.entries)
        if ((compared.entry.id, compared.status) case (
          final String id,
          ToSend() || ToUpdate(),
        ))
          (
            compared.entry,
            id,
            switch (compared.status) {
              ToUpdate(:final link) => link,
              InEkklo() || ToSend() => null,
            },
          ),
    ];
    var plan = SendPlan(
      date: date,
      pending: [for (final (entry, _, _) in toPlan) entry],
      inEkklo: [
        for (final compared in day.comparison.entries)
          if (compared.status is InEkklo) compared,
      ],
    );
    onProgress(plan);
    for (final (entry, id, replacing) in toPlan) {
      final planned = await _planOne(
        (food, results) => planEntry(
          entry: entry,
          entryId: id,
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
    required void Function(SendProgress progress) onProgress,
  }) async {
    final day = await _journal.readDay(plan.date);
    final statuses = {
      for (final compared in day.comparison.entries)
        if (compared.entry.id case final String id) id: compared.status,
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
    _remember(active);
    final ownCopyIds = <_OwnCopyKey, String>{
      for (final planned in active)
        if (planned.choice case SendAsOwnCopy(reuse: final OwnCopy copy))
          _ownCopyKey(planned.entry): copy.ekkloFoodId,
    };
    final createdCopies = <String>[];
    final work = _work(
      plan.date,
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
    return _report(plan.date, active, createdCopies);
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
          if (planned.choice case SendToEkkloFood(
            :final ekkloFoodId,
            :final ekkloFoodName,
            remembered: false,
          ))
            MatchedFood(
              mfpFoodId: planned.entry.food.id,
              mfpDescription: planned.entry.food.description,
              ekkloFoodId: ekkloFoodId,
              ekkloFoodName: ekkloFoodName,
            ),
      ],
      units: [
        for (final planned in active)
          if (planned.choice case SendToEkkloFood(
            weight: UnitWeight.estimated || UnitWeight.confirmed,
            gramsPerUnit: final double grams,
          ))
            RememberedUnit(
              mfpFoodId: planned.entry.food.id,
              mfpUnit: planned.entry.servingSize.unit,
              grams: grams,
            ),
      ],
    );
  }

  List<_Work> _work(
    DateTime date,
    List<PlannedEntry> active,
    List<EkkloDailyMeal> before,
    Map<_OwnCopyKey, String> ownCopyIds,
    List<String> createdCopies,
  ) {
    final placements = placementsOf(before);
    final ownCopies = <_OwnCopyKey, MfpFoodEntry>{
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
            mfpFoodId: entry.food.id,
            mfpUnit: entry.servingSize.unit,
            name: productName(entry.food),
          ),
          () async {
            final (ekkloFoodId, created) = await _ownCopy(entry);
            ownCopyIds[key] = ekkloFoodId;
            if (created) createdCopies.add(productName(entry.food));
          },
        ),
      for (final update in updates.values)
        (
          QuantityUpdateStep(
            entryId: update.planned.entryId,
            name: productName(update.planned.entry.food),
          ),
          () => _updateQuantity(update),
        ),
      for (final MapEntry(key: name, value: entries) in meals.entries)
        (
          MealStep(
            ekkloMealName: name,
            entryIds: [for (final planned in entries) planned.entryId],
          ),
          () => _sendMeal(date, name, entries, before, ownCopyIds),
        ),
    ];
  }

  _Update? _inPlace(PlannedEntry planned, Map<String, Placement> placements) =>
      switch ((planned.replacing, _knownTarget(planned))) {
        (final SentLink link, final ExpectedItem expected) =>
          switch (placements[link.ekkloItemId]) {
            (:final meal, :final item)
                when meal.name == expected.ekkloMealName &&
                    item.foodId == expected.ekkloFoodId &&
                    item.quantityType == expected.quantityType =>
              (planned: planned, link: link, expected: expected),
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
      ownCopyQuantityType(planned.entry.servingSize.unit),
    ),
    SendAsOwnCopy() || SkipEntry() => null,
  };

  ExpectedItem _target(
    PlannedEntry planned,
    Map<_OwnCopyKey, String> ownCopyIds,
  ) =>
      switch ((_knownTarget(planned), ownCopyIds[_ownCopyKey(planned.entry)])) {
        (final ExpectedItem expected, _) => expected,
        (null, final String ekkloFoodId) => planned.expectedIn(
          ekkloFoodId,
          ownCopyQuantityType(planned.entry.servingSize.unit),
        ),
        (null, null) => throw StateError(
          'No Ekklo food for entry ${planned.entryId}',
        ),
      };

  Future<(String, bool)> _ownCopy(MfpFoodEntry entry) async {
    switch (_memory.load().food(entry.food.id, entry.servingSize.unit)) {
      case final OwnCopy copy when isFresh(copy, entry):
        return (copy.ekkloFoodId, false);
      case OwnCopy() || MatchedFood() || null:
        final created = await _ekklo.foods.createOwn(ownCopyDraft(entry));
        _memory.saveFood(
          OwnCopy(
            mfpFoodId: entry.food.id,
            mfpDescription: entry.food.description,
            ekkloFoodId: created.id,
            ekkloFoodName: created.name,
            mfpUnit: entry.servingSize.unit,
            mfpFoodVersion: entry.food.version,
          ),
        );
        return (created.id, true);
    }
  }

  Future<void> _updateQuantity(_Update update) async {
    final (:planned, :link, :expected) = update;
    final item = await _ekklo.meals.updateItemQuantity(
      mealId: link.ekkloMealId,
      itemId: link.ekkloItemId,
      quantity: expected.quantity,
      quantityType: expected.quantityType,
    );
    _links.replace(
      dropped: [link],
      adopted: [_link(planned, link.ekkloMealId, item.id)],
    );
  }

  Future<void> _sendMeal(
    DateTime date,
    String ekkloMealName,
    List<PlannedEntry> entries,
    List<EkkloDailyMeal> before,
    Map<_OwnCopyKey, String> ownCopyIds,
  ) async {
    for (final planned in entries) {
      if (planned.replacing case final SentLink link) {
        await _ekklo.meals.removeItem(
          mealId: link.ekkloMealId,
          itemId: link.ekkloItemId,
        );
        _links.replace(dropped: [link], adopted: const []);
      }
    }
    final expected = [
      for (final planned in entries) (planned, _target(planned, ownCopyIds)),
    ];
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
    final adopted = <SentLink>[];
    for (final (planned, item) in expected) {
      if (added
              .where(
                (candidate) =>
                    !claimed.contains(candidate.id) &&
                    item.matches(meal, candidate),
              )
              .firstOrNull
          case final EkkloDailyMealItem match) {
        claimed.add(match.id);
        adopted.add(_link(planned, meal.id, match.id));
      }
    }
    _links.replace(dropped: const [], adopted: adopted);
  }

  SentLink _link(PlannedEntry planned, String mealId, String itemId) =>
      SentLink.forEntry(
        planned.entry,
        entryId: planned.entryId,
        ekkloMealId: mealId,
        ekkloItemId: itemId,
        sentAt: _clock(),
      );

  SendReport _report(
    DateTime date,
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
            planned.entry.food.id,
            planned.entry.servingSize.unit,
          ): RetainedWeight(
            unit: planned.entry.servingSize.unit,
            grams: grams,
          ),
    };
    return SendReport(
      date: date,
      sentAt: _clock(),
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
            productName(planned.entry.food),
      }.toList(),
      weights: weights.values.toList(),
      ownCopies: createdCopies,
    );
  }
}
