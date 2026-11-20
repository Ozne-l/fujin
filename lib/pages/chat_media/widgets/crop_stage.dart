import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';
import 'package:fujin/pages/chat_media/widgets/crop_overlay.dart';
import 'package:fujin/pages/chat_media/widgets/gesture_safe_padding.dart';
import 'package:motor/motor.dart';

class CropStage extends HookWidget {
  const CropStage({
    required this.aspectRatio,
    required this.picture,
    required this.crop,
    required this.onDragged,
    this.quarterTurns = 0,
    super.key,
  });

  static const int _turns = 4;

  final double aspectRatio;
  final Widget picture;
  final Rect crop;
  final int quarterTurns;
  final void Function(CropHandle handle, Offset delta) onDragged;

  @override
  Widget build(BuildContext context) {
    final heading = useRef(0);
    final previous = usePrevious(quarterTurns);
    if (previous case final previous? when previous != quarterTurns) {
      heading.value += _shortest(quarterTurns - previous);
    }
    final insets = GestureSafePadding.insetsOf(
      context,
      vertical: FujinSize.screenMargin,
      clearance: CropOverlay.edgeClearance,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final area = insets.deflateRect(Offset.zero & constraints.biggest);
        final fitted = applyBoxFit(
          BoxFit.contain,
          Size(aspectRatio, 1),
          area.size,
        ).destination;
        final shown = Alignment.center.inscribe(fitted, area);
        final across = applyBoxFit(
          BoxFit.contain,
          shown.size.flipped,
          area.size,
        ).destination;
        final acrossScale = across.width / math.max(1, shown.height);
        return SingleMotionBuilder(
          value: heading.value.toDouble(),
          motion: FujinMotion.rotate,
          active: !FujinMotion.reduced(context),
          builder: (context, value, child) {
            final remaining = value - heading.value;
            final odd = 1 - ((remaining.abs() % 2) - 1).abs();
            final scale = lerpDouble(1, acrossScale, odd) ?? 1;
            return Transform(
              origin: shown.center,
              transform: Matrix4.rotationZ(remaining * math.pi / 2)
                ..scaleByDouble(scale, scale, 1, 1),
              child: child,
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fromRect(rect: shown, child: picture),
              CropOverlay(
                picture: shown,
                crop: crop,
                quarterTurns: quarterTurns,
                onDragged: onDragged,
              ),
            ],
          ),
        );
      },
    );
  }

  static int _shortest(int turns) => switch (turns % _turns) {
    final over when over > _turns / 2 => over - _turns,
    final turn => turn,
  };
}
