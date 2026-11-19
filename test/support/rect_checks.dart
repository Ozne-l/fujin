import 'dart:ui';

import 'package:checks/context.dart';

extension RectChecks on Subject<Rect> {
  static const _tolerance = 1e-6;

  void isNear(Rect expected) => context.expect(
    () => ['is near ${literal(expected)}'],
    (actual) => switch ([
      actual.left - expected.left,
      actual.top - expected.top,
      actual.right - expected.right,
      actual.bottom - expected.bottom,
    ].every((difference) => difference.abs() <= _tolerance)) {
      true => null,
      false => Rejection(),
    },
  );
}
