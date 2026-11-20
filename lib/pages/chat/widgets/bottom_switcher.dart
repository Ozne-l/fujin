import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';

class BottomSwitcher extends StatelessWidget {
  const BottomSwitcher({required this.child, super.key});

  final Widget child;

  static Widget layout(Widget? current, List<Widget> previous) => Stack(
    alignment: Alignment.bottomCenter,
    clipBehavior: Clip.none,
    children: [
      for (final child in previous)
        Positioned(left: 0, right: 0, bottom: 0, child: child),
      ?current,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final switcher = AnimatedSwitcher(
      duration: FujinMotion.dissolve.duration,
      switchInCurve: FujinMotion.dissolve.curve,
      switchOutCurve: FujinMotion.dissolve.curve,
      layoutBuilder: layout,
      child: KeyedSubtree(key: ValueKey(child.runtimeType), child: child),
    );
    return switch (FujinMotion.reduced(context)) {
      true => switcher,
      false => AnimatedSize(
        duration: FujinMotion.grow.duration,
        curve: FujinMotion.grow.curve,
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        child: switcher,
      ),
    };
  }
}
