import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_amounts.dart';
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/widgets/day_share_bar.dart';
import 'package:fujin/pages/journal/journal_text.dart';

class NutritionCard extends StatelessWidget {
  const NutritionCard({
    required this.servingLine,
    required this.food,
    required this.day,
    required this.goals,
    required this.changed,
    required this.onMyDay,
    super.key,
  });

  final String servingLine;
  final DayNutrients food;
  final DayNutrients? day;
  final Goals? goals;
  final Set<Nutrient> changed;
  final VoidCallback onMyDay;

  @override
  Widget build(BuildContext context) {
    final kilocalories = food.amount(Nutrient.kilocalories);
    final left = switch (_goal(Nutrient.kilocalories)) {
      (final goal, final day)? =>
        goal - day.amount(Nutrient.kilocalories) - kilocalories,
      null => null,
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s4),
      decoration: BoxDecoration(
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: context.colors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  servingLine,
                  style: FujinText.inter13Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              InkWell(
                onTap: onMyDay,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.intl.addMyDay,
                      style: FujinText.inter13Medium.copyWith(
                        color: context.colors.textLink,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: FujinSize.rowChevron,
                      color: context.colors.textLink,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: FujinSpace.s2,
            children: [
              _Highlight(
                on: changed.contains(Nutrient.kilocalories),
                child: Text(
                  context.intl.kilocaloriesValue(kilocalories),
                  style: FujinText.inter28Semibold.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Text(
                context.intl.nutrientKilocalories,
                style: FujinText.inter14Regular.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const Spacer(),
              if (left case final left?)
                Text(
                  switch (left) {
                    < 0 => context.intl.addExceeds(-left),
                    _ => context.intl.addRemaining(left),
                  },
                  style: FujinText.inter14Medium.copyWith(
                    color: switch (left) {
                      < 0 => context.colors.goalExceeded,
                      _ => context.colors.goalInProgress,
                    },
                  ),
                ),
            ],
          ),
          ?_share(Nutrient.kilocalories),
          Row(
            spacing: FujinSpace.s3,
            children: [
              for (final nutrient in JournalText.macros)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: FujinSpace.s1,
                    children: [
                      Text(
                        JournalText.name(context.intl, nutrient),
                        style: FujinText.inter11Regular.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      _Highlight(
                        on: changed.contains(nutrient),
                        child: Text(
                          switch (food.isPartial(nutrient)) {
                            true => context.intl.macroUnknown,
                            false => context.intl.addMacroGrams(
                              food.amount(nutrient),
                            ),
                          },
                          style: FujinText.inter15Medium.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      ?_share(nutrient, thin: true),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  (double, DayNutrients)? _goal(Nutrient nutrient) =>
      switch ((goals?.amount(nutrient), day)) {
        (final goal?, final day?) when goal > 0 => (goal, day),
        _ => null,
      };

  Widget? _share(Nutrient nutrient, {bool thin = false}) =>
      switch (_goal(nutrient)) {
        (final goal, final day)? => DayShareBar(
          before: day.amount(nutrient) / goal,
          added: food.amount(nutrient) / goal,
          status: GoalStatus.of(
            nutrient,
            amount: day.amount(nutrient) + food.amount(nutrient),
            goal: goal,
          ),
          thin: thin,
        ),
        null => null,
      };
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.on, required this.child});

  final bool on;
  final Widget child;

  @override
  Widget build(BuildContext context) => switch (on) {
    false => child,
    true => DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.backgroundHighlight,
        borderRadius: BorderRadius.circular(FujinRadius.tile),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s1),
        child: child,
      ),
    ),
  };
}
