import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class DayNutrients {
  const DayNutrients({this.amounts = const {}, this.partial = const {}});

  factory DayNutrients.ofEntries(Iterable<MfpFoodEntry> entries) {
    final amounts = <Nutrient, double>{};
    final partial = <Nutrient>{};
    for (final entry in entries) {
      for (final nutrient in Nutrient.values) {
        switch (_mfpAmount(entry.nutrients, nutrient)) {
          case final amount?:
            amounts.update(
              nutrient,
              (total) => total + amount,
              ifAbsent: () => amount,
            );
          case null:
            partial.add(nutrient);
        }
      }
    }
    return DayNutrients(amounts: amounts, partial: partial);
  }

  factory DayNutrients.ofEkklo(Iterable<EkkloDailyMeal> meals) => DayNutrients(
    amounts: {
      for (final nutrient in Nutrient.values)
        nutrient: meals.fold(
          0,
          (total, meal) => total + _mealAmount(meal, nutrient),
        ),
    },
  );

  final Map<Nutrient, double> amounts;
  final Set<Nutrient> partial;

  double amount(Nutrient nutrient) => amounts[nutrient] ?? 0;

  bool isPartial(Nutrient nutrient) => partial.contains(nutrient);

  static double? _mfpAmount(MfpNutrients nutrients, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => nutrients.energy?.kilocalories,
        Nutrient.protein => nutrients.protein,
        Nutrient.carbohydrates => nutrients.carbohydrates,
        Nutrient.fat => nutrients.fat,
        Nutrient.fiber => nutrients.fiber,
      };

  static double _mealAmount(EkkloDailyMeal meal, Nutrient nutrient) =>
      switch (_manualAmount(meal, nutrient)) {
        final amount? => amount,
        null => meal.items.fold(
          0,
          (sum, item) => sum + _itemAmount(item, nutrient),
        ),
      };

  static double? _manualAmount(EkkloDailyMeal meal, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => meal.manualCalories,
        Nutrient.protein => meal.manualProteins,
        Nutrient.carbohydrates => meal.manualCarbs,
        Nutrient.fat => meal.manualFats,
        Nutrient.fiber => null,
      };

  static double _itemAmount(EkkloDailyMealItem item, Nutrient nutrient) =>
      switch (item.food) {
        null => 0,
        final food when food.portion <= 0 => 0,
        final food => switch (_inFoodUnit(item, food)) {
          null => 0,
          final quantity =>
            _perPortion(food, nutrient) * quantity / food.portion,
        },
      };

  static double _perPortion(EkkloFood food, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => food.calories,
        Nutrient.protein => food.proteins,
        Nutrient.carbohydrates => food.carbs,
        Nutrient.fat => food.fats,
        Nutrient.fiber => food.fiber,
      };

  static double? _inFoodUnit(EkkloDailyMealItem item, EkkloFood food) =>
      switch ((item.quantityType, food.quantityType)) {
        (final itemType, final foodType) when itemType == foodType =>
          item.quantity,
        (final itemType, EkkloQuantityType.grams) => switch (food.foodUnits
            .where((unit) => unit.quantityType == itemType)
            .firstOrNull) {
          null => null,
          final unit => item.quantity * unit.gramsPerUnit,
        },
        _ => null,
      };
}
