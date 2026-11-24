import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/pages/common/bottom_switcher.dart';
import 'package:motor/motor.dart';

class RisingSlot extends StatelessWidget {
  const RisingSlot({required this.child, this.appear = false, super.key});

  static const Offset _rise = Offset(0, 0.25);

  final Widget? child;
  final bool appear;

  @override
  Widget build(BuildContext context) {
    final reduced = FujinMotion.reduced(context);
    final motion = switch (reduced) {
      true => FujinMotion.effectsFast,
      false => FujinMotion.spatialFast,
    };
    final switcher = AnimatedSwitcher(
      duration: motion.duration,
      switchInCurve: motion.curve,
      switchOutCurve: motion.curve,
      layoutBuilder: BottomSwitcher.layout,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: switch (reduced) {
          true => child,
          false => SlideTransition(
            position: Tween(begin: _rise, end: Offset.zero).animate(animation),
            child: child,
          ),
        },
      ),
      child: switch (child) {
        final child? => KeyedSubtree(key: const ValueKey(true), child: child),
        null => const SizedBox.shrink(key: ValueKey(false)),
      },
    );
    return switch (appear) {
      false => switcher,
      true => SingleMotionBuilder(
        motion: motion,
        from: 0,
        value: 1,
        builder: (context, shown, child) => Opacity(
          opacity: shown.clamp(0, 1),
          child: switch (reduced) {
            true => child,
            false => FractionalTranslation(
              translation: _rise * (1 - shown),
              child: child,
            ),
          },
        ),
        child: switcher,
      ),
    };
  }
}
