import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:motor/motor.dart';

class RollingNumber extends StatelessWidget {
  const RollingNumber({required this.value, required this.builder, super.key});

  static const _figures = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
  );

  final double value;
  final Widget Function(BuildContext context, double value) builder;

  @override
  Widget build(BuildContext context) => DefaultTextStyle.merge(
    style: _figures,
    child: SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.spatialSlow),
      value: value,
      builder: (context, shown, _) => builder(context, shown),
    ),
  );
}
