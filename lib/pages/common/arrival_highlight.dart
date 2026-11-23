import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class ArrivalHighlight extends StatelessWidget {
  const ArrivalHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    final colour = context.colors.backgroundHighlight;
    return SingleMotionBuilder(
      motion: FujinMotion.effectsSlow,
      from: 1,
      value: 0,
      builder: (context, glow, _) => ColoredBox(
        color: colour.withValues(alpha: colour.a * glow.clamp(0.0, 1.0)),
      ),
    );
  }
}
