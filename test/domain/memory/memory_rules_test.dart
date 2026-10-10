import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/memory/memory_rules.dart';

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

List<String> _found(String query) => [
  for (final food in rememberedFoods(_memory, query)) food.mfpDescription,
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
