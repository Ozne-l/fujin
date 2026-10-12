import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_amounts.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

Future<void> showMyDaySheet(
  BuildContext context, {
  required String subtitle,
  required MfpFoodEntry entry,
  required DayNutrients? day,
  required Goals? goals,
}) => SheetFrame.show(
  context,
  builder: (_) =>
      _MyDay(subtitle: subtitle, entry: entry, day: day, goals: goals),
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
    final l10n = AppLocalizations.of(context);
    final food = DayNutrients.ofEntries([entry]);
    final nutrients = entry.nutrients;
    String amount(Nutrient nutrient, double value) => switch (nutrient) {
      Nutrient.kilocalories => l10n.kilocaloriesValue(value),
      Nutrient.protein ||
      Nutrient.carbohydrates ||
      Nutrient.fat ||
      Nutrient.fiber => l10n.macroValue(
        double.parse(value.toStringAsFixed(_decimals)),
      ),
    };
    final notes = [
      if ((nutrients.sugar, nutrients.sodiumMilligrams) case (
        final sugar?,
        final sodium?,
      ))
        l10n.addDayExtras(sugar, sodium),
      l10n.addDayNote,
    ];
    final secondary = FujinText.inter13Regular.copyWith(
      color: FujinColorRole.textSecondary,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.addMyDay,
                    style: FujinText.hina28.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(l10n.close),
                ),
              ],
            ),
            Text(subtitle, style: secondary),
            Table(
              columnWidths: const {0: FlexColumnWidth(_labelFlex)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: const TableBorder(
                horizontalInside: BorderSide(
                  color: FujinColorRole.borderHairline,
                ),
                bottom: BorderSide(color: FujinColorRole.borderHairline),
              ),
              children: [
                _row(
                  label: '',
                  values: (l10n.addThisFood, l10n.addAfterAdding, l10n.addGoal),
                  style: secondary,
                  total: secondary,
                ),
                for (final nutrient in Nutrient.values)
                  _row(
                    label: JournalText.name(l10n, nutrient),
                    values: (
                      l10n.addPlus(amount(nutrient, food.amount(nutrient))),
                      switch (day) {
                        final day? => amount(
                          nutrient,
                          day.amount(nutrient) + food.amount(nutrient),
                        ),
                        null => l10n.macroUnknown,
                      },
                      switch ((goals?.amount(nutrient), nutrient)) {
                        (null, _) => '',
                        (final goal?, Nutrient.fiber) => l10n.atLeast(
                          amount(nutrient, goal),
                        ),
                        (final goal?, _) => amount(nutrient, goal),
                      },
                    ),
                    style: FujinText.inter15Regular.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                    total: FujinText.inter15Semibold.copyWith(
                      color: FujinColorRole.goalInProgress,
                    ),
                  ),
              ],
            ),
            Text(
              notes.join(l10n.summarySeparator),
              style: FujinText.inter12Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TableRow _row({
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
        cell(goal, style.copyWith(color: FujinColorRole.textSecondary)),
      ],
    );
  }
}
