import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';

class AimFrame extends StatelessWidget {
  const AimFrame({
    required this.hint,
    required this.read,
    required this.busy,
    super.key,
  });

  final String hint;
  final bool read;
  final bool busy;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final frame = Rect.fromLTWH(
        (constraints.maxWidth - FujinSize.aimFrameWidth) / 2,
        MediaQuery.paddingOf(context).top + FujinSize.aimFrameTop,
        FujinSize.aimFrameWidth,
        FujinSize.aimFrameHeight,
      );
      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _AimPainter(
                frame: frame,
                read: read,
                colors: context.colors,
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
                    color: context.colors.cameraText,
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
    if (!read) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: frame.center,
            width: frame.width - FujinSpace.s4 * 2,
            height: FujinStroke.readLine,
          ),
          const Radius.circular(FujinStroke.readLine / 2),
        ),
        Paint()..color = colors.cameraAccent,
      );
    }
  }

  @override
  bool shouldRepaint(_AimPainter oldDelegate) =>
      frame != oldDelegate.frame ||
      read != oldDelegate.read ||
      colors != oldDelegate.colors;
}
