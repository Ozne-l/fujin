import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:motor/motor.dart';

class FailureShake extends HookWidget {
  const FailureShake({
    required this.failed,
    required this.child,
    this.buzz = false,
    super.key,
  });

  final bool failed;
  final bool buzz;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shakes =
        useValueChanged<bool, int>(
          failed,
          (wasFailed, count) => switch ((wasFailed, failed)) {
            (false, true) => _signal(count ?? 0),
            _ => count,
          },
        ) ??
        0;
    return SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.shake),
      value: shakes.toDouble(),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(FujinMotion.shakeOffset(value), 0),
        child: child,
      ),
      child: child,
    );
  }

  int _signal(int count) {
    if (buzz) FujinHaptics.error();
    return count + 1;
  }
}
