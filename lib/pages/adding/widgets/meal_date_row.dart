import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/day_picker_button.dart';
import 'package:fujin/pages/common/fujin_menu.dart';
import 'package:fujin/pages/common/fujin_menu_button.dart';
import 'package:fujin/pages/common/title_text.dart';

class MealDateRow extends StatelessWidget {
  const MealDateRow({
    required this.meal,
    required this.meals,
    required this.date,
    required this.onMeal,
    required this.onDate,
    this.lastDay,
    super.key,
  });

  static const _bookIcon = 'assets/icons/book.svg';

  final String meal;
  final List<String> meals;
  final DateTime date;
  final ValueChanged<String> onMeal;
  final ValueChanged<DateTime> onDate;
  final DateTime? lastDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: Row(
        spacing: FujinSpace.s2,
        children: [
          Expanded(
            child: FujinMenu<String>(
              items: [
                ...{meal, ...meals},
              ],
              selected: meal,
              labelOf: (name) => name,
              onSelected: onMeal,
              itemPadding: FujinMenuButton.pillPadding,
              builder: (context, {required expanded, required toggle}) =>
                  FujinMenuButton.pill(
                    label: meal,
                    expanded: expanded,
                    onTap: toggle,
                    leading: SvgPicture.asset(
                      _bookIcon,
                      width: FujinSize.mealArrow,
                      height: FujinSize.mealArrow,
                      theme: SvgTheme(
                        currentColor: context.colors.textPrimary,
                      ),
                      excludeFromSemantics: true,
                    ),
                  ),
            ),
          ),
          Expanded(
            child: DayPickerButton(
              label: TitleText.capitalized(context.intl.addMealDate(date)),
              selected: date,
              first: date.subtract(DayPickerButton.span),
              last: lastDay ?? date.add(DayPickerButton.span),
              onPicked: onDate,
              iconColor: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
