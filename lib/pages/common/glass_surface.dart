import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({required this.child, super.key});

  final Widget child;

  static const double _radius = FujinSize.tabBar / 2;
  static const double _stillScale = 1;
  static const double _stillStretch = 0;

  @override
  Widget build(BuildContext context) {
    final reduced = FujinMotion.reduced(context);
    return CustomPaint(
      painter: const _OuterShadowPainter(),
      child: LiquidStretch(
        interactionScale: switch (reduced) {
          true => _stillScale,
          false => FujinMotion.glassPress,
        },
        stretch: switch (reduced) {
          true => _stillStretch,
          false => FujinMotion.glassStretch,
        },
        child: LiquidGlass.grouped(
          shape: const LiquidRoundedSuperellipse(borderRadius: _radius),
          child: GlassGlow(
            glowColor: FujinColorRole.backgroundGlass,
            child: SizedBox(height: FujinSize.tabBar, child: child),
          ),
        ),
      ),
    );
  }
}

class _OuterShadowPainter extends CustomPainter {
  const _OuterShadowPainter();

  static const _radius = BorderRadius.all(
    Radius.circular(GlassSurface._radius),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final shape = _radius.toRSuperellipse(Offset.zero & size);
    const shadow = FujinTheme.floatingShadow;
    final reach = shadow.blurRadius + shadow.offset.distance;
    canvas
      ..save()
      ..clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(shape.outerRect.inflate(reach)),
          Path()..addRSuperellipse(shape),
        ),
      )
      ..drawRSuperellipse(shape.shift(shadow.offset), shadow.toPaint())
      ..restore();
  }

  @override
  bool shouldRepaint(_OuterShadowPainter oldDelegate) => false;
}
