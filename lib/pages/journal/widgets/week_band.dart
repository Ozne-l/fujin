import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';
import 'package:fujin/domain/journal/calendar_week.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/widgets/day_ring.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WeekBand extends HookConsumerWidget {
  const WeekBand({
    required this.selected,
    required this.today,
    required this.goals,
    required this.onSelect,
    super.key,
  });

  static const _visibleDays = 8;

  final DateTime selected;
  final DateTime today;
  final Goals? goals;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final thisWeek = CalendarWeek.mondayOf(today);
    final selectedPage = CalendarWeek.weeksBetween(selected, today);
    final controller = usePageController(
      initialPage: selectedPage,
      viewportFraction: (_visibleDays - 1) / _visibleDays,
    );
    final shown = useState(selectedPage);
    final turning = useRef(false);

    Future<void> turnTo(int page) async {
      turning.value = true;
      await controller.animateToPage(
        page,
        duration: FujinMotion.weekTurn.duration,
        curve: FujinMotion.weekTurn.curve,
      );
      turning.value = false;
    }

    useEffect(() {
      if (controller.hasClients && shown.value != selectedPage) {
        shown.value = selectedPage;
        unawaited(turnTo(selectedPage));
      }
      return null;
    }, [selectedPage]);

    void selectWeek(int weeksBack) => onSelect(
      CalendarWeek.sameWeekday(selected, weeksBack: weeksBack, today: today),
    );

    void showPage(int page) {
      shown.value = page;
      if (turning.value) return;
      selectWeek(page);
    }

    final kilocalories = ref.watch(
      weekKilocaloriesProvider(CalendarWeek.weeksBefore(thisWeek, shown.value)),
    );

    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.previousWeek): () =>
            selectWeek(shown.value + 1),
        if (shown.value > 0)
          CustomSemanticsAction(label: l10n.nextWeek): () =>
              selectWeek(shown.value - 1),
      },
      child: SizedBox(
        height: FujinSize.weekBand,
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              reverse: true,
              onPageChanged: showPage,
              itemBuilder: (context, page) => _Week(
                days: CalendarWeek.daysOf(
                  CalendarWeek.weeksBefore(thisWeek, page),
                ),
                selected: selected,
                today: today,
                goals: goals,
                kilocalories: switch (page == shown.value) {
                  true => kilocalories,
                  false => const AsyncLoading(),
                },
                onSelect: onSelect,
              ),
            ),
            const _Fade(alignment: AlignmentDirectional.centerStart),
            if (shown.value > 0)
              const _Fade(alignment: AlignmentDirectional.centerEnd),
          ],
        ),
      ),
    );
  }
}

class _Week extends StatelessWidget {
  const _Week({
    required this.days,
    required this.selected,
    required this.today,
    required this.goals,
    required this.kilocalories,
    required this.onSelect,
  });

  final List<DateTime> days;
  final DateTime selected;
  final DateTime today;
  final Goals? goals;
  final AsyncValue<Map<DateTime, double?>> kilocalories;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final day in days)
        Expanded(
          child: _Day(
            day: day,
            selected: day == selected,
            state: _state(day),
            progress: switch ((goals, kilocalories.value?[day])) {
              (final goals?, final eaten?) => eaten / goals.kilocalories,
              _ => 0,
            },
            onTap: switch (day.isAfter(today)) {
              true => null,
              false => () => onSelect(day),
            },
          ),
        ),
    ],
  );

  DayGoalState _state(DateTime day) => switch (kilocalories) {
    _ when day.isAfter(today) => DayGoalState.upcoming,
    AsyncValue(value: final eaten?) => DayGoalState.of(
      day: day,
      today: today,
      goals: goals,
      kilocalories: eaten[day],
    ),
    AsyncError() => DayGoalState.noGoal,
    _ => switch (goals) {
      null => DayGoalState.noGoal,
      Goals() => DayGoalState.inProgress,
    },
  };
}

class _Day extends StatelessWidget {
  const _Day({
    required this.day,
    required this.selected,
    required this.state,
    required this.progress,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final DayGoalState state;
  final double progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkResponse(
      onTap: onTap,
      radius: FujinSize.touchTarget / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: FujinSpace.s2,
        children: [
          Text(
            l10n.weekdayShort(day),
            style: switch (selected) {
              true => FujinText.inter11Semibold.copyWith(
                color: FujinColorRole.textPrimary,
              ),
              false => FujinText.inter11Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            },
          ),
          DayRing(
            date: l10n.dayOfMonth(day),
            state: state,
            progress: progress,
            selected: selected,
          ),
        ],
      ),
    );
  }
}

class _Fade extends StatelessWidget {
  const _Fade({required this.alignment});

  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: IgnorePointer(
      child: Container(
        width: FujinSize.bandFade,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: alignment,
            end: -alignment,
            colors: [
              FujinColorRole.backgroundScrollFade,
              FujinColorRole.backgroundScrollFade.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    ),
  );
}
