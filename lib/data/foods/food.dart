import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/flat_field_hook.dart';
import 'package:fujin/data/foods/food_nutrients.dart';

part 'food.mapper.dart';

@MappableClass(hook: FlatFieldHook(Food._nutrients))
final class Food with FoodMappable {
  const Food({
    required this.id,
    required this.updatedAt,
    this.name,
    this.brand,
    this.nutrients = const FoodNutrients(),
    this.verified,
    this.deletedAt,
  });

  static const _nutrients = 'nutrients';

  final String id;
  final String? name;
  final String? brand;
  final FoodNutrients nutrients;
  final bool? verified;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
