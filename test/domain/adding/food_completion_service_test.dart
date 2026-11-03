import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/domain/adding/food_completion_service.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/repositories.dart';

const _foodReads = '/v2/foods';

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
final MfpFood _skyr = mfpFood(
  skyr,
  description: 'Skyr nature',
  brand: 'Isey',
  version: '2',
  nutrients: nutrients(kcal: 64, protein: 10, carbs: 4, fat: 0.2),
);

void main() {
  late FujinDatabase database;
  late FoodRepository foods;
  late FakeBackends backends;
  late FoodCompletionService completion;

  setUp(() async {
    database = FujinDatabase.inMemory();
    foods = foodsOf(database)
      ..mfpFood(rice, name: 'Riz')
      ..mfpFood(skyr, name: 'Skyr');
    backends = FakeBackends(mfpFoods: [_basmati, _skyr]);
    completion = FoodCompletionService(
      mfp: await backends.mfp(),
      foods: foods,
    );
    backends.requests.clear();
  });

  tearDown(() => database.close());

  List<String> foodReads() => [
    for (final request in backends.requests)
      if ((request.url.path, request.url.queryParameters['ids']) case (
        _foodReads,
        final id?,
      ))
        id,
  ];

  group('a food the upgrade left without servings', () {
    test('is on the phone once MyFitnessPal has been read for it', () async {
      check(foods.onPhone(rice)).isNull();

      await completion.complete();

      check(foods.onPhone(rice)).isNotNull()
        ..has((food) => food.version, 'version').equals('4')
        ..has((food) => food.description, 'name').equals('Riz basmati')
        ..has(
          (food) => food.servingSizes,
          'servings',
        ).deepEquals(_basmati.servingSizes)
        ..has((food) => food.nutrients, 'nutrients').equals(_basmati.nutrients);
      check(foods.onPhone(skyr)).isNotNull();
      check(foods.mfpFoodsWithoutServings()).isEmpty();
    });

    test('waits for MyFitnessPal when it is offline, then is filled by a '
        'later run', () async {
      backends.mfpReachable = false;

      await completion.complete();

      check(foods.onPhone(rice)).isNull();
      check(foods.onPhone(skyr)).isNull();
      check(foodReads()).deepEquals([rice]);

      backends.mfpReachable = true;
      await completion.complete();

      check(foods.onPhone(rice)).isNotNull();
      check(foods.onPhone(skyr)).isNotNull();
    });

    test('is skipped when MyFitnessPal does not serve it, and the others are '
        'still filled', () async {
      backends.mfpFoods = [_skyr];

      await completion.complete();

      check(foods.onPhone(rice)).isNull();
      check(foods.onPhone(skyr)).isNotNull();
      check(foods.mfpFoodsWithoutServings()).deepEquals([rice]);
    });

    test('is not read again once it has its servings', () async {
      foods.fill(_basmati);

      await completion.complete();

      check(foodReads()).deepEquals([skyr]);
    });

    test('is read once when a second run is asked for while one is in '
        'flight', () async {
      final gate = backends.mfpFoodGate = Completer<void>();

      final first = completion.complete();
      final second = completion.complete();
      gate.complete();
      await (first, second).wait;

      check(foodReads()).deepEquals([rice, skyr]);
    });
  });
}
