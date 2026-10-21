import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/breeze_indicator.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:motor/motor.dart';

class TransitCard extends StatelessWidget {
  const TransitCard({required this.names, super.key});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final labelStyle = FujinText.inter12Medium.copyWith(
      color: context.colors.textSecondary,
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
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: context.colors.borderCard),
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
                  SourceDot(color: context.colors.sourceMfp),
                  Text(context.intl.sourceMyFitnessPal, style: labelStyle),
                ],
              ),
              Row(
                spacing: FujinSpace.s2,
                children: [
                  Text(context.intl.sourceEkklo, style: labelStyle),
                  SourceDot(color: context.colors.sourceEkklo),
                ],
              ),
            ],
          ),
          SizedBox(
            height: FujinSize.transitLane,
            child: SequenceMotionBuilder<int, double>(
              sequence: FujinMotion.driftCycle,
              converter: MotionConverter.single,
              builder: (context, value, _, _) => Stack(
                children: [
                  for (final (index, name) in names.indexed)
                    _Drifting(
                      name: name,
                      progress: FujinMotion.driftPhase(
                        value,
                        index,
                        names.length,
                      ),
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
      opacity: FujinMotion.driftFade(progress),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSpace.s1,
        children: [
          const BreezeIndicator(streaks: BreezeStreaks.transit),
          StatusPill(label: name, tone: PillTone.neutral),
        ],
      ),
    ),
  );
}
