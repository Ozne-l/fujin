import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class MealMappingsCard extends StatelessWidget {
  const MealMappingsCard({
    required this.meals,
    required this.choices,
    required this.onChange,
    super.key,
  });

  final List<MealMapping> meals;
  final List<String> choices;
  final ValueChanged<MealMapping> onChange;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: FujinSpace.s5,
      vertical: FujinSpace.s5,
    ),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.card),
      border: Border.all(color: FujinColorRole.borderCard),
    ),
    child: Column(
      spacing: FujinSpace.s4,
      children: [
        for (final (index, meal) in meals.indexed) ...[
          if (index > 0)
            const Divider(
              height: FujinStroke.card,
              thickness: FujinStroke.card,
              color: FujinColorRole.borderHairline,
            ),
          _MealRow(
            meal: meal,
            choices: choices,
            onSelect: (name) => onChange(
              MealMapping(mfpMealName: meal.mfpMealName, ekkloMealName: name),
            ),
          ),
        ],
      ],
    ),
  );
}

class _MealRow extends StatelessWidget {
  const _MealRow({
    required this.meal,
    required this.choices,
    required this.onSelect,
  });

  final MealMapping meal;
  final List<String> choices;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      spacing: FujinSpace.s3,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                l10n.sourceMyFitnessPal,
                style: FujinText.inter11Medium.copyWith(
                  color: FujinColorRole.textTertiary,
                ),
              ),
              Text(
                meal.mfpMealName,
                style: FujinText.inter15Medium.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward,
          size: FujinSize.mealArrow,
          color: FujinColorRole.textTertiary,
        ),
        PopupMenuButton<String>(
          initialValue: meal.ekkloMealName,
          onSelected: onSelect,
          tooltip: meal.mfpMealName,
          useRootNavigator: true,
          itemBuilder: (context) => [
            for (final choice in {meal.ekkloMealName, ...choices})
              PopupMenuItem(
                value: choice,
                child: Text(
                  choice,
                  style: FujinText.inter14Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
              ),
          ],
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: (FujinSize.touchTarget - FujinSize.controlHeight) / 2,
            ),
            width: FujinSize.menuWidth,
            height: FujinSize.controlHeight,
            padding: const EdgeInsetsDirectional.only(
              start: FujinSpace.s3,
              end: FujinSpace.s3,
            ),
            decoration: BoxDecoration(
              color: FujinColorRole.backgroundCard,
              borderRadius: BorderRadius.circular(FujinRadius.menu),
              border: Border.all(color: FujinColorRole.borderCard),
            ),
            child: Row(
              spacing: FujinSize.textGap,
              children: [
                Expanded(
                  child: Text(
                    meal.ekkloMealName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FujinText.inter14Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.expand_more,
                  size: FujinSize.menuChevron,
                  color: FujinColorRole.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
