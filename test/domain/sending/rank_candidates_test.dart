import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/sending/name_match.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';

import '../../support/fixtures.dart';

void main() {
  group('rankCandidates', () {
    test('puts foods sharing the product name first, then the closest', () {
      final ranked = rankCandidates([fromageBlanc, siggis, isey], skyrEntry);

      check([for (final candidate in ranked) candidate.food.id]).deepEquals([
        'isey',
        'siggis',
        'fromage-blanc',
      ]);
      check([for (final candidate in ranked) candidate.nameMatch]).deepEquals(
        [NameMatch.product, NameMatch.product, NameMatch.none],
      );
    });

    test('accepts a food within 12 % kcal and 10 % per macro only', () {
      final ranked = rankCandidates([isey, siggis, fromageBlanc], skyrEntry);

      check([for (final candidate in ranked) candidate.acceptable]).deepEquals(
        [true, false, false],
      );
    });

    test('gives signed gaps on the MyFitnessPal portion', () {
      final deltas = rankCandidates([isey], skyrEntry).single.deltas;

      check(deltas.kilocalories).isCloseTo(-5 / 160, 1e-9);
      check(deltas.of(Nutrient.protein)).isNotNull().isCloseTo(
        4 / 160,
        1e-9,
      );
      check(deltas.of(Nutrient.fiber)).isNull();
    });

    test('lets small foods miss a macro by up to 5 kcal', () {
      final small = entry(
        'E-3',
        food: skyr,
        description: 'Skyr nature',
        servingValue: 25,
        nutrients: nutrients(kcal: 20, protein: 1.6),
      );
      final candidate = rankCandidates([
        ekkloFood('skyr', name: 'Skyr', calories: 80, proteins: 10.4),
      ], small).single;

      check(candidate.deltas.of(Nutrient.protein)).isNotNull().isCloseTo(
        0.2,
        1e-9,
      );
      check(candidate.acceptable).isTrue();
    });

    test('estimates the grams of an unknown unit from the kilocalories', () {
      final candidate = rankCandidates([oliveOil], oilEntry).single;

      check(candidate.gramsInferred).isTrue();
      check(candidate.grams).isCloseTo(119 * 100 / 884, 1e-9);
    });

    test('uses the remembered grams of a unit', () {
      final candidate = rankCandidates(
        [
          oliveOil,
        ],
        oilEntry,
        gramsPerUnit: 13.5,
      ).single;

      check(candidate.gramsInferred).isFalse();
      check(candidate.grams).equals(13.5);
    });

    test('ignores Ekklo foods counted in portions', () {
      final ranked = rankCandidates([
        ekkloFood(
          'skyr-pot',
          name: 'Skyr nature',
          portion: 1,
          quantityType: EkkloQuantityType.portion,
        ),
      ], skyrEntry);

      check(ranked).isEmpty();
    });
  });
}
