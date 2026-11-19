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

  const FujinSpinner.disc({super.key}) : _tone = _SpinnerTone.disc;

  static const double _sweep = 220 / 360;

  final _SpinnerTone _tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spinner = SequenceMotionBuilder<int, double>(
      sequence: FujinMotion.spinTurns,
      converter: MotionConverter.single,
      builder: (context, turns, _, child) =>
          Transform.rotate(angle: turns * 2 * pi, child: child),
      child: ProgressRing(
        size: _tone.size,
        stroke: FujinStroke.spinner,
        track: _tone.track(colors),
        arc: _tone.arc(colors),
        progress: _sweep,
        cap: StrokeCap.butt,
        child: const SizedBox.shrink(),
      ),
    );
    return switch (_tone) {
      _SpinnerTone.card ||
      _SpinnerTone.button ||
      _SpinnerTone.camera => spinner,
      _SpinnerTone.disc => Container(
        width: FujinSize.pictogram,
        height: FujinSize.pictogram,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.backgroundCard,
          shape: BoxShape.circle,
          border: Border.all(color: colors.borderCard),
        ),
        child: spinner,
      ),
    };
  }
}

enum _SpinnerTone {
  card(FujinSize.spinner),
  button(FujinSize.spinnerSmall),
  camera(FujinSize.spinnerSmall),
  disc(FujinSize.stepMarker);

  const _SpinnerTone(this.size);

  final double size;

  Color track(FujinColors colors) => switch (this) {
    card || disc => colors.goalTrack,
    button => colors.textDisabled,
    camera => colors.cameraTextSecondary,
  };

  Color arc(FujinColors colors) => switch (this) {
    card => colors.textLink,
    button => colors.textSecondary,
    camera => colors.cameraText,
    disc => colors.backgroundAccent,
  };
}
