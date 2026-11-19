import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';

final class RectHook extends MappingHook {
  const RectHook();

  static const _left = 'left';
  static const _top = 'top';
  static const _right = 'right';
  static const _bottom = 'bottom';

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    {
      _left: final num left,
      _top: final num top,
      _right: final num right,
      _bottom: final num bottom,
    } =>
      Rect.fromLTRB(
        left.toDouble(),
        top.toDouble(),
        right.toDouble(),
        bottom.toDouble(),
      ),
    _ => value,
  };

  @override
  Object? beforeEncode(Object? value) => switch (value) {
    final Rect rect => {
      _left: rect.left,
      _top: rect.top,
      _right: rect.right,
      _bottom: rect.bottom,
    },
    _ => value,
  };
}
