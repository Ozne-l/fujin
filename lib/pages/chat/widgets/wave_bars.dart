import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaveBars extends StatelessWidget {
  const WaveBars({
    required this.levels,
    required this.played,
    required this.playedColour,
    required this.restColour,
    super.key,
  });

  final List<double> levels;
  final double played;
  final Color playedColour;
  final Color restColour;

  static const double height = 28;
  static const double _bar = 3;
  static const double _gap = 2;
  static const double _lowest = 4;
  static const double _highest = 26;

  static int fitting(double width) =>
      math.max(0, ((width + _gap) / (_bar + _gap)).floor());

  @override
  Widget build(BuildContext context) {
    final playedBars = (played * levels.length).round();
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _gap,
          children: [
            for (final (index, level) in levels.indexed)
              Container(
                width: _bar,
                height: _lowest + level * (_highest - _lowest),
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: switch (index < playedBars) {
                    true => playedColour,
                    false => restColour,
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
