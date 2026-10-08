import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:motor/motor.dart';

class TransitCard extends StatelessWidget {
  const TransitCard({required this.names, super.key});

  static const double _dot = 8;
  static const double _lane = 38;
  static const double _longStreak = 40;
  static const double _shortStreak = 24;
  static const double _streakThickness = 2;
  static const _drift = StepSequence<double>(
    [0, 1],
    motion: FujinMotion.drift,
    loop: LoopMode.seamless,
  );

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labelStyle = FujinText.inter12Medium.copyWith(
      color: FujinColorRole.textSecondary,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s5,
        FujinSpace.s4,
        FujinSpace.s5,
        FujinSpace.s3,
      ),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: FujinSpace.s2,
                children: [
                  const _Dot(color: FujinColorRole.sourceMfp),
                  Text(l10n.sourceMyFitnessPal, style: labelStyle),
                ],
              ),
              Row(
                spacing: FujinSpace.s2,
                children: [
                  Text(l10n.sourceEkklo, style: labelStyle),
                  const _Dot(color: FujinColorRole.sourceEkklo),
                ],
              ),
            ],
          ),
          SizedBox(
            height: _lane,
            child: SequenceMotionBuilder<int, double>(
              sequence: _drift,
              converter: MotionConverter.single,
              builder: (context, value, _, _) => Stack(
                children: [
                  for (final (index, name) in names.indexed)
                    _Drifting(
                      name: name,
                      progress: (value + index / names.length) % 1,
                      upper: index.isEven,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Drifting extends StatelessWidget {
  const _Drifting({
    required this.name,
    required this.progress,
    required this.upper,
  });

  final String name;
  final double progress;
  final bool upper;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment(
      progress * 2 - 1,
      switch (upper) {
        true => -1,
        false => 1,
      },
    ),
    child: Opacity(
      opacity: math.sin(progress * math.pi).clamp(0, 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSpace.s1,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: FujinSpace.s1,
            children: [
              _Streak(width: TransitCard._longStreak),
              _Streak(width: TransitCard._shortStreak),
            ],
          ),
          StatusPill(label: name, tone: PillTone.neutral),
        ],
      ),
    ),
  );
}

class _Streak extends StatelessWidget {
  const _Streak({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: TransitCard._streakThickness,
    decoration: BoxDecoration(
      color: FujinColor.sora,
      borderRadius: BorderRadius.circular(TransitCard._streakThickness / 2),
    ),
  );
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: TransitCard._dot,
    height: TransitCard._dot,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
