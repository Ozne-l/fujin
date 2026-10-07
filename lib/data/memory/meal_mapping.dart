import 'package:dart_mappable/dart_mappable.dart';

part 'meal_mapping.mapper.dart';

@MappableClass()
final class MealMapping with MealMappingMappable {
  const MealMapping({required this.mfpMealName, required this.ekkloMealName});

  final String mfpMealName;
  final String ekkloMealName;
}
