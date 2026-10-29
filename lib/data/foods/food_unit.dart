import 'package:dart_mappable/dart_mappable.dart';

part 'food_unit.mapper.dart';

@MappableClass()
final class FoodUnit with FoodUnitMappable {
  const FoodUnit({
    required this.id,
    required this.foodId,
    required this.unit,
    required this.grams,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String foodId;
  final String unit;
  final double grams;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
