import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

final class MemoryRepository {
  const MemoryRepository(this._database);

  final FujinDatabase _database;

  Memory load() => Memory(
    matches: [
      for (final row in _database.select(
        'SELECT * FROM memory_food ORDER BY mfp_description',
      ))
        MatchedFoodMapper.fromMap(row),
    ],
    ownCopies: [
      for (final row in _database.select(
        'SELECT * FROM memory_own_copy ORDER BY mfp_description, mfp_unit',
      ))
        OwnCopyMapper.fromMap(row),
    ],
    units: [
      for (final row in _database.select(
        'SELECT * FROM memory_unit ORDER BY mfp_food_id, mfp_unit',
      ))
        RememberedUnitMapper.fromMap(row),
    ],
    meals: [
      for (final row in _database.select(
        'SELECT * FROM memory_meal ORDER BY mfp_meal_name',
      ))
        MealMappingMapper.fromMap(row),
    ],
  );

  void saveFood(RememberedFood food) => _database.transaction(() {
    switch (food) {
      case OwnCopy():
        _database
          ..execute('DELETE FROM memory_food WHERE mfp_food_id = ?', [
            food.mfpFoodId,
          ])
          ..upsert(
            FujinTable.memoryOwnCopy,
            food.toMap(),
            key: const [_mfpFoodId, _mfpUnit],
          );
      case MatchedFood():
        _database
          ..execute('DELETE FROM memory_own_copy WHERE mfp_food_id = ?', [
            food.mfpFoodId,
          ])
          ..upsert(
            FujinTable.memoryFood,
            food.toMap(),
            key: const [_mfpFoodId],
          );
    }
  });

  void forget(RememberedFood food) => switch (food) {
    OwnCopy() => _database.execute(
      'DELETE FROM memory_own_copy WHERE mfp_food_id = ? AND mfp_unit = ?',
      [food.mfpFoodId, food.mfpUnit],
    ),
    MatchedFood() => _database.execute(
      'DELETE FROM memory_food WHERE mfp_food_id = ?',
      [food.mfpFoodId],
    ),
  };

  void saveUnit(RememberedUnit unit) => _database.upsert(
    FujinTable.memoryUnit,
    unit.toMap(),
    key: const [_mfpFoodId, _mfpUnit],
  );

  void saveMeal(MealMapping meal) => _database.upsert(
    FujinTable.memoryMeal,
    meal.toMap(),
    key: const [_mfpMealName],
  );

  void remember({
    required Iterable<MealMapping> meals,
    required Iterable<RememberedFood> foods,
    required Iterable<RememberedUnit> units,
  }) => _database.transaction(() {
    meals.forEach(saveMeal);
    foods.forEach(saveFood);
    units.forEach(saveUnit);
  });

  void clear() => _database.transaction(() {
    _database
      ..execute('DELETE FROM memory_unit')
      ..execute('DELETE FROM memory_food')
      ..execute('DELETE FROM memory_own_copy')
      ..execute('DELETE FROM memory_meal');
  });

  void replace(Memory memory) => _database.transaction(() {
    clear();
    remember(
      meals: memory.meals,
      foods: [...memory.matches, ...memory.ownCopies],
      units: memory.units,
    );
  });

  static const _mfpFoodId = 'mfp_food_id';
  static const _mfpUnit = 'mfp_unit';
  static const _mfpMealName = 'mfp_meal_name';
}
