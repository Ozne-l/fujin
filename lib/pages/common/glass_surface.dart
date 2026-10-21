import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_body.dart';
import 'package:fujin/pages/common/glass_touch_glow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassSurface extends ConsumerWidget {
  const GlassSurface({
    required this.child,
    this.height = FujinSize.tabBar,
    this.overlay,
    this.glows = false,
    this.shadow = FujinTheme.floatingShadow,
    super.key,
  });

  final Widget child;
  final double height;
  final Widget? overlay;
  final bool glows;
  final BoxShadow Function(FujinColors colors) shadow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return GlassBody.grouped(
      shape: LiquidRoundedSuperellipse(borderRadius: height / 2),
      reduced: FujinGlass.reduced(context, ref),
      opaque: colors.backgroundCard,
      fill: colors.backgroundGlass,
      highlight: colors.borderGlassHighlight,
      shade: colors.borderGlassShade,
      glow: switch (glows) {
        true => GlassTouchGlow.underTint,
        false => GlassTouchGlow.none,
      },
      pressable: true,
      overlay: overlay,
      shadow: shadow(colors),
      child: SizedBox(height: height, child: child),
    );
  }
}
