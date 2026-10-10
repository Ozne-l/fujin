import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/widgets/progress_ring.dart';

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
    final l10n = AppLocalizations.of(context);
    final value = switch (partial) {
      true => l10n.atLeast(l10n.ringValue(amount)),
      false => l10n.ringValue(amount),
    };
    final status = switch (goal) {
      final goal? => GoalStatus.of(nutrient, amount: amount, goal: goal),
      null => null,
    };
    final (fill, track, arc) = switch ((status, nutrient)) {
      (null, _) => (
        FujinColorRole.backgroundCard,
        FujinColorRole.textDisabled,
        null,
      ),
      (GoalStatus.below, Nutrient.fiber) => (
        FujinColorRole.backgroundCard,
        FujinColorRole.goalMinimumLeft,
        FujinColorRole.goalInProgress,
      ),
      (GoalStatus.below, _) => (
        FujinColorRole.backgroundCard,
        FujinColorRole.goalTrack,
        FujinColorRole.goalInProgress,
      ),
      (GoalStatus.reached, _) => (
        FujinColorRole.goalReachedBackground,
        FujinColorRole.goalReached,
        null,
      ),
      (GoalStatus.exceeded, _) => (
        FujinColorRole.goalExceededBackground,
        FujinColorRole.goalExceeded,
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
                  color: FujinColorRole.textPrimary,
                ),
              ),
              if (goal case final goal?)
                Text(
                  l10n.ringGoal(goal),
                  style: FujinText.inter10Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Text(
          label,
          style: FujinText.inter11Regular.copyWith(
            color: FujinColorRole.textSecondary,
          ),
        ),
      ],
    );
  }
}
