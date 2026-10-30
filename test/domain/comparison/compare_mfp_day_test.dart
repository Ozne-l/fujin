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
  List<LoggedEntry> owed = const [],
  DateTime? readAt,
}) => compareMfpDay(
  DayDraft.of(
    StoredDay(entries: stored, owed: owed),
    date: day,
  ),
  diary: diary,
  foodOf: foodOf,
  mealOf: knownMeal,
  now: now,
  readAt: readAt ?? now,
  ids: idsFrom('n'),
);

LoggedEntry unlinked(String id) =>
    loggedEntry(entry(id)).copyWith(mfpLink: null);

LoggedEntry editedTo(double servings, {String id = 'E-1'}) {
  final logged = loggedEntry(entry(id));
  return logged.copyWith(entry: logged.entry.copyWith(servings: servings));
}

LoggedEntry deletedEntry(String id) {
  final logged = loggedEntry(entry(id));
  return logged.copyWith(entry: logged.entry.copyWith(deletedAt: now));
}

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

  group('an entry waiting for MyFitnessPal', () {
    test('adopts the oldest matching unlinked row', () {
      final row = entry('E-1');

      final draft = read([unlinked('e-b'), unlinked('e-a')], [row]);

      check(draft.changes).equals(
        DayChanges(
          date: day,
          addedMfpLinks: [
            MfpLink.of(
              row,
              id: 'n-1',
              entryId: 'e-a',
              mfpEntryId: 'E-1',
              updatedAt: now,
            ),
          ],
        ),
      );
    });

    test("keeps Fūjin's values when the diary changed under a pending "
        'edit', () {
      final edited = editedTo(2);
      final changed = entry('E-1', servings: 3);

      final draft = read([edited], [changed]);

      check(draft.entries.single.entry).equals(edited.entry);
      check(draft.changes).equals(
        DayChanges(
          date: day,
          changedMfpLinks: [
            MfpLink.of(
              changed,
              id: 'mfp-link-E-1',
              entryId: 'E-1',
              mfpEntryId: 'E-1',
              updatedAt: now,
            ),
          ],
        ),
      );
    });

    test('turns a pending edit whose row vanished into a pending add', () {
      final edited = editedTo(2).copyWith(
        ekkloLink: ekkloLinkRow('k-E-1', entryId: 'E-1'),
      );

      final draft = read([edited], []);

      check(draft.entries.single)
        ..has((logged) => logged.mfpLink, 'MyFitnessPal link').isNull()
        ..has((logged) => logged.ekkloLink, 'Ekklo link').equals(
          edited.ekkloLink,
        );
      check(draft.changes).equals(
        DayChanges(date: day, deletedMfpLinkIds: ['mfp-link-E-1']),
      );
    });

    test('holds the copy of a pending edit', () {
      final draft = read(
        [editedTo(2)],
        [entry('E-1'), entry('E-2', servings: 2)],
      );

      check(draft.entries).length.equals(1);
      check(draft.changes).equals(DayChanges(date: day));
    });

    test('keeps a pending move whose row is on another day', () {
      final logged = loggedEntry(entry('E-1'));
      final moved = logged.copyWith(
        mfpLink: logged.mfpLink?.copyWith(
          date: day.subtract(const Duration(days: 1)),
        ),
      );

      final draft = read([moved], []);

      check(draft.entries).deepEquals([moved]);
      check(draft.changes).equals(DayChanges(date: day));
    });

    test("holds an owed deletion's row and never copies it in", () {
      final owed = deletedEntry('E-1');

      final draft = read([], [entry('E-1')], owed: [owed]);

      check(draft.owed).deepEquals([owed]);
      check(draft.entries).isEmpty();
      check(draft.changes).equals(DayChanges(date: day));
    });

    test('forgets an owed link whose row is gone', () {
      final draft = read([], [], owed: [deletedEntry('E-1')]);

      check(draft.changes).equals(
        DayChanges(date: day, deletedMfpLinkIds: ['mfp-link-E-1']),
      );
    });

    test('leaves a link written after the diary was read', () {
      final written = loggedEntry(entry('E-1'));

      final draft = read(
        [written],
        [],
        readAt: now.subtract(const Duration(minutes: 1)),
      );

      check(draft.entries).deepEquals([written]);
      check(draft.changes).equals(DayChanges(date: day));
    });
  });
}
