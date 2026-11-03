import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/replacement.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/writing/write_failure.dart';
import 'package:fujin/domain/writing/writer_state.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/food_text.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/journal/removal_reason.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
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
        title: context.intl.foodAdded(
          FoodText.name(context.intl, productName(entry)),
        ),
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
        intl.foodDeleted(FoodText.name(intl, productName(entry))),
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
    final food = FoodText.name(intl, productName(entry));
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

  static void written(
    BuildContext context,
    WriterIdle idle,
    AppEnvironment environment, {
    required VoidCallback onRetry,
  }) {
    final notices = [
      ?_replaced(context.intl, idle.replaced),
      ?_notWritten(
        context.intl,
        [...idle.stopped(environment)],
        environment,
        onRetry: onRetry,
      ),
    ];
    if (notices.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context)..clearSnackBars();
    for (final (content, duration) in notices) {
      messenger.showFujinSnackBar(_snackBar(content, duration));
    }
  }

  static (Widget, Duration)? _replaced(
    AppLocalizations intl,
    List<Replacement> replaced,
  ) {
    final detail = switch (replaced) {
      [] => null,
      [ReplacedDeletion(:final logged)] => intl.replacedDeletion(
        FoodText.name(intl, productName(logged)),
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
          FoodText.name(intl, productName(logged)),
          was,
          now,
        ),
        _ => intl.replacedChange(
          FoodText.name(intl, productName(logged)),
          before.mealName,
          logged.mealName,
        ),
      },
      _ => intl.replacedMany(replaced.length),
    };
    return switch (detail) {
      final detail? => (
        SnackBarContent(
          glyph: SnackBarGlyph.refresh,
          title: intl.replacedTitle,
          detail: detail,
        ),
        _settledDuration,
      ),
      null => null,
    };
  }

  static (Widget, Duration)? _notWritten(
    AppLocalizations intl,
    List<WriteFailure> failures,
    AppEnvironment environment, {
    required VoidCallback onRetry,
  }) {
    final mfp = [...failures.whereType<MfpNotWritten>()];
    final ekklo = [...failures.whereType<EkkloNotWritten>()];
    final notice = switch ((mfp, ekklo)) {
      ([_, ...], _) => (intl.mfpNotWritten, mfp),
      (_, [_, ...]) => (intl.ekkloNotWritten, ekklo),
      _ => null,
    };
    if (notice case (final title, final List<WriteFailure> reported)) {
      final blocked = reported.every(
        (failure) =>
            SendFailure.of(failure.error, environment) ==
            SendFailure.blockedInDev,
      );
      return (
        SnackBarContent(
          glyph: SnackBarGlyph.alert,
          title: title,
          detail: switch ((blocked, reported)) {
            (true, _) => intl.writeBlockedInDev,
            (false, [final failure]) => intl.foodStillPending(
              FoodText.name(intl, productName(failure.logged)),
            ),
            (false, _) => intl.foodsStillPending(reported.length),
          },
          action: switch (blocked) {
            true => null,
            false => (intl.tryAgain, onRetry),
          },
        ),
        undoWindow,
      );
    }
    return null;
  }

  static void show(
    BuildContext context, {
    required Widget content,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showFujinSnackBar(_snackBar(content, duration));
  }

  static SnackBar _snackBar(Widget content, Duration duration) =>
      SnackBar(duration: duration, padding: _padding, content: content);
}
