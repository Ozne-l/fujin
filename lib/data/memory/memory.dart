import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/memory/barcode_link.dart';
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
    this.barcodeLinks = const [],
  });

  final List<MatchedFood> matches;
  final List<OwnCopy> ownCopies;
  final List<RememberedUnit> units;
  final List<MealMapping> meals;
  final List<BarcodeLink> barcodeLinks;

  RememberedFood? food(String mfpFoodId, String? mfpUnit) =>
      matches.where((food) => food.mfpFoodId == mfpFoodId).firstOrNull ??
      switch (mfpUnit) {
        null => null,
        final mfpUnit =>
          ownCopies
              .where(
                (copy) =>
                    copy.mfpFoodId == mfpFoodId && copy.mfpUnit == mfpUnit,
              )
              .firstOrNull,
      };

  bool hasOwnCopy(String mfpFoodId) =>
      ownCopies.any((copy) => copy.mfpFoodId == mfpFoodId);

  double? gramsPerUnit(String mfpFoodId, String mfpUnit) => units
      .where((unit) => unit.mfpFoodId == mfpFoodId && unit.mfpUnit == mfpUnit)
      .firstOrNull
      ?.grams;

  List<RememberedUnit> unitsOf(RememberedFood food) => switch (food) {
    MatchedFood(:final mfpFoodId) => [
      for (final unit in units)
        if (unit.mfpFoodId == mfpFoodId) unit,
    ],
    OwnCopy() => const [],
  };

  String? ekkloMealName(String mfpMealName) => meals
      .where((meal) => meal.mfpMealName == mfpMealName)
      .firstOrNull
      ?.ekkloMealName;
}
