import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show addTearDown, group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/database/schema.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

import '../support/fixtures.dart';

const _versionWithOneCopyPerFood = 2;
const _versionBeforeGoals = 3;
const _oilSpoonGrams = 14.0;

OwnCopy _ownRice(String unit) => OwnCopy(
  mfpFoodId: rice,
  mfpDescription: rice,
  ekkloFoodId: 'own-rice-$unit',
  ekkloFoodName: rice,
  mfpUnit: unit,
);

String _databasePath() {
  final directory = Directory.systemTemp.createTempSync('fujin_db_');
  addTearDown(() => directory.deleteSync(recursive: true));
  return '${directory.path}/${FujinDatabase.fileName}';
}

(String, FujinDatabase) _legacyDatabase(int version) {
  final path = _databasePath();
  final legacy = FujinDatabase.open(path);
  for (final table in FujinTable.values) {
    legacy.execute('DROP TABLE ${table.sqlName}');
  }
  schemaMigrations.take(version).forEach(legacy.execute);
  legacy.execute('PRAGMA user_version = $version');
  return (path, legacy);
}

void main() {
  test('reopening a database file keeps its rows and runs no migration '
      'twice', () {
    final path = _databasePath();
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

    test('clears every remembered food, unit and meal but no sent link', () {
      final links = SentLinkRepository(database)..add(link('E-1', 'I-1'));
      repository
        ..saveFood(_ownRice(grams))
        ..saveMeal(memory.meals.first)
        ..clear();

      check(repository.load()).equals(const Memory());
      check(links.all()).deepEquals([link('E-1', 'I-1')]);
    });
  });

  test('keeps the memory and links of a version 3 database when the goals '
      'table arrives', () {
    final (path, legacy) = _legacyDatabase(_versionBeforeGoals);
    SentLinkRepository(legacy).add(link('E-1', 'I-1'));
    MemoryRepository(legacy).remember(
      meals: memory.meals,
      foods: memory.matches,
      units: memory.units,
    );
    legacy.close();

    final migrated = FujinDatabase.open(path);
    addTearDown(migrated.close);

    check(migrated.schemaVersion).equals(schemaMigrations.length);
    check(MemoryRepository(migrated).load()).equals(memory);
    check(SentLinkRepository(migrated).all()).deepEquals([link('E-1', 'I-1')]);
    check(GoalsRepository(migrated).load()).isNull();
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
      goals = GoalsRepository(database);
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
}
