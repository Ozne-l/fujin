import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

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

  static const double height = FujinSize.waveformHeight;
  static const double pitch = FujinSize.waveBar + FujinSize.waveBarGap;

  static int fitting(double width) =>
      math.max(0, ((width + FujinSize.waveBarGap) / pitch).floor());

  static double width(int count) =>
      math.max(0, count * pitch - FujinSize.waveBarGap);

  @override
  Widget build(BuildContext context) {
    final reached = played * levels.length;
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: FujinSize.waveBarGap,
          children: [
            for (final (index, level) in levels.indexed)
              Container(
                width: FujinSize.waveBar,
                height:
                    FujinSize.waveBarMin +
                    level * (FujinSize.waveBarMax - FujinSize.waveBarMin),
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: Color.lerp(
                    restColour,
                    playedColour,
                    (reached - index).clamp(0, 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
