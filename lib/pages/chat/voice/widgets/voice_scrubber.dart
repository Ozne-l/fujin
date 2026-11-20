import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_player_control.dart';
import 'package:fujin/pages/chat/widgets/message_gestures.dart';
import 'package:motor/motor.dart';

class VoiceScrubber extends HookWidget {
  const VoiceScrubber({
    required this.playback,
    required this.thumbColour,
    required this.builder,
    super.key,
  });

  final VoicePlayback playback;
  final Color thumbColour;
  final Widget Function(BuildContext context, double played) builder;

  @override
  Widget build(BuildContext context) {
    final dragged = useState<double?>(null);
    final touched = useState(false);
    final total = playback.total;
    final played = switch ((playback.started, total.inMilliseconds)) {
      (false, _) || (_, 0) => 0.0,
      (true, final length) => playback.position.inMilliseconds / length,
    };

    double fractionAt(Offset local) => switch (context.size) {
      Size(:final width) when width > 0 => (local.dx / width).clamp(0, 1),
      _ => 0,
    };

    Future<void> seek(double fraction) async {
      await playback.seek(total * fraction);
      if (!context.mounted) return;
      dragged.value = null;
      touched.value = false;
    }

    return Listener(
      onPointerDown: (event) => MessageGestures.cede(context, event),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => touched.value = true,
        onTapCancel: () => touched.value = false,
        onTapUp: (details) =>
            unawaited(seek(fractionAt(details.localPosition))),
        onHorizontalDragStart: (details) {
          playback.hold();
          touched.value = true;
          dragged.value = fractionAt(details.localPosition);
        },
        onHorizontalDragUpdate: (details) =>
            dragged.value = fractionAt(details.localPosition),
        onHorizontalDragEnd: (_) => unawaited(seek(dragged.value ?? played)),
        onHorizontalDragCancel: () {
          if (dragged.value case final fraction?) unawaited(seek(fraction));
        },
        child: SingleMotionBuilder(
          motion: switch (dragged.value) {
            null => FujinMotion.of(context, FujinMotion.playedFill),
            _ => const InstantMotion(),
          },
          value: dragged.value ?? played,
          builder: (context, shown, _) => Stack(
            clipBehavior: Clip.none,
            children: [
              builder(context, shown),
              if (playback.started || touched.value)
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, box) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left:
                              shown * box.maxWidth -
                              FujinSize.scrubberThumb / 2,
                          top: (box.maxHeight - FujinSize.scrubberThumb) / 2,
                          child: SingleMotionBuilder(
                            motion: FujinMotion.of(context, FujinMotion.lift),
                            value: switch (touched.value) {
                              true => FujinMotion.scrubSwell,
                              false => 1,
                            },
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: Container(
                              width: FujinSize.scrubberThumb,
                              height: FujinSize.scrubberThumb,
                              decoration: BoxDecoration(
                                color: thumbColour,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
