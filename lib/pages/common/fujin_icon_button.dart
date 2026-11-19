import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';

class FujinIconButton extends StatelessWidget {
  const FujinIconButton({
    required IconData this.icon,
    required this.tooltip,
    required this.onPressed,
    this.floating = false,
    super.key,
  }) : glyph = null,
       size = FujinSize.touchTarget;

  const FujinIconButton.glyph({
    required Widget this.glyph,
    required this.tooltip,
    required this.onPressed,
    this.size = FujinSize.touchTarget,
    this.floating = false,
    super.key,
  }) : icon = null;

  final IconData? icon;
  final Widget? glyph;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final bool floating;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: switch (glyph) {
      final glyph? => glyph,
      null => Icon(icon),
    },
    style:
        GlassFill.style(
          context.colors,
          GlassFinish.clear,
          floating: floating,
        ).merge(
          IconButton.styleFrom(
            fixedSize: Size.square(size),
          ).copyWith(overlayColor: FujinTheme.pressedOverlay(context.colors)),
        ),
  );
}
