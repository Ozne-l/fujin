import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/copied_food.dart';
import 'package:fujin/data/entries/copied_meal.dart';
import 'package:fujin/data/foods/food.dart';

final class DayCatalog {
  DayCatalog({
    required this._foodOf,
    required this._mealOf,
    required this._ids,
    List<CopiedFood> foods = const [],
    List<CopiedMeal> meals = const [],
  }) : _foods = {for (final food in foods) food.mfpFoodId: food},
       _meals = {for (final meal in meals) meal.mfpMealName: meal};

  final Food? Function(String mfpFoodId) _foodOf;
  final String? Function(String mfpMealName) _mealOf;
  final IdSource _ids;
  final Map<String, CopiedFood> _foods;
  final Map<String, CopiedMeal> _meals;

  List<CopiedFood> get foods => [..._foods.values];

  List<CopiedMeal> get meals => [..._meals.values];

  ({String id, String? name, String? brand}) food(
    String mfpFoodId, {
    String? name,
    String? brand,
  }) {
    if (_foods[mfpFoodId] case final copied?) {
      final named = switch ((copied.name, name)) {
        (null, final String name) => copied.copyWith(name: name, brand: brand),
        _ => copied,
      };
      _foods[mfpFoodId] = named;
      return (id: named.id, name: named.name, brand: named.brand);
    }
    switch (_foodOf(mfpFoodId)) {
      case Food(name: final String known) && final food:
        return (id: food.id, name: known, brand: food.brand);
      case final food? when name == null:
        return (id: food.id, name: null, brand: food.brand);
      case final food:
        final copied = CopiedFood(
          id: food?.id ?? _ids(),
          mfpFoodId: mfpFoodId,
          name: name,
          brand: brand,
        );
        _foods[mfpFoodId] = copied;
        return (id: copied.id, name: name, brand: brand);
    }
  }

  String meal(String mfpMealName) =>
      _meals[mfpMealName]?.id ??
      _mealOf(mfpMealName) ??
      (_meals[mfpMealName] = CopiedMeal(
        id: _ids(),
        mfpMealName: mfpMealName,
      )).id;
}
