import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:fujin/domain/sending/nutrient.dart';

GoalStatus _status(double amount, {Nutrient nutrient = Nutrient.protein}) =>
    GoalStatus.of(nutrient, amount: amount, goal: 100);

void main() {
  group('a goal', () {
    test('is below under 98 % of its value', () {
      check(_status(97.9)).equals(GoalStatus.below);
    });

    test('is reached within 2 % of its value, on either side', () {
      check(_status(98)).equals(GoalStatus.reached);
      check(_status(102)).equals(GoalStatus.reached);
    });

    test('is exceeded beyond 102 % of its value', () {
      check(_status(102.1)).equals(GoalStatus.exceeded);
    });

    test('of fiber is a floor that more fiber only keeps reached', () {
      check(
        _status(150, nutrient: Nutrient.fiber),
      ).equals(GoalStatus.reached);
      check(_status(50, nutrient: Nutrient.fiber)).equals(GoalStatus.below);
    });
  });
}
