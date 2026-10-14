import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';

class FadeThrough extends StatelessWidget {
  const FadeThrough({
    required this.child,
    this.scale = FujinMotion.fadeThroughScale,
    super.key,
  });

  final Widget child;
  final double scale;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: switch (FujinMotion.reduced(context)) {
      true => Duration.zero,
      false => FujinMotion.fadeThrough.duration,
    },
    switchInCurve: FujinMotion.fadeThrough.curve,
    switchOutCurve: FujinMotion.fadeThrough.curve,
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: scale,
          end: 1,
        ).animate(animation),
        child: child,
      ),
    ),
    layoutBuilder: (current, previous) => Stack(
      fit: StackFit.passthrough,
      children: [...previous, ?current],
    ),
    child: child,
  );
}
