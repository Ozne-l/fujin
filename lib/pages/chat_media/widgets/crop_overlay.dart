import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';

class CropOverlay extends HookWidget {
  const CropOverlay({
    required this.picture,
    required this.crop,
    required this.onDragged,
    super.key,
  });

  static const double _reach = 28;
  static const double edgeClearance = _reach / 2;

  final Rect picture;
  final Rect crop;
  final void Function(CropHandle handle, Offset delta) onDragged;

  @override
  Widget build(BuildContext context) {
    final handle = useState<CropHandle?>(null);
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final frame = Rect.fromLTRB(
          picture.left + crop.left * picture.width,
          picture.top + crop.top * picture.height,
          picture.left + crop.right * picture.width,
          picture.top + crop.bottom * picture.height,
        );
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) =>
              handle.value = _handleAt(frame, details.localPosition),
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
          child: CustomPaint(
            size: constraints.biggest,
            painter: _CropPainter(
              picture: picture,
              frame: frame,
              grid: handle.value != null,
              line: colors.cameraText,
              outside: colors.cameraBackground.withValues(
                alpha: _CropPainter.outsideAlpha,
              ),
            ),
          ),
        );
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
  static const double _border = 1;
  static const double _gridLine = 1;
  static const double _mark = 3;
  static const double _cornerLength = 24;
  static const double _tickLength = 24;
  static const List<double> _thirds = [1 / 3, 2 / 3];

  final Rect picture;
  final Rect frame;
  final bool grid;
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
        frame.deflate(_border / 2),
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = _border,
      );
    if (grid) {
      final gridPaint = Paint()
        ..color = line.withValues(alpha: _gridAlpha)
        ..strokeWidth = _gridLine;
      for (final third in _thirds) {
        final x = frame.left + frame.width * third;
        final y = frame.top + frame.height * third;
        canvas
          ..drawLine(Offset(x, frame.top), Offset(x, frame.bottom), gridPaint)
          ..drawLine(Offset(frame.left, y), Offset(frame.right, y), gridPaint);
      }
    }
    final mark = Paint()..color = line;
    final outer = frame.inflate(_mark);
    for (final rect in [
      Rect.fromLTWH(outer.left, outer.top, _cornerLength, _mark),
      Rect.fromLTWH(outer.left, outer.top, _mark, _cornerLength),
      Rect.fromLTWH(
        outer.right - _cornerLength,
        outer.top,
        _cornerLength,
        _mark,
      ),
      Rect.fromLTWH(outer.right - _mark, outer.top, _mark, _cornerLength),
      Rect.fromLTWH(outer.left, outer.bottom - _mark, _cornerLength, _mark),
      Rect.fromLTWH(
        outer.left,
        outer.bottom - _cornerLength,
        _mark,
        _cornerLength,
      ),
      Rect.fromLTWH(
        outer.right - _cornerLength,
        outer.bottom - _mark,
        _cornerLength,
        _mark,
      ),
      Rect.fromLTWH(
        outer.right - _mark,
        outer.bottom - _cornerLength,
        _mark,
        _cornerLength,
      ),
      Rect.fromCenter(
        center: Offset(frame.center.dx, outer.top + _mark / 2),
        width: _tickLength,
        height: _mark,
      ),
      Rect.fromCenter(
        center: Offset(frame.center.dx, outer.bottom - _mark / 2),
        width: _tickLength,
        height: _mark,
      ),
      Rect.fromCenter(
        center: Offset(outer.left + _mark / 2, frame.center.dy),
        width: _mark,
        height: _tickLength,
      ),
      Rect.fromCenter(
        center: Offset(outer.right - _mark / 2, frame.center.dy),
        width: _mark,
        height: _tickLength,
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
