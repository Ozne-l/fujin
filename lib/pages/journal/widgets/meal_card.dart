import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/status_counts.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/journal/widgets/meal_rows.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';

class MealCard extends HookWidget {
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

  static const _plusIcon = 'assets/icons/plus.svg';
  static const _foodSeparator = ', ';

  final JournalMeal meal;
  final VoidCallback onAdd;
  final Object groupTag;
  final bool removable;
  final String? removedEntryId;
  final ValueChanged<ComparedEntry> onOpen;
  final ValueChanged<ComparedEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final counts = meal.counts;
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
      (0, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          _title(context.intl, context.colors),
          Text(
            context.intl.mealEmpty,
            style: FujinText.inter13Regular.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
      (final total, true) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          _title(context.intl, context.colors),
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
                _name(context.colors),
                Text(
                  context.intl.mealFolded(
                    counts.inEkklo,
                    total,
                    meal.entries
                        .map((compared) => compared.entry.food.description)
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
            children: [_kilocalories(context.intl, context.colors), pills],
          ),
        ],
      ),
    };
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s5,
        FujinSpace.s4,
        FujinSpace.s5,
        FujinSpace.s2,
      ),
      decoration: BoxDecoration(
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(
          color: context.colors.borderCard,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          switch (counts.total) {
            0 => header,
            _ => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => toggled.value = (settled: settled, open: !open),
              child: header,
            ),
          },
          AnimatedSize(
            duration: FujinMotion.mealFold.duration,
            curve: FujinMotion.mealFold.curve,
            alignment: Alignment.topCenter,
            child: switch ((open, meal.entries)) {
              (true, [_, ...]) => Padding(
                padding: const EdgeInsets.only(top: FujinSpace.s3),
                child: MealRows(
                  entries: meal.entries,
                  groupTag: groupTag,
                  removable: removable,
                  removedEntryId: removedEntryId,
                  onOpen: onOpen,
                  onRemove: onRemove,
                ),
              ),
              _ => const SizedBox(
                width: double.infinity,
                height: FujinSpace.s3,
              ),
            },
          ),
          const Divider(),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onAdd,
              style: TextButton.styleFrom(
                textStyle: FujinText.inter14Medium,
                padding: EdgeInsets.zero,
              ),
              icon: SvgPicture.asset(
                _plusIcon,
                width: FujinSize.tileIcon,
                height: FujinSize.tileIcon,
                theme: SvgTheme(currentColor: context.colors.textLink),
                excludeFromSemantics: true,
              ),
              label: Text(context.intl.mealAddFood),
            ),
          ),
        ],
      ),
    );
  }

  Widget _name(FujinColors colors) => Text(
    meal.name,
    style: FujinText.inter16Medium.copyWith(
      color: colors.textPrimary,
    ),
  );

  Widget _kilocalories(AppLocalizations intl, FujinColors colors) => Text(
    intl.kilocalories(meal.kilocalories),
    style: FujinText.inter15Semibold.copyWith(
      color: colors.textPrimary,
    ),
  );

  Widget _title(AppLocalizations intl, FujinColors colors) =>
      SplitLine(leading: _name(colors), trailing: _kilocalories(intl, colors));

  static List<(String, PillTone)> _mealPills(
    AppLocalizations intl,
    StatusCounts counts,
  ) => switch ((counts.toSend, counts.toUpdate)) {
    (0, 0) => [(intl.statusInEkklo, PillTone.validated)],
    (final send, 0) => [(intl.mealToSend(send), PillTone.attention)],
    (0, final update) => [(intl.mealToUpdate(update), PillTone.info)],
    (final send, final update) => [
      (intl.mealToSend(send), PillTone.attention),
      (intl.mealToUpdate(update), PillTone.info),
    ],
  };
}
