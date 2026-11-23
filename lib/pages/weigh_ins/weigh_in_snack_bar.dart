import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/weigh_in_writer_state.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/not_written_notice.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_text.dart';

abstract final class WeighInSnackBar {
  static void saved(
    BuildContext context,
    WeighIn weighIn, {
    required DateTime today,
  }) => ScaffoldMessenger.of(context).showNotice(
    duration: FujinSnackBar.settledDuration,
    SnackBarContent(
      glyph: SnackBarGlyph.done,
      title: context.intl.weighInSaved,
      detail: WeighInText.saved(context.intl, weighIn, today: today),
    ),
  );

  static void removed(
    BuildContext context,
    WeighIn weighIn, {
    required DateTime today,
  }) => ScaffoldMessenger.of(context).showNotice(
    duration: FujinSnackBar.settledDuration,
    SnackBarContent(
      glyph: SnackBarGlyph.done,
      title: context.intl.weighInDeleted,
      detail: WeighInText.deleted(context.intl, weighIn, today: today),
    ),
  );

  static void written(
    BuildContext context,
    WeighInWriterIdle idle,
    AppEnvironment environment, {
    required DateTime today,
    required VoidCallback onRetry,
  }) {
    final intl = context.intl;
    if (NotWrittenNotice.of(
          intl,
          idle.stopped,
          environment,
          pending: (reported) =>
              WeighInText.stillPending(intl, reported, today: today),
          onRetry: onRetry,
        )
        case final notice?) {
      ScaffoldMessenger.of(context).showNotices([notice]);
    }
  }
}
