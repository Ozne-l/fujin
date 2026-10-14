import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_amounts.dart';
import 'package:fujin/domain/goals/goal_status.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/goals_text.dart';
import 'package:fujin/pages/common/progress_bar.dart';
import 'package:fujin/pages/common/send_label.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/journal/widgets/nutrient_ring.dart';

TextSpan _strong(String text) =>
    TextSpan(text: text, style: FujinText.inter13Semibold);

TextSpan _soft(String text) => TextSpan(
  text: text,
  style: FujinText.inter13Regular.copyWith(color: FujinColorRole.textSecondary),
);

TextSpan _faint(String text) => TextSpan(
  text: text,
  style: FujinText.inter13Regular.copyWith(color: FujinColorRole.textTertiary),
);

class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({
    required this.read,
    required this.goals,
    required this.stale,
    required this.onSend,
    required this.onDetail,
    super.key,
  });

  final JournalRead read;
  final Goals? goals;
  final bool stale;
  final VoidCallback onSend;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    final fresh = switch ((read, stale)) {
      (BothSides(:final day), false) => day,
      _ => null,
    };
    final mfp = switch (read) {
      BothSides(:final day) => day.nutrients,
      MfpOnly(:final nutrients) => nutrients,
      EkkloOnly() => null,
    };
    final rings = switch ((mfp, goals, stale)) {
      (final mfp?, final goals?, false) => (mfp, goals),
      _ => null,
    };
    final (sendLabel, onPressed) = switch (fresh) {
      final day? => switch (SendLabel.of(
        context.intl,
        day.counts.toSend,
        day.counts.toUpdate,
      )) {
        final label? => (label, onSend),
        null => (null, null),
      },
      null => (context.intl.sendToEkklo, null),
    };
    return GestureDetector(
      onTap: switch (fresh) {
        JournalDay() => onDetail,
        null => null,
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
        padding: const EdgeInsets.fromLTRB(
          FujinSpace.s5,
          FujinSpace.s4,
          FujinSpace.s5,
          FujinSpace.s4,
        ),
        decoration: BoxDecoration(
          color: FujinColorRole.backgroundCard,
          borderRadius: BorderRadius.circular(FujinRadius.card),
          border: Border.all(color: FujinColorRole.borderCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s4,
          children: [
            switch ((rings, mfp)) {
              ((final nutrients, final goals)?, _) => _MfpRings(
                nutrients: nutrients,
                goals: goals,
              ),
              (null, final nutrients?) => _MfpCompact(
                nutrients: nutrients,
                readAt: switch (stale) {
                  true => read.readAt,
                  false => null,
                },
              ),
              (null, null) => _MfpUnavailable(goals: goals),
            },
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s3,
              children: [
                if (rings != null) const Divider(),
                ...switch ((fresh, read)) {
                  (final day?, _) => _progress(context.intl, day),
                  (null, BothSides(:final day)) => [
                    _counted(context.intl, day.ekkloMeals),
                  ],
                  (null, EkkloOnly(:final ekkloMeals)) => [
                    _counted(context.intl, ekkloMeals),
                  ],
                  (null, MfpOnly()) => [
                    _SourceLine(
                      dot: FujinColorRole.sourceEkklo,
                      label: context.intl.sourceEkklo,
                      trailing: [_faint(context.intl.sideUnavailable)],
                    ),
                  ],
                },
              ],
            ),
            if (sendLabel case final label?)
              FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
                  textStyle: FujinText.inter15Medium,
                ),
                child: Text(label),
              ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _progress(AppLocalizations intl, JournalDay day) => [
    _SourceLine(
      dot: FujinColorRole.sourceEkklo,
      label: intl.sourceEkklo,
      trailing: [
        _strong(
          intl.kilocalories(day.ekkloNutrients.amount(Nutrient.kilocalories)),
        ),
        _soft(switch (day.counts.total) {
          0 => ' ${intl.ekkloNoFood}',
          final total => ' ${intl.ekkloProgress(day.counts.inEkklo, total)}',
        }),
      ],
    ),
    ProgressBar(
      fraction: switch (day.counts.total) {
        0 => 0,
        final total => day.counts.inEkklo / total,
      },
      color: FujinColor.fujin,
    ),
  ];

  static Widget _counted(
    AppLocalizations intl,
    List<EkkloDailyMeal> meals,
  ) => _SourceLine(
    dot: FujinColorRole.sourceEkklo,
    label: intl.sourceEkklo,
    trailing: [
      _strong(
        intl.kilocalories(
          DayNutrients.ofEkklo(meals).amount(Nutrient.kilocalories),
        ),
      ),
      _soft(switch (meals.fold(0, (count, meal) => count + meal.items.length)) {
        0 => ' ${intl.ekkloNoFood}',
        final count => ' ${intl.ekkloFoodCount(count)}',
      }),
    ],
  );
}

class _MfpRings extends StatelessWidget {
  const _MfpRings({required this.nutrients, required this.goals});

  final DayNutrients nutrients;
  final Goals goals;

  @override
  Widget build(BuildContext context) {
    final eaten = nutrients.amount(Nutrient.kilocalories);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s3,
      children: [
        _SourceLine(
          dot: FujinColorRole.sourceMfp,
          label: context.intl.sourceMyFitnessPal,
          trailing: [
            TextSpan(
              text: context.intl.kilocaloriesValue(eaten),
              style: FujinText.inter15Semibold,
            ),
            _soft(' ${context.intl.kilocaloriesGoal(goals.kilocalories)}'),
          ],
        ),
        ProgressBar(
          fraction: eaten / goals.kilocalories,
          color: switch (GoalStatus.of(
            Nutrient.kilocalories,
            amount: eaten,
            goal: goals.kilocalories,
          )) {
            GoalStatus.below => FujinColorRole.goalInProgress,
            GoalStatus.reached => FujinColorRole.goalReached,
            GoalStatus.exceeded => FujinColorRole.goalExceeded,
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final nutrient in JournalText.macros)
              NutrientRing(
                nutrient: nutrient,
                label: JournalText.name(context.intl, nutrient),
                amount: nutrients.amount(nutrient),
                partial: nutrients.isPartial(nutrient),
                goal: goals.amount(nutrient),
              ),
          ],
        ),
      ],
    );
  }
}

class _MfpCompact extends StatelessWidget {
  const _MfpCompact({required this.nutrients, required this.readAt});

  final DayNutrients nutrients;
  final DateTime? readAt;

  @override
  Widget build(BuildContext context) {
    final eaten = nutrients.amount(Nutrient.kilocalories);
    return _SourceBlock(
      trailing: switch (readAt) {
        final readAt? => _faint(context.intl.kilocaloriesAt(eaten, readAt)),
        null => TextSpan(
          text: context.intl.kilocalories(eaten),
          style: FujinText.inter15Semibold,
        ),
      },
      detail: JournalText.macroLine(context.intl, nutrients),
    );
  }
}

class _MfpUnavailable extends StatelessWidget {
  const _MfpUnavailable({required this.goals});

  final Goals? goals;

  @override
  Widget build(BuildContext context) {
    return _SourceBlock(
      trailing: _faint(context.intl.sideUnavailable),
      detail: switch (goals) {
        final goals? => context.intl.goalLine(
          GoalsText.summary(context.intl, goals),
        ),
        null => null,
      },
    );
  }
}

class _SourceBlock extends StatelessWidget {
  const _SourceBlock({required this.trailing, required this.detail});

  final TextSpan trailing;
  final String? detail;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: FujinSpace.s1,
    children: [
      _SourceLine(
        dot: FujinColorRole.sourceMfp,
        label: context.intl.sourceMyFitnessPal,
        trailing: [trailing],
      ),
      if (detail case final detail?)
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: FujinSize.sourceDot + FujinSpace.s2,
          ),
          child: Text(
            detail,
            style: FujinText.inter12Medium.copyWith(
              color: FujinColorRole.textTertiary,
            ),
          ),
        ),
    ],
  );
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({
    required this.dot,
    required this.label,
    required this.trailing,
  });

  final Color dot;
  final String label;
  final List<TextSpan> trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s2,
    children: [
      SourceDot(color: dot),
      Expanded(
        child: Text(
          label,
          style: FujinText.inter13Medium.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
      ),
      Text.rich(
        TextSpan(
          style: const TextStyle(color: FujinColorRole.textPrimary),
          children: trailing,
        ),
      ),
    ],
  );
}
