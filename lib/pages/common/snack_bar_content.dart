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
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      spacing: FujinSpace.s3,
      children: [
        RoundPictogram(
          icon: glyph.asset,
          side: FujinSize.icon,
          iconSide: FujinSize.tileIcon,
          background: glyph.background(colors),
          foreground: glyph.foreground(colors),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSize.textGap,
            children: [
              Text(
                title,
                style: FujinText.inter14Medium.copyWith(
                  color: colors.textOnDark,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter12Regular.copyWith(
                  color: colors.textOnDarkSecondary,
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
              foregroundColor: colors.textOnDarkAccent,
              textStyle: FujinText.inter14Semibold,
              padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
            ),
            child: Text(label),
          ),
      ],
    );
  }
}
