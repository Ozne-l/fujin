import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class JournalProblemCard extends StatelessWidget {
  const JournalProblemCard({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (pill, title, detail) = switch (error) {
      MfpAuthException() => (
        l10n.disconnected,
        l10n.mfpSessionExpired,
        l10n.mfpSessionExpiredDetail,
      ),
      EkkloAuthException() => (
        l10n.disconnected,
        l10n.ekkloSessionExpired,
        l10n.ekkloSessionExpiredDetail,
      ),
      _ => (null, l10n.readFailed, l10n.readFailedDetail),
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.margeEcran),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: FujinRole.fondAlerte,
        borderRadius: BorderRadius.circular(FujinRadius.carte),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s2,
        children: [
          if (pill case final pill?)
            StatusPill(label: pill, tone: PillTone.error),
          Text(
            title,
            style: FujinText.inter15Medium.copyWith(
              color: FujinRole.textePrincipal,
            ),
          ),
          Text(
            detail,
            style: FujinText.inter13RegularL19.copyWith(
              color: FujinRole.texteSecondaire,
            ),
          ),
        ],
      ),
    );
  }
}
