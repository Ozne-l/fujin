import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';

abstract final class JournalSnackBar {
  static const undoWindow = Duration(seconds: 8);
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
    final l10n = AppLocalizations.of(context);
    final entry = added.entry;
    show(
      context,
      duration: undoWindow,
      content: SnackBarContent(
        glyph: SnackBarGlyph.done,
        title: l10n.foodAdded(productName(entry.food)),
        detail: switch (added.ekkloWritten) {
          true => l10n.foodAddedBothSides(entry.mealName),
          false => l10n.foodAddedMfpOnly(entry.mealName),
        },
        action: (l10n.undoAdd, onUndo),
      ),
    );
  }

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
