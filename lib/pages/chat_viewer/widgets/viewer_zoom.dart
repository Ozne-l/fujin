import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:motor/motor.dart';

class ViewerZoom extends HookWidget {
  const ViewerZoom({required this.onZoomed, required this.child, super.key});

  static const double maxScale = 3;
  static const double _zoomedFrom = 1.01;
  static const double _scaleGive = 0.3;
  static const double _panGive = 0.35;
  static const double _decelerationRate = 0.998;
  static const double _millisecondsPerSecond = 1000;
  static const Rect _whole = Rect.fromLTWH(0, 0, 1, 1);

  final ValueChanged<bool> onZoomed;
  final Widget child;

  static double _elastic(double scale) => switch (scale) {
    < 1 => math.pow(scale, _scaleGive).toDouble(),
    > maxScale => maxScale * math.pow(scale / maxScale, _scaleGive),
    _ => scale,
  };

  static double _band(double value, double low, double high) => switch (value) {
    _ when low > high => (low + high) / 2,
    _ when value < low => low + (value - low) * _panGive,
    _ when value > high => high + (value - high) * _panGive,
    _ => value,
  };

  static Rect _view(Offset corner, double scale) =>
      Rect.fromLTWH(corner.dx, corner.dy, scale, scale);

  static Rect _settled(Rect view) {
    final scale = view.width.clamp(1.0, maxScale);
    return _view(
      Offset(
        view.left.clamp(1 - scale, 0.0),
        view.top.clamp(1 - scale, 0.0),
      ),
      scale,
    );
  }

  static double _projected(double speed) =>
      speed /
      _millisecondsPerSecond *
      _decelerationRate /
      (1 - _decelerationRate);

  @override
  Widget build(BuildContext context) {
    final vsync = useSingleTickerProvider();
    final view = useMemoized(
      () => MotionController<Rect>(
        motion: FujinMotion.gesture,
        vsync: vsync,
        converter: MotionConverter.rect,
        initialValue: _whole,
      ),
      [vsync],
    );
    final report = useRef(onZoomed)..value = onZoomed;
    useEffect(() {
      var zoomed = false;
      void follow() {
        final now = view.value.width > _zoomedFrom;
        if (now == zoomed) return;
        zoomed = now;
        report.value(now);
      }

      view.addListener(follow);
      return () {
        view
          ..removeListener(follow)
          ..dispose();
      };
    }, [view]);
    final shown = useAnimation(view);
    final start = useRef(_whole);
    final anchor = useRef(Offset.zero);
    final focal = useRef(Offset.zero);
    final tapped = useRef(Offset.zero);

    return LayoutBuilder(
      builder: (context, box) {
        final size = box.biggest;
        Offset unit(Offset point) =>
            Offset(point.dx / size.width, point.dy / size.height);

        void glide(Rect target, Motion motion, {Rect velocity = Rect.zero}) {
          view.motion = FujinMotion.of(context, motion);
          unawaited(view.animateTo(target, withVelocity: velocity));
        }

        void begin(ScaleStartDetails details) {
          unawaited(view.stop(canceled: true));
          start.value = view.value;
          focal.value = unit(details.localFocalPoint);
          anchor.value =
              (focal.value - start.value.topLeft) / start.value.width;
        }

        void follow(ScaleUpdateDetails details) {
          final pinching = details.pointerCount > 1;
          if (!pinching && start.value.width <= _zoomedFrom) return;
          final scale = _elastic(start.value.width * details.scale);
          focal.value = unit(details.localFocalPoint);
          final corner = focal.value - anchor.value * scale;
          view.value = _view(
            Offset(
              _band(corner.dx, 1 - scale, 0),
              _band(corner.dy, 1 - scale, 0),
            ),
            scale,
          );
        }

        void release(ScaleEndDetails details) {
          final current = view.value;
          final scale = current.width.clamp(1.0, maxScale);
          switch (scale == current.width) {
            case true:
              final speed = unit(details.velocity.pixelsPerSecond);
              glide(
                _settled(
                  current.shift(
                    Offset(_projected(speed.dx), _projected(speed.dy)),
                  ),
                ),
                FujinMotion.gesture,
                velocity: Rect.fromLTRB(speed.dx, speed.dy, speed.dx, speed.dy),
              );
            case false:
              final point = (focal.value - current.topLeft) / current.width;
              glide(
                _settled(_view(focal.value - point * scale, scale)),
                FujinMotion.gesture,
              );
          }
        }

        void toggle() {
          switch (view.value.width > _zoomedFrom) {
            case true:
              glide(_whole, FujinMotion.flight);
            case false:
              final point = unit(tapped.value);
              glide(
                _settled(_view(point - point * maxScale, maxScale)),
                FujinMotion.flight,
              );
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: begin,
          onScaleUpdate: follow,
          onScaleEnd: release,
          onDoubleTapDown: (details) => tapped.value = details.localPosition,
          onDoubleTap: toggle,
          child: Transform(
            transform: Matrix4.diagonal3Values(shown.width, shown.width, 1)
              ..setTranslationRaw(
                shown.left * size.width,
                shown.top * size.height,
                0,
              ),
            child: child,
          ),
        );
      },
    );
  }
}
