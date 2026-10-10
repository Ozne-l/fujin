import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';
import 'package:fujin/pages/journal/widgets/progress_ring.dart';

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
    final color = switch ((selected, state)) {
      (true, _) => FujinColorRole.textOnDark,
      (false, DayGoalState.upcoming) => FujinColorRole.textDisabled,
      (false, DayGoalState.nothingLogged) => FujinColorRole.textSecondary,
      (
        false,
        DayGoalState.noGoal ||
            DayGoalState.inProgress ||
            DayGoalState.missed ||
            DayGoalState.reached ||
            DayGoalState.exceeded,
      ) =>
        FujinColorRole.textPrimary,
    };
    return ProgressRing(
      size: FujinSize.dayRing,
      stroke: FujinStroke.dayRing,
      fill: fill,
      track: track,
      arc: arc,
      progress: progress,
      child: Container(
        width: FujinSize.dayPill,
        height: FujinSize.dayPill,
        alignment: Alignment.center,
        decoration: switch (selected) {
          true => const BoxDecoration(
            shape: BoxShape.circle,
            color: FujinColorRole.goalSelectedDay,
          ),
          false => null,
        },
        child: Text(
          date,
          style: FujinText.inter13Medium.copyWith(color: color),
        ),
      ),
    );
  }
}
