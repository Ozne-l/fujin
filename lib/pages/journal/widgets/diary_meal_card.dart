import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/widgets/entry_row.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';

class DiaryMealCard extends StatelessWidget {
  const DiaryMealCard({required this.meal, this.note, super.key});

  final DiaryMeal meal;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final secondary = FujinText.inter13Regular.copyWith(
      color: context.colors.textSecondary,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: context.colors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          SplitLine(
            leading: Text(
              meal.name,
              style: FujinText.inter16Medium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            trailing: Text(
              context.intl.kilocalories(meal.kilocalories),
              style: FujinText.inter15Semibold.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (note case final note?) Text(note, style: secondary),
          switch (meal.entries) {
            [] => Text(context.intl.mealEmpty, style: secondary),
            final entries => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s3,
              children: [
                for (final entry in entries) ...[
                  const Divider(),
                  EntryRow(
                    key: ValueKey(entry),
                    entry: entry,
                    detail: EntryText.macros(context.intl, entry.nutrients),
                  ),
                ],
              ],
            ),
          },
        ],
      ),
    );
  }
}
