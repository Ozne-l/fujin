import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/replacement.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/writing/write_failure.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/journal/removal_reason.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/sending/send_failure.dart';

abstract final class JournalSnackBar {
  static const undoWindow = Duration(seconds: 8);
  static const _settledDuration = Duration(seconds: 4);
  static const _padding = EdgeInsetsDirectional.fromSTEB(
    FujinSpace.s3,
    FujinSpace.s2,
    FujinSpace.s2,
    FujinSpace.s2,
  );

  static void added(
    BuildContext context,
    AddedFood added, {
    required VoidCallback onUndo,
  }) {
    final entry = added.entry;
    show(
      context,
      duration: undoWindow,
      content: SnackBarContent(
        glyph: SnackBarGlyph.done,
        title: context.intl.foodAdded(productName(entry)),
        detail: entry.mealName,
        action: (context.intl.undoAdd, onUndo),
      ),
    );
  }

  static void removed(BuildContext context, RemoveEntryDone done) {
    final entry = done.removal.entry;
    final intl = context.intl;
    final (glyph, title, detail) = switch (done.removal.reason) {
      RemovalReason.undoAdd => (
        SnackBarGlyph.undone,
        intl.addUndone,
        entry.mealName,
      ),
      RemovalReason.delete => (
        SnackBarGlyph.done,
        intl.foodDeleted(productName(entry)),
        entry.mealName,
      ),
    };
    show(
      context,
      duration: _settledDuration,
      content: SnackBarContent(glyph: glyph, title: title, detail: detail),
    );
  }

  static void edited(
    BuildContext context,
    EditedFood edited, {
    required VoidCallback onUndo,
    required VoidCallback onSee,
  }) {
    final intl = context.intl;
    final entry = edited.entry;
    final food = productName(entry);
    final (title, detail, action) = switch ((
      SelectedDay.calendarDay(entry.entry.date) ==
          SelectedDay.calendarDay(edited.original.entry.date),
      entry.mealName == edited.original.mealName,
    )) {
      (false, _) => (
        intl.foodMoved(food),
        intl.foodMovedToDayDetail(entry.mealName, entry.entry.date),
        (intl.foodMovedSee, onSee),
      ),
      (true, false) => (
        intl.foodMoved(food),
        entry.mealName,
        null,
      ),
      (true, true) => (
        intl.foodEdited(food),
        entry.mealName,
        (intl.undoAdd, onUndo),
      ),
    };
    show(
      context,
      duration: undoWindow,
      content: SnackBarContent(
        glyph: SnackBarGlyph.done,
        title: title,
        detail: detail,
        action: action,
      ),
    );
  }

  static void replaced(BuildContext context, List<Replacement> replaced) {
    final intl = context.intl;
    final detail = switch (replaced) {
      [] => null,
      [ReplacedDeletion(:final logged)] => intl.replacedDeletion(
        productName(logged),
      ),
      [ReplacedEdit(:final logged, :final before)] => switch ((
        intl.servingLine(
          before.servings,
          before.servingValue,
          before.servingUnit,
        ),
        EntryText.serving(intl, logged),
      )) {
        (final was, final now) when was != now => intl.replacedChange(
          productName(logged),
          was,
          now,
        ),
        _ => intl.replacedChange(
          productName(logged),
          before.mealName,
          logged.mealName,
        ),
      },
      _ => intl.replacedMany(replaced.length),
    };
    if (detail case final detail?) {
      show(
        context,
        duration: _settledDuration,
        content: SnackBarContent(
          glyph: SnackBarGlyph.refresh,
          title: intl.replacedTitle,
          detail: detail,
        ),
      );
    }
  }

  static void notWritten(
    BuildContext context,
    List<WriteFailure> failures,
    AppEnvironment environment, {
    required VoidCallback onRetry,
  }) {
    final intl = context.intl;
    List<WriteFailure> shown(bool Function(WriteFailure failure) side) => [
      for (final failure in failures)
        if (side(failure) &&
            SendFailure.of(failure.error, environment) != SendFailure.network)
          failure,
    ];
    final mfp = shown((failure) => failure is MfpNotWritten);
    final ekklo = shown((failure) => failure is EkkloNotWritten);
    final notice = switch ((mfp, ekklo)) {
      ([_, ...], _) => (intl.mfpNotWritten, mfp),
      (_, [_, ...]) => (intl.ekkloNotWritten, ekklo),
      _ => null,
    };
    if (notice case (final title, final reported)) {
      final blocked = reported.every(
        (failure) =>
            SendFailure.of(failure.error, environment) ==
            SendFailure.blockedInDev,
      );
      show(
        context,
        duration: undoWindow,
        content: SnackBarContent(
          glyph: SnackBarGlyph.alert,
          title: title,
          detail: switch ((blocked, reported)) {
            (true, _) => intl.writeBlockedInDev,
            (false, [final failure]) => intl.foodStillPending(
              productName(failure.logged),
            ),
            (false, _) => intl.foodsStillPending(reported.length),
          },
          action: switch (blocked) {
            true => null,
            false => (intl.tryAgain, onRetry),
          },
        ),
      );
    }
  }

  static void show(
    BuildContext context, {
    required Widget content,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showFujinSnackBar(
        SnackBar(duration: duration, padding: _padding, content: content),
      );
  }
}
