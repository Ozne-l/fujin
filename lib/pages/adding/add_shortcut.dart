import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/adding_possible.dart';
import 'package:fujin/domain/adding/meal_of_the_hour.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/journal_snack_bar.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/undo_add_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract final class AddShortcut {
  static bool possible(WidgetRef ref) => ref.watch(
    journalProvider(ref.watch(selectedDayProvider)).select(
      (journal) => addingPossible(read: journal.value, error: journal.error),
    ),
  );

  static Future<String?> mealOfNow(BuildContext context, WidgetRef ref) async {
    final List<String> names;
    try {
      names = await ref.read(mealNamesProvider.future);
    } on Object catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showProblem(context.intl, ReadProblem.of(error));
      }
      return null;
    }
    if (!context.mounted) return null;
    final meal =
        mealOfTheHour(names, ref.read(clockProvider)()) ?? names.firstOrNull;
    if (meal == null) {
      ScaffoldMessenger.of(
        context,
      ).showProblem(context.intl, ReadProblem.unknown);
    }
    return meal;
  }

  static void added(BuildContext context, WidgetRef ref, AddedFood added) {
    final day = SelectedDay.calendarDay(added.entry.date);
    final undo = ref.read(undoAddProvider.notifier);
    ref
      ..invalidate(memoryProvider)
      ..invalidate(mfpDiaryProvider(day))
      ..invalidate(ekkloMealsProvider(day));
    JournalSnackBar.added(
      context,
      added,
      onUndo: () => unawaited(undo.undo(added)),
    );
  }
}
