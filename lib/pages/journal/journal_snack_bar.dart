import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/journal/removal_reason.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:fujin/pages/journal/selected_day.dart';

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
        title: context.intl.foodAdded(productName(entry.food)),
        detail: switch (added.ekkloWritten) {
          true => context.intl.foodAddedBothSides(entry.mealName),
          false => context.intl.foodAddedMfpOnly(entry.mealName),
        },
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
        intl.addUndoneDetail,
      ),
      RemovalReason.delete => (
        SnackBarGlyph.done,
        intl.foodDeleted(productName(entry.food)),
        switch (done.ekkloRemoved) {
          true => intl.foodDeletedDetail(entry.mealName),
          false => intl.foodDeletedMfpOnlyDetail(entry.mealName),
        },
      ),
    };
    show(
      context,
      duration: _settledDuration,
      content: SnackBarContent(glyph: glyph, title: title, detail: detail),
    );
  }

  static void removeFailed(
    BuildContext context,
    RemoveEntryFailed failed, {
    required VoidCallback onRetry,
  }) {
    final intl = context.intl;
    final food = productName(failed.removal.entry.food);
    final reason = switch (failed.blockedInDev) {
      true => intl.writeBlockedInDev,
      false => JournalText.problemHeadline(intl, failed.problem),
    };
    final (title, detail) = switch ((
      failed.removedFromEkklo,
      failed.removal.reason,
    )) {
      (true, _) => (intl.addStillInMfp, intl.addStillInMfpDetail(food)),
      (false, RemovalReason.undoAdd) => (intl.addNotUndone, reason),
      (false, RemovalReason.delete) => (
        intl.foodNotDeleted(food),
        switch (failed.blockedInDev) {
          true => reason,
          false => intl.foodNotDeletedDetail,
        },
      ),
    };
    show(
      context,
      duration: undoWindow,
      content: SnackBarContent(
        glyph: SnackBarGlyph.alert,
        title: title,
        detail: detail,
        action: switch (failed.blockedInDev) {
          true => null,
          false => (intl.tryAgain, onRetry),
        },
      ),
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
    final food = productName(entry.food);
    final serving = EntryText.serving(intl, entry);
    final (title, detail, action) = switch ((
      SelectedDay.calendarDay(entry.date) ==
          SelectedDay.calendarDay(edited.original.date),
      entry.mealName == edited.original.mealName,
    )) {
      (false, _) => (
        intl.foodMoved(food),
        intl.foodMovedToDayDetail(entry.mealName, entry.date),
        (intl.foodMovedSee, onSee),
      ),
      (true, false) => (
        intl.foodMoved(food),
        switch (edited.ekkloWritten) {
          true => intl.foodMovedToMealDetail(entry.mealName),
          false => intl.foodAddedMfpOnly(entry.mealName),
        },
        null,
      ),
      (true, true) => (
        intl.foodEdited(food),
        switch (edited.ekkloWritten) {
          true => intl.foodEditedDetail(serving),
          false => intl.foodEditedMfpOnlyDetail(serving),
        },
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

  static void ekkloNotUpdated(
    BuildContext context,
    EditedFood edited, {
    required VoidCallback onRetry,
  }) {
    final intl = context.intl;
    final kept = switch (edited.link) {
      final link? => EntryText.linkServing(intl, link),
      null => EntryText.serving(intl, edited.original),
    };
    _failed(
      context,
      title: intl.ekkloNotUpdated,
      detail: intl.ekkloNotUpdatedDetail(productName(edited.entry.food), kept),
      onRetry: onRetry,
    );
  }

  static void oldEntryKept(
    BuildContext context,
    EditedFood edited, {
    required VoidCallback onRetry,
  }) => _failed(
    context,
    title: context.intl.editOldEntryKept(productName(edited.entry.food)),
    detail: context.intl.editOldEntryKeptDetail,
    onRetry: onRetry,
  );

  static void _failed(
    BuildContext context, {
    required String title,
    required String detail,
    required VoidCallback onRetry,
  }) => show(
    context,
    duration: undoWindow,
    content: SnackBarContent(
      glyph: SnackBarGlyph.alert,
      title: title,
      detail: detail,
      action: (context.intl.tryAgain, onRetry),
    ),
  );

  static void show(
    BuildContext context, {
    required Widget content,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showFujinSnackBar(
        SnackBar(duration: duration, padding: _padding, content: content),
      );
  }
}
