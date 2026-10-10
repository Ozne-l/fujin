import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:fujin/domain/sending/nutrient.dart';

enum DayGoalState {
  upcoming,
  noGoal,
  nothingLogged,
  inProgress,
  missed,
  reached,
  exceeded;

  static DayGoalState of({
    required DateTime day,
    required DateTime today,
    required Goals? goals,
    required double? kilocalories,
  }) => switch ((goals, kilocalories)) {
    _ when day.isAfter(today) => upcoming,
    (null, _) => noGoal,
    (_, null) when day == today => inProgress,
    (_, null) => nothingLogged,
    (final goals?, final kilocalories?) => switch (GoalStatus.of(
      Nutrient.kilocalories,
      amount: kilocalories,
      goal: goals.kilocalories,
    )) {
      GoalStatus.below when day == today => inProgress,
      GoalStatus.below => missed,
      GoalStatus.reached => reached,
      GoalStatus.exceeded => exceeded,
    },
  };
}
