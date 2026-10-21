import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.fraction,
    required this.color,
    this.track,
    super.key,
  });

  final double fraction;
  final Color color;
  final Color? track;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(FujinSize.kcalBar / 2);
    return Container(
      height: FujinSize.kcalBar,
      decoration: BoxDecoration(
        color: track ?? context.colors.goalTrack,
        borderRadius: radius,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: SingleMotionBuilder(
        motion: FujinMotion.of(context, FujinMotion.progress),
        value: fraction.clamp(0, 1),
        builder: (context, value, child) => FractionallySizedBox(
          widthFactor: value.clamp(0, 1),
          heightFactor: 1,
          child: child,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, borderRadius: radius),
        ),
      ),
    );
  }
}
