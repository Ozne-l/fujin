import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'expected_item.mapper.dart';

@MappableClass()
final class ExpectedItem with ExpectedItemMappable {
  const ExpectedItem({
    required this.ekkloMealName,
    required this.ekkloFoodId,
    required this.quantity,
    required this.quantityType,
  });

  factory ExpectedItem.rounded({
    required String ekkloMealName,
    required String ekkloFoodId,
    required double quantity,
    required EkkloQuantityType quantityType,
  }) => ExpectedItem(
    ekkloMealName: ekkloMealName,
    ekkloFoodId: ekkloFoodId,
    quantity: double.parse(quantity.toStringAsFixed(_decimals)),
    quantityType: quantityType,
  );

  static const quantityTolerance = 0.1;
  static const _decimals = 1;
  static const _epsilon = 1e-9;

  final String ekkloMealName;
  final String ekkloFoodId;
  final double quantity;
  final EkkloQuantityType quantityType;

  static ExpectedItem? forEntry(MfpFoodEntry entry, Memory memory) {
    final mealName = memory.ekkloMealName(entry.mealName);
    final unit = entry.servingSize.unit;
    final food = memory.food(entry.food.id, unit);
    final quantity = switch (food) {
      null => null,
      MatchedFood(:final mfpFoodId) => switch (entryGrams(
        entry,
        gramsPerUnit: memory.gramsPerUnit(mfpFoodId, unit),
      )) {
        null => null,
        final grams => (grams, EkkloQuantityType.grams),
      },
      OwnCopy() => (entryUnits(entry), ownCopyQuantityType(unit)),
    };
    return switch ((mealName, food, quantity)) {
      (
        final String mealName,
        final RememberedFood food,
        (
          final double amount,
          final EkkloQuantityType type,
        ),
      ) =>
        ExpectedItem.rounded(
          ekkloMealName: mealName,
          ekkloFoodId: food.ekkloFoodId,
          quantity: amount,
          quantityType: type,
        ),
      _ => null,
    };
  }

  bool matches(EkkloDailyMeal meal, EkkloDailyMealItem item) =>
      meal.name == ekkloMealName &&
      item.foodId == ekkloFoodId &&
      item.quantityType == quantityType &&
      (item.quantity - quantity).abs() <= quantityTolerance + _epsilon;
}
