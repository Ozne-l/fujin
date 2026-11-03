import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/entries/copied_food.dart';
import 'package:fujin/data/entries/copied_meal.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/foods/food_reference.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';

import '../support/fixtures.dart';
import '../support/repositories.dart';

void main() {
  late FujinDatabase database;
  late DateTime time;
  late EntryRepository entries;

  setUp(() {
    database = FujinDatabase.inMemory();
    time = now;
    entries = entriesOf(database, clock: () => time);
  });

  tearDown(() => database.close());

  MfpLink copiedLink(String entryId, String mfpEntryId) => mfpLinkRow(
    'link-$entryId',
    entryId: entryId,
    mfpEntryId: mfpEntryId,
  );

  group('a day', () {
    test('lists its live entries by meal position, then id, with their food, '
        'meal and links', () {
      mealsOf(database).arrange([breakfast, lunch]);
      storeEntry(database, entry('E-2', food: rice, meal: lunch), 'e-2');
      storeEntry(
        database,
        entry('E-3', description: 'Flocons d’avoine', brand: 'Quaker'),
        'e-3',
      );
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(
        database,
        entry('E-4', date: DateTime.utc(2026, 10, 8)),
        'e-4',
      );
      entries.linkItem('e-3', ekkloMealId: 'meal-1', ekkloItemId: 'I-3');

      final stored = entries.forDate(day);

      check([
        for (final logged in stored.entries) logged.entry.id,
      ]).deepEquals(['e-1', 'e-3', 'e-2']);
      check(stored.entries[1])
        ..has((logged) => logged.foodName, 'food name').equals(
          'Flocons d’avoine',
        )
        ..has((logged) => logged.brand, 'brand').equals('Quaker')
        ..has((logged) => logged.mfpFoodId, 'MyFitnessPal food').equals(oats)
        ..has((logged) => logged.mealName, 'meal').equals(breakfast)
        ..has(
          (logged) => logged.mfpLink?.mfpEntryId,
          'MyFitnessPal entry',
        ).equals('E-3')
        ..has(
          (logged) => logged.ekkloLink?.item?.ekkloItemId,
          'item',
        ).equals('I-3');
      check(stored.deleted).isEmpty();
    });

    test('keeps the Ekklo links of its deleted entries, and only those', () {
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-2');
      storeEntry(database, entry('E-3'), 'e-3');
      entries
        ..linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1')
        ..expect({'e-2': expectation()})
        ..remove('e-1')
        ..remove('e-2');

      final stored = entries.forDate(day);

      check([
        for (final logged in stored.entries) logged.entry.id,
      ]).deepEquals(['e-3']);
      check(stored.deleted).single
        ..has((logged) => logged.entry.id, 'entry').equals('e-1')
        ..has(
          (logged) => logged.mfpLink?.mfpEntryId,
          'MyFitnessPal entry',
        ).equals('E-1')
        ..has(
          (logged) => logged.ekkloLink?.item?.ekkloItemId,
          'item',
        ).equals('I-1');
      check(entries.find('e-1')).isNull();
      check(entries.findByMfpEntryId('E-1')).isNull();
    });
  });

  group('pending in MyFitnessPal', () {
    test('lists an entry without a link, an edited entry and a deleted '
        'linked entry', () {
      storeEntry(database, entry('E-3'), 'e-3');
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-2');
      storeEntry(database, entry('E-4'), 'e-4');
      entries
        ..unlinkMfp('e-1')
        ..saveEntry(
          entries.find('e-2')?.entry.copyWith(servings: 2) ?? _missing(),
        )
        ..remove('e-3');

      check({
        for (final write in entries.pendingMfp())
          write.logged.entry.id: write.runtimeType,
      }).deepEquals({'e-1': MfpAdd, 'e-2': MfpEdit, 'e-3': MfpDeletion});
    });

    test('does not list an entry restamped by a read with unchanged '
        'values', () {
      storeEntry(database, entry('E-1'), 'e-1');
      time = now.add(const Duration(hours: 1));

      entries.saveEntry(entries.find('e-1')?.entry ?? _missing());

      check(entries.find('e-1')?.entry.updatedAt).equals(time);
      check(entries.pendingMfp()).isEmpty();
    });

    test('agrees with MfpWrite.of on every listed and unlisted entry', () {
      final lunchId = mealsOf(database).mfpMeal(lunch, id: 'meal-lunch');
      final riceId = foodsOf(
        database,
      ).copiedMfpFood(rice, id: 'food-rice', name: rice, brand: null);
      for (final id in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']) {
        storeEntry(database, entry('E-$id'), id);
      }
      Entry stored(String id) => entries.find(id)?.entry ?? _missing();
      entries
        ..saveEntry(stored('b').copyWith(mealId: lunchId))
        ..saveEntry(stored('c').copyWith(foodId: riceId))
        ..saveEntry(
          stored('d').copyWith(date: day.add(const Duration(days: 1))),
        )
        ..saveEntry(stored('e').copyWith(servings: 3))
        ..saveEntry(stored('f').copyWith(servingValue: 50))
        ..saveEntry(stored('g').copyWith(servingUnit: cup))
        ..unlinkMfp('h')
        ..remove('i')
        ..unlinkMfp('j')
        ..remove('j');

      final listed = {
        for (final write in entries.pendingMfp()) write.logged.entry.id,
      };

      check(listed).deepEquals({'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'});
      for (final row in entries.entries()) {
        final logged = entries.findAny(row.id);
        check(
              switch (logged) {
                final logged? => MfpWrite.of(logged),
                null => null,
              },
              because: row.id,
            )
            .has((write) => write != null, 'pending')
            .equals(
              listed.contains(row.id),
            );
      }
    });

    test('keeps the MyFitnessPal link of a removed entry', () {
      storeEntry(database, entry('E-1'), 'e-1');

      entries.remove('e-1');

      check(entries.find('e-1')).isNull();
      check(entries.findAny('e-1'))
        ..has((logged) => logged?.entry.deletedAt, 'deleted at').equals(now)
        ..has(
          (logged) => logged?.mfpLink?.mfpEntryId,
          'MyFitnessPal entry',
        ).equals('E-1');
      check(entries.heldMfpEntryIds(day)).deepEquals({'E-1'});
    });

    test("returns owed entries of the link's day, not the entry's", () {
      final tomorrow = day.add(const Duration(days: 1));
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-2');
      storeEntry(database, entry('E-3'), 'e-3');
      entries
        ..saveEntry(
          entries.find('e-1')?.entry.copyWith(date: tomorrow) ?? _missing(),
        )
        ..remove('e-2');

      final today = entries.forDate(day);
      final next = entries.forDate(tomorrow);

      check([
        for (final logged in today.entries) logged.entry.id,
      ]).deepEquals(['e-3']);
      check([
        for (final logged in today.owed) logged.entry.id,
      ]).deepEquals(['e-1', 'e-2']);
      check([
        for (final logged in next.entries) logged.entry.id,
      ]).deepEquals(['e-1']);
      check(next.owed).isEmpty();
    });
  });

  group('storing a day', () {
    test('copies in entries with their foods and meals, naming only a food '
        'without a name and never its version', () {
      mealsOf(database).arrange([breakfast, lunch]);
      final foods = foodsOf(database);
      final namelessOats = foods.mfpFood(oats);
      final namedRice = foods.describedMfpFood(
        rice,
        name: 'Riz',
        brand: null,
      );

      entries.store(
        DayChanges(
          date: day,
          foods: const [
            CopiedFood(
              id: 'f-oats',
              mfpFoodId: oats,
              name: 'Flocons d’avoine',
              brand: 'Quaker',
            ),
            CopiedFood(id: 'f-rice', mfpFoodId: rice, name: 'Riz basmati'),
            CopiedFood(id: 'f-skyr', mfpFoodId: skyr, name: 'Skyr nature'),
          ],
          meals: const [CopiedMeal(id: 'm-snacks', mfpMealName: snacks)],
          addedEntries: [
            entryRow('e-1', foodId: 'f-oats', mealId: 'm-snacks'),
            entryRow('e-2', foodId: 'f-rice', mealId: 'm-snacks'),
            entryRow('e-3', foodId: 'f-skyr', mealId: 'm-snacks'),
          ],
          addedMfpLinks: [
            copiedLink('e-1', 'E-1'),
            copiedLink('e-2', 'E-2'),
            copiedLink('e-3', 'E-3'),
          ],
        ),
      );

      check([
        for (final logged in entries.forDate(day).entries)
          (logged.entry.foodId, logged.foodName, logged.brand, logged.mealName),
      ]).deepEquals([
        (namelessOats, 'Flocons d’avoine', 'Quaker', snacks),
        (namedRice, 'Riz', null, snacks),
        ('f-skyr', 'Skyr nature', null, snacks),
      ]);
      check([
        for (final reference in foods.references())
          if (reference is MfpReference) reference.version,
      ]).deepEquals([null, null, null]);
      check(
        [
          for (final meal in mealsOf(
            database,
          ).meals()..sort((a, b) => a.position.compareTo(b.position)))
            meal.name,
        ],
      ).deepEquals([breakfast, lunch, snacks]);
    });

    test('forgets the waiting rows of its own day only', () {
      final otherDay = link('E-9', 'I-9').copyWith(date: DateTime.utc(2026));
      database
        ..insert(FujinTable.sentLink, link('E-1', 'I-1').toMap())
        ..insert(FujinTable.sentLink, otherDay.toMap())
        ..insert(FujinTable.unattendedItem, unattendedItem('E-2').toMap());

      entries.store(DayChanges(date: day, forgetsWaiting: true));

      check(SentLinkRepository(database).all()).deepEquals([otherDay]);
      check(UnattendedItemRepository(database).forDate(day)).isEmpty();
    });

    test('stores nothing of a day whose MyFitnessPal entry is already '
        'held', () {
      storeEntry(database, entry('E-1'), 'e-1');
      final foodId = foodsOf(database).mfpFood(oats);
      final mealId = mealsOf(database).mfpMeal(breakfast, id: 'unused');

      check(
        () => entries.store(
          DayChanges(
            date: day,
            addedEntries: [entryRow('e-2', foodId: foodId, mealId: mealId)],
            addedMfpLinks: [copiedLink('e-2', 'E-1')],
          ),
        ),
      ).throws<Object>();
      check([for (final entry in entries.entries()) entry.id]).deepEquals([
        'e-1',
      ]);
    });
  });

  group('a written entry', () {
    test('takes over the row a read copied in under its MyFitnessPal id, '
        'with its Ekklo link', () {
      storeEntry(database, entry('E-1'), 'e-copy');
      entries.linkItem('e-copy', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');
      final copy = entries.find('e-copy');

      entries.saveLink(
        copiedLink('e-added', 'E-1'),
        entry: copy?.entry.copyWith(id: 'e-added') ?? _missing(),
      );

      check(entries.find('e-copy')).isNull();
      check(entries.findByMfpEntryId('E-1'))
        ..has((logged) => logged?.entry.id, 'entry').equals('e-added')
        ..has(
          (logged) => logged?.ekkloLink?.item?.ekkloItemId,
          'item',
        ).equals('I-1');
      check(entries.forDate(day).deleted).isEmpty();
    });

    test('keeps its Fūjin id and Ekklo item when edited, its MyFitnessPal '
        'link moving to the copy', () {
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2', servings: 2), 'e-copy');
      entries
        ..linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1')
        ..linkItem('e-copy', ekkloMealId: 'meal-1', ekkloItemId: 'I-2');
      final original = entries.find('e-1');

      entries
        ..saveEntry(original?.entry.copyWith(servings: 2) ?? _missing())
        ..saveLink(copiedLink('e-1', 'E-2').copyWith(servings: 2));

      check(entries.forDate(day).entries).single
        ..has((logged) => logged.entry.id, 'entry').equals('e-1')
        ..has((logged) => logged.entry.servings, 'servings').equals(2)
        ..has(
          (logged) => logged.mfpLink?.id,
          'MyFitnessPal link row',
        ).equals(original?.mfpLink?.id)
        ..has(
          (logged) => logged.mfpLink?.mfpEntryId,
          'MyFitnessPal entry',
        ).equals('E-2')
        ..has(
          (logged) => logged.ekkloLink?.item?.ekkloItemId,
          'item',
        ).equals('I-1');
      check(entries.forDate(day).deleted).isEmpty();
    });

    test('takes the item of the copy it takes over but keeps its own '
        'expectation', () {
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-copy');
      entries
        ..expect({'e-1': expectation(quantity: 120)})
        ..linkItem('e-copy', ekkloMealId: 'meal-1', ekkloItemId: 'I-2');
      final original = entries.find('e-1');

      entries.saveLink(
        copiedLink('e-1', 'E-2'),
        entry: original?.entry ?? _missing(),
      );

      check(entries.find('e-1')?.ekkloLink)
        ..has((link) => link?.item?.ekkloItemId, 'item').equals('I-2')
        ..has((link) => link?.unattended, 'expectation').equals(
          expectation(quantity: 120),
        );
      check([
        for (final link in entries.ekkloLinks())
          if (link.deletedAt == null) link.entryId,
      ]).deepEquals(['e-1']);
    });
  });

  group('an Ekklo link', () {
    test('keeps an expectation written before its item, and goes once an '
        'item-less one is forgotten', () {
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-2');
      entries
        ..expect({'e-1': expectation(), 'e-2': expectation()})
        ..linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');

      check(entries.find('e-1')?.ekkloLink?.unattended).equals(expectation());

      entries.forgetExpectations(['e-1', 'e-2']);

      check(entries.find('e-1')?.ekkloLink)
        ..has((link) => link?.item?.ekkloItemId, 'item').equals('I-1')
        ..has((link) => link?.unattended, 'expectation').isNull();
      check(entries.find('e-2')?.ekkloLink).isNull();
    });

    test('survives the removal of its item only for its expectation', () {
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-2');
      entries
        ..linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1')
        ..linkItem('e-2', ekkloMealId: 'meal-1', ekkloItemId: 'I-2')
        ..expect({'e-1': expectation()})
        ..unlinkItem('e-1')
        ..unlinkItem('e-2');

      check(entries.find('e-1')?.ekkloLink)
        ..has((link) => link?.item, 'item').isNull()
        ..has((link) => link?.unattended, 'expectation').equals(expectation());
      check(entries.find('e-2')?.ekkloLink).isNull();
    });

    test('refreshes the values written to the entry edited since, keeping '
        'when it was sent', () {
      storeEntry(database, entry('E-1'), 'e-1');
      entries.linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');
      final original = entries.find('e-1');
      time = now.add(const Duration(hours: 1));
      entries.saveLink(
        copiedLink('e-1', 'E-1'),
        entry: original?.entry.copyWith(servings: 2) ?? _missing(),
      );

      check(
        entries.find('e-1')?.ekkloLink?.item?.servings,
      ).equals(1);

      entries.refreshLink('e-1');

      check(entries.find('e-1')?.ekkloLink?.item)
        ..has((item) => item?.servings, 'servings').equals(2)
        ..has((item) => item?.sentAt, 'sent at').equals(now);
    });

    test('refuses a second live link on one item', () {
      storeEntry(database, entry('E-1'), 'e-1');
      storeEntry(database, entry('E-2'), 'e-2');
      entries.linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');

      check(
        () =>
            entries.linkItem('e-2', ekkloMealId: 'meal-1', ekkloItemId: 'I-1'),
      ).throws<Object>();
      check(entries.find('e-2')?.ekkloLink).isNull();
    });
  });
}

Entry _missing() => throw StateError('the entry was not stored');
