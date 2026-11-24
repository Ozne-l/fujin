import 'dart:math' as math;
import 'dart:ui';

abstract final class CodeBounds {
  static Rect? of({
    required List<Offset> corners,
    required Size image,
    required Size view,
  }) {
    if (corners.isEmpty || image.isEmpty || view.isEmpty) return null;
    final scale = math.max(
      view.width / image.width,
      view.height / image.height,
    );
    final crop = Offset(
      (image.width * scale - view.width) / 2,
      (image.height * scale - view.height) / 2,
    );
    final points = [for (final corner in corners) corner * scale - crop];
    return Rect.fromLTRB(
      points.map((point) => point.dx).reduce(math.min),
      points.map((point) => point.dy).reduce(math.min),
      points.map((point) => point.dx).reduce(math.max),
      points.map((point) => point.dy).reduce(math.max),
    );
  }
}
