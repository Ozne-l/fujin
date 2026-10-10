import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

part 'memory.mapper.dart';

@MappableClass()
final class Memory with MemoryMappable {
  const Memory({
    this.matches = const [],
    this.ownCopies = const [],
    this.units = const [],
    this.meals = const [],
  });

  final List<MatchedFood> matches;
  final List<OwnCopy> ownCopies;
  final List<RememberedUnit> units;
  final List<MealMapping> meals;

  RememberedFood? food(String mfpFoodId, String mfpUnit) =>
      matches.where((food) => food.mfpFoodId == mfpFoodId).firstOrNull ??
      ownCopies
          .where(
            (copy) => copy.mfpFoodId == mfpFoodId && copy.mfpUnit == mfpUnit,
          )
          .firstOrNull;

  bool hasOwnCopy(String mfpFoodId) =>
      ownCopies.any((copy) => copy.mfpFoodId == mfpFoodId);

  double? gramsPerUnit(String mfpFoodId, String mfpUnit) => units
      .where((unit) => unit.mfpFoodId == mfpFoodId && unit.mfpUnit == mfpUnit)
      .firstOrNull
      ?.grams;

  String? ekkloMealName(String mfpMealName) => meals
      .where((meal) => meal.mfpMealName == mfpMealName)
      .firstOrNull
      ?.ekkloMealName;
}
