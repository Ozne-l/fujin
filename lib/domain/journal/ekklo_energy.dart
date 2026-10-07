import 'package:ekklo_client/ekklo_client.dart';

double ekkloKilocaloriesOf(Iterable<EkkloDailyMeal> meals) => meals.fold(
  0,
  (total, meal) =>
      total +
      (meal.manualCalories ??
          meal.items.fold(0, (sum, item) => sum + _itemKilocalories(item))),
);

double _itemKilocalories(EkkloDailyMealItem item) => switch (item.food) {
  null => 0,
  final food when food.portion <= 0 => 0,
  final food => switch (_inFoodUnit(item, food)) {
    null => 0,
    final amount => food.calories * amount / food.portion,
  },
};

double? _inFoodUnit(EkkloDailyMealItem item, EkkloFood food) => switch ((
  item.quantityType,
  food.quantityType,
)) {
  (final itemType, final foodType) when itemType == foodType => item.quantity,
  (final itemType, EkkloQuantityType.grams) => switch (food.foodUnits
      .where((unit) => unit.quantityType == itemType)
      .firstOrNull) {
    null => null,
    final unit => item.quantity * unit.gramsPerUnit,
  },
  _ => null,
};
