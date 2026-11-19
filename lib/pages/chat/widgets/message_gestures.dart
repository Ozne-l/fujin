import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    super.key,
  });

  final bool mine;
  final Widget child;
  final VoidCallback? onReply;
  final ValueChanged<Rect>? onLongPress;

  static const double threshold = 30;
  static const double dragFactor = 0.3;
  static const double _disc = 32;
  static const double _discIcon = 16;
  static const double _reach = threshold * 2;

  @override
  Widget build(BuildContext context) {
    final dragged = useState<double?>(null);
    final armed = useRef(false);
    final onReply = this.onReply;
    final direction = switch (mine) {
      true => -1.0,
      false => 1.0,
    };

    void update(DragUpdateDetails details) {
      final next =
          ((dragged.value ?? 0) + details.delta.dx * dragFactor * direction)
              .clamp(0.0, _reach);
      dragged.value = next;
      switch ((armed.value, next >= threshold)) {
        case (false, true):
          armed.value = true;
          unawaited(HapticFeedback.lightImpact());
        case (true, false):
          armed.value = false;
        case (true, true) || (false, false):
          break;
      }
    }

    void end() {
      final reply = armed.value;
      armed.value = false;
      dragged.value = null;
      if (reply) onReply?.call();
    }

    void longPress() {
      final onLongPress = this.onLongPress;
      if (onLongPress == null) return;
      if (context.findRenderObject() case final RenderBox box
          when box.hasSize) {
        unawaited(HapticFeedback.mediumImpact());
        onLongPress(box.localToGlobal(Offset.zero) & box.size);
      }
    }

    final colors = context.colors;
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      onLongPress: switch (onLongPress) {
        null => null,
        _ => longPress,
      },
      onHorizontalDragStart: switch (onReply) {
        null => null,
        _ => (_) => dragged.value = 0,
      },
      onHorizontalDragUpdate: switch (onReply) {
        null => null,
        _ => update,
      },
      onHorizontalDragEnd: switch (onReply) {
        null => null,
        _ => (_) => end(),
      },
      onHorizontalDragCancel: switch (onReply) {
        null => null,
        _ => end,
      },
      child: SingleMotionBuilder(
        motion: FujinMotion.of(context, switch (dragged.value) {
          null => FujinMotion.tabSlide,
          _ => FujinMotion.lensFollow,
        }),
        value: dragged.value ?? 0,
        builder: (context, offset, child) => Stack(
          clipBehavior: Clip.none,
          children: [
            if (offset > 0)
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
                    opacity: (offset / threshold).clamp(0, 1),
                    child: Container(
                      width: _disc,
                      height: _disc,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: const CircleBorder(),
                        color: colors.backgroundAccent,
                      ),
                      child: MediaGlyph(
                        ChatMediaIcon.reply,
                        size: _discIcon,
                        color: colors.textOnAccent,
                      ),
                    ),
                  ),
                ),
              ),
            Transform.translate(
              offset: Offset(offset * direction, 0),
              child: child,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
