import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class ReactionFlight extends StatelessWidget {
  const ReactionFlight({
    required this.emoji,
    required this.from,
    required this.to,
    required this.onLanded,
    super.key,
  });

  final String emoji;
  final Rect from;
  final Offset to;
  final VoidCallback onLanded;

  static final double _landedScale = switch ((
    FujinText.inter13Regular.fontSize,
    FujinText.hina24.fontSize,
  )) {
    (final landed?, final flown?) => landed / flown,
    _ => 1,
  };

  static Future<void> launch(
    BuildContext context, {
    required String emoji,
    required Rect from,
    required Offset to,
  }) {
    if (FujinMotion.reduced(context)) return Future.value();
    final landed = Completer<void>();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => ReactionFlight(
        emoji: emoji,
        from: from,
        to: to,
        onLanded: () {
          entry
            ..remove()
            ..dispose();
          landed.complete();
        },
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
    return landed.future;
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SingleMotionBuilder(
      motion: FujinMotion.reactionFlight,
      from: 0,
      value: 1,
      onAnimationStatusChanged: (status) {
        if (status.isCompleted) onLanded();
      },
      builder: (context, t, child) {
        final across = FujinMotion.easeOutQuint.transform(t);
        final drop = FujinMotion.flightDrop.transform(t);
        final start = from.center;
        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset:
                Offset(
                  lerpDouble(start.dx, to.dx, across) ?? to.dx,
                  lerpDouble(start.dy, to.dy, drop) ?? to.dy,
                ) -
                from.size.center(Offset.zero),
            child: Transform.scale(
              scale: lerpDouble(1, _landedScale, across),
              child: child,
            ),
          ),
        );
      },
      child: SizedBox.fromSize(
        size: from.size,
        child: Center(
          child: Text(
            emoji,
            style: FujinText.hina24.copyWith(color: context.colors.textPrimary),
          ),
        ),
      ),
    ),
  );
}
