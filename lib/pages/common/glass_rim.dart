import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class GlassRim extends StatelessWidget {
  const GlassRim({
    required this.shape,
    required this.highlight,
    required this.shade,
    required this.child,
    this.width = FujinStroke.card,
    super.key,
  });

  final OutlinedBorder shape;
  final Color highlight;
  final Color shade;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _RimPainter(
      shape: shape,
      highlight: highlight,
      shade: shade,
      width: width,
    ),
    child: child,
  );
}

class _RimPainter extends CustomPainter {
  const _RimPainter({
    required this.shape,
    required this.highlight,
    required this.shade,
    required this.width,
  });

  final OutlinedBorder shape;
  final Color highlight;
  final Color shade;
  final double width;

  static const _start = Alignment(-0.5, -0.5);
  static const _end = Alignment(0.5, 0.5);

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawPath(
      shape.getOuterPath(bounds.deflate(width / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..shader = LinearGradient(
          begin: _start,
          end: _end,
          colors: [highlight, shade, highlight],
        ).createShader(bounds),
    );
  }

  @override
  bool shouldRepaint(_RimPainter oldDelegate) =>
      oldDelegate.shape != shape ||
      oldDelegate.highlight != highlight ||
      oldDelegate.shade != shade ||
      oldDelegate.width != width;
}
