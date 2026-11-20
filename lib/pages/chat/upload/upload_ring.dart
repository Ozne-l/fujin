import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/upload/upload_disc.dart';
import 'package:fujin/pages/common/progress_ring.dart';
import 'package:motor/motor.dart';

class UploadRing extends HookWidget {
  const UploadRing({required this.percent, super.key});

  final int percent;

  static const double _whole = 100;
  static const double _turn = 2 * math.pi;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final round = useRef(0);
    final previous = usePrevious(percent);
    if (previous case final previous? when percent < previous) round.value++;
    return Semantics(
      label: context.intl.chatUploadRing(percent),
      child: ExcludeSemantics(
        child: UploadDisc(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SequenceMotionBuilder<int, double>(
                sequence: FujinMotion.uploadSpinTurns,
                converter: MotionConverter.single,
                builder: (context, turns, _, child) =>
                    Transform.rotate(angle: turns * _turn, child: child),
                child: ProgressRing(
                  key: ValueKey(round.value),
                  size: FujinSize.uploadRing,
                  stroke: FujinStroke.uploadRing,
                  track: colors.goalTrack,
                  arc: colors.backgroundAccent,
                  progress: percent / _whole,
                  child: const SizedBox.shrink(),
                ),
              ),
              Text(
                context.intl.chatUploadRingLabel(percent),
                style: FujinText.inter11Semibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
