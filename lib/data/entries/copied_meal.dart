import 'package:dart_mappable/dart_mappable.dart';

part 'copied_meal.mapper.dart';

@MappableClass()
final class CopiedMeal with CopiedMealMappable {
  const CopiedMeal({required this.id, required this.mfpMealName});

  final String id;
  final String mfpMealName;
}
