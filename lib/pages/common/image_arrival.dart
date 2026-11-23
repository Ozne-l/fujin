import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class ImageArrival extends HookWidget {
  const ImageArrival({required this.arrived, required this.child, super.key});

  final bool arrived;
  final Widget child;

  static const ImageFrameBuilder frameBuilder = _arrive;

  @override
  Widget build(BuildContext context) {
    final seen = useRef(false);
    seen.value = seen.value || arrived;
    return ColoredBox(
      color: context.colors.backgroundNeutral,
      child: SingleMotionBuilder(
        motion: FujinMotion.effectsFast,
        value: switch (seen.value) {
          true => 1.0,
          false => 0.0,
        },
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity.clamp(0, 1), child: child),
        child: child,
      ),
    );
  }
}

Widget _arrive(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
) => ImageArrival(
  arrived: wasSynchronouslyLoaded || frame != null,
  child: child,
);
