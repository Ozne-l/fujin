import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class InPageSheet extends StatelessWidget {
  const InPageSheet({required this.child, this.onDismiss, super.key});

  static const Offset _below = Offset(0, 1);

  final Widget? child;
  final VoidCallback? onDismiss;

  static Widget _layout(Widget? current, List<Widget> previous) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      for (final leaving in previous)
        IgnorePointer(key: leaving.key, child: leaving),
      if (current case final current?)
        IgnorePointer(key: current.key, ignoring: false, child: current),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final (rise, fall) = switch (FujinMotion.reduced(context)) {
      true => (Duration.zero, Duration.zero),
      false => (
        FujinMotion.sheetRise.duration,
        FujinMotion.sheetFall.duration,
      ),
    };
    final scrim = context.colors.backgroundScrim;
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          ignoring: child == null,
          child: GestureDetector(
            onTap: onDismiss,
            child: SingleMotionBuilder(
              motion: FujinMotion.of(context, FujinMotion.effects),
              value: switch (child) {
                null => 0,
                _ => 1,
              },
              builder: (context, shown, _) => ColoredBox(
                color: scrim.withValues(alpha: scrim.a * shown.clamp(0, 1)),
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: rise,
          reverseDuration: fall,
          switchInCurve: FujinMotion.sheetRise.curve,
          switchOutCurve: FujinMotion.sheetFall.curve,
          layoutBuilder: _layout,
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween(begin: _below, end: Offset.zero).animate(animation),
            child: child,
          ),
          child: switch (child) {
            final child? => KeyedSubtree(
              key: ValueKey(child.runtimeType),
              child: child,
            ),
            null => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }
}
