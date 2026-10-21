import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';

class FujinIconButton extends StatelessWidget {
  const FujinIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.floating = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool floating;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(icon),
    style:
        GlassFill.style(
          context.colors,
          GlassFinish.clear,
          floating: floating,
        ).merge(
          IconButton.styleFrom(
            fixedSize: const Size.square(FujinSize.touchTarget),
          ).copyWith(overlayColor: FujinTheme.pressedOverlay(context.colors)),
        ),
  );
}
