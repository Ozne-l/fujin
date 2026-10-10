import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.size,
    required this.stroke,
    required this.child,
    this.fill,
    this.track,
    this.arc,
    this.progress = 0,
    this.dashed = false,
    super.key,
  });

  final double size;
  final double stroke;
  final Widget child;
  final Color? fill;
  final Color? track;
  final Color? arc;
  final double progress;
  final bool dashed;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: SingleMotionBuilder(
      motion: FujinMotion.progress,
      value: progress.clamp(0, 1),
      builder: (context, value, child) => CustomPaint(
        painter: _RingPainter(
          stroke: stroke,
          fill: fill,
          track: track,
          arc: arc,
          progress: value,
          dashed: dashed,
        ),
        child: child,
      ),
      child: Center(child: child),
    ),
  );
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.stroke,
    required this.fill,
    required this.track,
    required this.arc,
    required this.progress,
    required this.dashed,
  });

  static const double _start = -pi / 2;
  static const double _turn = 2 * pi;

  final double stroke;
  final Color? fill;
  final Color? track;
  final Color? arc;
  final double progress;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2;
    final radius = outer - stroke / 2;
    if (fill case final fill?) {
      canvas.drawCircle(center, outer, Paint()..color = fill);
    }
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    if (track case final track?) {
      switch (dashed) {
        case true:
          _dashes(canvas, center, radius, line..color = track);
        case false:
          canvas.drawCircle(center, radius, line..color = track);
      }
    }
    if ((arc, progress) case (final arc?, > 0)) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _start,
        _turn * progress,
        false,
        line
          ..color = arc
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _dashes(Canvas canvas, Offset center, double radius, Paint paint) {
    const period = FujinSize.macroRingDash + FujinSize.macroRingDashGap;
    final count = (_turn * radius / period).floor();
    final step = _turn / count;
    final sweep = step * FujinSize.macroRingDash / period;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    for (var index = 0; index < count; index++) {
      canvas.drawArc(bounds, _start + step * index, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.stroke != stroke ||
      old.fill != fill ||
      old.track != track ||
      old.arc != arc ||
      old.progress != progress ||
      old.dashed != dashed;
}
