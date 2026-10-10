import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/goals/macro_energy.dart';
import 'package:fujin/domain/sending/nutrient.dart';

MacroEnergy? _of(Map<Nutrient, double> amounts) =>
    MacroEnergy.of((nutrient) => amounts[nutrient]);

void main() {
  test('counts 4 kcal per gram of protein and carbs and 9 per gram of fat, '
      'never fiber', () {
    final energy = _of({
      Nutrient.kilocalories: 3000,
      Nutrient.protein: 160,
      Nutrient.carbohydrates: 400,
      Nutrient.fat: 70,
      Nutrient.fiber: 40,
    });

    check(energy?.kilocalories).equals(2870);
    check(energy?.counted).isNotNull().deepEquals(MacroEnergy.macros);
    check(energy?.missing).isNotNull().isEmpty();
  });

  test('names the macros without a goal and sums the others', () {
    final energy = _of({Nutrient.protein: 160, Nutrient.fat: 70});

    check(energy?.kilocalories).equals(1270);
    check(
      energy?.counted,
    ).isNotNull().deepEquals([Nutrient.protein, Nutrient.fat]);
    check(energy?.missing).isNotNull().deepEquals([Nutrient.carbohydrates]);
  });

  test('has nothing to say without any macro goal', () {
    check(_of({Nutrient.kilocalories: 3000, Nutrient.fiber: 40})).isNull();
  });
}
