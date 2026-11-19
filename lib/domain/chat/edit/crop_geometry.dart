import 'dart:math' as math;
import 'dart:ui';

import 'package:fujin/domain/chat/edit/crop_handle.dart';

abstract final class CropGeometry {
  static const Rect whole = Rect.fromLTRB(0, 0, 1, 1);
  static const double minimumSide = 1 / 8;
  static const _tolerance = 1e-3;
  static const _turns = 4;

  static Rect? normalized(Rect crop) => switch (_clamped(crop)) {
    Rect(:final left, :final top, :final right, :final bottom)
        when left <= _tolerance &&
            top <= _tolerance &&
            right >= 1 - _tolerance &&
            bottom >= 1 - _tolerance =>
      null,
    final clamped => clamped,
  };

  static Rect fitted(double ratio, Size picture) {
    final (width, height) = switch (ratio > picture.width / picture.height) {
      true => (picture.width, picture.width / ratio),
      false => (picture.height * ratio, picture.height),
    };
    return _fractions(
      Rect.fromCenter(
        center: picture.center(Offset.zero),
        width: width,
        height: height,
      ),
      picture,
    );
  }

  static Rect turned(Rect rect, int quarterTurns) {
    var turned = rect;
    for (var turn = 0; turn < quarterTurns % _turns; turn++) {
      turned = Rect.fromLTRB(
        1 - turned.bottom,
        turned.left,
        1 - turned.top,
        turned.right,
      );
    }
    return turned;
  }

  static Rect unturned(Rect rect, int quarterTurns) =>
      turned(rect, _turns - quarterTurns % _turns);

  static Rect dragged(
    Rect crop,
    CropHandle handle,
    Offset delta, {
    required Size picture,
    double? ratio,
  }) {
    final clamped = _clamped(crop);
    final rect = Rect.fromLTRB(
      clamped.left * picture.width,
      clamped.top * picture.height,
      clamped.right * picture.width,
      clamped.bottom * picture.height,
    );
    final shift = Offset(delta.dx * picture.width, delta.dy * picture.height);
    final minimum = minimumSide * picture.shortestSide;
    final next = switch ((handle, ratio)) {
      (CropHandle.inside, _) => _moved(rect, shift, picture),
      (_, null) => _resized(rect, handle, shift, picture, minimum),
      (_, final ratio?) => _scaled(
        rect,
        handle,
        shift,
        picture,
        minimum,
        ratio,
      ),
    };
    return _fractions(next, picture);
  }

  static Rect _moved(Rect rect, Offset shift, Size picture) => rect.shift(
    Offset(
      _clamp(shift.dx, -rect.left, picture.width - rect.right),
      _clamp(shift.dy, -rect.top, picture.height - rect.bottom),
    ),
  );

  static Rect _resized(
    Rect rect,
    CropHandle handle,
    Offset shift,
    Size picture,
    double minimum,
  ) => Rect.fromLTRB(
    switch (handle.horizontal) {
      -1 => _clamp(rect.left + shift.dx, 0, rect.right - minimum),
      _ => rect.left,
    },
    switch (handle.vertical) {
      -1 => _clamp(rect.top + shift.dy, 0, rect.bottom - minimum),
      _ => rect.top,
    },
    switch (handle.horizontal) {
      1 => _clamp(rect.right + shift.dx, rect.left + minimum, picture.width),
      _ => rect.right,
    },
    switch (handle.vertical) {
      1 => _clamp(rect.bottom + shift.dy, rect.top + minimum, picture.height),
      _ => rect.bottom,
    },
  );

  static Rect _scaled(
    Rect rect,
    CropHandle handle,
    Offset shift,
    Size picture,
    double minimum,
    double ratio,
  ) {
    final availableWidth = switch (handle.horizontal) {
      1 => picture.width - rect.left,
      -1 => rect.right,
      _ => math.min(rect.center.dx, picture.width - rect.center.dx) * 2,
    };
    final availableHeight = switch (handle.vertical) {
      1 => picture.height - rect.top,
      -1 => rect.bottom,
      _ => math.min(rect.center.dy, picture.height - rect.center.dy) * 2,
    };
    final proposedWidth = rect.width + handle.horizontal * shift.dx;
    final proposedHeight = rect.height + handle.vertical * shift.dy;
    final wanted = switch ((handle.horizontal, handle.vertical)) {
      (0, _) => proposedHeight * ratio,
      (_, 0) => proposedWidth,
      _
          when (proposedWidth - rect.width).abs() >=
              (proposedHeight * ratio - rect.width).abs() =>
        proposedWidth,
      _ => proposedHeight * ratio,
    };
    final largest = math.min(availableWidth, availableHeight * ratio);
    final smallest = math.min(math.max(minimum, minimum * ratio), largest);
    final width = _clamp(wanted, smallest, largest);
    final height = width / ratio;
    final left = switch (handle.horizontal) {
      1 => rect.left,
      -1 => rect.right - width,
      _ => rect.center.dx - width / 2,
    };
    final top = switch (handle.vertical) {
      1 => rect.top,
      -1 => rect.bottom - height,
      _ => rect.center.dy - height / 2,
    };
    return Rect.fromLTWH(left, top, width, height);
  }

  static Rect _fractions(Rect rect, Size picture) => _clamped(
    Rect.fromLTRB(
      rect.left / picture.width,
      rect.top / picture.height,
      rect.right / picture.width,
      rect.bottom / picture.height,
    ),
  );

  static Rect _clamped(Rect rect) => Rect.fromLTRB(
    _clamp(rect.left, 0, 1),
    _clamp(rect.top, 0, 1),
    _clamp(rect.right, 0, 1),
    _clamp(rect.bottom, 0, 1),
  );

  static double _clamp(double value, double lowest, double highest) =>
      math.min(math.max(value, lowest), highest);
}
