import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';

class DaySwitcher extends HookWidget {
  const DaySwitcher({required this.day, required this.child, super.key});

  static const _remembered = 4;

  final DateTime day;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final previousDay = usePrevious(day);
    final previousKey = usePrevious(child.key);
    final shifts = useRef(<Key?, ({double enter, double exit})>{});
    final reading = switch (Directionality.of(context)) {
      TextDirection.ltr => 1,
      TextDirection.rtl => -1,
    };
    if (previousKey != child.key) {
      final shift = switch (previousDay) {
        final before? when before.isBefore(day) => reading.toDouble(),
        final before? when before.isAfter(day) => -reading.toDouble(),
        _ => 0.0,
      };
      final remembered = shifts.value;
      if (remembered[previousKey] case (:final enter, exit: _)) {
        remembered[previousKey] = (enter: enter, exit: shift);
      }
      remembered
        ..remove(child.key)
        ..[child.key] = (enter: shift, exit: 0);
      while (remembered.length > _remembered) {
        remembered.remove(remembered.keys.first);
      }
    }
    return AnimatedSwitcher(
      duration: switch (FujinMotion.reduced(context)) {
        true => Duration.zero,
        false => FujinMotion.spatial.duration,
      },
      switchInCurve: FujinMotion.spatial.curve,
      switchOutCurve: FujinMotion.spatial.curve,
      transitionBuilder: (shown, animation) {
        final shift = switch ((
          shifts.value[shown.key],
          shown.key == child.key,
        )) {
          ((:final enter, exit: _)?, true) => enter,
          ((enter: _, :final exit)?, false) => -exit,
          (null, _) => 0.0,
        };
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: Offset(FujinMotion.daySlide * shift, 0),
              end: Offset.zero,
            ).animate(animation),
            child: shown,
          ),
        );
      },
      layoutBuilder: (current, previous) => Stack(
        children: [
          for (final child in previous)
            IgnorePointer(key: child.key, child: child),
          ?current,
        ],
      ),
      child: child,
    );
  }
}
