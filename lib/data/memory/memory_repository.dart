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
    foods: [
      for (final row in _database.select(
        'SELECT * FROM memory_food ORDER BY mfp_description',
      ))
        RememberedFoodMapper.fromMap(row),
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
      case OwnCopy(:final mfpFoodId):
        _database.execute('DELETE FROM memory_unit WHERE mfp_food_id = ?', [
          mfpFoodId,
        ]);
      case MatchedFood():
        break;
    }
    _database.upsert(
      FujinTable.memoryFood,
      food.toMap(),
      key: const [_mfpFoodId],
    );
  });

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

  static const _mfpFoodId = 'mfp_food_id';
  static const _mfpUnit = 'mfp_unit';
  static const _mfpMealName = 'mfp_meal_name';
}
