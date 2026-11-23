import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/flat_field_hook.dart';
import 'package:fujin/data/goals/goals.dart';

part 'goal_period.mapper.dart';

@MappableClass(hook: FlatFieldHook(GoalPeriod._goals))
final class GoalPeriod with GoalPeriodMappable {
  const GoalPeriod({required this.startsOn, required this.goals});

  static const _goals = 'goals';

  @MappableField(hook: CalendarDateHook())
  final DateTime startsOn;
  final Goals goals;
}
