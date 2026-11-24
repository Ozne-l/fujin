import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/sending/send_failure.dart';

extension FujinSnackBar on ScaffoldMessengerState {
  static const alertDuration = Duration(seconds: 4);
  static const settledDuration = Duration(seconds: 4);
  static const _noticePadding = EdgeInsetsDirectional.fromSTEB(
    FujinSpace.s3,
    FujinSpace.s2,
    FujinSpace.s2,
    FujinSpace.s2,
  );

  void showNotice(Widget content, {required Duration duration}) =>
      showNotices([(content, duration)]);

  void showNotices(Iterable<(Widget, Duration)> notices) {
    clearSnackBars();
    for (final (content, duration) in notices) {
      showSnackBar(
        SnackBar(
          duration: duration,
          padding: _noticePadding,
          content: content,
        ),
        snackBarAnimationStyle: FujinMotion.snackBar,
      );
    }
  }

  void showAlert(String title, {String? detail}) => showNotice(
    SnackBarContent(glyph: SnackBarGlyph.alert, title: title, detail: detail),
    duration: alertDuration,
  );

  void showProblem(AppLocalizations intl, ReadProblem problem) =>
      showAlert(JournalText.problemHeadline(intl, problem));

  void showWriteProblem(
    AppLocalizations intl,
    Object error,
    AppEnvironment environment,
  ) => switch (SendFailure.of(error, environment)) {
    SendFailure.blockedInDev => showAlert(intl.writeBlockedInDev),
    SendFailure.network ||
    SendFailure.ekkloSession ||
    SendFailure.mfpSession ||
    SendFailure.refused ||
    SendFailure.other => showProblem(intl, ReadProblem.of(error)),
  };
}
