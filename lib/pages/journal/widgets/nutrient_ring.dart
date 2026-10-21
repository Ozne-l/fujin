import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/progress_ring.dart';

class NutrientRing extends StatelessWidget {
  const NutrientRing({
    required this.nutrient,
    required this.label,
    required this.amount,
    required this.partial,
    required this.goal,
    super.key,
  });

  final Nutrient nutrient;
  final String label;
  final double amount;
  final bool partial;
  final double? goal;

  @override
  Widget build(BuildContext context) {
    final value = switch (partial) {
      true => context.intl.atLeast(context.intl.ringValue(amount)),
      false => context.intl.ringValue(amount),
    };
    final status = switch (goal) {
      final goal? => GoalStatus.of(nutrient, amount: amount, goal: goal),
      null => null,
    };
    final (fill, track, arc) = switch ((status, nutrient)) {
      (null, _) => (
        context.colors.backgroundCard,
        context.colors.textDisabled,
        null,
      ),
      (GoalStatus.below, Nutrient.fiber) => (
        context.colors.backgroundCard,
        context.colors.goalMinimumLeft,
        context.colors.goalInProgress,
      ),
      (GoalStatus.below, _) => (
        context.colors.backgroundCard,
        context.colors.goalTrack,
        context.colors.goalInProgress,
      ),
      (GoalStatus.reached, _) => (
        context.colors.goalReachedBackground,
        context.colors.goalReached,
        null,
      ),
      (GoalStatus.exceeded, _) => (
        context.colors.goalExceededBackground,
        context.colors.goalExceeded,
        null,
      ),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: FujinSpace.s1,
      children: [
        ProgressRing(
          size: FujinSize.macroRing,
          stroke: FujinStroke.macroRing,
          fill: fill,
          track: track,
          arc: arc,
          progress: switch (goal) {
            final goal? => amount / goal,
            null => 0,
          },
          dashed: goal == null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: FujinText.inter13Medium.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              if (goal case final goal?)
                Text(
                  context.intl.ringGoal(goal),
                  style: FujinText.inter10Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Text(
          label,
          style: FujinText.inter11Regular.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
