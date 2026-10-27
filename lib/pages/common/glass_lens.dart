import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassLens extends StatelessWidget {
  const GlassLens({
    required this.rect,
    required this.visibility,
    this.squash = _unsquashed,
    super.key,
  });

  final Rect rect;
  final double visibility;
  final double squash;

  static const double _unsquashed = 1;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fromRect(
          rect: rect,
          child: Transform.scale(
            scaleX: squash,
            child: LiquidGlass.withOwnLayer(
              settings: FujinGlass.lens,
              appearance: FujinGlass.appearance(
                Theme.of(context).brightness,
                tint: context.colors.backgroundGlassLens,
                visibility: visibility,
              ),
              shape: LiquidRoundedSuperellipse(borderRadius: rect.height / 2),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    ),
  );
}
