import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/round_pictogram.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    required this.glyph,
    required this.title,
    required this.detail,
    this.action,
    super.key,
  });

  final SnackBarGlyph glyph;
  final String title;
  final String detail;
  final (String, VoidCallback)? action;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s3,
    children: [
      RoundPictogram(
        icon: glyph.asset,
        side: FujinSize.icon,
        iconSide: FujinSize.tileIcon,
        background: glyph.background,
        foreground: FujinColorRole.textOnDark,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: FujinSize.textGap,
          children: [
            Text(
              title,
              style: FujinText.inter14Medium.copyWith(color: FujinColor.washi),
            ),
            Text(
              detail,
              style: FujinText.inter12Regular.copyWith(
                color: FujinColorRole.textDisabled,
              ),
            ),
          ],
        ),
      ),
      if (action case (final label, final onPressed))
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            onPressed();
          },
          style: TextButton.styleFrom(
            foregroundColor: FujinColor.kin,
            textStyle: FujinText.inter14Semibold,
            minimumSize: const Size.square(FujinSize.touchTarget),
            padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
          ),
          child: Text(label),
        ),
    ],
  );
}
