import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/calendar_week.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/day_pill.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:fujin/pages/common/gold_separator.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DayPickerSheet extends HookConsumerWidget {
  const DayPickerSheet({
    required this.selected,
    required this.first,
    required this.last,
    required this.onPicked,
    super.key,
  });

  static const _rows = 6;
  static const _monthsPerYear = 12;

  final DateTime selected;
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final months = _monthsBetween(first, last) + 1;
    final initialPage = _monthsBetween(first, selected);
    final controller = usePageController(initialPage: initialPage);
    final shown = useState(initialPage);

    void turnTo(int page) =>
        unawaited(FujinMotion.turnPage(context, controller, page));

    void pick(DateTime day) {
      Navigator.of(context).pop();
      onPicked(day);
    }

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: context.intl.dayPickerTitle,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            FujinSize.textInset,
            0,
            FujinSize.textInset,
            FujinSpace.s3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FujinSpace.s4,
            children: [
              Row(
                spacing: FujinSpace.s2,
                children: [
                  Expanded(
                    child: Text(
                      TitleText.capitalized(
                        context.intl.dayPickerMonth(_monthOf(shown.value)),
                      ),
                      style: FujinText.hina24.copyWith(
                        color: FujinColorRole.textPrimary,
                      ),
                    ),
                  ),
                  _Turn(
                    visible: shown.value > 0,
                    icon: Icons.chevron_left,
                    tooltip: context.intl.previousMonth,
                    onPressed: () => turnTo(shown.value - 1),
                  ),
                  _Turn(
                    visible: shown.value < months - 1,
                    icon: Icons.chevron_right,
                    tooltip: context.intl.nextMonth,
                    onPressed: () => turnTo(shown.value + 1),
                  ),
                ],
              ),
              const GoldSeparator(volute: true),
              Column(
                spacing: FujinSpace.s2,
                children: [
                  Row(
                    children: [
                      for (final day in CalendarWeek.daysOf(today))
                        Expanded(
                          child: Text(
                            context.intl.weekdayShort(day),
                            textAlign: TextAlign.center,
                            style: FujinText.inter11Medium.copyWith(
                              color: FujinColorRole.textTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: _rows * FujinSize.touchTarget,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: months,
                      onPageChanged: (page) => shown.value = page,
                      itemBuilder: (context, page) => _Month(
                        month: _monthOf(page),
                        selected: selected,
                        today: today,
                        first: first,
                        last: last,
                        onPick: pick,
                      ),
                    ),
                  ),
                ],
              ),
              if (!today.isBefore(first) && !today.isAfter(last))
                TextButton(
                  onPressed: () => pick(today),
                  child: Text(context.intl.journalToday),
                ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _monthOf(int page) => DateTime.utc(first.year, first.month + page);

  static int _monthsBetween(DateTime from, DateTime to) =>
      (to.year - from.year) * _monthsPerYear + to.month - from.month;
}

class _Turn extends StatelessWidget {
  const _Turn({
    required this.visible,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final bool visible;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Visibility(
    visible: visible,
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    child: FujinIconButton(icon: icon, tooltip: tooltip, onPressed: onPressed),
  );
}

class _Month extends StatelessWidget {
  const _Month({
    required this.month,
    required this.selected,
    required this.today,
    required this.first,
    required this.last,
    required this.onPick,
  });

  final DateTime month;
  final DateTime selected;
  final DateTime today;
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    final lead = month.weekday - DateTime.monday;
    final length = DateTime.utc(month.year, month.month + 1, 0).day;
    return Column(
      children: [
        for (var row = 0; row < DayPickerSheet._rows; row++)
          Expanded(
            child: Row(
              children: [
                for (
                  var column = 0;
                  column < CalendarWeek.daysPerWeek;
                  column++
                )
                  Expanded(
                    child: switch (row * CalendarWeek.daysPerWeek +
                        column -
                        lead +
                        1) {
                      final date when date >= 1 && date <= length => _Day(
                        day: DateTime.utc(month.year, month.month, date),
                        selected: selected,
                        today: today,
                        first: first,
                        last: last,
                        onPick: onPick,
                      ),
                      _ => const SizedBox.shrink(),
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({
    required this.day,
    required this.selected,
    required this.today,
    required this.first,
    required this.last,
    required this.onPick,
  });

  final DateTime day;
  final DateTime selected;
  final DateTime today;
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    final chosen = day == selected;
    final inRange = !day.isBefore(first) && !day.isAfter(last);

    return MergeSemantics(
      child: InkResponse(
        onTap: switch (inRange) {
          true => () => onPick(day),
          false => null,
        },
        radius: FujinSize.touchTarget / 2,
        child: Semantics(
          label: context.intl.dayPickerDay(day),
          selected: chosen,
          button: true,
          enabled: inRange,
          excludeSemantics: true,
          child: Center(
            child: Container(
              width: FujinSize.dayRing,
              height: FujinSize.dayRing,
              alignment: Alignment.center,
              decoration: switch (day == today) {
                true => BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FujinColorRole.textLink,
                    width: FujinStroke.dayRing,
                  ),
                ),
                false => null,
              },
              child: DayPill(
                date: context.intl.dayOfMonth(day),
                selected: chosen,
                idleColor: switch (inRange) {
                  true => FujinColorRole.textPrimary,
                  false => FujinColorRole.textDisabled,
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
