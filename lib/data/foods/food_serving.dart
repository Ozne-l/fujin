import 'package:dart_mappable/dart_mappable.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'food_serving.mapper.dart';

@MappableClass()
final class FoodServing with FoodServingMappable {
  const FoodServing({
    required this.id,
    required this.foodId,
    required this.position,
    required this.value,
    required this.unit,
    required this.updatedAt,
    this.nutritionMultiplier,
    this.deletedAt,
  });

  final String id;
  final String foodId;
  final int position;
  final double value;
  final String unit;
  final double? nutritionMultiplier;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  MfpServingSize toMfp() => MfpServingSize(
    value: value,
    unit: unit,
    nutritionMultiplier: nutritionMultiplier,
  );
}
