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
        FujinColorRole.backgroundCard,
        FujinColorRole.goalTrack,
        null,
      ),
      DayGoalState.inProgress => (
        FujinColorRole.backgroundCard,
        FujinColorRole.goalTrack,
        FujinColorRole.goalInProgress,
      ),
      DayGoalState.missed => (
        FujinColorRole.goalMissedBackground,
        FujinColorRole.goalTrack,
        FujinColorRole.goalMissed,
      ),
      DayGoalState.reached => (
        FujinColorRole.goalReachedBackground,
        FujinColorRole.goalReached,
        null,
      ),
      DayGoalState.exceeded => (
        FujinColorRole.goalExceededBackground,
        FujinColorRole.goalExceeded,
        null,
      ),
    };
    final idleColor = switch (state) {
      DayGoalState.upcoming => FujinColorRole.textDisabled,
      DayGoalState.nothingLogged => FujinColorRole.textSecondary,
      DayGoalState.noGoal ||
      DayGoalState.inProgress ||
      DayGoalState.missed ||
      DayGoalState.reached ||
      DayGoalState.exceeded => FujinColorRole.textPrimary,
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
