import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/pill_tone.dart';

class SheetPictogram extends StatelessWidget {
  const SheetPictogram({required this.icon, required this.tone, super.key});

  final Widget icon;
  final PillTone tone;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: CircleAvatar(
      radius: FujinSize.pictogram / 2,
      backgroundColor: tone.background(context.colors),
      child: IconTheme(
        data: IconThemeData(
          size: FujinSize.pictogramIcon,
          color: tone.foreground(context.colors),
        ),
        child: icon,
      ),
    ),
  );
}
