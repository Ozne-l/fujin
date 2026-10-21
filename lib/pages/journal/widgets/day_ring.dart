import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';
import 'package:fujin/pages/common/day_pill.dart';
import 'package:fujin/pages/common/progress_ring.dart';

class DayRing extends StatelessWidget {
  const DayRing({
    required this.date,
    required this.state,
    required this.progress,
    required this.selected,
    super.key,
  });

  final String date;
  final DayGoalState state;
  final double progress;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final (fill, track, arc) = switch (state) {
      DayGoalState.upcoming || DayGoalState.noGoal => (null, null, null),
      DayGoalState.nothingLogged => (
        context.colors.backgroundCard,
        context.colors.goalTrack,
        null,
      ),
      DayGoalState.inProgress => (
        context.colors.backgroundCard,
        context.colors.goalTrack,
        context.colors.goalInProgress,
      ),
      DayGoalState.missed => (
        context.colors.goalMissedBackground,
        context.colors.goalTrack,
        context.colors.goalMissed,
      ),
      DayGoalState.reached => (
        context.colors.goalReachedBackground,
        context.colors.goalReached,
        null,
      ),
      DayGoalState.exceeded => (
        context.colors.goalExceededBackground,
        context.colors.goalExceeded,
        null,
      ),
    };
    final idleColor = switch (state) {
      DayGoalState.upcoming => context.colors.textDisabled,
      DayGoalState.nothingLogged => context.colors.textSecondary,
      DayGoalState.noGoal ||
      DayGoalState.inProgress ||
      DayGoalState.missed ||
      DayGoalState.reached ||
      DayGoalState.exceeded => context.colors.textPrimary,
    };
    return ProgressRing(
      size: FujinSize.dayRing,
      stroke: FujinStroke.dayRing,
      fill: fill,
      track: track,
      arc: arc,
      progress: progress,
      child: DayPill(date: date, selected: selected, idleColor: idleColor),
    );
  }
}
