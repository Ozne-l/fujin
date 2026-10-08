import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/sending/send_text.dart';

class CandidateCard extends StatelessWidget {
  const CandidateCard({
    required this.selected,
    required this.onTap,
    required this.child,
    super.key,
  });

  final bool selected;
  final VoidCallback? onTap;
  final Widget child;

  static String origin(AppLocalizations l10n, EkkloCandidate candidate) {
    final match = SendText.nameMatch(l10n, candidate.nameMatch);
    return switch (candidate.food.brands) {
      null => match,
      final brands => l10n.candidateBrandMatch(brands, match),
    };
  }

  @override
  Widget build(BuildContext context) {
    final accent = switch (selected) {
      true => FujinColor.fujin,
      false => FujinColorRole.borderCard,
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(FujinRadius.card),
      side: BorderSide(color: accent),
    );
    return Semantics(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: FujinColorRole.backgroundCard,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              FujinSpace.s4,
              FujinSpace.s3,
              FujinSpace.s4,
              FujinSpace.s3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s3,
              children: [
                Container(
                  width: FujinSize.radio,
                  height: FujinSize.radio,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: FujinColorRole.backgroundCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: accent, width: FujinStroke.radio),
                  ),
                  child: switch (selected) {
                    true => const DecoratedBox(
                      decoration: BoxDecoration(
                        color: FujinColor.fujin,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(dimension: FujinSize.radioDot),
                    ),
                    false => null,
                  },
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
