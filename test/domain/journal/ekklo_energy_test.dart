import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/journal/ekklo_energy.dart';

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
  test('scales grams and converts other units through the food units', () {
    final kilocalories = ekkloKilocaloriesOf([
      meal('meal-1', [
        _riceItem(150, EkkloQuantityType.grams),
        _riceItem(1, EkkloQuantityType.cup),
      ]),
    ]);

    check(kilocalories).isCloseTo(525 + 630, 0.001);
  });

  test('counts a meal with manual calories at that value only', () {
    final kilocalories = ekkloKilocaloriesOf([
      meal('meal-1', [
        _riceItem(150, EkkloQuantityType.grams),
      ]).copyWith(manualCalories: 400),
    ]);

    check(kilocalories).equals(400);
  });

  test('counts nothing for a unit the food cannot convert', () {
    final kilocalories = ekkloKilocaloriesOf([
      meal('meal-1', [_riceItem(2, EkkloQuantityType.slice)]),
    ]);

    check(kilocalories).equals(0);
  });
}
