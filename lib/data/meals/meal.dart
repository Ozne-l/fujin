import 'package:dart_mappable/dart_mappable.dart';

part 'meal.mapper.dart';

@MappableClass()
final class Meal with MealMappable {
  const Meal({
    required this.id,
    required this.name,
    required this.position,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String name;
  final int position;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
