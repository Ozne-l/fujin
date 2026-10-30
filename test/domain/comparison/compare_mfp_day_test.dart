import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/entries/copied_food.dart';
import 'package:fujin/data/entries/copied_meal.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/domain/comparison/compare_ekklo_day.dart';
import 'package:fujin/domain/comparison/compare_mfp_day.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

DayDraft read(
  List<LoggedEntry> stored,
  List<MfpFoodEntry> diary, {
  Food? Function(String mfpFoodId) foodOf = knownFood,
}) => compareMfpDay(
  DayDraft.of(StoredDay(entries: stored), date: day),
  diary: diary,
  foodOf: foodOf,
  mealOf: knownMeal,
  now: now,
  ids: idsFrom('n'),
);

void main() {
  group('an entry with an id', () {
    test('is copied in with its food and meal, found or created', () {
      final skyrSnack = entry(
        'E-1',
        food: skyr,
        meal: snacks,
        description: 'Skyr nature',
        brand: 'Isey',
        version: '3',
      );
      final oatsBreakfast = entry('E-2');

      final draft = read([], [skyrSnack, oatsBreakfast]);

      check(draft.changes).equals(
        DayChanges(
          date: day,
          foods: [
            const CopiedFood(
              id: 'n-3',
              mfpFoodId: skyr,
              name: 'Skyr nature',
              brand: 'Isey',
            ),
          ],
          meals: [const CopiedMeal(id: 'n-2', mfpMealName: snacks)],
          addedEntries: [
            Entry.copyOf(
              skyrSnack,
              id: 'n-1',
              mealId: 'n-2',
              foodId: 'n-3',
              updatedAt: now,
            ),
            Entry.copyOf(
              oatsBreakfast,
              id: 'n-5',
              mealId: fujinMealId(breakfast),
              foodId: fujinFoodId(oats),
              updatedAt: now,
            ),
          ],
          addedMfpLinks: [
            MfpLink.of(
              skyrSnack,
              id: 'n-4',
              entryId: 'n-1',
              mfpEntryId: 'E-1',
              updatedAt: now,
            ),
            MfpLink.of(
              oatsBreakfast,
              id: 'n-6',
              entryId: 'n-5',
              mfpEntryId: 'E-2',
              updatedAt: now,
            ),
          ],
        ),
      );
    });

    test('changes nothing when MyFitnessPal holds what is stored', () {
      final draft = read([loggedEntry(entry('E-1'))], [entry('E-1')]);

      check(draft.changes).equals(DayChanges(date: day));
    });

    test('updates its entry when its values changed under the same id', () {
      final stored = loggedEntry(entry('E-1'));
      final edited = entry('E-1', meal: lunch, servings: 2);

      final draft = read([stored], [edited]);

      check(draft.changes).equals(
        DayChanges(
          date: day,
          changedEntries: [
            stored.entry.copyWith(mealId: fujinMealId(lunch), servings: 2),
          ],
          changedMfpLinks: [
            MfpLink.of(
              edited,
              id: 'mfp-link-E-1',
              entryId: 'E-1',
              mfpEntryId: 'E-1',
              updatedAt: now,
            ),
          ],
        ),
      );
    });

    test('names a food without a name and keeps a named one', () {
      final draft = read(
        [],
        [
          entry('E-1', description: "Flocons d'avoine", brand: 'Quaker'),
          entry('E-2', food: rice, description: 'Rice, white'),
        ],
        foodOf: (mfpFoodId) => switch (mfpFoodId) {
          oats => Food(id: fujinFoodId(oats), updatedAt: now),
          _ => Food(id: fujinFoodId(rice), name: 'Riz basmati', updatedAt: now),
        },
      );

      check(draft.changes.foods).deepEquals([
        CopiedFood(
          id: fujinFoodId(oats),
          mfpFoodId: oats,
          name: "Flocons d'avoine",
          brand: 'Quaker',
        ),
      ]);
      check([
        for (final logged in draft.entries) logged.foodName,
      ]).deepEquals(["Flocons d'avoine", 'Riz basmati']);
    });
  });

  group('a stored entry gone from MyFitnessPal', () {
    test('is deleted and keeps its Ekklo link', () {
      final link = ekkloLinkRow('k-1', entryId: 'E-1', item: sentItem('I-1'));
      final sent = loggedEntry(entry('E-1')).copyWith(ekkloLink: link);
      final unsent = loggedEntry(entry('E-2'));

      final draft = read([sent, unsent], []);

      check(draft.changes).equals(
        DayChanges(
          date: day,
          deletedEntryIds: ['E-1', 'E-2'],
          deletedMfpLinkIds: ['mfp-link-E-1', 'mfp-link-E-2'],
        ),
      );
      check(draft.entries).isEmpty();
      check([
        for (final logged in draft.deleted) logged.ekkloLink,
      ]).deepEquals([link]);
    });
  });

  group('an entry without an id', () {
    test('is left unstored', () {
      final draft = read([], [entry(null)]);

      check(draft.changes).equals(DayChanges(date: day));
      check(draft.entries).isEmpty();
      check(draft.unstored.single.mfpFoodId).equals(oats);
    });

    test('is always to send and has no Fūjin id', () {
      final result = compareEkkloDay(
        read([], [entry(null)]),
        meals: [
          meal('meal-1', [item('I-1')]),
        ],
        memory: memory,
        now: now,
        ids: idsFrom('k'),
      );

      check(result.entries.single)
        ..has((compared) => compared.status, 'status').equals(const ToSend())
        ..has((compared) => compared.entryId, 'entryId').isNull();
      check(result.changes).equals(DayChanges(date: day));
    });
  });

  test('an entry a held diary would copy in shows without a Fūjin id', () {
    final result = compareEkkloDay(
      read([], [entry('E-1')]),
      meals: [
        meal('meal-1', [item('I-1')]),
      ],
      memory: memory,
      now: now,
      ids: idsFrom('k'),
    );

    check(result.entries.single.entryId).equals('n-1');
    check(result.held().entries.single)
      ..has((compared) => compared.status, 'status').isA<InEkklo>()
      ..has((compared) => compared.entryId, 'entryId').isNull();
  });
}
