import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
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

  static const quantityTolerance = 0.1;
  static const _decimals = 1;
  static const _epsilon = 1e-9;

  final String ekkloMealName;
  final String ekkloFoodId;
  final double quantity;
  final EkkloQuantityType quantityType;

  static ExpectedItem? forEntry(MfpFoodEntry entry, Memory memory) {
    final mealName = memory.ekkloMealName(entry.mealName);
    final food = memory.food(entry.food.id);
    final units = entry.servingSize.value * entry.servings;
    final quantity = switch (food) {
      null => null,
      MatchedFood(:final mfpFoodId) => switch (isGramUnit(
        entry.servingSize.unit,
      )) {
        true => (units, EkkloQuantityType.grams),
        false => switch (memory.gramsPerUnit(
          mfpFoodId,
          entry.servingSize.unit,
        )) {
          null => null,
          final grams => (units * grams, EkkloQuantityType.grams),
        },
      },
      OwnCopy(:final mfpUnit) => switch ((
        mfpUnit == entry.servingSize.unit,
        isGramUnit(mfpUnit),
      )) {
        (false, _) => null,
        (true, true) => (units, EkkloQuantityType.grams),
        (true, false) => (units, EkkloQuantityType.portion),
      },
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
        ExpectedItem(
          ekkloMealName: mealName,
          ekkloFoodId: food.ekkloFoodId,
          quantity: double.parse(amount.toStringAsFixed(_decimals)),
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
