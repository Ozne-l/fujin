import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:motor/motor.dart';

class MessageGestures extends HookWidget {
  const MessageGestures({
    required this.mine,
    required this.child,
    this.onReply,
    this.onLongPress,
    this.onDoubleTap,
    super.key,
  });

  final bool mine;
  final Widget child;
  final VoidCallback? onReply;
  final ValueChanged<Rect>? onLongPress;
  final VoidCallback? onDoubleTap;

  static const double trigger = 64;
  static const double _reach = 96;
  static const double _rearm = 8;

  static double _band(double distance) => switch (distance <= trigger) {
    true => distance,
    false =>
      trigger +
          (_reach - trigger) *
              (1 - math.exp(-(distance - trigger) / (_reach - trigger))),
  };

  static void cede(BuildContext context, PointerDownEvent event) => context
      .getInheritedWidgetOfExactType<_SwipeScope>()
      ?.ceded
      ?.add(event.pointer);

  static double _slope(double distance) => switch (distance <= trigger) {
    true => 1,
    false => math.exp(-(distance - trigger) / (_reach - trigger)),
  };

  @override
  Widget build(BuildContext context) {
    final vsync = useSingleTickerProvider();
    final offset = useMemoized(
      () => SingleMotionController(motion: FujinMotion.gesture, vsync: vsync),
    );
    useEffect(() => offset.dispose, [offset]);
    final distance = useRef<double>(0);
    final fired = useRef(false);
    final armed = useState(false);
    final firstTap = useRef<Offset?>(null);
    final tapWindow = useRef<Timer?>(null);
    useEffect(
      () =>
          () => tapWindow.value?.cancel(),
      const [],
    );
    final ceded = useMemoized(() => <int>{});
    final onReply = this.onReply;
    final direction = switch (mine) {
      true => -1.0,
      false => 1.0,
    };

    void start(DragStartDetails details) {
      distance.value = offset.value;
      fired.value = offset.value >= _rearm;
    }

    void update(DragUpdateDetails details) {
      distance.value = math.max(
        0,
        distance.value + details.delta.dx * direction,
      );
      final next = _band(distance.value);
      offset.value = next;
      armed.value = next >= trigger;
      switch ((fired.value, next >= trigger, next < _rearm)) {
        case (false, true, _):
          fired.value = true;
          FujinHaptics.threshold();
        case (true, _, true):
          fired.value = false;
        case _:
          break;
      }
    }

    void settle(double velocity) {
      final reply = armed.value;
      armed.value = false;
      switch (FujinMotion.reduced(context)) {
        case true:
          offset.value = 0;
        case false:
          unawaited(
            offset.animateTo(
              0,
              withVelocity: velocity * direction * _slope(distance.value),
            ),
          );
      }
      distance.value = 0;
      if (reply) onReply?.call();
    }

    void longPress() {
      final onLongPress = this.onLongPress;
      if (onLongPress == null) return;
      if (context.findRenderObject() case final RenderBox box
          when box.hasSize) {
        FujinHaptics.press();
        onLongPress(box.localToGlobal(Offset.zero) & box.size);
      }
    }

    void tapUp(TapUpDetails details) {
      final onDoubleTap = this.onDoubleTap;
      if (onDoubleTap == null) return;
      final second = switch (firstTap.value) {
        final first? =>
          (details.globalPosition - first).distance <= kDoubleTapSlop,
        null => false,
      };
      tapWindow.value?.cancel();
      switch (second) {
        case true:
          firstTap.value = null;
          FujinHaptics.select();
          onDoubleTap();
        case false:
          firstTap.value = details.globalPosition;
          tapWindow.value = Timer(
            kDoubleTapTimeout,
            () => firstTap.value = null,
          );
      }
    }

    final colors = context.colors;
    final content = GestureDetector(
      onTapUp: switch (onDoubleTap) {
        null => null,
        _ => tapUp,
      },
      onLongPress: switch (onLongPress) {
        null => null,
        _ => longPress,
      },
      child: AnimatedBuilder(
        animation: offset,
        builder: (context, child) {
          final shift = offset.value;
          final shown = (shift / trigger).clamp(0.0, 1.0);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (shift > 0)
                PositionedDirectional(
                  top: 0,
                  bottom: 0,
                  start: switch (mine) {
                    true => null,
                    false => 0,
                  },
                  end: switch (mine) {
                    true => 0,
                    false => null,
                  },
                  child: Center(
                    child: Opacity(
                      opacity: shown,
                      child: Transform.scale(
                        scale: shown,
                        child: SingleMotionBuilder(
                          motion: FujinMotion.of(context, FujinMotion.emphasis),
                          value: switch (armed.value) {
                            true => FujinMotion.emphasisSwell,
                            false => 1,
                          },
                          builder: (context, swell, disc) =>
                              Transform.scale(scale: swell, child: disc),
                          child: Container(
                            width: FujinSize.swipeReplyDisc,
                            height: FujinSize.swipeReplyDisc,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: colors.backgroundAccent,
                            ),
                            child: MediaGlyph(
                              ChatMediaIcon.reply,
                              size: FujinSize.swipeReplyIcon,
                              color: colors.textOnAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(shift * direction, 0),
                child: child,
              ),
            ],
          );
        },
        child: child,
      ),
    );
    return _SwipeScope(
      ceded: switch (onReply) {
        null => null,
        _ => ceded,
      },
      child: RawGestureDetector(
        gestures: {
          if (onReply != null)
            _SwipeRecognizer:
                GestureRecognizerFactoryWithHandlers<_SwipeRecognizer>(
                  () => _SwipeRecognizer(ceded, debugOwner: this),
                  (recognizer) => recognizer
                    ..dragStartBehavior = DragStartBehavior.down
                    ..onStart = start
                    ..onUpdate = update
                    ..onEnd = ((details) {
                      settle(details.velocity.pixelsPerSecond.dx);
                    })
                    ..onCancel = (() => settle(0)),
                ),
        },
        child: content,
      ),
    );
  }
}

class _SwipeScope extends InheritedWidget {
  const _SwipeScope({required this.ceded, required super.child});

  final Set<int>? ceded;

  @override
  bool updateShouldNotify(_SwipeScope oldWidget) => false;
}

final class _SwipeRecognizer extends HorizontalDragGestureRecognizer {
  _SwipeRecognizer(this._ceded, {super.debugOwner});

  static const double _claim = 10;
  static const double _ratio = 3;

  final Set<int> _ceded;
  Offset _down = Offset.zero;
  Offset _moved = Offset.zero;
  bool _won = false;

  @override
  bool isPointerAllowed(PointerEvent event) => switch (_ceded.remove(
    event.pointer,
  )) {
    true => false,
    false => super.isPointerAllowed(event),
  };

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _down = event.position;
    _moved = Offset.zero;
    _won = false;
    super.addAllowedPointer(event);
  }

  bool get _claims =>
      _moved.dx.abs() > _claim && _moved.dx.abs() > _ratio * _moved.dy.abs();

  @override
  void acceptGesture(int pointer) {
    _won = true;
    super.acceptGesture(pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    switch (event) {
      case PointerMoveEvent(:final position):
        _moved = position - _down;
        if (!_won && !_claims && _moved.distance > _claim) {
          resolve(GestureDisposition.rejected);
          return;
        }
      case PointerUpEvent() when !_won:
        resolve(GestureDisposition.rejected);
        return;
      case _:
        break;
    }
    super.handleEvent(event);
  }

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) => _claims;
}
