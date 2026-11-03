import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/foods/flat_nutrients_hook.dart';
import 'package:fujin/data/foods/food_nutrients.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'entry.mapper.dart';

@MappableClass(hook: FlatNutrientsHook())
final class Entry with EntryMappable {
  const Entry({
    required this.id,
    required this.date,
    required this.mealId,
    required this.foodId,
    required this.servingValue,
    required this.servingUnit,
    required this.servings,
    required this.updatedAt,
    this.nutritionMultiplier,
    this.nutrients = const FoodNutrients(),
    this.deletedAt,
  });

  factory Entry.copyOf(
    MfpFoodEntry entry, {
    required String id,
    required String mealId,
    required String foodId,
    required DateTime updatedAt,
  }) => Entry(
    id: id,
    date: entry.date,
    mealId: mealId,
    foodId: foodId,
    servingValue: entry.servingSize.value,
    servingUnit: entry.servingSize.unit,
    nutritionMultiplier: entry.servingSize.nutritionMultiplier,
    servings: entry.servings,
    nutrients: FoodNutrients.ofMfp(entry.nutrients),
    updatedAt: updatedAt,
  );

  final String id;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final String mealId;
  final String foodId;
  final double servingValue;
  final String servingUnit;
  final double? nutritionMultiplier;
  final double servings;
  final FoodNutrients nutrients;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
