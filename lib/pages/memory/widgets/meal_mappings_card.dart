import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_menu.dart';
import 'package:fujin/pages/common/fujin_menu_button.dart';

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
    return Row(
      spacing: FujinSpace.s3,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                context.intl.sourceMyFitnessPal,
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
          color: FujinColorRole.textGold,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: (FujinSize.touchTarget - FujinSize.controlHeight) / 2,
          ),
          child: FujinMenu<String>(
            items: [
              ...{meal.ekkloMealName, ...choices},
            ],
            selected: meal.ekkloMealName,
            labelOf: (choice) => choice,
            onSelected: onSelect,
            itemPadding: _padding,
            builder: (context, {required expanded, required toggle}) =>
                FujinMenuButton(
                  label: meal.ekkloMealName,
                  expanded: expanded,
                  onTap: toggle,
                  width: FujinSize.menuWidth,
                  height: FujinSize.controlHeight,
                  radius: FujinRadius.menu,
                  padding: _padding,
                  spacing: FujinSize.textGap,
                  semanticsLabel: context.intl.memoryMealMenu(meal.mfpMealName),
                ),
          ),
        ),
      ],
    );
  }

  static const _padding = EdgeInsetsDirectional.symmetric(
    horizontal: FujinSpace.s3,
  );
}
