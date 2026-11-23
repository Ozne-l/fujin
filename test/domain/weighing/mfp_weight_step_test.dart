import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/weighing/mfp_weight_step.dart';

import '../../support/fixtures.dart';

void main() {
  test('posts on a day without weight', () {
    check(MfpWeightStep.next(68.9, const [])).equals(const PostWeight());
  });

  test('adopts the first weight within 0.05 kg, in pounds too', () {
    for (final held in [
      mfpWeight('m-1', 68.94),
      mfpWeight('m-1', 151.9, unit: 'pounds'),
    ]) {
      check(
        MfpWeightStep.next(68.9, [held]),
      ).equals(const AdoptMeasurement('m-1'));
    }
  });

  test('removes a first weight that differs or has an unknown unit', () {
    for (final held in [
      mfpWeight('m-1', 69),
      mfpWeight('m-1', 68.9, unit: 'stones'),
    ]) {
      check(
        MfpWeightStep.next(68.9, [held]),
      ).equals(const RemoveMeasurement('m-1'));
    }
  });
}
