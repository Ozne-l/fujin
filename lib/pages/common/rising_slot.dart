import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/pages/common/bottom_switcher.dart';

class RisingSlot extends StatelessWidget {
  const RisingSlot({required this.child, super.key});

  static const Offset _rise = Offset(0, 0.25);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final reduced = FujinMotion.reduced(context);
    final motion = switch (reduced) {
      true => FujinMotion.effectsFast,
      false => FujinMotion.spatialFast,
    };
    return AnimatedSwitcher(
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
  }
}
