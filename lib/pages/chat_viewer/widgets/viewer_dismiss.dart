import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:motor/motor.dart';

class ViewerDismiss extends HookWidget {
  const ViewerDismiss({
    required this.enabled,
    required this.travel,
    required this.onDragging,
    required this.onDismiss,
    required this.child,
    super.key,
  });

  static const double _closingShare = 1 / 6;
  static const double _closingSpeed = 700;
  static const double _fadingShare = 1 / 4;
  static const double _faintest = 0.5;

  final bool enabled;
  final ValueNotifier<double> travel;
  final ValueChanged<bool> onDragging;
  final VoidCallback onDismiss;
  final Widget child;

  static double backdropOf(double travel, double width) =>
      1 - (travel.abs() / (width * _fadingShare)).clamp(0.0, 1.0) * _faintest;

  @override
  Widget build(BuildContext context) {
    final vsync = useSingleTickerProvider();
    final spring = useMemoized(
      () => SingleMotionController(motion: FujinMotion.release, vsync: vsync),
      [vsync],
    );
    useEffect(() {
      void follow() => travel.value = spring.value;
      spring.addListener(follow);
      return () {
        spring
          ..removeListener(follow)
          ..dispose();
      };
    }, [spring, travel]);

    void settle(double velocity) {
      onDragging(false);
      spring.motion = FujinMotion.of(context, FujinMotion.release);
      unawaited(
        spring.animateTo(0, from: travel.value, withVelocity: velocity),
      );
    }

    void release(DragEndDetails details) {
      final velocity = details.primaryVelocity ?? 0;
      final offset = travel.value;
      final reach = MediaQuery.sizeOf(context).height * _closingShare;
      final far = offset.abs() > reach;
      final flung =
          velocity.abs() > _closingSpeed && velocity.sign == offset.sign;
      switch (far || flung) {
        case true:
          onDismiss();
        case false:
          settle(velocity);
      }
    }

    return RawGestureDetector(
      gestures: {
        if (enabled)
          _OneFingerDrag: GestureRecognizerFactoryWithHandlers<_OneFingerDrag>(
            () => _OneFingerDrag(debugOwner: this),
            (drag) => drag
              ..gestureSettings = MediaQuery.gestureSettingsOf(context)
              ..onStart = (details) {
                unawaited(spring.stop(canceled: true));
                onDragging(true);
              }
              ..onUpdate = (details) {
                travel.value += details.primaryDelta ?? 0;
              }
              ..onEnd = release
              ..onCancel = () => settle(0),
          ),
      },
      child: ValueListenableBuilder<double>(
        valueListenable: travel,
        builder: (context, offset, child) =>
            Transform.translate(offset: Offset(0, offset), child: child),
        child: child,
      ),
    );
  }
}

final class _OneFingerDrag extends VerticalDragGestureRecognizer {
  _OneFingerDrag({super.debugOwner});

  final Set<int> _fingers = {};
  bool _accepted = false;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _fingers.add(event.pointer);
    switch ((_fingers.length > 1, _accepted)) {
      case (false, _):
        super.addAllowedPointer(event);
      case (true, false):
        resolve(GestureDisposition.rejected);
      case (true, true):
        break;
    }
  }

  @override
  void acceptGesture(int pointer) {
    _accepted = true;
    super.acceptGesture(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _fingers.clear();
    _accepted = false;
    super.didStopTrackingLastPointer(pointer);
  }
}
