import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/day_picker_sheet.dart';
import 'package:fujin/pages/common/fujin_menu.dart';
import 'package:fujin/pages/common/fujin_menu_button.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';

class MealDateRow extends StatelessWidget {
  const MealDateRow({
    required this.meal,
    required this.meals,
    required this.date,
    required this.onMeal,
    required this.onDate,
    super.key,
  });

  static const _pickerSpan = Duration(days: 365);
  static const _bookIcon = 'assets/icons/book.svg';
  static const _padding = EdgeInsetsDirectional.symmetric(
    horizontal: FujinSpace.s4,
  );

  final String meal;
  final List<String> meals;
  final DateTime date;
  final ValueChanged<String> onMeal;
  final ValueChanged<DateTime> onDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              itemPadding: _padding,
              builder: (context, {required expanded, required toggle}) => _pill(
                label: meal,
                expanded: expanded,
                onTap: toggle,
                leading: SvgPicture.asset(
                  _bookIcon,
                  width: FujinSize.mealArrow,
                  height: FujinSize.mealArrow,
                  theme: const SvgTheme(
                    currentColor: FujinColorRole.textPrimary,
                  ),
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: _pill(
              label: TitleText.capitalized(l10n.addMealDate(date)),
              expanded: false,
              onTap: () => unawaited(
                SheetFrame.show(
                  context,
                  builder: (context) => DayPickerSheet(
                    selected: date,
                    first: date.subtract(_pickerSpan),
                    last: date.add(_pickerSpan),
                    onPicked: onDate,
                  ),
                ),
              ),
              leading: const Icon(
                Icons.calendar_today_outlined,
                size: FujinSize.mealArrow,
                color: FujinColorRole.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _pill({
    required String label,
    required bool expanded,
    required VoidCallback onTap,
    required Widget leading,
  }) => FujinMenuButton(
    label: label,
    expanded: expanded,
    onTap: onTap,
    height: FujinSize.buttonMedium,
    radius: FujinRadius.pill,
    padding: _padding,
    chevronSize: FujinSize.mealArrow,
    leading: leading,
  );
}
