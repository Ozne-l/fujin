import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_rim.dart';
import 'package:fujin/pages/common/glass_shadow.dart';
import 'package:fujin/pages/common/glass_touch_glow.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassBody extends StatelessWidget {
  const GlassBody.grouped({
    required this.shape,
    required this.reduced,
    required this.opaque,
    required this.fill,
    required this.highlight,
    required this.shade,
    required this.child,
    this.rim = FujinStroke.card,
    this.glow = GlassTouchGlow.none,
    this.pressable = false,
    this.overlay,
    this.shadow,
    super.key,
  }) : _ownLayer = null;

  const GlassBody.ownLayer({
    required LiquidGlassSettings settings,
    required this.shape,
    required this.reduced,
    required this.opaque,
    required this.fill,
    required this.highlight,
    required this.shade,
    required this.child,
    this.rim = FujinStroke.card,
    this.glow = GlassTouchGlow.none,
    this.pressable = false,
    this.overlay,
    this.shadow,
    super.key,
  }) : _ownLayer = settings;

  final LiquidGlassSettings? _ownLayer;
  final LiquidShape shape;
  final bool reduced;
  final Color opaque;
  final Color fill;
  final Color highlight;
  final Color shade;
  final double rim;
  final GlassTouchGlow glow;
  final bool pressable;
  final Widget? overlay;
  final BoxShadow? shadow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final body = switch (reduced) {
      true => DecoratedBox(
        decoration: ShapeDecoration(
          color: opaque,
          shape: shape.copyWith(side: BorderSide(color: colors.borderCard)),
        ),
        child: child,
      ),
      false => _glass(colors),
    };
    final layered = switch (overlay) {
      null => body,
      final overlay => Stack(
        clipBehavior: Clip.none,
        children: [
          body,
          Positioned.fill(child: overlay),
        ],
      ),
    };
    final pressed = switch (pressable && !FujinMotion.reduced(context)) {
      false => layered,
      true => LiquidStretch(
        interactionScale: FujinMotion.glassPress,
        stretch: FujinMotion.glassStretch,
        child: layered,
      ),
    };
    return switch (shadow) {
      null => pressed,
      final shadow => GlassShadow(shape: shape, shadow: shadow, child: pressed),
    };
  }

  Widget _glass(FujinColors colors) {
    Widget glowing(Widget lit) => GlassGlowLayer(
      child: GlassGlow(glowColor: colors.backgroundGlassGlow, child: lit),
    );
    final tinted = GlassRim(
      shape: shape,
      highlight: highlight,
      shade: shade,
      width: rim,
      child: DecoratedBox(
        decoration: ShapeDecoration(color: fill, shape: shape),
        child: switch (glow) {
          GlassTouchGlow.overTint => glowing(child),
          GlassTouchGlow.none || GlassTouchGlow.underTint => child,
        },
      ),
    );
    final lit = switch (glow) {
      GlassTouchGlow.underTint => ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: glowing(tinted),
      ),
      GlassTouchGlow.none || GlassTouchGlow.overTint => tinted,
    };
    return switch (_ownLayer) {
      null => LiquidGlass.grouped(shape: shape, child: lit),
      final settings => LiquidGlass.withOwnLayer(
        settings: settings,
        shape: shape,
        child: lit,
      ),
    };
  }
}
