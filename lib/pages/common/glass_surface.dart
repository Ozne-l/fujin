import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({required this.child, super.key});

  final Widget child;

  static const _radius = BorderRadius.all(
    Radius.circular(FujinSize.tabBar / 2),
  );

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const _OuterShadowPainter(_radius),
    child: ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: FujinSize.glassBlur,
          sigmaY: FujinSize.glassBlur,
        ),
        child: ColoredBox(
          color: FujinColorRole.backgroundGlass,
          child: SizedBox(height: FujinSize.tabBar, child: child),
        ),
      ),
    ),
  );
}

class _OuterShadowPainter extends CustomPainter {
  const _OuterShadowPainter(this.radius);

  final BorderRadius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = radius.toRRect(Offset.zero & size);
    const shadow = FujinTheme.floatingShadow;
    final reach = shadow.blurRadius + shadow.offset.distance;
    canvas
      ..save()
      ..clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(shape.outerRect.inflate(reach)),
          Path()..addRRect(shape),
        ),
      )
      ..drawRRect(shape.shift(shadow.offset), shadow.toPaint())
      ..restore();
  }

  @override
  bool shouldRepaint(_OuterShadowPainter oldDelegate) =>
      radius != oldDelegate.radius;
}
