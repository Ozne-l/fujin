import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/selected_day.dart';

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

  final String meal;
  final List<String> meals;
  final DateTime date;
  final ValueChanged<String> onMeal;
  final ValueChanged<DateTime> onDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(_pickerSpan),
        lastDate: date.add(_pickerSpan),
      );
      if (picked case final picked?) onDate(SelectedDay.calendarDay(picked));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: Row(
        spacing: FujinSpace.s2,
        children: [
          Expanded(
            child: PopupMenuButton<String>(
              initialValue: meal,
              onSelected: onMeal,
              itemBuilder: (context) => [
                for (final name in {meal, ...meals})
                  PopupMenuItem(value: name, child: Text(name)),
              ],
              child: _Pill(icon: Icons.description_outlined, label: meal),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => unawaited(pickDate()),
              customBorder: const StadiumBorder(),
              child: _Pill(
                icon: Icons.calendar_today_outlined,
                label: TitleText.capitalized(l10n.addMealDate(date)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    height: FujinSize.buttonMedium,
    padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
    decoration: const ShapeDecoration(
      color: FujinColorRole.backgroundCard,
      shape: StadiumBorder(
        side: BorderSide(color: FujinColorRole.borderCard),
      ),
    ),
    child: Row(
      spacing: FujinSpace.s2,
      children: [
        Icon(
          icon,
          size: FujinSize.searchIcon,
          color: FujinColorRole.textPrimary,
        ),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: FujinText.inter15Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
        ),
        const Icon(Icons.expand_more, color: FujinColorRole.textPrimary),
      ],
    ),
  );
}
