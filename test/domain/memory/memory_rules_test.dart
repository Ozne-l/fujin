import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/memory/memory_rules.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

const _crepe = MatchedFood(
  mfpFoodId: 'mfp-crepe',
  mfpDescription: 'Crêpe Bretonne',
  ekkloFoodId: 'ekklo-crepe',
  ekkloFoodName: 'Galette de sarrasin',
);

const _oil = OwnCopy(
  mfpFoodId: oil,
  mfpDescription: 'Huile d’olive',
  ekkloFoodId: 'own-oil',
  ekkloFoodName: 'Huile d’olive',
  mfpUnit: tablespoon,
);

const _memory = Memory(matches: [_crepe], ownCopies: [_oil]);

List<String?> _found(String query) => [
  for (final food in rememberedFoods(_memory, query)) food.mfpDescription,
];

final List<MfpFood> _onPhone = [
  mfpFood(rice, description: 'Riz basmati cuit'),
  mfpFood(oats, description: 'Flocons d’avoine', brand: 'Quaker'),
  mfpFood(skyr, description: 'Riz basmati', brand: 'Taureau Ailé'),
];

List<String> _onPhoneFound(String query) => [
  for (final food in foodsOnPhone(_onPhone, query)) food.description,
];

void main() {
  group('the remembered foods', () {
    test('list matches and own copies by MyFitnessPal name', () {
      check(_found('')).deepEquals(['Crêpe Bretonne', 'Huile d’olive']);
    });

    test('match a search without accents or case, on either name', () {
      check(_found('CREPE')).deepEquals(['Crêpe Bretonne']);
      check(_found('sarrasin')).deepEquals(['Crêpe Bretonne']);
      check(_found(' huile ')).deepEquals(['Huile d’olive']);
      check(_found('riz')).isEmpty();
    });
  });

  group('the foods on the phone', () {
    test('match a search like the remembered foods, on name or brand, '
        'by name', () {
      check(
        _onPhoneFound('RIZ basmati'),
      ).deepEquals(['Riz basmati', 'Riz basmati cuit']);
      check(_onPhoneFound('taureau aile')).deepEquals(['Riz basmati']);
      check(_onPhoneFound('quaker')).deepEquals(['Flocons d’avoine']);
      check(_onPhoneFound('skyr')).isEmpty();
    });
  });

  test('the meal choices offer each known name once, in order', () {
    check(
      mealChoices(
        const Memory(
          meals: [
            MealMapping(mfpMealName: breakfast, ekkloMealName: petitDejeuner),
          ],
        ),
        [dejeuner, petitDejeuner],
      ),
    ).deepEquals([breakfast, dejeuner, petitDejeuner]);
  });
}
