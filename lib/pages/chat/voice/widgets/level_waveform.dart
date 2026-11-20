import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/pages/chat/widgets/wave_bars.dart';
import 'package:motor/motor.dart';

class LevelWaveform extends StatelessWidget {
  const LevelWaveform({
    required this.levels,
    required this.whole,
    required this.played,
    required this.playedColour,
    required this.restColour,
    super.key,
  });

  final List<double> levels;
  final bool whole;
  final double played;
  final Color playedColour;
  final Color restColour;

  List<double> _summary(int count) => switch (levels.length <= count) {
    true => levels,
    false => [
      for (var index = 0; index < count; index++)
        levels
            .sublist(
              index * levels.length ~/ count,
              math.max(
                index * levels.length ~/ count + 1,
                (index + 1) * levels.length ~/ count,
              ),
            )
            .reduce(math.max),
    ],
  };

  Widget _bars(List<double> shown) => WaveBars(
    levels: shown,
    played: played,
    playedColour: playedColour,
    restColour: restColour,
  );

  Widget _scrolling(BuildContext context, int count) =>
      switch (levels.length <= count) {
        true => _bars(levels),
        false => SingleMotionBuilder(
          motion: FujinMotion.of(context, FujinMotion.levelScroll),
          value: levels.length.toDouble(),
          builder: (context, scrolled, child) => ClipRect(
            child: OverflowBox(
              alignment: Alignment.centerLeft,
              maxWidth: WaveBars.width(count + 1),
              child: Transform.translate(
                offset: Offset(
                  ((levels.length - scrolled).clamp(0, 1) - 1) * WaveBars.pitch,
                  0,
                ),
                child: child,
              ),
            ),
          ),
          child: _bars(levels.sublist(levels.length - count - 1)),
        ),
      };

  @override
  Widget build(BuildContext context) => SizedBox(
    height: WaveBars.height,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final count = WaveBars.fitting(constraints.maxWidth);
        return Align(
          alignment: Alignment.centerLeft,
          child: switch (whole) {
            true => _bars(_summary(count)),
            false => _scrolling(context, count),
          },
        );
      },
    ),
  );
}
