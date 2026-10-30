import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/widgets/connector_pill.dart';
import 'package:fujin/pages/journal/widgets/entry_row.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiaryMealCard extends ConsumerWidget {
  const DiaryMealCard({required this.meal, this.note, super.key});

  final DiaryMeal meal;
  final String? note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failed = ref.watch(
      backgroundWriteProvider.select((state) => state.mfpFailedIds),
    );
    final secondary = FujinText.inter13Regular.copyWith(
      color: context.colors.textSecondary,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: context.colors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          SplitLine(
            leading: Text(
              meal.name,
              style: FujinText.inter16Medium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            trailing: Text(
              context.intl.kilocalories(meal.kilocalories),
              style: FujinText.inter15Semibold.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (note case final note?) Text(note, style: secondary),
          switch (meal.entries) {
            [] => Text(context.intl.mealEmpty, style: secondary),
            final entries => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s3,
              children: [
                for (final entry in entries) ...[
                  const Divider(),
                  EntryRow(
                    key: ValueKey(entry),
                    entry: entry,
                    detail: EntryText.macros(
                      context.intl,
                      entry.entry.nutrients,
                    ),
                    pills: [
                      if (MfpWrite.of(entry) case MfpAdd() || MfpEdit())
                        ConnectorPill(
                          connector: Connector.mfp,
                          failed: failed.contains(entry.entry.id),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          },
        ],
      ),
    );
  }
}
