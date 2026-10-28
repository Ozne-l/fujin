import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/sending/send_failure.dart';

extension FujinSnackBar on ScaffoldMessengerState {
  void showFujinSnackBar(SnackBar snackBar) =>
      showSnackBar(snackBar, snackBarAnimationStyle: FujinMotion.snackBar);

  void showProblem(AppLocalizations intl, ReadProblem problem) =>
      showFujinSnackBar(
        SnackBar(content: Text(JournalText.problemHeadline(intl, problem))),
      );

  void showWriteProblem(
    AppLocalizations intl,
    Object error,
    AppEnvironment environment,
  ) => switch (SendFailure.of(error, environment)) {
    SendFailure.blockedInDev => showFujinSnackBar(
      SnackBar(content: Text(intl.writeBlockedInDev)),
    ),
    SendFailure.network ||
    SendFailure.ekkloSession ||
    SendFailure.mfpSession ||
    SendFailure.refused ||
    SendFailure.other => showProblem(intl, ReadProblem.of(error)),
  };
}
