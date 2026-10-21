import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';
import 'package:fujin/pages/journal/journal_text.dart';

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
    final headline = JournalText.problemHeadline(context.intl, problem);
    final (title, detail) = switch (problem) {
      ReadProblem.mfpSessionExpired => (
        context.intl.disconnected,
        context.intl.mfpSessionExpiredDetail,
      ),
      ReadProblem.ekkloSessionExpired => (
        context.intl.disconnected,
        context.intl.ekkloSessionExpiredDetail,
      ),
      ReadProblem.offline => (
        context.intl.offlineTitle,
        switch (readAt) {
          final readAt? => context.intl.offlineSince(readAt),
          null => context.intl.offlineDetail,
        },
      ),
      ReadProblem.mfpUnavailable ||
      ReadProblem.ekkloUnavailable ||
      ReadProblem.unknown => (
        context.intl.unavailableTitle,
        context.intl.readFailedDetail,
      ),
    };
    final (action, onPressed) = switch (problem) {
      ReadProblem.mfpSessionExpired => (
        context.intl.mfpReconnect,
        () => onSignIn(FujinRoute.mfpSignIn),
      ),
      ReadProblem.ekkloSessionExpired => (
        context.intl.ekkloReconnect,
        () => onSignIn(FujinRoute.ekkloSignIn),
      ),
      ReadProblem.offline ||
      ReadProblem.mfpUnavailable ||
      ReadProblem.ekkloUnavailable ||
      ReadProblem.unknown => (context.intl.tryAgain, onRetry),
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: context.colors.backgroundAlert,
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
                    color: context.colors.textAlert,
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
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter13Regular.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          FilledButton(
            onPressed: onPressed,
            style: FujinTheme.alertButtonStyle(context.colors),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
