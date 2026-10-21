import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:motor/motor.dart';

class DayShareBar extends StatelessWidget {
  const DayShareBar({
    required this.before,
    required this.added,
    required this.status,
    this.thin = false,
    super.key,
  });

  final double before;
  final double added;
  final GoalStatus status;
  final bool thin;

  @override
  Widget build(BuildContext context) {
    final height = switch (thin) {
      true => FujinSize.macroBar,
      false => FujinSize.kcalBar,
    };
    final radius = BorderRadius.circular(height / 2);
    final colors = context.colors;
    final (soFar, adding) = switch (status) {
      GoalStatus.below => (colors.goalInProgressLogged, colors.goalInProgress),
      GoalStatus.reached => (colors.goalReachedLogged, colors.goalReached),
      GoalStatus.exceeded => (colors.goalExceededLogged, colors.goalExceeded),
    };
    Widget segment(double share, Color color) => SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.progress),
      value: share.clamp(0, 1),
      builder: (context, value, child) => FractionallySizedBox(
        widthFactor: value,
        heightFactor: 1,
        child: child,
      ),
      child: ColoredBox(color: color),
    );
    return Container(
      width: double.infinity,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: colors.goalTrack, borderRadius: radius),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [segment(before + added, adding), segment(before, soFar)],
      ),
    );
  }
}
