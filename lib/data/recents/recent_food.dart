import 'package:dart_mappable/dart_mappable.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'recent_food.mapper.dart';

@MappableClass()
final class RecentFood with RecentFoodMappable {
  const RecentFood({
    required this.mfpFoodId,
    required this.description,
    required this.servingValue,
    required this.servingUnit,
    required this.servings,
    required this.addedAt,
    this.brandName,
    this.kilocalories,
  });

  factory RecentFood.forEntry(
    MfpFoodEntry entry, {
    required DateTime addedAt,
  }) => RecentFood(
    mfpFoodId: entry.food.id,
    description: entry.food.description,
    brandName: entry.food.brandName,
    servingValue: entry.servingSize.value,
    servingUnit: entry.servingSize.unit,
    servings: entry.servings,
    kilocalories: entry.nutrients.energy?.kilocalories,
    addedAt: addedAt,
  );

  final String mfpFoodId;
  final String description;
  final String? brandName;
  final double servingValue;
  final String servingUnit;
  final double servings;
  final double? kilocalories;
  final DateTime addedAt;

  MfpServingSize get servingSize =>
      MfpServingSize(value: servingValue, unit: servingUnit);
}
