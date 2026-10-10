import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show addTearDown, group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/database/schema.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

import '../support/fixtures.dart';

const _versionWithOneCopyPerFood = 2;
const _oilSpoonGrams = 14.0;

OwnCopy _ownRice(String unit) => OwnCopy(
  mfpFoodId: rice,
  mfpDescription: rice,
  ekkloFoodId: 'own-rice-$unit',
  ekkloFoodName: rice,
  mfpUnit: unit,
);

void main() {
  test('reopening a database file keeps its rows and runs no migration '
      'twice', () {
    final directory = Directory.systemTemp.createTempSync('fujin_db_');
    addTearDown(() => directory.deleteSync(recursive: true));
    final path = '${directory.path}/${FujinDatabase.fileName}';
    final first = FujinDatabase.open(path);
    SentLinkRepository(first).add(link('E-1', 'I-1'));
    first.close();

    final reopened = FujinDatabase.open(path);
    addTearDown(reopened.close);

    check(reopened.schemaVersion).equals(schemaMigrations.length);
    check(SentLinkRepository(reopened).forDate(day)).deepEquals([
      link('E-1', 'I-1'),
    ]);
  });

  test('moves the own copies of a version 2 database to one row per '
      'unit', () {
    final directory = Directory.systemTemp.createTempSync('fujin_db_');
    addTearDown(() => directory.deleteSync(recursive: true));
    final path = '${directory.path}/${FujinDatabase.fileName}';
    final legacy = FujinDatabase.open(path);
    for (final table in FujinTable.values) {
      legacy.execute('DROP TABLE ${table.sqlName}');
    }
    schemaMigrations.take(_versionWithOneCopyPerFood).forEach(legacy.execute);
    legacy
      ..execute('PRAGMA user_version = $_versionWithOneCopyPerFood')
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

    final loaded = MemoryRepository(migrated).load();
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
      links
        ..add(link('E-1', 'I-1'))
        ..add(otherDay);

      check(links.forDate(day)).deepEquals([link('E-1', 'I-1')]);
    });

    test('move to a new entry when dropped and adopted together', () {
      links
        ..add(link('E-1', 'I-1'))
        ..replace(dropped: [link('E-1', 'I-1')], adopted: [link('E-2', 'I-1')]);

      check(links.forDate(day)).deepEquals([link('E-2', 'I-1')]);
    });

    test('are all kept when one adoption is refused', () {
      links.add(link('E-1', 'I-1'));

      check(
        () => links.replace(
          dropped: [link('E-1', 'I-1')],
          adopted: [link('E-2', 'I-2'), link('E-3', 'I-2')],
        ),
      ).throws<Object>();
      check(links.forDate(day)).deepEquals([link('E-1', 'I-1')]);
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
      repository = MemoryRepository(database)
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
  });
}
