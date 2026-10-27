import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_body.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/glass_touch_glow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:motor/motor.dart';

class GlassFill extends HookConsumerWidget {
  const GlassFill({
    required this.finish,
    required this.child,
    this.floating = false,
    this.pressable = false,
    super.key,
  });

  final GlassFinish finish;
  final Widget child;
  final bool floating;
  final bool pressable;

  static const LiquidRoundedSuperellipse _shape = LiquidRoundedSuperellipse(
    borderRadius: FujinRadius.pill,
  );

  static ButtonStyle style(
    FujinColors colors,
    GlassFinish finish, {
    bool floating = false,
  }) {
    final foreground = WidgetStateProperty.resolveWith(
      (states) => switch (states.contains(WidgetState.disabled)) {
        true => colors.buttonDisabledText,
        false => finish.foreground(colors),
      },
    );
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        colors.backgroundPage.withValues(alpha: 0),
      ),
      foregroundColor: foreground,
      iconColor: foreground,
      side: const WidgetStatePropertyAll(BorderSide.none),
      backgroundBuilder: (context, states, child) {
        final enabled = !states.contains(WidgetState.disabled);
        return GlassFill(
          finish: switch (enabled) {
            true => finish,
            false => GlassFinish.clear,
          },
          floating: floating,
          pressable: enabled,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final brightness = Theme.of(context).brightness;
    final reduced = FujinGlass.reduced(context, ref);
    final (from, changes) =
        useValueChanged<GlassFinish, (GlassFinish, int)>(
          finish,
          (old, last) => (
            old,
            switch (last) {
              null => 1,
              (_, final count) => count + 1,
            },
          ),
        ) ??
        (finish, 0);

    Widget painted(double progress) {
      final t = (progress - changes + 1).clamp(0, 1).toDouble();
      Color blend(Color Function(GlassFinish finish) of) =>
          Color.lerp(of(from), of(finish), t) ?? of(finish);
      final fill = blend((it) => it.fill(colors, brightness));
      return GlassBody.ownLayer(
        settings: FujinGlass.control(brightness),
        shape: _shape,
        reduced: reduced,
        opaque: Color.alphaBlend(fill, colors.backgroundCard),
        fill: fill,
        glow: switch (pressable) {
          true => GlassTouchGlow.overTint,
          false => GlassTouchGlow.none,
        },
        pressable: pressable && !reduced,
        shadow: switch (floating) {
          true => FujinTheme.floatingShadow(colors),
          false => null,
        },
        child: child,
      );
    }

    return SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.pill),
      value: changes.toDouble(),
      builder: (context, progress, _) => painted(progress),
    );
  }
}
