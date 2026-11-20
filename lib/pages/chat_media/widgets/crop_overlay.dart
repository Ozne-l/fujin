import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:fujin/domain/chat/edit/crop_geometry.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';
import 'package:motor/motor.dart';

class CropOverlay extends HookWidget {
  const CropOverlay({
    required this.picture,
    required this.crop,
    required this.onDragged,
    this.quarterTurns = 0,
    super.key,
  });

  static const double _reach = 28;
  static const double _slack = 0.5;
  static const double edgeClearance = _reach / 2;

  final Rect picture;
  final Rect crop;
  final int quarterTurns;
  final void Function(CropHandle handle, Offset delta) onDragged;

  @override
  Widget build(BuildContext context) {
    final handle = useState<CropHandle?>(null);
    final previous = usePrevious((turns: quarterTurns, crop: crop));
    final limits = _limitsOf(crop, picture.size);
    final touched = useRef(limits);
    final held = handle.value != null;
    useEffect(() {
      if (held && limits & ~touched.value != 0) FujinHaptics.select();
      touched.value = limits;
      return null;
    }, [limits]);
    final colors = context.colors;
    final reduced = FujinMotion.reduced(context);
    return LayoutBuilder(
      builder: (context, constraints) => MotionBuilder<Rect>(
        key: ValueKey(quarterTurns),
        value: crop,
        from: switch (previous) {
          (:final turns, crop: final before) when turns != quarterTurns =>
            CropGeometry.turned(before, quarterTurns - turns),
          _ => null,
        },
        motion: FujinMotion.grow,
        converter: MotionConverter.rect,
        active: !held && !reduced,
        builder: (context, shownCrop, _) {
          final frame = Rect.fromLTRB(
            picture.left + shownCrop.left * picture.width,
            picture.top + shownCrop.top * picture.height,
            picture.left + shownCrop.right * picture.width,
            picture.top + shownCrop.bottom * picture.height,
          );
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) {
              touched.value = limits;
              handle.value = _handleAt(frame, details.localPosition);
            },
            onPanUpdate: (details) {
              if (handle.value case final dragged?) {
                onDragged(
                  dragged,
                  Offset(
                    details.delta.dx / picture.width,
                    details.delta.dy / picture.height,
                  ),
                );
              }
            },
            onPanEnd: (details) => handle.value = null,
            onPanCancel: () => handle.value = null,
            child: SingleMotionBuilder(
              value: switch (held) {
                true => 1,
                false => 0,
              },
              motion: switch (held) {
                true => const InstantMotion(),
                false => FujinMotion.of(context, FujinMotion.gridFade),
              },
              builder: (context, grid, _) => CustomPaint(
                size: constraints.biggest,
                painter: _CropPainter(
                  picture: picture,
                  frame: frame,
                  grid: grid,
                  line: colors.cameraText,
                  outside: colors.cameraBackground.withValues(
                    alpha: _CropPainter.outsideAlpha,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static int _limitsOf(Rect crop, Size picture) {
    final minimum = CropGeometry.minimumSide * picture.shortestSide + _slack;
    return [
      crop.left * picture.width <= _slack,
      crop.top * picture.height <= _slack,
      (1 - crop.right) * picture.width <= _slack,
      (1 - crop.bottom) * picture.height <= _slack,
      crop.width * picture.width <= minimum,
      crop.height * picture.height <= minimum,
    ].indexed.fold(
      0,
      (limits, contact) => switch (contact) {
        (final bit, true) => limits | 1 << bit,
        (_, false) => limits,
      },
    );
  }

  static CropHandle? _handleAt(Rect frame, Offset point) {
    final corner = CropHandle.values
        .where((handle) => handle.isCorner)
        .reduce(
          (nearest, candidate) => switch (_distance(frame, candidate, point) <
              _distance(frame, nearest, point)) {
            true => candidate,
            false => nearest,
          },
        );
    return switch (_edgeAt(frame, point)) {
      _ when _distance(frame, corner, point) <= _reach => corner,
      final edge? => edge,
      null when frame.contains(point) => CropHandle.inside,
      null => null,
    };
  }

  static double _distance(Rect frame, CropHandle handle, Offset point) =>
      (_anchor(frame, handle) - point).distance;

  static CropHandle? _edgeAt(Rect frame, Offset point) {
    final across = Rect.fromLTRB(
      frame.left + _reach,
      frame.top - _reach,
      frame.right - _reach,
      frame.bottom + _reach,
    );
    final along = Rect.fromLTRB(
      frame.left - _reach,
      frame.top + _reach,
      frame.right + _reach,
      frame.bottom - _reach,
    );
    return switch (point) {
      _ when across.contains(point) && (point.dy - frame.top).abs() <= _reach =>
        CropHandle.top,
      _
          when across.contains(point) &&
              (point.dy - frame.bottom).abs() <= _reach =>
        CropHandle.bottom,
      _ when along.contains(point) && (point.dx - frame.left).abs() <= _reach =>
        CropHandle.left,
      _
          when along.contains(point) &&
              (point.dx - frame.right).abs() <= _reach =>
        CropHandle.right,
      _ => null,
    };
  }

  static Offset _anchor(Rect frame, CropHandle handle) => Offset(
    frame.center.dx + handle.horizontal * frame.width / 2,
    frame.center.dy + handle.vertical * frame.height / 2,
  );
}

class _CropPainter extends CustomPainter {
  const _CropPainter({
    required this.picture,
    required this.frame,
    required this.grid,
    required this.line,
    required this.outside,
  });

  static const double outsideAlpha = 0.6;
  static const double _gridAlpha = 0.45;
  static const List<double> _thirds = [1 / 3, 2 / 3];

  final Rect picture;
  final Rect frame;
  final double grid;
  final Color line;
  final Color outside;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(picture),
          Path()..addRect(frame),
        ),
        Paint()..color = outside,
      )
      ..drawRect(
        frame.deflate(FujinStroke.card / 2),
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = FujinStroke.card,
      );
    if (grid > 0) {
      final gridPaint = Paint()
        ..color = line.withValues(alpha: _gridAlpha * grid)
        ..strokeWidth = FujinStroke.card;
      for (final third in _thirds) {
        final x = frame.left + frame.width * third;
        final y = frame.top + frame.height * third;
        canvas
          ..drawLine(Offset(x, frame.top), Offset(x, frame.bottom), gridPaint)
          ..drawLine(Offset(frame.left, y), Offset(frame.right, y), gridPaint);
      }
    }
    final mark = Paint()..color = line;
    final outer = frame.inflate(FujinStroke.cropMark);
    for (final rect in [
      Rect.fromLTWH(
        outer.left,
        outer.top,
        FujinSize.cropCorner,
        FujinStroke.cropMark,
      ),
      Rect.fromLTWH(
        outer.left,
        outer.top,
        FujinStroke.cropMark,
        FujinSize.cropCorner,
      ),
      Rect.fromLTWH(
        outer.right - FujinSize.cropCorner,
        outer.top,
        FujinSize.cropCorner,
        FujinStroke.cropMark,
      ),
      Rect.fromLTWH(
        outer.right - FujinStroke.cropMark,
        outer.top,
        FujinStroke.cropMark,
        FujinSize.cropCorner,
      ),
      Rect.fromLTWH(
        outer.left,
        outer.bottom - FujinStroke.cropMark,
        FujinSize.cropCorner,
        FujinStroke.cropMark,
      ),
      Rect.fromLTWH(
        outer.left,
        outer.bottom - FujinSize.cropCorner,
        FujinStroke.cropMark,
        FujinSize.cropCorner,
      ),
      Rect.fromLTWH(
        outer.right - FujinSize.cropCorner,
        outer.bottom - FujinStroke.cropMark,
        FujinSize.cropCorner,
        FujinStroke.cropMark,
      ),
      Rect.fromLTWH(
        outer.right - FujinStroke.cropMark,
        outer.bottom - FujinSize.cropCorner,
        FujinStroke.cropMark,
        FujinSize.cropCorner,
      ),
      Rect.fromCenter(
        center: Offset(frame.center.dx, outer.top + FujinStroke.cropMark / 2),
        width: FujinSize.cropTick,
        height: FujinStroke.cropMark,
      ),
      Rect.fromCenter(
        center: Offset(
          frame.center.dx,
          outer.bottom - FujinStroke.cropMark / 2,
        ),
        width: FujinSize.cropTick,
        height: FujinStroke.cropMark,
      ),
      Rect.fromCenter(
        center: Offset(outer.left + FujinStroke.cropMark / 2, frame.center.dy),
        width: FujinStroke.cropMark,
        height: FujinSize.cropTick,
      ),
      Rect.fromCenter(
        center: Offset(outer.right - FujinStroke.cropMark / 2, frame.center.dy),
        width: FujinStroke.cropMark,
        height: FujinSize.cropTick,
      ),
    ]) {
      canvas.drawRect(rect, mark);
    }
  }

  @override
  bool shouldRepaint(_CropPainter oldDelegate) =>
      oldDelegate.picture != picture ||
      oldDelegate.frame != frame ||
      oldDelegate.grid != grid ||
      oldDelegate.line != line ||
      oldDelegate.outside != outside;
}
