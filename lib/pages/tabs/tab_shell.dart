import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/pages/adding/add_shortcut.dart';
import 'package:fujin/pages/journal/selected_day.dart';
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
      navigationShell.goBranch(FujinTab.journal.index);
      ref
          .read(selectedDayProvider.notifier)
          .select(SelectedDay.calendarDay(added.entry.date));
      AddShortcut.added(context, ref, added);
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
      if (await AddShortcut.mealOfNow(context, ref) case final meal?
          when context.mounted) {
        await open(day, meal);
      }
    }

    final canAdd = AddShortcut.possible(ref);

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
