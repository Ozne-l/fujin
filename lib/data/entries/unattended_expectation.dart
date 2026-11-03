import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';

part 'unattended_expectation.mapper.dart';

@MappableClass()
final class UnattendedExpectation with UnattendedExpectationMappable {
  const UnattendedExpectation({
    required this.ekkloMealName,
    required this.ekkloFoodId,
    required this.quantity,
    required this.quantityType,
  });

  static const mealNameKey = 'unattended_meal_name';

  @MappableField(key: mealNameKey)
  final String ekkloMealName;
  @MappableField(key: 'unattended_food_id')
  final String ekkloFoodId;
  @MappableField(key: 'unattended_quantity')
  final double quantity;
  @MappableField(key: 'unattended_quantity_type')
  final EkkloQuantityType quantityType;
}
