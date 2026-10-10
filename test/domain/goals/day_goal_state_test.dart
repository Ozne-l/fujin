import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';

import '../../support/fixtures.dart';

const _goals = Goals(kilocalories: 3000);
final _yesterday = DateTime.utc(2026, 10, 6);
final _tomorrow = DateTime.utc(2026, 10, 8);

DayGoalState _state(
  DateTime date, {
  double? kilocalories,
  Goals? goals = _goals,
}) => DayGoalState.of(
  day: date,
  today: day,
  goals: goals,
  kilocalories: kilocalories,
);

void main() {
  group('a day of the week band', () {
    test('after today is upcoming, goals or not', () {
      check(_state(_tomorrow)).equals(DayGoalState.upcoming);
      check(_state(_tomorrow, goals: null)).equals(DayGoalState.upcoming);
    });

    test('has no goal when none is set', () {
      check(
        _state(_yesterday, kilocalories: 3000, goals: null),
      ).equals(DayGoalState.noGoal);
    });

    test('in the past with nothing logged shows nothing logged', () {
      check(_state(_yesterday)).equals(DayGoalState.nothingLogged);
    });

    test('today stays in progress while under the goal, even empty', () {
      check(_state(day)).equals(DayGoalState.inProgress);
      check(_state(day, kilocalories: 1898)).equals(DayGoalState.inProgress);
    });

    test('in the past under the goal is missed', () {
      check(
        _state(_yesterday, kilocalories: 1898),
      ).equals(DayGoalState.missed);
    });

    test('is reached within 2 % and exceeded beyond, today included', () {
      check(
        _state(_yesterday, kilocalories: 2990),
      ).equals(DayGoalState.reached);
      check(_state(day, kilocalories: 3120)).equals(DayGoalState.exceeded);
    });
  });
}
