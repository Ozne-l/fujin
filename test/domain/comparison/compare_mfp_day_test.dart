import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/connectors/role.dart';
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
import 'package:fujin/domain/comparison/replacement.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

DayDraft read(
  List<LoggedEntry> stored,
  List<MfpFoodEntry> diary, {
  Food? Function(String mfpFoodId) foodOf = storedFood,
  List<LoggedEntry> owed = const [],
  DateTime? readAt,
  Role role = Role.twoWay,
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
  role: role,
);

MfpLink linkTo(MfpFoodEntry row, {String id = 'E-1'}) => MfpLink.of(
  row,
  id: 'mfp-link-$id',
  entryId: id,
  mfpEntryId: row.id ?? '',
  updatedAt: now,
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

      final refreshed = MfpLink.of(
        changed,
        id: 'mfp-link-E-1',
        entryId: 'E-1',
        mfpEntryId: 'E-1',
        updatedAt: now,
      );
      check(draft.entries.single.entry).equals(edited.entry);
      check(draft.changes).equals(
        DayChanges(date: day, changedMfpLinks: [refreshed]),
      );
      check(draft.replaced).deepEquals([
        ReplacedEdit(edited.copyWith(mfpLink: refreshed), before: refreshed),
      ]);
    });

    test('records no replacement when the row still holds the link', () {
      final draft = read([editedTo(2)], [entry('E-1')]);

      check(draft.replaced).isEmpty();
      check(draft.changes).equals(DayChanges(date: day));
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

  group('a pending change whose row the MyFitnessPal app replaced', () {
    test("moves an edit's link to a row of the same food and meal", () {
      final edited = editedTo(2);
      final otherMeal = entry('M-1', meal: lunch, servings: 3);
      final sameMeal = entry('M-2', servings: 3);

      final draft = read([edited], [otherMeal, sameMeal]);

      final kept = edited.copyWith(mfpLink: linkTo(sameMeal));
      check(draft.entries.first).equals(kept);
      check(draft.entries).length.equals(2);
      check(draft.replaced).deepEquals([
        ReplacedEdit(kept, before: linkTo(sameMeal)),
      ]);
      check(
        draft.changes.changedMfpLinks,
      ).deepEquals([linkTo(sameMeal)]);
    });

    test('moves it to a row of another meal when none shares its meal', () {
      final edited = editedTo(2);
      final otherMeal = entry('M-1', meal: lunch, servings: 3);

      final draft = read([edited], [otherMeal]);

      final kept = edited.copyWith(mfpLink: linkTo(otherMeal));
      check(draft.entries).deepEquals([kept]);
      check(draft.replaced).deepEquals([
        ReplacedEdit(kept, before: linkTo(otherMeal)),
      ]);
      check(draft.changes).equals(
        DayChanges(date: day, changedMfpLinks: [linkTo(otherMeal)]),
      );
    });

    test('gives the row to the oldest entry', () {
      final older = editedTo(2);
      final newer = editedTo(3, id: 'E-2');
      final row = entry('M-1', servings: 5);

      final draft = read([newer, older], [row]);

      check(draft.entries).deepEquals([
        newer.copyWith(mfpLink: null),
        older.copyWith(mfpLink: linkTo(row)),
      ]);
    });

    test('leaves a row another link holds', () {
      final held = loggedEntry(entry('L-1', servings: 3));

      final draft = read([editedTo(2), held], [entry('L-1', servings: 3)]);

      check(draft.entries.first.mfpLink).isNull();
      check(draft.replaced).isEmpty();
      check(draft.changes).equals(
        DayChanges(date: day, deletedMfpLinkIds: ['mfp-link-E-1']),
      );
    });

    test('leaves a row an entry without a link adopts', () {
      final draft = read([editedTo(2), unlinked('U-1')], [entry('M-1')]);

      check(draft.entries.first.mfpLink).isNull();
      check(draft.entries.last.mfpLink?.mfpEntryId).equals('M-1');
      check(draft.replaced).isEmpty();
    });

    test('leaves a row of another food', () {
      final draft = read([editedTo(2)], [entry('M-1', food: rice)]);

      check(draft.entries.first.mfpLink).isNull();
      check(draft.replaced).isEmpty();
    });

    test("takes a row holding Fūjin's values as the link", () {
      final edited = editedTo(2);
      final row = entry('M-1', servings: 2);

      final draft = read([edited], [row]);

      final kept = edited.copyWith(mfpLink: linkTo(row));
      check(draft.entries).deepEquals([kept]);
      check(draft.replaced).isEmpty();
      check(draft.changes).equals(
        DayChanges(date: day, changedMfpLinks: [linkTo(row)]),
      );
    });

    test("moves an owed deletion's link to the replacing row", () {
      final owed = deletedEntry('E-1');
      final row = entry('M-1', servings: 3);

      final draft = read([], [row], owed: [owed]);

      final kept = owed.copyWith(mfpLink: linkTo(row));
      check(draft.owed).deepEquals([kept]);
      check(draft.entries).isEmpty();
      check(draft.replaced).deepEquals([ReplacedDeletion(kept)]);
      check(draft.changes).equals(
        DayChanges(date: day, changedMfpLinks: [linkTo(row)]),
      );
    });

    test(
      "moves the link of an entry moved to another day to the app's row",
      () {
        final logged = loggedEntry(entry('E-1'));
        final moved = logged.copyWith(
          entry: logged.entry.copyWith(date: day.add(const Duration(days: 1))),
        );
        final row = entry('M-1', servings: 3);

        final draft = read([], [row], owed: [moved]);

        final kept = moved.copyWith(mfpLink: linkTo(row));
        check(draft.owed).deepEquals([kept]);
        check(draft.entries).isEmpty();
        check(draft.replaced).deepEquals([
          ReplacedEdit(kept, before: linkTo(row)),
        ]);
        check(draft.changes).equals(
          DayChanges(date: day, changedMfpLinks: [linkTo(row)]),
        );
      },
    );

    test('gives an edit the row before an owed deletion', () {
      final row = entry('M-1', servings: 3);

      final draft = read([editedTo(2)], [row], owed: [deletedEntry('D-1')]);

      check(draft.entries.single.mfpLink).equals(linkTo(row));
      check(draft.owed.single.mfpLink).isNull();
    });

    test('leaves a link written after the diary was read', () {
      final edited = editedTo(2);

      final draft = read(
        [edited],
        [entry('M-1', servings: 3)],
        readAt: now.subtract(const Duration(minutes: 1)),
      );

      check(draft.entries.first).equals(edited);
      check(draft.replaced).isEmpty();
    });
  });

  group('MyFitnessPal in receive only', () {
    DayDraft receive(
      List<LoggedEntry> stored,
      List<MfpFoodEntry> diary, {
      List<LoggedEntry> owed = const [],
    }) => read(stored, diary, owed: owed, role: Role.receiveOnly);

    test('neither copies in nor shows a row only the app logged', () {
      final draft = receive([], [entry('E-1'), entry(null)]);

      check(draft.entries).isEmpty();
      check(draft.unstored).isEmpty();
      check(draft.changes).equals(DayChanges(date: day));
    });

    test('changes nothing when MyFitnessPal holds what is stored', () {
      final draft = receive([loggedEntry(entry('E-1'))], [entry('E-1')]);

      check(draft.replaced).isEmpty();
      check(draft.changes).equals(DayChanges(date: day));
    });

    test("keeps Fūjin's values when the app changed a row under its id", () {
      final stored = loggedEntry(entry('E-1'));
      final changed = entry('E-1', meal: lunch, servings: 2);

      final draft = receive([stored], [changed]);

      final kept = stored.copyWith(mfpLink: linkTo(changed));
      check(draft.entries).deepEquals([kept]);
      check(draft.replaced).deepEquals([
        ReplacedEdit(kept, before: linkTo(changed)),
      ]);
      check(draft.changes).equals(
        DayChanges(date: day, changedMfpLinks: [linkTo(changed)]),
      );
    });

    test("moves the link of a row the app replaced and keeps Fūjin's "
        'values', () {
      final stored = loggedEntry(entry('E-1'));
      final row = entry('M-1', servings: 3);

      final draft = receive([stored], [row]);

      final kept = stored.copyWith(mfpLink: linkTo(row));
      check(draft.entries).deepEquals([kept]);
      check(draft.replaced).deepEquals([
        ReplacedEdit(kept, before: linkTo(row)),
      ]);
      check(draft.changes).equals(
        DayChanges(date: day, changedMfpLinks: [linkTo(row)]),
      );
    });

    test('keeps an entry whose row is gone, to be added again', () {
      final link = ekkloLinkRow('k-1', entryId: 'E-1', item: sentItem('I-1'));
      final sent = loggedEntry(entry('E-1')).copyWith(ekkloLink: link);
      final unsent = loggedEntry(entry('E-2'));

      final draft = receive([sent, unsent], [entry('M-1', food: rice)]);

      check(draft.entries).deepEquals([
        sent.copyWith(mfpLink: null),
        unsent.copyWith(mfpLink: null),
      ]);
      check(draft.deleted).isEmpty();
      check(draft.replaced).isEmpty();
      check(draft.changes).equals(
        DayChanges(
          date: day,
          deletedMfpLinkIds: ['mfp-link-E-1', 'mfp-link-E-2'],
        ),
      );
    });

    test("still settles Fūjin's owed deletions and pending edits", () {
      final edited = editedTo(2);

      final draft = receive(
        [edited],
        [entry('E-1'), entry('D-1')],
        owed: [deletedEntry('D-1')],
      );

      check(draft.entries).deepEquals([edited]);
      check(draft.owed).deepEquals([deletedEntry('D-1')]);
      check(draft.changes).equals(DayChanges(date: day));
    });
  });
}
