import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/recents/recent_food.dart';

part 'recent_food_row.mapper.dart';

@MappableClass()
final class RecentFoodRow with RecentFoodRowMappable {
  const RecentFoodRow({
    required this.foodId,
    required this.servingValue,
    required this.servingUnit,
    required this.servings,
    required this.addedAt,
    this.kilocalories,
  });

  factory RecentFoodRow.of(RecentFood recent, {required String foodId}) =>
      RecentFoodRow(
        foodId: foodId,
        servingValue: recent.servingValue,
        servingUnit: recent.servingUnit,
        servings: recent.servings,
        kilocalories: recent.kilocalories,
        addedAt: recent.addedAt,
      );

  final String foodId;
  final double servingValue;
  final String servingUnit;
  final double servings;
  final double? kilocalories;
  final DateTime addedAt;
}
