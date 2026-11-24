import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:motor/motor.dart';

class AimFrame extends StatelessWidget {
  const AimFrame({
    required this.hint,
    required this.read,
    required this.busy,
    this.code,
    super.key,
  });

  static const double _snapMargin = FujinSpace.s2;
  static const double _smallest = FujinSize.aimCorner * 2;

  final String hint;
  final bool read;
  final bool busy;
  final Rect? code;

  static Rect closingOn(Rect frame, {required Rect? code}) => switch (code) {
    final code? => Rect.fromCenter(
      center: code.center,
      width: math.max(code.width + _snapMargin * 2, _smallest),
      height: math.max(code.height + _snapMargin * 2, _smallest),
    ),
    null => Rect.fromCenter(
      center: frame.center,
      width: FujinSize.aimCodeWidth,
      height: FujinSize.aimCodeHeight,
    ),
  };

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final colors = context.colors;
      final frame = Rect.fromLTWH(
        (constraints.maxWidth - FujinSize.aimFrameWidth) / 2,
        MediaQuery.paddingOf(context).top + FujinSize.aimFrameTop,
        FujinSize.aimFrameWidth,
        FujinSize.aimFrameHeight,
      );
      return Stack(
        children: [
          Positioned.fill(
            child: MotionBuilder<Rect>(
              motion: FujinMotion.of(context, switch (read) {
                true => FujinMotion.emphasis,
                false => FujinMotion.spatial,
              }),
              converter: MotionConverter.rect,
              value: switch (read) {
                true => closingOn(frame, code: code),
                false => frame,
              },
              builder: (context, corners, _) => CustomPaint(
                painter: _AimPainter(
                  frame: corners,
                  read: read,
                  colors: colors,
                ),
              ),
            ),
          ),
          if (!read)
            Positioned.fill(
              child: RepaintBoundary(
                child: SequenceMotionBuilder<int, double>(
                  sequence: FujinMotion.aimSweep,
                  converter: MotionConverter.single,
                  builder: (context, sweep, _, _) => CustomPaint(
                    painter: _SweepPainter(
                      frame: frame,
                      sweep: sweep,
                      colors: colors,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: frame.bottom + FujinSpace.s6,
            left: FujinSize.screenMargin,
            right: FujinSize.screenMargin,
            child: Column(
              spacing: FujinSpace.s4,
              children: [
                Text(
                  hint,
                  textAlign: TextAlign.center,
                  style: FujinText.inter15Medium.copyWith(
                    color: colors.cameraText,
                  ),
                ),
                if (busy) const FujinSpinner.camera(),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class _AimPainter extends CustomPainter {
  const _AimPainter({
    required this.frame,
    required this.read,
    required this.colors,
  });

  final Rect frame;
  final bool read;
  final FujinColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRRect(
          RRect.fromRectAndRadius(
            frame,
            const Radius.circular(FujinRadius.aimFrame),
          ),
        ),
      ),
      Paint()..color = colors.backgroundScrim,
    );
    final corner = Paint()
      ..color = switch (read) {
        true => colors.cameraAccent,
        false => colors.cameraText,
      };
    final outer = frame.inflate(FujinStroke.aimCorner / 2);
    const arm = FujinSize.aimCorner;
    const stroke = FujinStroke.aimCorner;
    for (final rect in [
      Rect.fromLTWH(outer.left, outer.top, arm, stroke),
      Rect.fromLTWH(outer.left, outer.top, stroke, arm),
      Rect.fromLTWH(outer.right - arm, outer.top, arm, stroke),
      Rect.fromLTWH(outer.right - stroke, outer.top, stroke, arm),
      Rect.fromLTWH(outer.left, outer.bottom - stroke, arm, stroke),
      Rect.fromLTWH(outer.left, outer.bottom - arm, stroke, arm),
      Rect.fromLTWH(outer.right - arm, outer.bottom - stroke, arm, stroke),
      Rect.fromLTWH(outer.right - stroke, outer.bottom - arm, stroke, arm),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(FujinRadius.bar)),
        corner,
      );
    }
  }

  @override
  bool shouldRepaint(_AimPainter oldDelegate) =>
      frame != oldDelegate.frame ||
      read != oldDelegate.read ||
      colors != oldDelegate.colors;
}

class _SweepPainter extends CustomPainter {
  const _SweepPainter({
    required this.frame,
    required this.sweep,
    required this.colors,
  });

  static const List<double> _fadeStops = [0, 0.2, 0.8, 1];

  final Rect frame;
  final double sweep;
  final FujinColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final lane = frame.deflate(FujinSpace.s4);
    final line = Rect.fromCenter(
      center: Offset(lane.center.dx, lane.top + lane.height * sweep),
      width: lane.width,
      height: FujinStroke.readLine,
    );
    final clear = colors.cameraAccent.withValues(alpha: 0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        line,
        const Radius.circular(FujinStroke.readLine / 2),
      ),
      Paint()
        ..shader = LinearGradient(
          colors: [clear, colors.cameraAccent, colors.cameraAccent, clear],
          stops: _fadeStops,
        ).createShader(line),
    );
  }

  @override
  bool shouldRepaint(_SweepPainter oldDelegate) =>
      frame != oldDelegate.frame ||
      sweep != oldDelegate.sweep ||
      colors != oldDelegate.colors;
}
