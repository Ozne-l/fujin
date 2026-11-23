import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/weighing/imported_weights.dart';

import '../../support/fixtures.dart';

void main() {
  final dayBefore = day.subtract(const Duration(days: 1));

  test('keeps the latest entry of each day, oldest day first', () {
    check(
      importedWeights([
        ekkloWeight('w-1', day, 69.1, later: const Duration(minutes: 5)),
        ekkloWeight('w-2', day, 68.9),
        ekkloWeight('w-3', dayBefore, 69.4),
      ], taken: const {}),
    ).deepEquals([
      (date: dayBefore, kilograms: 69.4),
      (date: day, kilograms: 69.1),
    ]);
  });

  test('skips the days Fujin already holds', () {
    check(
      importedWeights(
        [
          ekkloWeight('w-1', day, 68.9),
          ekkloWeight('w-2', dayBefore, 69.4),
        ],
        taken: {'2026-10-07'},
      ),
    ).deepEquals([(date: dayBefore, kilograms: 69.4)]);
  });

  test('rounds to 0.1 kg and drops a weight that rounds to nothing', () {
    check(
      importedWeights([
        ekkloWeight('w-1', day, 68.94),
        ekkloWeight('w-2', dayBefore, 0.04),
      ], taken: const {}),
    ).deepEquals([(date: day, kilograms: 68.9)]);
  });
}
