import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class DayPill extends StatelessWidget {
  const DayPill({
    required this.date,
    required this.selected,
    required this.idleColor,
    super.key,
  });

  final String date;
  final bool selected;
  final Color idleColor;

  @override
  Widget build(BuildContext context) => Container(
    width: FujinSize.dayPill,
    height: FujinSize.dayPill,
    alignment: Alignment.center,
    decoration: switch (selected) {
      true => const BoxDecoration(
        shape: BoxShape.circle,
        color: FujinColorRole.goalSelectedDay,
      ),
      false => null,
    },
    child: Text(
      date,
      style: FujinText.inter13Medium.copyWith(
        color: switch (selected) {
          true => FujinColorRole.textOnDark,
          false => idleColor,
        },
      ),
    ),
  );
}
