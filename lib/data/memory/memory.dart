import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

part 'memory.mapper.dart';

@MappableClass()
final class Memory with MemoryMappable {
  const Memory({
    this.foods = const [],
    this.units = const [],
    this.meals = const [],
  });

  final List<RememberedFood> foods;
  final List<RememberedUnit> units;
  final List<MealMapping> meals;

  RememberedFood? food(String mfpFoodId) =>
      foods.where((food) => food.mfpFoodId == mfpFoodId).firstOrNull;

  double? gramsPerUnit(String mfpFoodId, String mfpUnit) => units
      .where((unit) => unit.mfpFoodId == mfpFoodId && unit.mfpUnit == mfpUnit)
      .firstOrNull
      ?.grams;

  String? ekkloMealName(String mfpMealName) => meals
      .where((meal) => meal.mfpMealName == mfpMealName)
      .firstOrNull
      ?.ekkloMealName;
}
