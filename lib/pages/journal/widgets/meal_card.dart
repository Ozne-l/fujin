import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/status_counts.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';

class MealCard extends HookWidget {
  const MealCard({required this.meal, required this.onAdd, super.key});

  static const _plusIcon = 'assets/icons/plus.svg';
  static const _foodSeparator = ', ';

  final JournalMeal meal;
  final VoidCallback onAdd;

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
          _title(context.intl),
          Text(
            context.intl.mealEmpty,
            style: FujinText.inter13Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ],
      ),
      (final total, true) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          _title(context.intl),
          _Line(
            leading: Text(
              context.intl.mealProgress(counts.inEkklo, total),
              style: FujinText.inter13Regular.copyWith(
                color: FujinColorRole.textSecondary,
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
                _name(),
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
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: FujinSpace.s1,
            children: [_kilocalories(context.intl), pills],
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
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(
          color: FujinColorRole.borderCard,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: FujinSpace.s3,
                  children: [
                    for (final compared in meal.entries) ...[
                      const Divider(),
                      _EntryRow(compared, key: ValueKey(compared.entry)),
                    ],
                  ],
                ),
              ),
              _ => const SizedBox(width: double.infinity),
            },
          ),
          const SizedBox(height: FujinSpace.s3),
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
                theme: const SvgTheme(currentColor: FujinColorRole.textLink),
                excludeFromSemantics: true,
              ),
              label: Text(context.intl.mealAddFood),
            ),
          ),
        ],
      ),
    );
  }

  Widget _name() => Text(
    meal.name,
    style: FujinText.inter16Medium.copyWith(
      color: FujinColorRole.textPrimary,
    ),
  );

  Widget _kilocalories(AppLocalizations intl) => Text(
    intl.kilocalories(meal.kilocalories),
    style: FujinText.inter15Semibold.copyWith(
      color: FujinColorRole.textPrimary,
    ),
  );

  Widget _title(AppLocalizations intl) =>
      _Line(leading: _name(), trailing: _kilocalories(intl));

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

class _EntryRow extends StatelessWidget {
  const _EntryRow(this.compared, {super.key});

  final ComparedEntry compared;

  @override
  Widget build(BuildContext context) {
    final entry = compared.entry;
    final detail = switch (compared.status) {
      ToUpdate(:final link) => EntryText.linkedServing(context.intl, link),
      InEkklo() || ToSend() => EntryText.macros(context.intl, entry.nutrients),
    };
    final (label, tone, icon) = switch (compared.status) {
      InEkklo() => (context.intl.statusInEkklo, PillTone.validated, null),
      ToSend() => (context.intl.statusToSend, PillTone.attention, null),
      ToUpdate() => (context.intl.statusToUpdate, PillTone.info, Icons.refresh),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s1,
      children: [
        _Line(
          leading: Text(
            entry.food.description,
            style: FujinText.inter15Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
          trailing: Text(
            EntryText.energy(context.intl, entry),
            style: FujinText.inter15Semibold.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
        ),
        _Line(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                EntryText.brandedServing(context.intl, entry),
                style: FujinText.inter13Regular.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textTertiary,
                ),
              ),
            ],
          ),
          trailing: StatusPill(label: label, tone: tone, icon: icon),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.leading, required this.trailing});

  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s3,
    children: [
      Expanded(child: leading),
      trailing,
    ],
  );
}
