import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/data/goals/goal_period.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_timeline.dart';

void main() {
  const bulk = Goals(kilocalories: 3200, protein: 170);
  const cut = Goals(kilocalories: 2500, protein: 160);
  final bulkStart = DateTime.utc(2026, 9, 2);
  final cutStart = DateTime.utc(2026, 10, 6);
  final timeline = GoalTimeline([
    GoalPeriod(startsOn: bulkStart, goals: bulk),
    GoalPeriod(startsOn: cutStart, goals: cut),
  ]);

  test('gives a day the goals saved last on or before it', () {
    check(timeline.on(DateTime.utc(2026, 10, 5))).equals(bulk);
    check(timeline.on(cutStart)).equals(cut);
    check(timeline.on(DateTime.utc(2026, 12, 25))).equals(cut);
  });

  test('gives the days before the first goals those first goals', () {
    check(
      timeline.periodOn(DateTime.utc(2026, 8, 15)),
    ).equals(GoalPeriod(startsOn: bulkStart, goals: bulk));
  });

  test('gives no goals to any day before goals are saved', () {
    check(const GoalTimeline([]).on(cutStart)).isNull();
  });
}
