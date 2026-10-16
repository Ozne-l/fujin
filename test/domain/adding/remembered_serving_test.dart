import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/adding/remembered_serving.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

const _hundredGrams = MfpServingSize(value: 100, unit: grams);
const _onePot = MfpServingSize(value: 1, unit: pot);
const _oneCup = MfpServingSize(value: 1, unit: cup);

final MfpFood _rice = mfpFood(
  rice,
  servingSizes: const [_hundredGrams, _onePot, _oneCup],
);

final MatchedFood _matchedRice = memory.matches.last;

const _riceInPots = OwnCopy(
  mfpFoodId: rice,
  mfpDescription: rice,
  ekkloFoodId: riceInEkklo,
  ekkloFoodName: riceInEkklo,
  mfpUnit: pot,
);

RecentFood _recent(String unit, {String food = rice}) => RecentFood(
  mfpFoodId: food,
  description: food,
  servingValue: 1,
  servingUnit: unit,
  servings: 2,
  addedAt: now,
);

MfpServingSize? _serving(
  RememberedFood remembered, {
  Memory known = memory,
  List<RecentFood> recents = const [],
}) => rememberedServing(
  _rice,
  remembered: remembered,
  memory: known,
  recents: recents,
);

void main() {
  group('the serving of a remembered food', () {
    test('is the one of its recent food first', () {
      check(
        _serving(_matchedRice, recents: [_recent(pot)]),
      ).equals(_onePot);
    });

    test('is the unit of an own copy when no recent food matches it', () {
      check(
        _serving(_riceInPots, recents: [_recent(grams)]),
      ).equals(_onePot);
    });

    test('is a remembered unit of a matched food', () {
      check(_serving(_matchedRice)).equals(_oneCup);
    });

    test('skips a unit MyFitnessPal no longer serves', () {
      check(
        _serving(_matchedRice, recents: [_recent(bowl)]),
      ).equals(_oneCup);
    });

    test('ignores the recent food of another food', () {
      check(
        _serving(_matchedRice, recents: [_recent(pot, food: oats)]),
      ).equals(_oneCup);
    });

    test('is none when no remembered unit is served', () {
      check(_serving(_matchedRice, known: const Memory())).isNull();
    });
  });
}
