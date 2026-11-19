import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/progress_ring.dart';

class UploadRing extends StatelessWidget {
  const UploadRing({required this.percent, super.key});

  final int percent;

  static const double _disc = 52;
  static const double _ring = 44;
  static const double _stroke = 3.5;
  static const double _whole = 100;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.intl.chatUploadRing(percent),
      child: ExcludeSemantics(
        child: Container(
          width: _disc,
          height: _disc,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.backgroundCard,
            shape: BoxShape.circle,
            border: Border.all(color: colors.borderCard),
          ),
          child: ProgressRing(
            size: _ring,
            stroke: _stroke,
            track: colors.goalTrack,
            arc: colors.backgroundAccent,
            progress: percent / _whole,
            child: Text(
              context.intl.chatUploadRingLabel(percent),
              style: FujinText.inter11Semibold.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
