import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/pages/adding/add_shortcut.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:fujin/pages/tabs/floating_tab_bar.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabShell extends HookConsumerWidget {
  const TabShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const double _minimizeTravel = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minimized = useState(false);
    final travel = useRef<double>(0);

    bool onScroll(ScrollUpdateNotification notification) {
      final metrics = notification.metrics;
      double inRange(double pixels) =>
          pixels.clamp(metrics.minScrollExtent, metrics.maxScrollExtent);
      final delta =
          inRange(metrics.pixels) -
          inRange(metrics.pixels - (notification.scrollDelta ?? 0));
      if (metrics.axis != Axis.vertical || delta == 0) return false;
      travel.value = switch (travel.value.sign == delta.sign) {
        true => travel.value + delta,
        false => delta,
      };
      minimized.value = switch (travel.value) {
        _ when metrics.pixels <= metrics.minScrollExtent => false,
        > _minimizeTravel => true,
        < -_minimizeTravel => false,
        _ => minimized.value,
      };
      return false;
    }

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
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: onScroll,
        child: navigationShell,
      ),
      bottomNavigationBar: FloatingTabBar(
        selected: FujinTab.values[navigationShell.currentIndex],
        minimized: minimized.value,
        onSelect: (tab) {
          minimized.value = false;
          travel.value = 0;
          navigationShell.goBranch(
            tab.index,
            initialLocation: tab.index == navigationShell.currentIndex,
          );
        },
        onScan: canAdd ? () => unawaited(scan()) : null,
      ),
    );
  }
}
