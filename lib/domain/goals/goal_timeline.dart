import 'package:fujin/data/goals/goal_period.dart';
import 'package:fujin/data/goals/goals.dart';

final class GoalTimeline {
  const GoalTimeline(this._periods);

  final List<GoalPeriod> _periods;

  GoalPeriod? periodOn(DateTime day) => switch (_periods) {
    [] => null,
    [final first, ...] => _periods.lastWhere(
      (period) => !period.startsOn.isAfter(day),
      orElse: () => first,
    ),
  };

  Goals? on(DateTime day) => periodOn(day)?.goals;
}
