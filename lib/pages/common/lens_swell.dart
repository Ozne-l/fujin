import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';

class LensSwell extends ConsumerWidget {
  const LensSwell({
    required this.held,
    required this.position,
    required this.target,
    required this.builder,
    super.key,
  });

  final bool held;
  final double position;
  final double? target;
  final Widget Function(BuildContext context, double swell) builder;

  static const double _swollen = 1;
  static const double _flat = 0;

  static bool showing(double swell) => swell > _flat;

  static double underneath(double swell) =>
      (1 - swell / FujinMotion.lensFade).clamp(0, 1).toDouble();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final up =
        !FujinGlass.reduced(context, ref) &&
        (held ||
            switch (target) {
              final to? => (position - to).abs() > FujinMotion.lensTravel,
              null => false,
            });
    return SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.lensSwell),
      value: switch (up) {
        true => _swollen,
        false => _flat,
      },
      builder: (context, swell, _) => builder(context, swell),
    );
  }
}
