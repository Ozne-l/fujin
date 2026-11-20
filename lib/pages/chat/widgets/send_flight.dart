import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:motor/motor.dart';

final class SendFlight {
  SendFlight();

  final GlobalKey field = GlobalKey();
  final GlobalKey bottom = GlobalKey();
  ({String text, Rect from})? _launch;

  void launch(String text) => _launch = switch (rectOf(field)) {
    final from? => (text: text.trim(), from: from),
    null => null,
  };

  Rect? takeText(String text) {
    final launch = _launch;
    _launch = null;
    return switch (launch) {
      (text: final launched, :final from) when launched == text.trim() => from,
      _ => null,
    };
  }

  void drop() => _launch = null;

  Rect? get voiceOrigin => rectOf(bottom);

  static Rect? rectOf(GlobalKey key) => switch (key.currentContext) {
    final context? => rectIn(context),
    null => null,
  };

  static Rect? rectIn(BuildContext context) =>
      switch (context.findRenderObject()) {
        final RenderBox box when box.attached && box.hasSize =>
          box.localToGlobal(Offset.zero) & box.size,
        _ => null,
      };

  static OverlayEntry? flyText(
    BuildContext context, {
    required Rect from,
    required Rect to,
    required String text,
    required Widget? quote,
    required VoidCallback onLanded,
  }) => _fly(
    context,
    from: from,
    to: to,
    onLanded: onLanded,
    ghost: (context, progress) =>
        _TextGhost(progress: progress, text: text, quote: quote),
  );

  static OverlayEntry? flyRow(
    BuildContext context, {
    required Rect from,
    required Rect to,
    required Widget row,
    required VoidCallback onLanded,
  }) => _fly(
    context,
    from: from,
    to: to,
    onLanded: onLanded,
    ghost: (context, progress) => Opacity(
      opacity: progress.clamp(0, 1),
      child: FittedBox(
        alignment: AlignmentDirectional.bottomEnd,
        child: SizedBox.fromSize(size: to.size, child: row),
      ),
    ),
  );

  static OverlayEntry? _fly(
    BuildContext context, {
    required Rect from,
    required Rect to,
    required VoidCallback onLanded,
    required Widget Function(BuildContext context, double progress) ghost,
  }) {
    final overlay = Overlay.maybeOf(context);
    final origin = switch (overlay?.context.findRenderObject()) {
      final RenderBox box when box.hasSize => box.localToGlobal(Offset.zero),
      _ => null,
    };
    if (overlay == null || origin == null) return null;
    final entry = OverlayEntry(
      builder: (context) => _Flight(
        from: from.shift(-origin),
        to: to.shift(-origin),
        onLanded: onLanded,
        ghost: ghost,
      ),
    );
    overlay.insert(entry);
    return entry;
  }
}

double _across(double progress) =>
    FujinMotion.sendFlight.curve.transform(progress.clamp(0, 1));

class _Flight extends StatelessWidget {
  const _Flight({
    required this.from,
    required this.to,
    required this.onLanded,
    required this.ghost,
  });

  final Rect from;
  final Rect to;
  final VoidCallback onLanded;
  final Widget Function(BuildContext context, double progress) ghost;

  @override
  Widget build(BuildContext context) => SingleMotionBuilder(
    motion: FujinMotion.sendFlightClock,
    from: 0,
    value: 1,
    onAnimationStatusChanged: (status) {
      if (status.isCompleted) onLanded();
    },
    builder: (context, progress, _) {
      final across = _across(progress);
      return Stack(
        children: [
          Positioned.fromRect(
            rect: Rect.fromLTRB(
              lerpDouble(from.left, to.left, across) ?? to.left,
              lerpDouble(from.top, to.top, progress) ?? to.top,
              lerpDouble(from.right, to.right, across) ?? to.right,
              lerpDouble(from.bottom, to.bottom, progress) ?? to.bottom,
            ),
            child: IgnorePointer(
              child: Material(
                type: MaterialType.transparency,
                child: ghost(context, progress),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _TextGhost extends StatelessWidget {
  const _TextGhost({
    required this.progress,
    required this.text,
    required this.quote,
  });

  final double progress;
  final String text;
  final Widget? quote;

  static const EdgeInsets _fieldInset = EdgeInsets.all(FujinSpace.s4);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(
      lerpDouble(FujinRadius.button, FujinRadius.field, progress) ??
          FujinRadius.field,
    );
    final across = _across(progress);
    final inset =
        EdgeInsets.lerp(_fieldInset, ChatBubble.textPadding, across) ??
        ChatBubble.textPadding;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.lerp(
          colors.backgroundGlass,
          colors.backgroundTabActive,
          progress,
        ),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: OverflowBox(
          alignment: AlignmentDirectional.bottomStart,
          minWidth: 0,
          minHeight: 0,
          maxHeight: double.infinity,
          child: Padding(
            padding: inset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: FujinSpace.s2,
              children: [
                if (quote case final quote?)
                  Opacity(opacity: progress.clamp(0, 1), child: quote),
                Text(
                  text,
                  style: TextStyle.lerp(
                    FujinText.inter16Regular.copyWith(
                      color: colors.textPrimary,
                    ),
                    FujinText.inter15RegularL22.copyWith(
                      color: colors.textPrimary,
                    ),
                    across,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
