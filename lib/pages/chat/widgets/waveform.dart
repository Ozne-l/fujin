import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fujin/pages/chat/widgets/wave_bars.dart';

class Waveform extends StatelessWidget {
  const Waveform({
    required this.seed,
    required this.played,
    required this.playedColour,
    required this.restColour,
    super.key,
  });

  final Uri seed;
  final double played;
  final Color playedColour;
  final Color restColour;

  static const int _bars = 28;
  static const double _byteRange = 255;

  List<double> get _levels {
    final bytes = sha256.convert(utf8.encode('$seed')).bytes;
    return [
      for (var index = 0; index < _bars; index++)
        bytes[index % bytes.length] / _byteRange,
    ];
  }

  @override
  Widget build(BuildContext context) => WaveBars(
    levels: _levels,
    played: played,
    playedColour: playedColour,
    restColour: restColour,
  );
}
