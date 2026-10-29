import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/foods/flat_nutrients_hook.dart';
import 'package:fujin/data/foods/food_nutrients.dart';

part 'food.mapper.dart';

@MappableClass(hook: FlatNutrientsHook())
final class Food with FoodMappable {
  const Food({
    required this.id,
    required this.updatedAt,
    this.name,
    this.brand,
    this.nutrients = const FoodNutrients(),
    this.deletedAt,
  });

  final String id;
  final String? name;
  final String? brand;
  final FoodNutrients nutrients;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
