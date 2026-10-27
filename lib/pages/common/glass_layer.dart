import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassLayer extends ConsumerWidget {
  const GlassLayer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (FujinGlass.reduced(context, ref)) {
        true => child,
        false => LiquidGlassLayer(
          settings: FujinGlass.floating(Theme.of(context).brightness),
          defaultAppearance: FujinGlass.appearance(
            Theme.of(context).brightness,
          ),
          child: LiquidGlassBlendGroup(blend: FujinGlass.blend, child: child),
        ),
      };
}
