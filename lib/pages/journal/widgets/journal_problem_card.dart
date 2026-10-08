import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class JournalProblemCard extends StatelessWidget {
  const JournalProblemCard({
    required this.error,
    required this.onSignIn,
    super.key,
  });

  final Object error;
  final ValueChanged<FujinRoute> onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (pill, title, detail, action) = switch (error) {
      MfpAuthException() => (
        l10n.disconnected,
        l10n.mfpSessionExpired,
        l10n.mfpSessionExpiredDetail,
        null,
      ),
      EkkloAuthException() => (
        l10n.disconnected,
        l10n.ekkloSessionExpired,
        l10n.ekkloSessionExpiredDetail,
        (l10n.ekkloReconnect, FujinRoute.ekkloSignIn),
      ),
      _ => (null, l10n.readFailed, l10n.readFailedDetail, null),
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundAlert,
        borderRadius: BorderRadius.circular(FujinRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s2,
        children: [
          if (pill case final pill?)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: StatusPill(label: pill, tone: PillTone.error),
            ),
          Text(
            title,
            style: FujinText.inter15Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
          Text(
            detail,
            style: FujinText.inter13RegularL19.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
          if (action case (final label, final route))
            Padding(
              padding: const EdgeInsets.only(top: FujinSpace.s2),
              child: FilledButton(
                onPressed: () => onSignIn(route),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
                  backgroundColor: FujinColorRole.buttonAlertBackground,
                  foregroundColor: FujinColorRole.buttonAlertText,
                  textStyle: FujinText.inter15Medium,
                  shape: const StadiumBorder(),
                ),
                child: Text(label),
              ),
            ),
        ],
      ),
    );
  }
}
