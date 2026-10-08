import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
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

typedef _Placement = ({EkkloDailyMeal meal, EkkloDailyMealItem item});

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
    final placements = <String, _Placement>{
      for (final meal in day.ekkloMeals)
        for (final item in meal.items) item.id: (meal: meal, item: item),
    };
    final ownCopyIds = <String, String>{
      for (final planned in active)
        if (planned.choice case SendAsOwnCopy(reuse: final OwnCopy copy))
          planned.entry.food.id: copy.ekkloFoodId,
    };
    final steps = _steps(active, placements);
    final createdCopies = <String>[];
    var progress = SendProgress(steps: steps);
    onProgress(progress);
    for (final (index, step) in steps.indexed) {
      progress = progress.marking(index, StepState.running);
      onProgress(progress);
      try {
        switch (step) {
          case OwnCopyStep(:final mfpFoodId):
            final entry = active
                .firstWhere((planned) => planned.entry.food.id == mfpFoodId)
                .entry;
            final (ekkloFoodId, created) = await _ownCopy(entry);
            ownCopyIds[mfpFoodId] = ekkloFoodId;
            if (created) createdCopies.add(step.name);
          case QuantityUpdateStep(:final entryId):
            await _updateQuantity(
              active.firstWhere((planned) => planned.entryId == entryId),
              ownCopyIds,
            );
          case MealStep(:final ekkloMealName, :final entryIds):
            await _sendMeal(
              plan.date,
              ekkloMealName,
              [
                for (final planned in active)
                  if (entryIds.contains(planned.entryId)) planned,
              ],
              day.ekkloMeals,
              ownCopyIds,
            );
        }
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
    for (final planned in active) {
      if (memory.ekkloMealName(planned.entry.mealName) == null) {
        _memory.saveMeal(
          MealMapping(
            mfpMealName: planned.entry.mealName,
            ekkloMealName: planned.ekkloMealName,
          ),
        );
      }
      switch (planned.choice) {
        case SendToEkkloFood(
          :final ekkloFoodId,
          :final ekkloFoodName,
          :final remembered,
          :final weight,
          :final gramsPerUnit,
        ):
          if (!remembered) {
            _memory.saveFood(
              MatchedFood(
                mfpFoodId: planned.entry.food.id,
                mfpDescription: planned.entry.food.description,
                ekkloFoodId: ekkloFoodId,
                ekkloFoodName: ekkloFoodName,
              ),
            );
          }
          if ((weight, gramsPerUnit) case (
            UnitWeight.estimated || UnitWeight.confirmed,
            final double grams,
          )) {
            _memory.saveUnit(
              RememberedUnit(
                mfpFoodId: planned.entry.food.id,
                mfpUnit: planned.entry.servingSize.unit,
                grams: grams,
              ),
            );
          }
        case SendAsOwnCopy() || SkipEntry():
          break;
      }
    }
  }

  List<SendStep> _steps(
    List<PlannedEntry> active,
    Map<String, _Placement> placements,
  ) {
    final ownCopies = <String, OwnCopyStep>{
      for (final planned in active)
        if (planned.choice case SendAsOwnCopy(reuse: null))
          planned.entry.food.id: OwnCopyStep(
            mfpFoodId: planned.entry.food.id,
            name: productName(planned.entry.food),
          ),
    };
    final updates = [
      for (final planned in active)
        if (_updatesInPlace(planned, placements)) planned,
    ];
    final meals = <String, List<String>>{};
    for (final planned in active) {
      if (!updates.contains(planned)) {
        meals.putIfAbsent(planned.ekkloMealName, () => []).add(planned.entryId);
      }
    }
    return [
      ...ownCopies.values,
      for (final planned in updates)
        QuantityUpdateStep(
          entryId: planned.entryId,
          name: productName(planned.entry.food),
        ),
      for (final MapEntry(key: name, value: entryIds) in meals.entries)
        MealStep(ekkloMealName: name, entryIds: entryIds),
    ];
  }

  bool _updatesInPlace(
    PlannedEntry planned,
    Map<String, _Placement> placements,
  ) => switch ((planned.replacing, _target(planned, const {}))) {
    (final SentLink link, (final String foodId, final quantityType)) =>
      switch (placements[link.ekkloItemId]) {
        (:final meal, :final item) =>
          meal.name == planned.ekkloMealName &&
              item.foodId == foodId &&
              item.quantityType == quantityType,
        null => false,
      },
    _ => false,
  };

  (String, EkkloQuantityType)? _target(
    PlannedEntry planned,
    Map<String, String> ownCopyIds,
  ) => switch (planned.choice) {
    SendToEkkloFood(:final ekkloFoodId) => (
      ekkloFoodId,
      EkkloQuantityType.grams,
    ),
    SendAsOwnCopy(:final reuse) => switch (reuse?.ekkloFoodId ??
        ownCopyIds[planned.entry.food.id]) {
      final String id => (
        id,
        ownCopyQuantityType(planned.entry.servingSize.unit),
      ),
      null => null,
    },
    SkipEntry() => null,
  };

  Future<(String, bool)> _ownCopy(MfpFoodEntry entry) async {
    switch (_memory.load().food(entry.food.id)) {
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

  Future<void> _updateQuantity(
    PlannedEntry planned,
    Map<String, String> ownCopyIds,
  ) async {
    if ((planned.replacing, _target(planned, ownCopyIds)) case (
      final SentLink link,
      (final String foodId, final quantityType),
    )) {
      final expected = planned.expectedIn(foodId, quantityType);
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
  }

  Future<void> _sendMeal(
    DateTime date,
    String ekkloMealName,
    List<PlannedEntry> entries,
    List<EkkloDailyMeal> before,
    Map<String, String> ownCopyIds,
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
      for (final planned in entries)
        if (_target(planned, ownCopyIds) case (
          final String foodId,
          final quantityType,
        ))
          (planned, planned.expectedIn(foodId, quantityType)),
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
    _links.replace(
      dropped: const [],
      adopted: [
        for (final (planned, item) in expected)
          if (added
                  .where(
                    (candidate) =>
                        !claimed.contains(candidate.id) &&
                        item.matches(meal, candidate),
                  )
                  .firstOrNull
              case final EkkloDailyMealItem match)
            _claim(claimed, match, _link(planned, meal.id, match.id)),
      ],
    );
  }

  SentLink _claim(
    Set<String> claimed,
    EkkloDailyMealItem item,
    SentLink link,
  ) {
    claimed.add(item.id);
    return link;
  }

  SentLink _link(PlannedEntry planned, String mealId, String itemId) =>
      SentLink(
        mfpEntryId: planned.entryId,
        date: planned.entry.date,
        mfpFoodId: planned.entry.food.id,
        mfpMealName: planned.entry.mealName,
        mfpServings: planned.entry.servings,
        mfpServingValue: planned.entry.servingSize.value,
        mfpServingUnit: planned.entry.servingSize.unit,
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
