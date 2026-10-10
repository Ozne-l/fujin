import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';

class JournalProblemCard extends StatelessWidget {
  const JournalProblemCard({
    required this.problem,
    required this.onSignIn,
    required this.onRetry,
    this.readAt,
    super.key,
  });

  final ReadProblem problem;
  final DateTime? readAt;
  final ValueChanged<FujinRoute> onSignIn;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, headline, detail) = switch (problem) {
      ReadProblem.mfpSessionExpired => (
        l10n.disconnected,
        l10n.mfpSessionExpired,
        l10n.mfpSessionExpiredDetail,
      ),
      ReadProblem.ekkloSessionExpired => (
        l10n.disconnected,
        l10n.ekkloSessionExpired,
        l10n.ekkloSessionExpiredDetail,
      ),
      ReadProblem.offline => (
        l10n.offlineTitle,
        l10n.offlineHeadline,
        switch (readAt) {
          final readAt? => l10n.offlineSince(readAt),
          null => l10n.offlineDetail,
        },
      ),
      ReadProblem.mfpUnavailable => (
        l10n.unavailableTitle,
        l10n.serviceNotResponding(l10n.sourceMyFitnessPal),
        l10n.readFailedDetail,
      ),
      ReadProblem.ekkloUnavailable => (
        l10n.unavailableTitle,
        l10n.serviceNotResponding(l10n.sourceEkklo),
        l10n.readFailedDetail,
      ),
      ReadProblem.unknown => (
        l10n.unavailableTitle,
        l10n.readFailed,
        l10n.readFailedDetail,
      ),
    };
    final (action, onPressed) = switch (problem) {
      ReadProblem.mfpSessionExpired => (
        l10n.mfpReconnect,
        () => onSignIn(FujinRoute.mfpSignIn),
      ),
      ReadProblem.ekkloSessionExpired => (
        l10n.ekkloReconnect,
        () => onSignIn(FujinRoute.ekkloSignIn),
      ),
      ReadProblem.offline ||
      ReadProblem.mfpUnavailable ||
      ReadProblem.ekkloUnavailable ||
      ReadProblem.unknown => (l10n.tryAgain, onRetry),
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundAlert,
        borderRadius: BorderRadius.circular(FujinRadius.stateCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s4,
        children: [
          Row(
            spacing: FujinSpace.s4,
            children: [
              const FujinWeatherGlyph(
                weather: FujinWeather.storm,
                side: FujinSize.glyphCard,
              ),
              Expanded(
                child: Text(
                  title,
                  style: FujinText.hina30.copyWith(
                    color: FujinColorRole.textAlert,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FujinSpace.s2,
            children: [
              Text(
                headline,
                style: FujinText.inter15Medium.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter13Regular.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
            ],
          ),
          FilledButton(
            onPressed: onPressed,
            style: FujinTheme.alertButtonStyle,
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
