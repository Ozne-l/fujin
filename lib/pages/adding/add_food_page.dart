import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/adding/widgets/food_view.dart';
import 'package:fujin/pages/adding/widgets/search_view.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFoodPage extends HookConsumerWidget {
  const AddFoodPage({
    required this.date,
    required this.mfpMealName,
    this.scan,
    super.key,
  });

  final DateTime date;
  final String mfpMealName;
  final ScannerSearch? scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opened = useState<({AddDraft draft, String? barcode})?>(null);
    final scanned = useState(scan);
    final searching = opened.value == null;

    Future<void> openScanner() async {
      final exit = await context.push<ScannerExit>(
        FujinRoute.scanner.forMeal(date, mfpMealName),
      );
      if (!context.mounted) return;
      switch (exit) {
        case ScannerAdded(:final added):
          context.pop(added);
        case final ScannerSearch search:
          scanned.value = search;
        case null:
          break;
      }
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Offstage(
              offstage: !searching,
              child: TickerMode(
                enabled: searching,
                child: ExcludeFocus(
                  excluding: !searching,
                  child: SearchView(
                    key: ValueKey(scanned.value),
                    date: date,
                    mfpMealName: mfpMealName,
                    scan: scanned.value,
                    onOpen: (draft, {barcode}) =>
                        opened.value = (draft: draft, barcode: barcode),
                    onScan: () => unawaited(openScanner()),
                  ),
                ),
              ),
            ),
            if (opened.value case (:final draft, :final barcode))
              Positioned.fill(
                child: FoodView(
                  key: ValueKey(draft),
                  initial: draft,
                  barcode: barcode,
                  barcodeToLink: scanned.value?.barcode,
                  onBack: () {
                    ref
                        .read(addSearchProvider(scanned.value).notifier)
                        .refreshRecents();
                    opened.value = null;
                  },
                  onLeave: context.pop,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
