import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/adding/widgets/food_view.dart';
import 'package:fujin/pages/adding/widgets/search_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFoodPage extends HookConsumerWidget {
  const AddFoodPage({required this.date, required this.mfpMealName, super.key});

  final DateTime date;
  final String mfpMealName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opened = useState<({AddDraft draft, String? barcode})?>(null);
    final searching = opened.value == null;
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
                    date: date,
                    mfpMealName: mfpMealName,
                    onOpen: (draft, {barcode}) =>
                        opened.value = (draft: draft, barcode: barcode),
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
                  onBack: () {
                    ref.read(addSearchProvider.notifier).refreshRecents();
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
