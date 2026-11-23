import 'package:flutter/widgets.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/domain/writing/connector_failure.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/sending/send_failure.dart';

abstract final class NotWrittenNotice {
  static const _duration = Duration(seconds: 8);

  static (Widget, Duration)? of<F extends ConnectorFailure>(
    AppLocalizations intl,
    List<F> failures,
    AppEnvironment environment, {
    required String Function(List<F> reported) pending,
    required VoidCallback onRetry,
  }) {
    List<F> failedIn(Connector connector) => [
      for (final failure in failures)
        if (failure.connector == connector) failure,
    ];
    final notice = switch ((
      failedIn(Connector.mfp),
      failedIn(Connector.ekklo),
    )) {
      ([_, ...] && final mfp, _) => (intl.mfpNotWritten, mfp),
      (_, [_, ...] && final ekklo) => (intl.ekkloNotWritten, ekklo),
      _ => null,
    };
    if (notice case (final title, final reported)) {
      final blocked = reported.every(
        (failure) =>
            SendFailure.of(failure.error, environment) ==
            SendFailure.blockedInDev,
      );
      return (
        SnackBarContent(
          glyph: SnackBarGlyph.alert,
          title: title,
          detail: switch (blocked) {
            true => intl.writeBlockedInDev,
            false => pending(reported),
          },
          action: switch (blocked) {
            true => null,
            false => (intl.tryAgain, onRetry),
          },
        ),
        _duration,
      );
    }
    return null;
  }
}
