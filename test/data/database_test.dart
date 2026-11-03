import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show addTearDown, group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/database/schema.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/foods/food_nutrients.dart';
import 'package:fujin/data/foods/food_reference.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/comparison/entry_status.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/repositories.dart';

const _versionWithOneCopyPerFood = 2;
const _versionBeforeGoals = 3;
const _oilSpoonGrams = 14.0;
const _versionOfRelease040 = 7;
const _riceBarcode = '3017620422003';
const _skyrBarcode = '3033490004521';
const _chips = 'mfp-chips';
final _uuidV7 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

OwnCopy _ownRice(String unit) => OwnCopy(
  mfpFoodId: rice,
  mfpDescription: rice,
  ekkloFoodId: 'own-rice-$unit',
  ekkloFoodName: rice,
  mfpUnit: unit,
);

String _uuid(int number) =>
    '7f3c2a10-4b5d-4e6f-8a9b-${'$number'.padLeft(12, '0')}';

String _databasePath() {
  final directory = Directory.systemTemp.createTempSync('fujin_db_');
  addTearDown(() => directory.deleteSync(recursive: true));
  return '${directory.path}/${FujinDatabase.fileName}';
}

(String, FujinDatabase) _legacyDatabase(int version) {
  final path = _databasePath();
  final legacy = FujinDatabase.open(path)..execute('PRAGMA foreign_keys = OFF');
  for (final table in legacy.select(
    "SELECT name FROM sqlite_master WHERE type = 'table'",
  )) {
    legacy.execute('DROP TABLE ${table.columnAt(0)}');
  }
  legacy.execute('PRAGMA foreign_keys = ON');
  schemaMigrations.take(version).forEach(legacy.execute);
  legacy.execute('PRAGMA user_version = $version');
  return (path, legacy);
}

void main() {
  test('reopening a database file keeps its rows and runs no migration '
      'twice', () {
    final path = _databasePath();
    final first = FujinDatabase.open(path);
    storeEntry(first, entry('E-1'), 'e-1');
    entriesOf(first).linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');
    final stored = entriesOf(first).find('e-1');
    first.close();

    final reopened = FujinDatabase.open(path);
    addTearDown(reopened.close);

    check(reopened.schemaVersion).equals(schemaMigrations.length);
    check(entriesOf(reopened).forDate(day).entries).deepEquals([?stored]);
  });

  test('moves the own copies of a version 2 database to one row per '
      'unit', () {
    final (path, legacy) = _legacyDatabase(_versionWithOneCopyPerFood);
    legacy
      ..execute(
        'INSERT INTO memory_food (mfp_food_id, mfp_description, kind, '
        'ekklo_food_id, ekklo_food_name, mfp_food_version, mfp_unit) VALUES '
        "(?, ?, 'ekklo', ?, ?, NULL, NULL), "
        "(?, ?, 'own_copy', ?, ?, 'v1', ?), "
        "(?, ?, 'own_copy', ?, ?, NULL, NULL)",
        [
          ...[rice, rice, riceInEkklo, riceInEkklo],
          ...[oil, oil, 'own-oil', oil, tablespoon],
          ...[skyr, skyr, 'own-skyr', skyr],
        ],
      )
      ..execute(
        'INSERT INTO memory_unit (mfp_food_id, mfp_unit, grams) VALUES '
        '(?, ?, ?), (?, ?, ?)',
        [
          for (final unit in memory.units) ...[
            unit.mfpFoodId,
            unit.mfpUnit,
            unit.grams,
          ],
          ...[oil, tablespoon, _oilSpoonGrams],
        ],
      )
      ..close();

    final migrated = FujinDatabase.open(path);
    addTearDown(migrated.close);

    final loaded = memoryOf(migrated).load();
    check(loaded.matches).deepEquals([
      const MatchedFood(
        mfpFoodId: rice,
        mfpDescription: rice,
        ekkloFoodId: riceInEkklo,
        ekkloFoodName: riceInEkklo,
      ),
    ]);
    check(loaded.ownCopies).deepEquals([
      const OwnCopy(
        mfpFoodId: oil,
        mfpDescription: oil,
        ekkloFoodId: 'own-oil',
        ekkloFoodName: oil,
        mfpUnit: tablespoon,
        mfpFoodVersion: 'v1',
      ),
    ]);
    check(loaded.units).deepEquals(memory.units);
  });

  group('a 0.4.0 database', () {
    late FujinDatabase migrated;

    setUp(() {
      final (path, legacy) = _legacyDatabase(_versionOfRelease040);
      legacy
        ..insert(FujinTable.sentLink, link('E-1', 'I-1', food: rice).toMap())
        ..insert(FujinTable.unattendedItem, unattendedItem('E-2').toMap())
        ..execute(
          'INSERT INTO memory_food (mfp_food_id, mfp_description, kind, '
          'ekklo_food_id, ekklo_food_name) VALUES '
          "(?, ?, 'ekklo', ?, ?), (?, ?, 'ekklo', ?, ?)",
          [
            ...[oats, 'Flocons avoine', oatsInEkklo, 'Flocons d’avoine'],
            ...[rice, 'Riz basmati', riceInEkklo, 'Riz basmati cuit'],
          ],
        )
        ..execute(
          'INSERT INTO memory_own_copy (mfp_food_id, mfp_unit, '
          'mfp_description, kind, ekklo_food_id, ekklo_food_name, '
          "mfp_food_version) VALUES (?, ?, ?, 'own_copy', ?, ?, ?), "
          "(?, ?, ?, 'own_copy', ?, ?, NULL)",
          [
            ...[skyr, pot, 'Skyr nature', 'own-skyr-pot', 'Skyr nature', 'v3'],
            ...[skyr, grams, 'Skyr nature', 'own-skyr-g', 'Skyr nature'],
          ],
        )
        ..execute(
          'INSERT INTO memory_unit (mfp_food_id, mfp_unit, grams) VALUES '
          '(?, ?, ?), (?, ?, ?)',
          [
            ...[rice, cup, 180],
            ...[oats, bowl, 45],
          ],
        )
        ..execute(
          'INSERT INTO memory_meal (mfp_meal_name, ekklo_meal_name) VALUES '
          '(?, ?), (?, ?), (?, ?)',
          [
            ...[lunch, dejeuner],
            ...[snacks, 'Collation'],
            ...[breakfast, petitDejeuner],
          ],
        )
        ..execute(
          'INSERT INTO memory_barcode (barcode, mfp_food_id) VALUES '
          '(?, ?), (?, ?)',
          [
            ...[_skyrBarcode, skyr],
            ...[_riceBarcode, _chips],
          ],
        )
        ..execute(
          'INSERT INTO recent_food (mfp_food_id, description, brand_name, '
          'serving_value, serving_unit, servings, kilocalories, added_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?), (?, ?, NULL, ?, ?, ?, NULL, ?)',
          [
            ...[oats, 'Flocons d’avoine complète', 'Quaker', 40, grams, 1.5],
            ...[150, '2026-10-07T08:00:00.000'],
            ...[oil, 'Huile d’olive', 1, tablespoon, 2],
            '2026-10-06T19:00:00.000',
          ],
        )
        ..execute(
          'INSERT INTO goals (id, kilocalories, protein, fat) '
          'VALUES (1, 3000, 160, 70)',
        )
        ..close();
      migrated = FujinDatabase.open(path);
    });

    tearDown(() => migrated.close());

    test('keeps every remembered food, unit and meal mapping', () {
      check(migrated.schemaVersion).equals(schemaMigrations.length);
      check(memoryOf(migrated).load()).equals(
        const Memory(
          matches: [
            MatchedFood(
              mfpFoodId: oats,
              mfpDescription: 'Flocons d’avoine complète',
              ekkloFoodId: oatsInEkklo,
              ekkloFoodName: 'Flocons d’avoine',
            ),
            MatchedFood(
              mfpFoodId: rice,
              mfpDescription: 'Riz basmati',
              ekkloFoodId: riceInEkklo,
              ekkloFoodName: 'Riz basmati cuit',
            ),
          ],
          ownCopies: [
            OwnCopy(
              mfpFoodId: skyr,
              mfpDescription: 'Skyr nature',
              ekkloFoodId: 'own-skyr-g',
              ekkloFoodName: 'Skyr nature',
              mfpUnit: grams,
            ),
            OwnCopy(
              mfpFoodId: skyr,
              mfpDescription: 'Skyr nature',
              ekkloFoodId: 'own-skyr-pot',
              ekkloFoodName: 'Skyr nature',
              mfpUnit: pot,
              mfpFoodVersion: 'v3',
            ),
          ],
          units: [
            RememberedUnit(mfpFoodId: oats, mfpUnit: bowl, grams: 45),
            RememberedUnit(mfpFoodId: rice, mfpUnit: cup, grams: 180),
          ],
          meals: [
            MealMapping(mfpMealName: breakfast, ekkloMealName: petitDejeuner),
            MealMapping(mfpMealName: snacks, ekkloMealName: 'Collation'),
            MealMapping(mfpMealName: lunch, ekkloMealName: dejeuner),
          ],
          barcodeLinks: [
            BarcodeLink(barcode: _riceBarcode, mfpFoodId: _chips),
            BarcodeLink(barcode: _skyrBarcode, mfpFoodId: skyr),
          ],
        ),
      );
    });

    test('makes one food per MyFitnessPal food, named from its recent '
        'first, without servings or nutrients yet', () {
      final foods = foodsOf(migrated);

      check(foods.foods()).length.equals(5);
      check(foods.servings()).isEmpty();
      check(
        {for (final food in foods.foods()) food.name},
      ).deepEquals({
        'Flocons d’avoine complète',
        'Riz basmati',
        'Skyr nature',
        'Huile d’olive',
        null,
      });
      check(
        foods.foods().map((food) => food.nutrients).toSet(),
      ).deepEquals({const FoodNutrients()});
      check([
        for (final reference in foods.references())
          if (reference is MfpReference) reference.externalId,
      ]).unorderedEquals([oats, rice, skyr, oil, _chips]);
    });

    test('gives every new row a UUIDv7 id and a time, and deletes none', () {
      final foods = foodsOf(migrated);
      final meals = mealsOf(migrated);
      final rows = [
        for (final food in foods.foods()) (food.id, food.updatedAt),
        for (final unit in foods.units()) (unit.id, unit.updatedAt),
        for (final reference in foods.references())
          (reference.id, reference.updatedAt),
        for (final link in foods.barcodes()) (link.id, link.updatedAt),
        for (final meal in meals.meals()) (meal.id, meal.updatedAt),
        for (final mapping in meals.connectorMeals())
          (mapping.id, mapping.updatedAt),
      ];

      check(rows).length.equals(5 + 2 + 9 + 2 + 3 + 6);
      for (final (id, _) in rows) {
        check(id).matchesPattern(_uuidV7);
      }
      check(rows.map((row) => row.$1).toSet()).length.equals(rows.length);
      check(
        [
          ...foods.foods().map((food) => food.deletedAt),
          ...foods.references().map((reference) => reference.deletedAt),
          ...meals.meals().map((meal) => meal.deletedAt),
        ].nonNulls,
      ).isEmpty();
    });

    test('orders the meals by their MyFitnessPal name', () {
      check([
        for (final meal in mealsOf(
          migrated,
        ).meals().toList()..sort((a, b) => a.position.compareTo(b.position)))
          (meal.position, meal.name),
      ]).deepEquals([(0, breakfast), (1, snacks), (2, lunch)]);
    });

    test('points the barcode links and recent foods at the foods', () {
      final memory = memoryOf(migrated);

      check(memory.barcodeFood(_skyrBarcode)).equals(skyr);
      check(memory.barcodeFood(_riceBarcode)).equals(_chips);
      check(recentsOf(migrated).latest()).deepEquals([
        RecentFood(
          mfpFoodId: oats,
          description: 'Flocons d’avoine complète',
          brandName: 'Quaker',
          servingValue: 40,
          servingUnit: grams,
          servings: 1.5,
          kilocalories: 150,
          addedAt: DateTime(2026, 10, 7, 8),
        ),
        RecentFood(
          mfpFoodId: oil,
          description: 'Huile d’olive',
          servingValue: 1,
          servingUnit: tablespoon,
          servings: 2,
          addedAt: DateTime(2026, 10, 6, 19),
        ),
      ]);
    });

    test('keeps the send links, unattended items and goals, and stamps the '
        'goals', () {
      check(SentLinkRepository(migrated).all()).deepEquals([
        link('E-1', 'I-1', food: rice),
      ]);
      check(
        UnattendedItemRepository(migrated).forDate(day),
      ).deepEquals([unattendedItem('E-2')]);
      check(
        goalsOf(migrated).load(),
      ).equals(const Goals(kilocalories: 3000, protein: 160, fat: 70));
      check(
        migrated.select('SELECT updated_at FROM goals').single.columnAt(0),
      ).isA<String>().isNotEmpty();
    });

    test('starts with no entry and no MyFitnessPal or Ekklo link', () {
      final entries = entriesOf(migrated);

      check(entries.entries()).isEmpty();
      check(entries.mfpLinks()).isEmpty();
      check(entries.ekkloLinks()).isEmpty();
    });

    test('drops the old Memory tables', () {
      check([
        for (final row in migrated.select(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name LIKE 'memory_%'",
        ))
          row.columnAt(0),
      ]).isEmpty();
    });
  });

  group('a 0.4.0 database with days it sent', () {
    final sentOnDay = <SentLink>[
      link(
        _uuid(1),
        _uuid(11),
        ekkloMeal: _uuid(21),
        servings: 1.149999976158142,
        unit: 'gramme',
      ).copyWith(sentAt: DateTime.utc(2026, 10, 7, 8, 0, 0, 123, 456)),
      link(
        _uuid(2),
        _uuid(12),
        ekkloMeal: _uuid(21),
        servings: 45,
        servingValue: 1,
      ).copyWith(sentAt: DateTime.utc(2026, 10, 7, 8, 0, 0, 123, 461)),
      link(
        _uuid(3),
        _uuid(13),
        meal: lunch,
        ekkloMeal: _uuid(22),
        servings: 1.350000023841858,
        servingValue: 30,
      ).copyWith(sentAt: DateTime.utc(2026, 10, 7, 12, 30, 0, 500)),
      for (final (number, sentAt) in [
        (4, DateTime.utc(2026, 10, 7, 12, 30, 0, 500, 3)),
        (5, DateTime.utc(2026, 10, 7, 19, 45, 10, 0, 2)),
      ])
        link(
          _uuid(number),
          _uuid(10 + number),
          food: skyr,
          meal: lunch,
          ekkloMeal: _uuid(22),
          servings: 120,
          servingValue: 1,
          unit: 'gram',
        ).copyWith(sentAt: sentAt),
    ];
    final sentNextDay = link(
      _uuid(6),
      _uuid(16),
      ekkloMeal: _uuid(23),
      servings: 2.700000047683716,
      servingValue: 1,
      unit: 'gram(s)',
    ).copyWith(date: DateTime.utc(2026, 10, 8), sentAt: now);
    late FujinDatabase migrated;

    setUp(() {
      final (path, legacy) = _legacyDatabase(_versionOfRelease040);
      for (final sent in [...sentOnDay, sentNextDay]) {
        legacy.insert(FujinTable.sentLink, sent.toMap());
      }
      legacy
        ..execute(
          'INSERT INTO memory_food (mfp_food_id, mfp_description, kind, '
          "ekklo_food_id, ekklo_food_name) VALUES (?, ?, 'ekklo', ?, ?)",
          [oats, 'Flocons d’avoine', oatsInEkklo, 'Flocons d’avoine'],
        )
        ..execute(
          'INSERT INTO memory_own_copy (mfp_food_id, mfp_unit, '
          'mfp_description, kind, ekklo_food_id, ekklo_food_name, '
          "mfp_food_version) VALUES (?, ?, ?, 'own_copy', ?, ?, ?), "
          "(?, ?, ?, 'own_copy', ?, ?, ?), (?, ?, ?, 'own_copy', ?, ?, NULL)",
          [
            ...[skyr, 'gram', skyr, 'own-skyr-gram', skyr, 'v1'],
            ...[skyr, 'gramme', skyr, 'own-skyr-gramme', skyr, 'v2'],
            ...[skyr, grams, skyr, 'own-skyr-g', skyr],
          ],
        )
        ..execute(
          'INSERT INTO memory_meal (mfp_meal_name, ekklo_meal_name) VALUES '
          '(?, ?), (?, ?)',
          [
            ...[breakfast, petitDejeuner],
            ...[lunch, dejeuner],
          ],
        )
        ..close();
      migrated = FujinDatabase.open(path);
    });

    tearDown(() => migrated.close());

    test('keeps one own copy per spelling of grams, each with its '
        'version', () {
      check(memoryOf(migrated).load().ownCopies).unorderedEquals([
        for (final (unit, version) in [
          ('gram', 'v1'),
          ('gramme', 'v2'),
          (grams, null),
        ])
          OwnCopy(
            mfpFoodId: skyr,
            mfpDescription: skyr,
            ekkloFoodId: 'own-skyr-$unit',
            ekkloFoodName: skyr,
            mfpUnit: unit,
            mfpFoodVersion: version,
          ),
      ]);
    });

    test('reads a day it sent as in Ekklo, adopting each send link once '
        'without sending again', () async {
      final backends = FakeBackends(
        entries: [
          for (final sent in sentOnDay)
            entry(
              sent.mfpEntryId,
              food: sent.mfpFoodId,
              meal: sent.mfpMealName,
              servings: sent.mfpServings,
              servingValue: sent.mfpServingValue,
              unit: sent.mfpServingUnit,
            ),
        ],
        ekkloMeals: [
          meal(_uuid(21), [
            item(_uuid(11), quantity: 115),
            item(_uuid(12), quantity: 45),
          ]),
          meal(
            _uuid(22),
            [
              item(_uuid(13), quantity: 40.5),
              for (final number in [14, 15])
                item(_uuid(number), food: 'own-skyr-gram', quantity: 120),
            ],
            name: dejeuner,
          ),
        ],
      );
      final entries = entriesOf(migrated);

      final read = await journalOver(
        migrated,
        mfp: await backends.mfp(),
        ekklo: await backends.ekklo(),
      ).readDay(day);

      check(read.entries).length.equals(sentOnDay.length);
      check(read.entries).every(
        (compared) => compared
          ..has((it) => it.status, 'status').isA<InEkklo>()
          ..has((it) => it.mfpPending, 'mfpPending').isFalse(),
      );
      check({
        for (final sent in sentOnDay)
          if (entries.findByMfpEntryId(sent.mfpEntryId)?.ekkloLink?.item
              case final item?)
            sent.mfpEntryId: (item.ekkloItemId, item.servings, item.sentAt),
      }).deepEquals({
        for (final sent in sentOnDay)
          sent.mfpEntryId: (sent.ekkloItemId, sent.mfpServings, sent.sentAt),
      });
      check(entries.pendingMfp()).isEmpty();
      check([
        for (final request in backends.requests)
          if (request.method != 'GET') request.url.path,
      ]).isEmpty();
      check(SentLinkRepository(migrated).all()).deepEquals([sentNextDay]);
    });
  });

  group('sent links', () {
    late FujinDatabase database;
    late SentLinkRepository links;

    setUp(() {
      database = FujinDatabase.inMemory();
      links = SentLinkRepository(database);
    });

    tearDown(() => database.close());

    test('are read back for their own day only', () {
      final otherDay = link('E-2', 'I-2').copyWith(date: DateTime.utc(2026));
      database
        ..insert(FujinTable.sentLink, link('E-1', 'I-1').toMap())
        ..insert(FujinTable.sentLink, otherDay.toMap());

      check(links.forDate(day)).deepEquals([link('E-1', 'I-1')]);
    });
  });

  group('Ekklo links', () {
    late FujinDatabase database;
    late EntryRepository entries;

    setUp(() {
      database = FujinDatabase.inMemory();
      entries = entriesOf(database);
      for (final id in ['E-1', 'E-2', 'E-3']) {
        storeEntry(database, entry(id), id.toLowerCase());
      }
      entries.linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');
    });

    tearDown(() => database.close());

    String? itemOf(String entryId) =>
        entries.find(entryId)?.ekkloLink?.item?.ekkloItemId;

    test('move to another entry with their item', () {
      final moved = entries.find('e-1')?.ekkloLink;

      entries.store(
        DayChanges(
          date: day,
          changedEkkloLinks: [?moved?.copyWith(entryId: 'e-2')],
        ),
      );

      check(itemOf('e-1')).isNull();
      check(itemOf('e-2')).equals('I-1');
      check(entries.find('e-2')?.ekkloLink?.id).equals(moved?.id);
    });

    test('are all kept when a second live link on one item is refused', () {
      final dropped = entries.find('e-1')?.ekkloLink;
      final item = dropped?.item;

      check(
        () => entries.store(
          DayChanges(
            date: day,
            droppedEkkloLinkIds: [?dropped?.id],
            addedEkkloLinks: [
              ekkloLinkRow(
                'link-2',
                entryId: 'e-2',
                item: item?.copyWith(ekkloItemId: 'I-2'),
              ),
              ekkloLinkRow(
                'link-3',
                entryId: 'e-3',
                item: item?.copyWith(ekkloItemId: 'I-2'),
              ),
            ],
          ),
        ),
      ).throws<Object>();
      check(itemOf('e-1')).equals('I-1');
      check(itemOf('e-2')).isNull();
      check(itemOf('e-3')).isNull();
    });
  });

  group('memory', () {
    late FujinDatabase database;
    late MemoryRepository repository;
    const matched = MatchedFood(
      mfpFoodId: rice,
      mfpDescription: rice,
      ekkloFoodId: riceInEkklo,
      ekkloFoodName: riceInEkklo,
    );
    const unit = RememberedUnit(mfpFoodId: rice, mfpUnit: cup, grams: 180);

    setUp(() {
      database = FujinDatabase.inMemory();
      repository = memoryOf(database)
        ..saveFood(matched)
        ..saveUnit(unit);
    });

    tearDown(() => database.close());

    test('keeps the units of a food saved again', () {
      repository.saveFood(matched.copyWith(ekkloFoodName: 'Riz basmati'));

      final loaded = repository.load();
      check(loaded.food(rice, cup)?.ekkloFoodName).equals('Riz basmati');
      check(loaded.gramsPerUnit(rice, cup)).equals(180);
    });

    test('drops the units of a food that becomes an own copy', () {
      repository.saveFood(
        const OwnCopy(
          mfpFoodId: rice,
          mfpDescription: rice,
          ekkloFoodId: 'own-rice',
          ekkloFoodName: rice,
          mfpUnit: cup,
          mfpFoodVersion: 'v2',
        ),
      );

      final loaded = repository.load();
      check(loaded.food(rice, cup)).isA<OwnCopy>();
      check(loaded.units).isEmpty();
    });

    test('keeps one own copy per unit of a food', () {
      repository
        ..saveFood(_ownRice(cup))
        ..saveFood(_ownRice(grams));

      final loaded = repository.load();
      check(
        loaded.food(rice, cup)?.ekkloFoodId,
      ).equals(_ownRice(cup).ekkloFoodId);
      check(
        loaded.food(rice, grams)?.ekkloFoodId,
      ).equals(_ownRice(grams).ekkloFoodId);
    });

    test('forgets the own copies of a food matched again', () {
      repository
        ..saveFood(_ownRice(cup))
        ..saveFood(_ownRice(grams))
        ..saveFood(matched);

      final loaded = repository.load();
      check(loaded.food(rice, grams)).equals(matched);
      check(loaded.hasOwnCopy(rice)).isFalse();
    });

    test('forgets a matched food with its unit weights', () {
      repository.forget(matched);

      final loaded = repository.load();
      check(loaded.matches).isEmpty();
      check(loaded.units).isEmpty();
    });

    test('forgets an own copy in its unit only', () {
      repository
        ..saveFood(_ownRice(cup))
        ..saveFood(_ownRice(grams))
        ..forget(_ownRice(cup));

      final loaded = repository.load();
      check(loaded.food(rice, cup)).isNull();
      check(loaded.food(rice, grams)).equals(_ownRice(grams));
    });

    test('keeps nothing of a send whose unit weight is refused', () {
      check(
        () => repository.remember(
          meals: const [
            MealMapping(mfpMealName: snacks, ekkloMealName: snacks),
          ],
          foods: const [
            MatchedFood(
              mfpFoodId: skyr,
              mfpDescription: skyr,
              ekkloFoodId: 'isey',
              ekkloFoodName: 'isey',
            ),
          ],
          units: const [RememberedUnit(mfpFoodId: oil, mfpUnit: pot, grams: 1)],
        ),
      ).throws<Object>();

      final loaded = repository.load();
      check(loaded.food(skyr, pot)).isNull();
      check(loaded.ekkloMealName(snacks)).isNull();
    });

    test('forgets the version of an own copy saved again without one', () {
      const ownCopy = OwnCopy(
        mfpFoodId: rice,
        mfpDescription: rice,
        ekkloFoodId: 'own-rice',
        ekkloFoodName: rice,
        mfpUnit: cup,
        mfpFoodVersion: 'v2',
      );
      repository
        ..saveFood(ownCopy)
        ..saveFood(ownCopy.copyWith(mfpFoodVersion: null));

      check(repository.load().food(rice, cup)).equals(
        const OwnCopy(
          mfpFoodId: rice,
          mfpDescription: rice,
          ekkloFoodId: 'own-rice',
          ekkloFoodName: rice,
          mfpUnit: cup,
        ),
      );
    });

    test('clears every remembered food, unit, meal and barcode link but no '
        'Ekklo link', () {
      storeEntry(database, entry('E-1'), 'e-1');
      final entries = entriesOf(database)
        ..linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1');
      final links = entries.ekkloLinks();
      repository
        ..saveFood(_ownRice(grams))
        ..saveMeal(memory.meals.first)
        ..saveBarcodeLink(
          const BarcodeLink(barcode: _riceBarcode, mfpFoodId: rice),
        )
        ..clear();

      check(repository.load()).equals(const Memory());
      check(repository.barcodeFood(_riceBarcode)).isNull();
      check(entries.ekkloLinks()).deepEquals(links);
    });

    test('offers the food last linked to a barcode', () {
      check(repository.barcodeFood(_riceBarcode)).isNull();

      repository.saveBarcodeLink(
        const BarcodeLink(barcode: _riceBarcode, mfpFoodId: oats),
      );
      check(repository.barcodeFood(_riceBarcode)).equals(oats);

      repository.saveBarcodeLink(
        const BarcodeLink(barcode: _riceBarcode, mfpFoodId: rice),
      );
      check(repository.barcodeFood(_riceBarcode)).equals(rice);
      check(
        repository.load().barcodeLinks,
      ).deepEquals([const BarcodeLink(barcode: _riceBarcode, mfpFoodId: rice)]);
    });
  });

  test('keeps the memory and links of a version 3 database when the goals '
      'table arrives', () {
    final (path, legacy) = _legacyDatabase(_versionBeforeGoals);
    legacy
      ..insert(FujinTable.sentLink, link('E-1', 'I-1').toMap())
      ..execute(
        'INSERT INTO memory_food (mfp_food_id, mfp_description, kind, '
        "ekklo_food_id, ekklo_food_name) VALUES (?, ?, 'ekklo', ?, ?), "
        "(?, ?, 'ekklo', ?, ?)",
        [
          for (final food in memory.matches) ...[
            food.mfpFoodId,
            food.mfpDescription,
            food.ekkloFoodId,
            food.ekkloFoodName,
          ],
        ],
      )
      ..execute(
        'INSERT INTO memory_unit (mfp_food_id, mfp_unit, grams) '
        'VALUES (?, ?, ?)',
        [
          for (final unit in memory.units) ...[
            unit.mfpFoodId,
            unit.mfpUnit,
            unit.grams,
          ],
        ],
      )
      ..execute(
        'INSERT INTO memory_meal (mfp_meal_name, ekklo_meal_name) '
        'VALUES (?, ?), (?, ?)',
        [
          for (final meal in memory.meals) ...[
            meal.mfpMealName,
            meal.ekkloMealName,
          ],
        ],
      )
      ..close();

    final migrated = FujinDatabase.open(path);
    addTearDown(migrated.close);

    check(migrated.schemaVersion).equals(schemaMigrations.length);
    check(memoryOf(migrated).load()).equals(memory);
    check(SentLinkRepository(migrated).all()).deepEquals([link('E-1', 'I-1')]);
    check(goalsOf(migrated).load()).isNull();
  });

  group('meals arranged from the diary', () {
    const dinner = 'Dinner';
    late FujinDatabase database;
    late MealRepository meals;

    List<String> ordered() => [
      for (final meal
          in meals.meals()..sort((a, b) => a.position.compareTo(b.position)))
        meal.name,
    ];

    setUp(() {
      database = FujinDatabase.inMemory();
      meals = mealsOf(database);
      for (final name in [snacks, dinner, lunch]) {
        meals.mfpMeal(name, id: 'meal-$name');
      }
    });

    tearDown(() => database.close());

    test('follow the order of its names, the others after in their own '
        'order', () {
      meals.arrange([breakfast, lunch]);

      check(ordered()).deepEquals([breakfast, lunch, snacks, dinner]);
    });

    test('get one meal per name missing, mapped to MyFitnessPal', () {
      meals
        ..arrange([breakfast, lunch])
        ..arrange([lunch, breakfast]);

      check(ordered()).deepEquals([lunch, breakfast, snacks, dinner]);
      check(meals.mealOfMfp(breakfast)).isNotNull();
      check(meals.mealOfMfp(lunch)).equals('meal-$lunch');
    });
  });

  group('goals', () {
    late FujinDatabase database;
    late GoalsRepository goals;
    const complete = Goals(
      kilocalories: 3000,
      protein: 160,
      carbohydrates: 400,
      fat: 70,
      fiber: 40,
    );

    setUp(() {
      database = FujinDatabase.inMemory();
      goals = goalsOf(database);
    });

    tearDown(() => database.close());

    test('are read back as saved, one row for every day', () {
      goals.save(complete);

      check(goals.load()).equals(complete);
      check(database.select('SELECT * FROM goals')).length.equals(1);
    });

    test('forget a macro left empty when saved again', () {
      goals
        ..save(complete)
        ..save(const Goals(kilocalories: 2500, protein: 150));

      check(
        goals.load(),
      ).equals(const Goals(kilocalories: 2500, protein: 150));
    });

    test('are gone after a replace with none', () {
      goals
        ..save(complete)
        ..replace(null);

      check(goals.load()).isNull();
    });
  });

  group('recent foods', () {
    late FujinDatabase database;

    setUp(() => database = FujinDatabase.inMemory());
    tearDown(() => database.close());

    test('keeps the 20 latest foods', () {
      final recents = recentsOf(database);
      for (var minute = 0; minute <= 20; minute++) {
        recents.record(
          RecentFood(
            mfpFoodId: 'food-$minute',
            description: 'food-$minute',
            servingValue: 100,
            servingUnit: grams,
            servings: 1,
            addedAt: now.add(Duration(minutes: minute)),
          ),
        );
      }

      final latest = recents.latest();

      check(latest).length.equals(20);
      check(latest.first.mfpFoodId).equals('food-20');
      check(latest.last.mfpFoodId).equals('food-1');
    });
  });
}
