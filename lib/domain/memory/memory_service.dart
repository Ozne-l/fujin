import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

final class MemoryService {
  const MemoryService({required this._memory, required this._ekklo});

  final MemoryRepository _memory;
  final EkkloClient _ekklo;

  Memory load() => _memory.load();

  void forget(RememberedFood food) => _memory.forget(food);

  void saveUnit(RememberedUnit unit) => _memory.saveUnit(unit);

  void saveMeal(MealMapping meal) => _memory.saveMeal(meal);

  void associate(RememberedFood food, EkkloFood ekkloFood) => _memory.saveFood(
    MatchedFood(
      mfpFoodId: food.mfpFoodId,
      mfpDescription: food.mfpDescription,
      ekkloFoodId: ekkloFood.id,
      ekkloFoodName: ekkloFood.name,
    ),
  );

  Future<EkkloFood> ekkloFood(String ekkloFoodId) =>
      _ekklo.foods.byId(ekkloFoodId);

  Future<List<EkkloFood>> search(String terms) => _ekklo.foods.search(terms);

  Future<List<String>> ekkloMealNames() async => [
    for (final meal in (await _ekklo.meals.history()).items) meal.name,
  ];
}
