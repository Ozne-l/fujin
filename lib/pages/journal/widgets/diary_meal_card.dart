import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/pages/journal/widgets/meal_title.dart';
import 'package:fujin/pages/journal/widgets/stored_row.dart';

class DiaryMealCard extends StatelessWidget {
  const DiaryMealCard({required this.meal, this.note, super.key});

  final DiaryMeal meal;
  final String? note;

  @override
  Widget build(BuildContext context) => Container(
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
        MealTitle(
          name: meal.name,
          kilocalories: meal.kilocalories,
          note: note,
          empty: meal.entries.isEmpty,
        ),
        for (final entry in meal.entries) ...[
          const Divider(),
          StoredRow(
            entry,
            mfpPending: meal.mfpPending.contains(entry.entry.id),
            key: ValueKey(entry),
          ),
        ],
      ],
    ),
  );
}
