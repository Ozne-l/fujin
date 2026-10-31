import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/widgets/meal_card_frame.dart';
import 'package:fujin/pages/journal/widgets/meal_rows.dart';
import 'package:fujin/pages/journal/widgets/meal_title.dart';
import 'package:fujin/pages/journal/widgets/stored_row.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoredMealCard extends ConsumerWidget {
  const StoredMealCard({
    required this.meal,
    required this.onAdd,
    required this.groupTag,
    required this.removable,
    required this.onOpen,
    required this.onRemove,
    this.removedEntryId,
    super.key,
  });

  final DiaryMeal meal;
  final VoidCallback onAdd;
  final Object groupTag;
  final bool removable;
  final String? removedEntryId;
  final ValueChanged<LoggedEntry> onOpen;
  final ValueChanged<LoggedEntry> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaving = MealRows.shown(
      meal.leaving,
      ref.watch(
        backgroundWriteProvider.select((state) => state.ekkloRemovalIds),
      ),
    );
    final empty = meal.entries.isEmpty && leaving.isEmpty;
    return MealCardFrame(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          MealTitle(name: meal.name, kilocalories: meal.kilocalories),
          if (empty)
            Text(
              context.intl.mealEmpty,
              style: FujinText.inter13Regular.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
        ],
      ),
      body: switch (empty) {
        false => Padding(
          padding: const EdgeInsets.only(top: FujinSpace.s3),
          child: MealRows<LoggedEntry>(
            entries: meal.entries,
            leaving: leaving,
            idOf: (logged) => logged.entry.id,
            rowOf: StoredRow.new,
            groupTag: groupTag,
            removable: removable,
            removedEntryId: removedEntryId,
            onOpen: onOpen,
            onRemove: onRemove,
            ekklo: false,
          ),
        ),
        true => const SizedBox(width: double.infinity, height: FujinSpace.s3),
      },
      onAdd: onAdd,
    );
  }
}
