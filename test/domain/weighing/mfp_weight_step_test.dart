import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/weighing/mfp_weight_step.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

MfpMeasurement _measurement(String id, double value, String unit) =>
    MfpMeasurement(id: id, type: 'weight', value: value, unit: unit, date: day);

void main() {
  test('posts on a day without weight', () {
    check(MfpWeightStep.next(68.9, const [])).equals(const PostWeight());
  });

  test('adopts the first weight within 0.05 kg, in pounds too', () {
    for (final held in [
      _measurement('m-1', 68.94, 'kilograms'),
      _measurement('m-1', 151.9, 'pounds'),
    ]) {
      check(
        MfpWeightStep.next(68.9, [held]),
      ).equals(const AdoptMeasurement('m-1'));
    }
  });

  test('removes a first weight that differs or has an unknown unit', () {
    for (final held in [
      _measurement('m-1', 69, 'kilograms'),
      _measurement('m-1', 68.9, 'stones'),
    ]) {
      check(
        MfpWeightStep.next(68.9, [held]),
      ).equals(const RemoveMeasurement('m-1'));
    }
  });
}
