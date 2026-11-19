import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat_media/widgets/dark_badge.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';

class DarkPill extends StatelessWidget {
  const DarkPill({
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.labelStyle,
    required this.padding,
    super.key,
  });

  final String icon;
  final double iconSize;
  final String label;
  final TextStyle labelStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.backgroundDark.withValues(alpha: DarkBadge.opacity),
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: FujinSpace.s1,
          children: [
            MediaGlyph(icon, size: iconSize, color: colors.textOnDark),
            Text(label, style: labelStyle.copyWith(color: colors.textOnDark)),
          ],
        ),
      ),
    );
  }
}
