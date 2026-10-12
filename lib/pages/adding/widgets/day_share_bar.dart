import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class DayShareBar extends StatelessWidget {
  const DayShareBar({
    required this.before,
    required this.added,
    required this.exceeded,
    this.thin = false,
    super.key,
  });

  final double before;
  final double added;
  final bool exceeded;
  final bool thin;

  @override
  Widget build(BuildContext context) {
    final height = switch (thin) {
      true => FujinSize.macroBar,
      false => FujinSize.kcalBar,
    };
    final radius = BorderRadius.circular(height / 2);
    final (soFar, adding) = switch (exceeded) {
      true => (
        FujinColorRole.goalExceededBackground,
        FujinColorRole.goalExceeded,
      ),
      false => (FujinColorRole.goalMinimumLeft, FujinColorRole.goalInProgress),
    };
    Widget segment(double share, Color color) => SingleMotionBuilder(
      motion: FujinMotion.progress,
      value: share.clamp(0, 1),
      builder: (context, value, child) => FractionallySizedBox(
        widthFactor: value,
        heightFactor: 1,
        child: child,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, borderRadius: radius),
      ),
    );
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: FujinColorRole.goalTrack,
        borderRadius: radius,
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [segment(before + added, adding), segment(before, soFar)],
      ),
    );
  }
}
