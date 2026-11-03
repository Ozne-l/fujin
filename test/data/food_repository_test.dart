import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fixtures.dart';
import '../support/repositories.dart';

const _copiedId = 'food-copied';

final MfpFood _basmati = mfpFood(
  rice,
  description: 'Riz basmati',
  brand: 'Taureau Ailé',
  version: '4',
  servingSizes: const [
    MfpServingSize(value: 100, unit: grams, nutritionMultiplier: 1),
    MfpServingSize(value: 1, unit: cup, nutritionMultiplier: 1.58),
  ],
  nutrients: nutrients(kcal: 350, protein: 8.5, carbs: 77, fat: 0.9),
);

void main() {
  late FujinDatabase database;
  late FoodRepository foods;

  setUp(() {
    database = FujinDatabase.inMemory();
    foods = foodsOf(database)
      ..mfpFood(rice)
      ..fill(_basmati)
      ..copiedMfpFood(
        oats,
        id: _copiedId,
        name: 'Flocons d’avoine',
        brand: 'Quaker',
      );
  });

  tearDown(() => database.close());

  group('a food on the phone', () {
    test('is rebuilt from the rows MyFitnessPal filled', () {
      check(foods.onPhone(rice)).isNotNull()
        ..has((food) => food.id, 'id').equals(rice)
        ..has((food) => food.version, 'version').equals('4')
        ..has((food) => food.description, 'name').equals('Riz basmati')
        ..has((food) => food.brandName, 'brand').equals('Taureau Ailé')
        ..has(
          (food) => food.servingSizes,
          'servings',
        ).deepEquals(_basmati.servingSizes)
        ..has((food) => food.nutrients, 'nutrients').equals(_basmati.nutrients);
    });

    test('keeps MyFitnessPal’s verified mark, read again at the same '
        'version', () {
      check(foods.onPhone(rice)?.verified).equals(_basmati.verified);

      foods.fill(_basmati.copyWith(verified: false));

      check(foods.onPhone(rice)?.verified).equals(false);
    });

    test('is not a food copied in from the diary, never filled', () {
      check(foods.onPhone(oats)).isNull();
      check(foods.onPhone('mfp-unknown')).isNull();
    });

    test('lists only the foods MyFitnessPal filled', () {
      check([
        for (final food in foods.onPhoneFoods()) food.id,
      ]).deepEquals([rice]);
    });
  });
}
