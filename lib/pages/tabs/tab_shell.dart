import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/adding_possible.dart';
import 'package:fujin/domain/adding/meal_of_the_hour.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/journal_snack_bar.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/undo_add_notifier.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:fujin/pages/tabs/floating_tab_bar.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabShell extends ConsumerWidget {
  const TabShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onAdded(AddedFood added) {
      final day = SelectedDay.calendarDay(added.entry.date);
      navigationShell.goBranch(FujinTab.journal.index);
      ref.read(selectedDayProvider.notifier).select(day);
      ref
        ..invalidate(memoryProvider)
        ..invalidate(mfpDiaryProvider(day))
        ..invalidate(ekkloMealsProvider(day));
      JournalSnackBar.added(
        context,
        added,
        onUndo: () => unawaited(ref.read(undoAddProvider.notifier).undo(added)),
      );
    }

    Future<void> open(DateTime day, String meal) async {
      final exit = await context.push<ScannerExit>(
        FujinRoute.scanner.forMeal(day, meal),
      );
      if (!context.mounted) return;
      switch (exit) {
        case ScannerAdded(added: final food):
          onAdded(food);
        case final ScannerSearch search:
          final food = await context.push<AddedFood>(
            FujinRoute.addFood.forScanSearch(day, meal, search),
          );
          if (food case final food? when context.mounted) onAdded(food);
        case null:
          break;
      }
    }

    Future<void> scan() async {
      final day = ref.read(selectedDayProvider);
      final List<String> names;
      try {
        names = await ref.read(mealNamesProvider.future);
      } on Object catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showProblem(AppLocalizations.of(context), ReadProblem.of(error));
        }
        return;
      }
      if (!context.mounted) return;
      switch (mealOfTheHour(names, ref.read(clockProvider)()) ??
          names.firstOrNull) {
        case final meal?:
          await open(day, meal);
        case null:
          ScaffoldMessenger.of(
            context,
          ).showProblem(AppLocalizations.of(context), ReadProblem.unknown);
      }
    }

    final canAdd = ref.watch(
      journalProvider(ref.watch(selectedDayProvider)).select(
        (journal) => addingPossible(read: journal.value, error: journal.error),
      ),
    );

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: FloatingTabBar(
        selected: FujinTab.values[navigationShell.currentIndex],
        onSelect: (tab) => navigationShell.goBranch(
          tab.index,
          initialLocation: tab.index == navigationShell.currentIndex,
        ),
        onScan: canAdd ? () => unawaited(scan()) : null,
      ),
    );
  }
}
