import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/status_counts.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/food_text.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/widgets/compared_row.dart';
import 'package:fujin/pages/journal/widgets/meal_card_frame.dart';
import 'package:fujin/pages/journal/widgets/meal_rows.dart';
import 'package:fujin/pages/journal/widgets/meal_title.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MealCard extends HookConsumerWidget {
  const MealCard({
    required this.meal,
    required this.onAdd,
    required this.groupTag,
    required this.removable,
    required this.onOpen,
    required this.onRemove,
    this.removedEntryId,
    super.key,
  });

  static const _foodSeparator = ', ';

  final JournalMeal meal;
  final VoidCallback onAdd;
  final Object groupTag;
  final bool removable;
  final String? removedEntryId;
  final ValueChanged<ComparedEntry> onOpen;
  final ValueChanged<ComparedEntry> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final removals = ref.watch(
      backgroundWriteProvider.select((state) => state.ekkloRemovalIds),
    );
    final leaving = MealRows.shown(meal.leaving, removals);
    final counts = ref.watch(
      backgroundWriteProvider.select(
        (state) => meal.counts(sending: state.ekkloSendIds),
      ),
    );
    final settled = counts.total > 0 && counts.pending == 0;
    final toggled = useState<({bool settled, bool open})?>(null);
    final open = switch (toggled.value) {
      (settled: final wasSettled, :final open)? when wasSettled == settled =>
        open,
      _ => !settled,
    };
    final pills = Wrap(
      spacing: FujinSpace.s1,
      children: [
        for (final (label, tone) in _mealPills(context.intl, counts))
          StatusPill(key: ValueKey(tone), label: label, tone: tone),
      ],
    );
    final header = switch ((counts.total, open)) {
      (0, _) => MealTitle(
        name: meal.name,
        kilocalories: meal.kilocalories,
        empty: true,
      ),
      (final total, true) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          MealTitle(name: meal.name, kilocalories: meal.kilocalories),
          SplitLine(
            leading: Text(
              context.intl.mealProgress(counts.inEkklo, total),
              style: FujinText.inter13Regular.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            trailing: pills,
          ),
        ],
      ),
      (final total, false) => Row(
        spacing: FujinSpace.s3,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s2,
              children: [
                MealTitle.nameText(context, meal.name),
                Text(
                  context.intl.mealFolded(
                    counts.inEkklo,
                    total,
                    meal.entries
                        .map(
                          (compared) => FoodText.name(
                            context.intl,
                            compared.logged.foodName,
                          ),
                        )
                        .join(_foodSeparator),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FujinText.inter13Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: FujinSpace.s1,
            children: [
              MealTitle.kilocaloriesText(context, meal.kilocalories),
              pills,
            ],
          ),
        ],
      ),
    };
    return MealCardFrame(
      header: switch (counts.total) {
        0 => header,
        _ => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => toggled.value = (settled: settled, open: !open),
          child: header,
        ),
      },
      body: AnimatedSize(
        duration: FujinMotion.mealFold.duration,
        curve: FujinMotion.mealFold.curve,
        alignment: Alignment.topCenter,
        child: switch ((open, [...meal.entries, ...leaving])) {
          (true, [_, ...]) => Padding(
            padding: const EdgeInsets.only(top: FujinSpace.s3),
            child: MealRows<ComparedEntry>(
              entries: meal.entries,
              leaving: leaving,
              idOf: (compared) => compared.entryId,
              rowOf: ComparedRow.new,
              groupTag: groupTag,
              removable: removable,
              removedEntryId: removedEntryId,
              onOpen: onOpen,
              onRemove: onRemove,
            ),
          ),
          _ => MealCardFrame.emptyBody,
        },
      ),
      onAdd: onAdd,
    );
  }

  static List<(String, PillTone)> _mealPills(
    AppLocalizations intl,
    StatusCounts counts,
  ) => switch ((counts.toSend, counts.toUpdate, counts.sending)) {
    (0, 0, 0) => [(intl.statusInEkklo, PillTone.validated)],
    (0, 0, _) => [],
    (final send, 0, _) => [(intl.mealToSend(send), PillTone.attention)],
    (0, final update, _) => [(intl.mealToUpdate(update), PillTone.info)],
    (final send, final update, _) => [
      (intl.mealToSend(send), PillTone.attention),
      (intl.mealToUpdate(update), PillTone.info),
    ],
  };
}
