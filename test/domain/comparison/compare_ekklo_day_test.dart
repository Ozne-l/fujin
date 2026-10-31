import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/compare_ekklo_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/mfp_status.dart';
import 'package:fujin/domain/comparison/update_kind.dart';

import '../../support/fixtures.dart';

DayComparison compare(
  List<LoggedEntry> entries,
  List<EkkloDailyMeal> meals, {
  List<LoggedEntry> deleted = const [],
  List<LoggedEntry> owed = const [],
  Memory remembered = memory,
}) => compareEkkloDay(
  DayDraft.of(
    StoredDay(entries: entries, deleted: deleted, owed: owed),
    date: day,
  ),
  meals: meals,
  memory: remembered,
  now: now,
  ids: idsFrom('k'),
);

List<EntryStatus> statusesOf(DayComparison comparison) => [
  for (final compared in comparison.entries) compared.status,
];

LoggedEntry stored(
  String id, {
  String food = oats,
  String meal = breakfast,
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
  LinkedItem? item,
  UnattendedExpectation? unattended,
}) {
  final logged = loggedEntry(
    entry(
      id,
      food: food,
      meal: meal,
      servings: servings,
      servingValue: servingValue,
      unit: unit,
    ),
  );
  return switch ((item, unattended)) {
    (null, null) => logged,
    _ => logged.copyWith(
      ekkloLink: ekkloLinkRow(
        'k-$id',
        entryId: id,
        item: item,
        unattended: unattended,
      ),
    ),
  };
}

LoggedEntry deletedIn(
  String id,
  String itemId, {
  String meal = breakfast,
  double servings = 1,
  UnattendedExpectation? unattended,
}) {
  final logged = stored(
    id,
    meal: meal,
    servings: servings,
    item: sentItem(itemId, meal: meal, servings: servings),
    unattended: unattended,
  );
  return logged.copyWith(
    entry: logged.entry.copyWith(deletedAt: now),
    mfpLink: null,
  );
}

EkkloLink linkOf(LoggedEntry logged) => switch (logged.ekkloLink) {
  final link? => link,
  null => throw StateError('No Ekklo link on ${logged.entry.id}'),
};

EkkloLink adoptedLink(
  String entryId,
  String itemId, {
  String food = oats,
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
}) => EkkloLink(
  id: 'k-1',
  entryId: entryId,
  item: sentItem(
    itemId,
    food: food,
    servings: servings,
    servingValue: servingValue,
    unit: unit,
  ).copyWith(sentAt: now),
  updatedAt: now,
);

DayChanges changes({
  List<EkkloLink> added = const [],
  List<EkkloLink> changed = const [],
  List<String> dropped = const [],
}) => DayChanges(
  date: day,
  addedEkkloLinks: added,
  changedEkkloLinks: changed,
  droppedEkkloLinkIds: dropped,
);

void main() {
  group('a linked entry', () {
    test('is in Ekklo while its item exists', () {
      final sent = stored('e-1', item: sentItem('I-1'));

      final result = compare(
        [sent],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([InEkklo(linkOf(sent))]);
      check(result.changes).equals(changes());
    });

    test('loses its link and is to send once its item is gone', () {
      final result = compare(
        [stored('e-1', item: sentItem('I-1'))],
        [meal('meal-1', [])],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.changes).equals(changes(dropped: ['k-e-1']));
    });

    test('edited in Fūjin is to update while its item is as written', () {
      final edited = stored('e-1', servings: 1.5, item: sentItem('I-1'));

      final result = compare(
        [edited],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(linkOf(edited), UpdateKind.quantityOnly)]);
      check(result.changes).equals(changes());
    });

    test('edited in Fūjin is in Ekklo with its link refreshed once its item '
        'matches', () {
      final edited = stored('e-1', servings: 1.5, item: sentItem('I-1'));

      final result = compare(
        [edited],
        [
          meal('meal-1', [item('I-1', quantity: 150)]),
        ],
      );

      final refreshed = linkOf(
        edited,
      ).copyWith(item: sentItem('I-1', servings: 1.5));
      check(statusesOf(result)).deepEquals([InEkklo(refreshed)]);
      check(result.changes).equals(changes(changed: [refreshed]));
    });
  });

  group('an entry waiting for MyFitnessPal', () {
    test('marks entries waiting for MyFitnessPal as pending', () {
      final added = stored('e-1').copyWith(mfpLink: null);
      final edited = stored('e-2');
      final written = stored('e-3');

      final result = compare(
        [
          added,
          edited.copyWith(entry: edited.entry.copyWith(servings: 2)),
          written,
        ],
        [],
      );

      check([
        for (final compared in result.entries) compared.mfp,
      ]).deepEquals([const MfpPending(), const MfpPending(), null]);
    });

    test('keeps the Ekklo link of an entry moved to another day until it is '
        'written', () {
      final sent = stored('e-1', item: sentItem('I-1'));
      final moved = sent.copyWith(
        mfpLink: sent.mfpLink?.copyWith(
          date: day.subtract(const Duration(days: 1)),
        ),
      );

      final result = compare([moved], [meal('meal-1', [])]);

      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(linkOf(sent), UpdateKind.mealChanged)]);
      check(result.changes).equals(changes());
    });
  });

  group('an unlinked entry', () {
    test('adopts the unclaimed item Memory expects', () {
      final result = compare(
        [stored('e-1', servings: 1.5)],
        [
          meal('meal-1', [item('I-1', quantity: 150)]),
        ],
      );

      final adopted = adoptedLink('e-1', 'I-1', servings: 1.5);
      check(statusesOf(result)).deepEquals([InEkklo(adopted)]);
      check(result.changes).equals(changes(added: [adopted]));
    });

    test('adopts within 0.1 of the expected quantity and not beyond', () {
      final result = compare(
        [stored('e-1'), stored('e-2', servings: 2)],
        [
          meal('meal-1', [
            item('I-1', quantity: 100.1),
            item('I-2', quantity: 200.2),
          ]),
        ],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(adoptedLink('e-1', 'I-1')),
        const ToSend(),
      ]);
    });

    test('converts a remembered unit to grams', () {
      final result = compare(
        [stored('e-1', food: rice, unit: cup, servingValue: 1, servings: 2)],
        [
          meal('meal-1', [item('I-1', food: riceInEkklo, quantity: 360)]),
        ],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(
          adoptedLink(
            'e-1',
            'I-1',
            food: rice,
            servings: 2,
            servingValue: 1,
            unit: cup,
          ),
        ),
      ]);
    });

    test(
      'expects an own copy in portions of its unit, and nothing in another',
      () {
        const copied = Memory(
          ownCopies: [
            OwnCopy(
              mfpFoodId: oats,
              mfpDescription: oats,
              ekkloFoodId: 'own-oats',
              ekkloFoodName: oats,
              mfpUnit: cup,
            ),
          ],
          meals: [
            MealMapping(mfpMealName: breakfast, ekkloMealName: petitDejeuner),
          ],
        );

        final result = compare(
          [
            stored('e-1', unit: cup, servingValue: 0.5, servings: 3),
            stored('e-2', unit: 'bowl', servingValue: 1, servings: 1.5),
          ],
          [
            meal('meal-1', [
              item(
                'I-1',
                food: 'own-oats',
                quantity: 1.5,
                type: EkkloQuantityType.portion,
              ),
              item(
                'I-2',
                food: 'own-oats',
                quantity: 1.5,
                type: EkkloQuantityType.portion,
              ),
            ]),
          ],
          remembered: copied,
        );

        check(statusesOf(result)).deepEquals([
          InEkklo(
            adoptedLink(
              'e-1',
              'I-1',
              servings: 3,
              servingValue: 0.5,
              unit: cup,
            ),
          ),
          const ToSend(),
        ]);
      },
    );

    test('is to send when its unit has no grams in Memory', () {
      final result = compare(
        [stored('e-1', unit: cup, servingValue: 1)],
        [
          meal('meal-1', [item('I-1', quantity: 1)]),
        ],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
    });

    test('is to send when its meal has no Ekklo meal in Memory', () {
      final result = compare(
        [stored('e-1', meal: 'Snacks')],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
    });

    test('cannot adopt an item a link already claims', () {
      final sent = stored('e-1', item: sentItem('I-1'));

      final result = compare(
        [sent, stored('e-2')],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(
        statusesOf(result),
      ).deepEquals([InEkklo(linkOf(sent)), const ToSend()]);
    });

    test("claims each item once, in Fūjin's order", () {
      final result = compare(
        [stored('e-1'), stored('e-2')],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(adoptedLink('e-1', 'I-1')),
        const ToSend(),
      ]);
    });
  });

  group('an orphan link', () {
    test('is never the link of a deletion MyFitnessPal still owes', () {
      final deleted = deletedIn('e-1', 'I-1');
      final owed = deleted.copyWith(
        mfpLink: MfpLink.of(
          entry('mfp-1'),
          id: 'l-1',
          entryId: 'e-1',
          mfpEntryId: 'mfp-1',
          updatedAt: now,
        ),
      );

      final result = compare(
        [stored('e-2', servings: 1.5)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [owed],
        owed: [owed],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.changes).equals(changes());
      check(result.leaving.single.entry.id).equals('e-1');
    });

    test('turns the same food in the same meal into a quantity update', () {
      final orphan = deletedIn('e-1', 'I-1');

      final result = compare(
        [stored('e-2', servings: 1.5)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
      );

      final moved = linkOf(orphan).copyWith(entryId: 'e-2');
      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(moved, UpdateKind.quantityOnly)]);
      check(result.changes).equals(changes(changed: [moved]));
    });

    test('turns the same food moved to another Ekklo meal into a move', () {
      final orphan = deletedIn('e-1', 'I-1');

      final result = compare(
        [stored('e-2', meal: lunch)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
      );

      check(statusesOf(result)).deepEquals([
        ToUpdate(
          linkOf(orphan).copyWith(entryId: 'e-2'),
          UpdateKind.mealChanged,
        ),
      ]);
    });

    test('moves to the new entry when nothing changed in Ekklo terms', () {
      final orphan = deletedIn('e-1', 'I-1');

      final result = compare(
        [stored('e-2')],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
      );

      final moved = linkOf(orphan).copyWith(entryId: 'e-2');
      check(statusesOf(result)).deepEquals([InEkklo(moved)]);
      check(result.changes).equals(changes(changed: [moved]));
    });

    test('moves to the new entry refreshed, keeping when it was sent, once '
        'its item matches the new values', () {
      final orphan = deletedIn('e-1', 'I-1');

      final result = compare(
        [stored('e-2', servings: 1.5)],
        [
          meal('meal-1', [item('I-1', quantity: 150)]),
        ],
        deleted: [orphan],
      );

      final moved = linkOf(
        orphan,
      ).copyWith(entryId: 'e-2', item: sentItem('I-1', servings: 1.5));
      check(statusesOf(result)).deepEquals([InEkklo(moved)]);
      check(result.changes).equals(changes(changed: [moved]));
    });

    test('pairs with an entry of its own meal before any other', () {
      final orphan = deletedIn('e-1', 'I-1');

      final result = compare(
        [
          stored('e-2', meal: lunch, servings: 2),
          stored('e-3', servings: 2),
        ],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
      );

      check(statusesOf(result)).deepEquals([
        const ToSend(),
        ToUpdate(
          linkOf(orphan).copyWith(entryId: 'e-3'),
          UpdateKind.quantityOnly,
        ),
      ]);
    });

    test('is dropped with nothing to update when its item is gone', () {
      final result = compare(
        [stored('e-2', servings: 2)],
        [meal('meal-1', [])],
        deleted: [deletedIn('e-1', 'I-1')],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.changes).equals(changes(dropped: ['k-e-1']));
    });

    test('left unpaired changes nothing and keeps its link', () {
      final result = compare(
        [stored('e-2', food: rice)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [deletedIn('e-1', 'I-1')],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.changes).equals(changes());
    });
  });

  group('an entry sent without the owner', () {
    const forgetful = Memory();

    test('adopts the item its automatic send recorded although Memory '
        'expects nothing', () {
      final waiting = stored('e-1', unattended: expectation());

      final result = compare(
        [waiting],
        [
          meal('meal-1', [item('I-1')]),
        ],
        remembered: forgetful,
      );

      final adopted = linkOf(
        waiting,
      ).copyWith(item: sentItem('I-1').copyWith(sentAt: now));
      check(statusesOf(result)).deepEquals([InEkklo(adopted)]);
      check(result.changes).equals(changes(changed: [adopted]));
    });

    test('stays in Ekklo while Memory expects nothing for it', () {
      final sent = stored(
        'e-1',
        item: sentItem('I-1'),
        unattended: expectation(),
      );

      final result = compare(
        [sent],
        [
          meal('meal-1', [item('I-1')]),
        ],
        remembered: forgetful,
      );

      check(statusesOf(result)).deepEquals([InEkklo(linkOf(sent))]);
    });

    test('is to update once Memory expects another item', () {
      final sent = stored(
        'e-1',
        item: sentItem('I-1'),
        unattended: expectation(food: 'ekklo-other'),
      );

      final result = compare(
        [sent],
        [
          meal('meal-1', [item('I-1', food: 'ekklo-other')]),
        ],
      );

      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(linkOf(sent), UpdateKind.quantityOnly)]);
      check(result.changes).equals(changes());
    });

    test('is in Ekklo once Memory expects the item it got', () {
      final sent = stored(
        'e-1',
        item: sentItem('I-1'),
        unattended: expectation(),
      );

      final result = compare(
        [sent],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([InEkklo(linkOf(sent))]);
    });

    test('counts its expectation only while the entry is unchanged', () {
      final unchanged = stored(
        'e-1',
        item: sentItem('I-1'),
        unattended: expectation(),
      );
      final edited = stored(
        'e-2',
        servings: 2,
        item: sentItem('I-2'),
        unattended: expectation(),
      );

      final result = compare(
        [unchanged, edited],
        [
          meal('meal-1', [item('I-1'), item('I-2')]),
        ],
        remembered: forgetful,
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(linkOf(unchanged)),
        ToUpdate(linkOf(edited), UpdateKind.quantityOnly),
      ]);
    });

    test('keeps its expectation when its item is gone', () {
      final result = compare(
        [stored('e-1', item: sentItem('I-1'), unattended: expectation())],
        [
          meal('meal-1', [item('I-2')]),
        ],
        remembered: forgetful,
      );

      final adopted = ekkloLinkRow(
        'k-e-1',
        entryId: 'e-1',
        item: sentItem('I-2').copyWith(sentAt: now),
        unattended: expectation(),
      );
      check(statusesOf(result)).deepEquals([InEkklo(adopted)]);
      check(result.changes).equals(changes(changed: [adopted]));
    });

    test('is relinked after it was re-saved in MyFitnessPal', () {
      final orphan = deletedIn('e-1', 'I-1', unattended: expectation());

      final result = compare(
        [stored('e-9')],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
        remembered: forgetful,
      );

      final moved = linkOf(orphan).copyWith(entryId: 'e-9');
      check(statusesOf(result)).deepEquals([InEkklo(moved)]);
      check(result.changes).equals(changes(changed: [moved]));
    });

    test('keeps its meal when re-saved in MyFitnessPal with another '
        'quantity', () {
      final orphan = deletedIn('e-1', 'I-1', unattended: expectation());

      final result = compare(
        [stored('e-9', servings: 2)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
        remembered: forgetful,
      );

      final moved = linkOf(orphan).copyWith(entryId: 'e-9');
      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(moved, UpdateKind.quantityOnly)]);
      check(moved.unattended).equals(expectation());
    });

    test('changes meal when re-saved in another MyFitnessPal meal', () {
      final orphan = deletedIn('e-1', 'I-1', unattended: expectation());

      final result = compare(
        [stored('e-9', meal: lunch)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        deleted: [orphan],
        remembered: forgetful,
      );

      check(statusesOf(result)).deepEquals([
        ToUpdate(
          linkOf(orphan).copyWith(entryId: 'e-9'),
          UpdateKind.mealChanged,
        ),
      ]);
    });

    test('takes its own expectation over the one of the link it pairs '
        'with, and drops its own link', () {
      final orphan = deletedIn(
        'e-1',
        'I-1',
        unattended: expectation(quantity: 90),
      );

      final result = compare(
        [stored('e-9', unattended: expectation())],
        [
          meal('meal-1', [item('I-1', quantity: 50)]),
        ],
        deleted: [orphan],
        remembered: forgetful,
      );

      final moved = linkOf(
        orphan,
      ).copyWith(entryId: 'e-9', unattended: expectation());
      check(
        result.changes,
      ).equals(changes(changed: [moved], dropped: ['k-e-9']));
    });

    test('loses its expectation once deleted in MyFitnessPal', () {
      final waiting = stored('e-1', unattended: expectation());

      final result = compare(
        [],
        [meal('meal-1', [])],
        deleted: [
          waiting.copyWith(
            entry: waiting.entry.copyWith(deletedAt: now),
            mfpLink: null,
          ),
        ],
      );

      check(result.changes).equals(changes(dropped: ['k-e-1']));
    });
  });

  test('a linked entry sent with the owner stays in Ekklo whatever Memory '
      'now expects', () {
    final sent = stored('e-1', item: sentItem('I-1'));

    final result = compare(
      [sent],
      [
        meal('meal-1', [item('I-1', food: 'ekklo-other')]),
      ],
    );

    check(statusesOf(result)).deepEquals([InEkklo(linkOf(sent))]);
  });
}
