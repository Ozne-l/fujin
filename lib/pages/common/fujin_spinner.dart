import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/progress_ring.dart';
import 'package:motor/motor.dart';

class FujinSpinner extends StatelessWidget {
  const FujinSpinner.card({super.key}) : _tone = _SpinnerTone.card;

  const FujinSpinner.button({super.key}) : _tone = _SpinnerTone.button;

  const FujinSpinner.camera({super.key}) : _tone = _SpinnerTone.camera;

  static const double _sweep = 220 / 360;

  final _SpinnerTone _tone;

  @override
  Widget build(BuildContext context) => SequenceMotionBuilder<int, double>(
    sequence: FujinMotion.spinTurns,
    converter: MotionConverter.single,
    builder: (context, turns, _, child) =>
        Transform.rotate(angle: turns * 2 * pi, child: child),
    child: ProgressRing(
      size: _tone.size,
      stroke: FujinStroke.spinner,
      track: _tone.track,
      arc: _tone.arc,
      progress: _sweep,
      cap: StrokeCap.butt,
      child: const SizedBox.shrink(),
    ),
  );
}

enum _SpinnerTone {
  card(
    size: FujinSize.spinner,
    track: FujinColorRole.goalTrack,
    arc: FujinColorRole.textLink,
  ),
  button(
    size: FujinSize.spinnerSmall,
    track: FujinColorRole.textDisabled,
    arc: FujinColorRole.textSecondary,
  ),
  camera(
    size: FujinSize.spinnerSmall,
    track: FujinColor.usuzumi,
    arc: FujinColor.washi,
  );

  const _SpinnerTone({
    required this.size,
    required this.track,
    required this.arc,
  });

  final double size;
  final Color track;
  final Color arc;
}
