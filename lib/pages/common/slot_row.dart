import 'dart:ui';

import 'package:fujin/app/theme/fujin_motion.dart';

final class SlotRow {
  SlotRow({
    required double width,
    required this.count,
    required this.inset,
    this.gap = 0,
  }) : slot = (width - inset * 2 - gap * (count - 1)) / count;

  static const double _resistance = 0.4;
  static const double _overdrag = 0.15;

  final int count;
  final double inset;
  final double gap;
  final double slot;

  double get _pitch => slot + gap;

  double get _last => (count - 1).toDouble();

  double at(double dx) {
    final raw = (dx - inset - slot / 2) / _pitch;
    return switch (raw) {
      < 0 => -(-raw * _resistance).clamp(0, _overdrag).toDouble(),
      final beyond when beyond > _last =>
        _last + ((beyond - _last) * _resistance).clamp(0, _overdrag).toDouble(),
      final within => within,
    };
  }

  int landing(double position, double velocity) =>
      (position + velocity / _pitch * FujinMotion.lensFling).round().clamp(
        0,
        count - 1,
      );

  double offset(double position) => position * _pitch;

  Rect rect(double position, {required double top, required double height}) =>
      Rect.fromLTWH(inset + offset(position), top, slot, height);
}
