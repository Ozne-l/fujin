import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/journal_text.dart';

extension FujinSnackBar on ScaffoldMessengerState {
  void showFujinSnackBar(SnackBar snackBar) =>
      showSnackBar(snackBar, snackBarAnimationStyle: FujinMotion.snackBar);

  void showProblem(AppLocalizations l10n, ReadProblem problem) =>
      showFujinSnackBar(
        SnackBar(content: Text(JournalText.problemHeadline(l10n, problem))),
      );
}
