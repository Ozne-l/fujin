import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/day_picker_sheet.dart';
import 'package:fujin/pages/common/fujin_menu_button.dart';
import 'package:fujin/pages/common/sheet_frame.dart';

class DayPickerButton extends StatelessWidget {
  const DayPickerButton({
    required this.label,
    required this.selected,
    required this.first,
    required this.last,
    required this.onPicked,
    required this.iconColor,
    super.key,
  });

  static const padding = EdgeInsetsDirectional.symmetric(
    horizontal: FujinSpace.s4,
  );

  final String label;
  final DateTime selected;
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateTime> onPicked;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => FujinMenuButton(
    label: label,
    expanded: false,
    onTap: () => unawaited(
      SheetFrame.show(
        context,
        builder: (context) => DayPickerSheet(
          selected: selected,
          first: first,
          last: last,
          onPicked: onPicked,
        ),
      ),
    ),
    height: FujinSize.buttonMedium,
    radius: FujinRadius.pill,
    padding: padding,
    chevronSize: FujinSize.mealArrow,
    leading: Icon(
      Icons.calendar_today_outlined,
      size: FujinSize.mealArrow,
      color: iconColor,
    ),
  );
}
