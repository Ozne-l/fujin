import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_amounts.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/common/sheet_header.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

Future<void> showMyDaySheet(
  BuildContext context, {
  required String subtitle,
  required MfpFoodEntry entry,
  required DayNutrients? day,
  required Goals? goals,
}) => SheetFrame.show(
  context,
  builder: (_) => SheetFrame.handled(
    _MyDay(subtitle: subtitle, entry: entry, day: day, goals: goals),
  ),
);

class _MyDay extends StatelessWidget {
  const _MyDay({
    required this.subtitle,
    required this.entry,
    required this.day,
    required this.goals,
  });

  static const _decimals = 1;
  static const _labelFlex = 1.4;

  final String subtitle;
  final MfpFoodEntry entry;
  final DayNutrients? day;
  final Goals? goals;

  @override
  Widget build(BuildContext context) {
    final food = DayNutrients.ofEntries([entry]);
    final nutrients = entry.nutrients;
    String amount(Nutrient nutrient, double value) => switch (nutrient) {
      Nutrient.kilocalories => context.intl.kilocaloriesValue(value),
      Nutrient.protein ||
      Nutrient.carbohydrates ||
      Nutrient.fat ||
      Nutrient.fiber => context.intl.macroValue(
        double.parse(value.toStringAsFixed(_decimals)),
      ),
    };
    final notes = [
      if ((nutrients.sugar, nutrients.sodiumMilligrams) case (
        final sugar?,
        final sodium?,
      ))
        context.intl.addDayExtras(sugar, sodium),
      context.intl.addDayNote,
    ];
    final secondary = FujinText.inter13Regular.copyWith(
      color: context.colors.textSecondary,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        FujinSize.textInset,
        0,
        FujinSize.textInset,
        FujinSpace.s3,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s3,
          children: [
            SheetHeader(title: context.intl.addMyDay, subtitle: subtitle),
            Table(
              columnWidths: const {0: FlexColumnWidth(_labelFlex)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: context.colors.borderHairline,
                ),
                bottom: BorderSide(color: context.colors.borderHairline),
              ),
              children: [
                _row(
                  colors: context.colors,
                  label: '',
                  values: (
                    context.intl.addThisFood,
                    context.intl.addAfterAdding,
                    context.intl.addGoal,
                  ),
                  style: secondary,
                  total: secondary,
                ),
                for (final nutrient in Nutrient.values)
                  _row(
                    colors: context.colors,
                    label: JournalText.name(context.intl, nutrient),
                    values: (
                      context.intl.addPlus(
                        amount(nutrient, food.amount(nutrient)),
                      ),
                      switch (day) {
                        final day? => amount(
                          nutrient,
                          day.amount(nutrient) + food.amount(nutrient),
                        ),
                        null => context.intl.macroUnknown,
                      },
                      switch ((goals?.amount(nutrient), nutrient)) {
                        (null, _) => '',
                        (final goal?, Nutrient.fiber) => context.intl.atLeast(
                          amount(nutrient, goal),
                        ),
                        (final goal?, _) => amount(nutrient, goal),
                      },
                    ),
                    style: FujinText.inter15Regular.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    total: FujinText.inter15Semibold.copyWith(
                      color: context.colors.goalInProgress,
                    ),
                  ),
              ],
            ),
            Text(
              notes.join(context.intl.summarySeparator),
              style: FujinText.inter12Regular.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TableRow _row({
    required FujinColors colors,
    required String label,
    required (String, String, String) values,
    required TextStyle style,
    required TextStyle total,
  }) {
    Widget cell(String text, TextStyle style) => Padding(
      padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
      child: Text(text, textAlign: TextAlign.end, style: style),
    );
    final (food, after, goal) = values;
    return TableRow(
      children: [
        Text(label, style: style),
        cell(food, style),
        cell(after, total),
        cell(goal, style.copyWith(color: colors.textSecondary)),
      ],
    );
  }
}
