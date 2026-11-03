import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/unattended/unattended_item.dart';
import 'package:fujin/domain/comparison/adopt_waiting.dart';
import 'package:fujin/domain/comparison/compare_ekklo_day.dart';
import 'package:fujin/domain/comparison/compare_mfp_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

DayDraft adopt(
  List<LoggedEntry> stored,
  List<MfpFoodEntry> diary, {
  required IdSource ids,
  List<SentLink> links = const [],
  List<UnattendedItem> unattended = const [],
  Role role = Role.twoWay,
}) => adoptWaiting(
  DayDraft.of(StoredDay(entries: stored), date: day),
  diary: diary,
  links: links,
  unattended: unattended,
  foodOf: storedFood,
  mealOf: knownMeal,
  now: now,
  ids: ids,
  role: role,
);

DayComparison read(
  List<MfpFoodEntry> diary, {
  required List<SentLink> links,
  required IdSource ids,
  List<LoggedEntry> stored = const [],
  List<UnattendedItem> unattended = const [],
  Memory known = memory,
  Role role = Role.twoWay,
}) => compareEkkloDay(
  compareMfpDay(
    adopt(
      stored,
      diary,
      links: links,
      unattended: unattended,
      ids: ids,
      role: role,
    ),
    diary: diary,
    foodOf: storedFood,
    mealOf: knownMeal,
    now: now,
    readAt: now,
    ids: ids,
    role: role,
  ),
  meals: [
    meal('meal-1', [item('I-1')]),
  ],
  memory: known,
  now: now,
  ids: ids,
);

LoggedEntry unlinked(String id) =>
    loggedEntry(entry(id)).copyWith(mfpLink: null);

EkkloLink waitingLink(String id, String entryId) =>
    ekkloLinkRow(id, entryId: entryId, item: sentItem('I-1'));

void main() {
  group('a send link', () {
    test('of a stored entry becomes its Ekklo link', () {
      final draft = adopt(
        [loggedEntry(entry('E-1'))],
        [entry('E-1')],
        links: [link('E-1', 'I-1')],
        ids: idsFrom('w'),
      );

      check(draft.changes).equals(
        DayChanges(
          date: day,
          addedEkkloLinks: [waitingLink('w-1', 'E-1')],
          forgetsWaiting: true,
        ),
      );
    });

    test('of an entry the read copies in becomes the link of the copy', () {
      final ids = idsFrom('w');
      final diary = [entry('E-1')];

      final draft = compareMfpDay(
        adopt([], diary, links: [link('E-1', 'I-1')], ids: ids),
        diary: diary,
        foodOf: storedFood,
        mealOf: knownMeal,
        now: now,
        readAt: now,
        ids: ids,
        role: Role.twoWay,
      );

      check(draft.changes)
        ..has(
          (changes) => changes.addedEkkloLinks,
          'addedEkkloLinks',
        ).deepEquals([waitingLink('w-2', 'w-1')])
        ..has(
          (changes) => [for (final entry in changes.addedEntries) entry.id],
          'addedEntries',
        ).deepEquals(['w-1'])
        ..has((changes) => changes.forgetsWaiting, 'forgetsWaiting').isTrue();
    });

    test('of an entry re-saved in MyFitnessPal pairs with the new entry', () {
      final result = read(
        [entry('E-2')],
        links: [link('E-1', 'I-1')],
        ids: idsFrom('w'),
      );

      final moved = waitingLink('w-3', 'w-1');
      check(result.entries.single.status).equals(InEkklo(moved));
      check(result.changes)
        ..has(
          (changes) => [for (final entry in changes.addedEntries) entry.id],
          'addedEntries',
        ).deepEquals(['w-1'])
        ..has(
          (changes) => changes.addedEkkloLinks,
          'addedEkkloLinks',
        ).deepEquals([moved]);
    });

    test('of an entry gone from MyFitnessPal stays on a deleted entry', () {
      final result = read([], links: [link('E-1', 'I-1')], ids: idsFrom('w'));

      check(result.changes).equals(
        DayChanges(
          date: day,
          addedEntries: [
            Entry(
              id: 'w-1',
              date: day,
              mealId: fujinMealId(breakfast),
              foodId: fujinFoodId(oats),
              servingValue: 100,
              servingUnit: grams,
              servings: 1,
              updatedAt: now,
              deletedAt: now,
            ),
          ],
          addedEkkloLinks: [waitingLink('w-2', 'w-1')],
          forgetsWaiting: true,
        ),
      );
    });

    test('of a row a stored entry claims keeps the day waiting', () {
      final result = read(
        [entry('X-1')],
        stored: [unlinked('U-1')],
        links: [link('X-1', 'I-1')],
        known: const Memory(),
        ids: idsFrom('w'),
      );

      check(result.changes.forgetsWaiting).isFalse();
    });

    test('is refused next to an Ekklo link of its entry', () {
      final draft = adopt(
        [
          loggedEntry(entry('E-1')).copyWith(
            ekkloLink: ekkloLinkRow(
              'k-1',
              entryId: 'E-1',
              item: sentItem('I-2'),
            ),
          ),
        ],
        [entry('E-1')],
        links: [link('E-1', 'I-1')],
        ids: idsFrom('w'),
      );

      check(draft.changes).equals(DayChanges(date: day, forgetsWaiting: true));
    });

    test('is refused on an item another entry is linked to', () {
      final draft = adopt(
        [
          loggedEntry(entry('E-1')).copyWith(
            ekkloLink: ekkloLinkRow(
              'k-1',
              entryId: 'E-1',
              item: sentItem('I-1'),
            ),
          ),
          loggedEntry(entry('E-2')),
        ],
        [entry('E-1'), entry('E-2')],
        links: [link('E-2', 'I-1')],
        ids: idsFrom('w'),
      );

      check(draft.changes).equals(DayChanges(date: day, forgetsWaiting: true));
    });
  });

  group('an unattended item', () {
    test('becomes the expectation of the link its send link becomes', () {
      final draft = adopt(
        [loggedEntry(entry('E-1'))],
        [entry('E-1')],
        links: [link('E-1', 'I-1')],
        unattended: [unattendedItem('E-1')],
        ids: idsFrom('w'),
      );

      check(draft.changes.addedEkkloLinks).deepEquals([
        waitingLink('w-1', 'E-1').copyWith(unattended: expectation()),
      ]);
    });

    test('without a send link becomes a link without an item', () {
      final draft = adopt(
        [loggedEntry(entry('E-1'))],
        [entry('E-1')],
        unattended: [unattendedItem('E-1')],
        ids: idsFrom('w'),
      );

      check(draft.changes.addedEkkloLinks).deepEquals([
        ekkloLinkRow('w-1', entryId: 'E-1', unattended: expectation()),
      ]);
    });

    test('of an entry that left the day is dropped', () {
      final draft = adopt(
        [loggedEntry(entry('E-1'))],
        [entry('E-1')],
        unattended: [unattendedItem('E-9')],
        ids: idsFrom('w'),
      );

      check(draft.changes).equals(DayChanges(date: day, forgetsWaiting: true));
    });
  });

  group('with MyFitnessPal in receive only', () {
    test('a send link of a row Fūjin does not hold stays waiting', () {
      final result = read(
        [entry('E-1')],
        links: [link('E-1', 'I-1')],
        unattended: [unattendedItem('E-1')],
        ids: idsFrom('w'),
        role: Role.receiveOnly,
      );

      check(result.entries).isEmpty();
      check(result.changes).equals(DayChanges(date: day));
    });

    test('a send link of a stored entry still becomes its Ekklo link', () {
      final draft = adopt(
        [loggedEntry(entry('E-1'))],
        [entry('E-1')],
        links: [link('E-1', 'I-1')],
        ids: idsFrom('w'),
        role: Role.receiveOnly,
      );

      check(draft.changes).equals(
        DayChanges(
          date: day,
          addedEkkloLinks: [waitingLink('w-1', 'E-1')],
          forgetsWaiting: true,
        ),
      );
    });

    test('a send link of a stored entry beside a row Fūjin does not hold '
        'keeps the day waiting', () {
      final draft = adopt(
        [loggedEntry(entry('E-1'))],
        [entry('E-1'), entry('E-2')],
        links: [link('E-1', 'I-1'), link('E-2', 'I-2')],
        ids: idsFrom('w'),
        role: Role.receiveOnly,
      );

      check(draft.changes).equals(
        DayChanges(date: day, addedEkkloLinks: [waitingLink('w-1', 'E-1')]),
      );
    });
  });
}
