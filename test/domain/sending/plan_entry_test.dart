import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/sending/entry_planning.dart';
import 'package:fujin/domain/sending/plan_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

EntryPlanning plan(
  MfpFoodEntry entry, {
  Memory remembered = memory,
  EkkloFood? rememberedFood,
  List<EkkloFood>? searchResults,
}) => planEntry(
  entry: entry,
  entryId: entry.id ?? '',
  memory: remembered,
  rememberedFood: rememberedFood,
  searchResults: searchResults,
);

Subject<PlannedEntry> planned(EntryPlanning planning) =>
    check(planning).isA<Planned>().has((it) => it.planned, 'planned');

final copiedOil = Memory(
  ownCopies: [
    OwnCopy(
      mfpFoodId: oil,
      mfpDescription: oilEntry.food.description,
      ekkloFoodId: 'own-oil',
      ekkloFoodName: oilEntry.food.description,
      mfpUnit: tablespoon,
      mfpFoodVersion: 'v1',
    ),
  ],
);

void main() {
  group('a remembered food', () {
    test('is sent without review when its grams are known', () {
      final planning = plan(entry('E-1', servings: 1.5));

      planned(planning)
        ..has((it) => it.reviewed, 'reviewed').isFalse()
        ..has((it) => it.ekkloMealName, 'meal').equals(petitDejeuner)
        ..has((it) => it.choice, 'choice').equals(
          const SendToEkkloFood(
            ekkloFoodId: oatsInEkklo,
            ekkloFoodName: oatsInEkklo,
            grams: 150,
            remembered: true,
          ),
        );
    });

    test('converts a remembered unit to grams', () {
      final planning = plan(
        entry('E-1', food: rice, unit: cup, servingValue: 1, servings: 2),
      );

      planned(planning)
          .has((it) => it.choice, 'choice')
          .equals(
            const SendToEkkloFood(
              ekkloFoodId: riceInEkklo,
              ekkloFoodName: riceInEkklo,
              grams: 360,
              remembered: true,
              weight: UnitWeight.remembered,
              gramsPerUnit: 180,
            ),
          );
    });

    test('asks for its Ekklo food, then for the weight of a new unit', () {
      final bowl = entry(
        'E-1',
        food: rice,
        unit: 'bowl',
        servingValue: 1,
        nutrients: nutrients(kcal: 350, carbs: 78),
      );
      final riceFood = ekkloFood(riceInEkklo, calories: 350, carbs: 78);

      check(
            plan(bowl),
          )
          .isA<NeedsEkkloFood>()
          .has((it) => it.ekkloFoodId, 'id')
          .equals(
            riceInEkklo,
          );
      planned(plan(bowl, rememberedFood: riceFood))
        ..has((it) => it.reviewed, 'reviewed').isTrue()
        ..has((it) => it.reason, 'reason').equals(ReviewReason.weightToConfirm)
        ..has((it) => it.choice, 'choice')
            .isA<SendToEkkloFood>()
            .has((it) => it.gramsPerUnit, 'grams per unit')
            .equals(100);
    });

    test('reuses an own copy of the same unit and version', () {
      final planning = plan(
        entry(
          'E-2',
          food: oil,
          unit: tablespoon,
          servingValue: 1,
          version: 'v1',
        ),
        remembered: copiedOil,
      );

      planned(planning)
        ..has((it) => it.reviewed, 'reviewed').isFalse()
        ..has((it) => it.choice, 'choice').equals(
          SendAsOwnCopy(reuse: copiedOil.ownCopies.single),
        );
    });

    test('reuses the own copy of each unit of a food copied in two', () {
      final teaspoonCopy = copiedOil.ownCopies.single.copyWith(
        ekkloFoodId: 'own-oil-teaspoon',
        mfpUnit: teaspoon,
      );
      final copiedTwice = copiedOil.copyWith(
        ownCopies: [...copiedOil.ownCopies, teaspoonCopy],
      );

      for (final (logged, copy) in [
        (
          entry('E-2', food: oil, unit: tablespoon, version: 'v1'),
          copiedOil.ownCopies.single,
        ),
        (
          entry('E-3', food: oil, unit: teaspoon, version: 'v1'),
          teaspoonCopy,
        ),
      ]) {
        planned(
          plan(logged, remembered: copiedTwice),
        ).has((it) => it.choice, 'choice').equals(SendAsOwnCopy(reuse: copy));
      }
    });

    test('copies again a food changed in MyFitnessPal or logged in '
        'another unit', () {
      for (final logged in [
        entry('E-2', food: oil, unit: tablespoon, version: 'v2'),
        entry('E-3', food: oil, unit: teaspoon, version: 'v1'),
      ]) {
        planned(plan(logged, remembered: copiedOil))
          ..has((it) => it.reviewed, 'reviewed').isFalse()
          ..has((it) => it.choice, 'choice').equals(const SendAsOwnCopy());
      }
    });
  });

  group('an unknown food', () {
    test('searches Ekklo with its product name', () {
      check(
        plan(skyrEntry),
      ).isA<NeedsSearch>().has((it) => it.terms, 'terms').equals('skyr');
    });

    test('proposes the best acceptable candidate for review', () {
      final planning = plan(
        skyrEntry,
        searchResults: [fromageBlanc, siggis, isey],
      );

      planned(planning)
        ..has((it) => it.reason, 'reason').equals(ReviewReason.newAssociation)
        ..has(
          (it) => [for (final candidate in it.candidates) candidate.food.id],
          'candidates',
        ).deepEquals(['isey', 'siggis', 'fromage-blanc'])
        ..has((it) => it.choice, 'choice')
            .isA<SendToEkkloFood>()
            .has((it) => it.ekkloFoodId, 'food')
            .equals('isey');
    });

    test('proposes an own copy when no candidate is close enough', () {
      final planning = plan(skyrEntry, searchResults: [siggis, fromageBlanc]);

      planned(planning)
        ..has((it) => it.reason, 'reason').equals(ReviewReason.noCloseFood)
        ..has((it) => it.choice, 'choice').equals(const SendAsOwnCopy())
        ..has((it) => it.candidates.length, 'rejected').equals(2);
    });

    test('keeps the MyFitnessPal meal name when Memory maps no meal', () {
      final planning = plan(
        entry('E-1', meal: snacks),
        searchResults: const [],
      );

      planned(planning)
          .has((it) => it.ekkloMealName, 'meal')
          .equals(
            snacks,
          );
    });
  });
}
