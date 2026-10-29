import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

final class MemoryRepository {
  const MemoryRepository({
    required this._database,
    required this._foods,
    required this._meals,
  });

  final FujinDatabase _database;
  final FoodRepository _foods;
  final MealRepository _meals;

  Memory load() => Memory(
    matches: _foods.matches(),
    ownCopies: _foods.ownCopies(),
    units: _foods.rememberedUnits(),
    meals: _meals.mappings(),
    barcodeLinks: _foods.barcodeLinks(),
  );

  String? barcodeFood(String barcode) => _foods.barcodeFood(barcode);

  void saveBarcodeLink(BarcodeLink link) => _database.transaction(
    () => _foods.linkBarcode(link.barcode, _foods.mfpFood(link.mfpFoodId)),
  );

  void saveFood(RememberedFood food) => _database.transaction(() {
    final foodId = _foods.mfpFood(food.mfpFoodId, name: food.mfpDescription);
    switch (food) {
      case OwnCopy():
        _foods.ownCopy(
          foodId,
          ekkloFoodId: food.ekkloFoodId,
          name: food.ekkloFoodName,
          unit: food.mfpUnit,
          version: food.mfpFoodVersion,
        );
      case MatchedFood():
        _foods.match(
          foodId,
          ekkloFoodId: food.ekkloFoodId,
          name: food.ekkloFoodName,
        );
    }
  });

  void forget(RememberedFood food) {
    if (_foods.foodOfMfp(food.mfpFoodId) case final foodId?) {
      switch (food) {
        case OwnCopy():
          _foods.forgetOwnCopy(foodId, food.mfpUnit);
        case MatchedFood():
          _foods.forgetMatch(foodId);
      }
    }
  }

  void saveUnit(RememberedUnit unit) => switch (_foods.foodOfMfp(
    unit.mfpFoodId,
  )) {
    final foodId? when _foods.isMatched(foodId) => _foods.saveUnit(
      foodId,
      unit.mfpUnit,
      unit.grams,
    ),
    _ => throw StateError('a unit weight needs a matched food'),
  };

  void saveMeal(MealMapping meal) => _meals.map(meal);

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
    _foods.forgetMemory();
    _meals.forgetEkkloMappings();
  });

  void restore(Memory memory) => _database.transaction(() {
    remember(
      meals: [...memory.meals]
        ..sort((a, b) => a.mfpMealName.compareTo(b.mfpMealName)),
      foods: [...memory.matches, ...memory.ownCopies],
      units: memory.units,
    );
    memory.barcodeLinks.forEach(saveBarcodeLink);
  });
}
