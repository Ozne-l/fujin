import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fujin/pages/chat/widgets/wave_bars.dart';

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

  List<double> _bars(int count) => switch (whole) {
    false => levels.sublist(math.max(0, levels.length - count)),
    true when levels.length <= count => levels,
    true => [
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

  @override
  Widget build(BuildContext context) => SizedBox(
    height: WaveBars.height,
    child: LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: Alignment.centerLeft,
        child: WaveBars(
          levels: _bars(WaveBars.fitting(constraints.maxWidth)),
          played: played,
          playedColour: playedColour,
          restColour: restColour,
        ),
      ),
    ),
  );
}
