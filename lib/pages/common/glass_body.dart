import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_shadow.dart';
import 'package:fujin/pages/common/glass_touch_glow.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassBody extends StatelessWidget {
  const GlassBody.grouped({
    required this.shape,
    required this.reduced,
    required this.opaque,
    required this.fill,
    required this.child,
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
    required this.child,
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
      false => _glass(colors, Theme.of(context).brightness),
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

  Widget _glass(FujinColors colors, Brightness brightness) {
    Widget glowing(Widget lit) => GlassGlowLayer(
      child: GlassGlow(glowColor: colors.backgroundGlassGlow, child: lit),
    );
    final lit = switch (glow) {
      GlassTouchGlow.none => child,
      GlassTouchGlow.overTint => glowing(child),
      GlassTouchGlow.underTint => ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: glowing(child),
      ),
    };
    final appearance = FujinGlass.appearance(brightness, tint: fill);
    return switch (_ownLayer) {
      null => LiquidGlass.grouped(
        shape: shape,
        appearance: appearance,
        child: lit,
      ),
      final settings => LiquidGlass.withOwnLayer(
        settings: settings,
        appearance: appearance,
        shape: shape,
        child: lit,
      ),
    };
  }
}
