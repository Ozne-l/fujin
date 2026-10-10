import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';

import '../../support/fixtures.dart';

const _rice = EkkloFood(
  id: riceInEkklo,
  name: 'Riz basmati',
  portion: 100,
  quantityType: EkkloQuantityType.grams,
  calories: 350,
  proteins: 7,
  carbs: 78,
  fats: 1,
  fiber: 1,
  sugar: 0,
  sodiumMilligrams: 0,
  category: EkkloFoodCategory.other,
  foodUnits: [
    EkkloFoodUnit(quantityType: EkkloQuantityType.cup, gramsPerUnit: 180),
  ],
);

EkkloDailyMealItem _riceItem(double quantity, EkkloQuantityType type) => item(
  'I-1',
  food: riceInEkklo,
  quantity: quantity,
  type: type,
).copyWith(food: _rice);

void main() {
  group('Ekklo meals', () {
    test('scale grams and convert other units through the food units', () {
      final nutrients = DayNutrients.ofEkklo([
        meal('meal-1', [
          _riceItem(150, EkkloQuantityType.grams),
          _riceItem(1, EkkloQuantityType.cup),
        ]),
      ]);

      check(
        nutrients.amount(Nutrient.kilocalories),
      ).isCloseTo(525 + 630, 0.001);
      check(nutrients.amount(Nutrient.protein)).isCloseTo(10.5 + 12.6, 0.001);
    });

    test('count a meal with manual values at those values only', () {
      final nutrients = DayNutrients.ofEkklo([
        meal('meal-1', [
          _riceItem(150, EkkloQuantityType.grams),
        ]).copyWith(manualCalories: 400, manualProteins: 30),
      ]);

      check(nutrients.amount(Nutrient.kilocalories)).equals(400);
      check(nutrients.amount(Nutrient.protein)).equals(30);
      check(nutrients.amount(Nutrient.fiber)).isCloseTo(1.5, 0.001);
    });

    test('count nothing for a unit the food cannot convert', () {
      final nutrients = DayNutrients.ofEkklo([
        meal('meal-1', [_riceItem(2, EkkloQuantityType.slice)]),
      ]);

      check(nutrients.amount(Nutrient.kilocalories)).equals(0);
    });
  });

  test('MyFitnessPal entries add up and flag a nutrient some entries '
      'lack', () {
    final totals = DayNutrients.ofEntries([
      entry('E-1', nutrients: nutrients(kcal: 300, fiber: 4)),
      entry('E-2', nutrients: nutrients(kcal: 200)),
    ]);

    check(totals.amount(Nutrient.kilocalories)).equals(500);
    check(totals.amount(Nutrient.fiber)).equals(4);
    check(totals.isPartial(Nutrient.fiber)).isTrue();
    check(totals.isPartial(Nutrient.kilocalories)).isFalse();
  });
}
