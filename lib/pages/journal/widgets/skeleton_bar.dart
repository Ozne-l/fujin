import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class SkeletonBar extends StatelessWidget {
  const SkeletonBar({required this.height, this.width, super.key});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colour = context.colors.goalTrack;
    final radius = BorderRadius.circular(height / 2);
    return SequenceMotionBuilder<int, double>(
      sequence: FujinMotion.driftCycle,
      converter: MotionConverter.single,
      builder: (context, drift, _, _) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colour.withValues(
            alpha: colour.a * FujinMotion.skeletonBreath(drift),
          ),
          borderRadius: radius,
        ),
      ),
    );
  }
}
