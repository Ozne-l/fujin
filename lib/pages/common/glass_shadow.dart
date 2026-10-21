import 'package:flutter/widgets.dart';

class GlassShadow extends StatelessWidget {
  const GlassShadow({
    required this.shape,
    required this.shadow,
    required this.child,
    super.key,
  });

  final OutlinedBorder shape;
  final BoxShadow shadow;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _OuterShadowPainter(shadow: shadow, shape: shape),
    child: child,
  );
}

class _OuterShadowPainter extends CustomPainter {
  const _OuterShadowPainter({required this.shadow, required this.shape});

  final BoxShadow shadow;
  final OutlinedBorder shape;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final outline = shape.getOuterPath(bounds);
    final reach = shadow.blurRadius + shadow.offset.distance;
    canvas
      ..save()
      ..clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(bounds.inflate(reach)),
          outline,
        ),
      )
      ..drawPath(outline.shift(shadow.offset), shadow.toPaint())
      ..restore();
  }

  @override
  bool shouldRepaint(_OuterShadowPainter oldDelegate) =>
      oldDelegate.shadow != shadow || oldDelegate.shape != shape;
}
