import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/hints/hint.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';
import 'package:fujin/domain/journal/calendar_week.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/journal/logged_kilocalories.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/widgets/day_ring.dart';
import 'package:fujin/pages/journal/widgets/week_band_hint.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class WeekBand extends HookConsumerWidget {
  const WeekBand({
    required this.selected,
    required this.today,
    required this.goals,
    required this.onSelect,
    super.key,
  });

  static const _visibleDays = 8;
  static const _hintDuration = Duration(seconds: 4);
  static const _nudge = StepSequence<double>(
    [0, FujinSize.bandNudge, 0],
    motion: FujinMotion.bandNudge,
  );

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
    final hints = ref.watch(hintRepositoryProvider);
    final hinting = useMemoized(() => !hints.wasShown(Hint.weekBandSwipe));
    final bubble = useOverlayPortalController();
    final anchor = useMemoized(LayerLink.new);

    useEffect(() {
      if (!hinting) return null;
      unawaited(hints.markShown(Hint.weekBandSwipe));
      bubble.show();
      final timer = Timer(_hintDuration, bubble.hide);
      return timer.cancel;
    }, const []);

    void turnTo(int page) => unawaited(
      controller.animateToPage(
        page,
        duration: FujinMotion.pageTurn.duration,
        curve: FujinMotion.pageTurn.curve,
      ),
    );

    useEffect(() {
      if (controller.hasClients && shown.value != selectedPage) {
        shown.value = selectedPage;
        turnTo(selectedPage);
      }
      return null;
    }, [selectedPage]);

    void selectWeek(int weeksBack) => onSelect(
      CalendarWeek.sameWeekday(selected, weeksBack: weeksBack, today: today),
    );

    bool settle(ScrollEndNotification end) {
      if (end.depth == 0) {
        switch (controller.page) {
          case final position?
              when (position - position.round()).abs() <
                      precisionErrorTolerance &&
                  position.round() != shown.value:
            shown.value = position.round();
            selectWeek(position.round());
          case _:
            break;
        }
      }
      return false;
    }

    final shownWeek = ref.watch(
      weekReadProvider(CalendarWeek.weeksBefore(thisWeek, shown.value)),
    );
    if (shownWeek.hasValue) {
      for (final neighbour in [shown.value + 1, shown.value - 1]) {
        if (neighbour >= 0) {
          ref.watch(
            weekReadProvider(CalendarWeek.weeksBefore(thisWeek, neighbour)),
          );
        }
      }
    }

    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.previousWeek): () =>
            selectWeek(shown.value + 1),
        if (shown.value > 0)
          CustomSemanticsAction(label: l10n.nextWeek): () =>
              selectWeek(shown.value - 1),
      },
      child: OverlayPortal(
        controller: bubble,
        overlayChildBuilder: (context) => IgnorePointer(
          child: CompositedTransformFollower(
            link: anchor,
            targetAnchor: Alignment.bottomLeft,
            offset: const Offset(FujinSize.screenMargin, FujinSpace.s2),
            child: const Padding(
              padding: EdgeInsets.only(right: FujinSize.screenMargin * 2),
              child: Align(
                alignment: Alignment.topLeft,
                child: WeekBandHint(),
              ),
            ),
          ),
        ),
        child: CompositedTransformTarget(
          link: anchor,
          child: SizedBox(
            height: FujinSize.weekBand,
            child: Stack(
              children: [
                NotificationListener<ScrollStartNotification>(
                  onNotification: (notification) {
                    if (notification.dragDetails != null) bubble.hide();
                    return false;
                  },
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: settle,
                    child: SequenceMotionBuilder<int, double>(
                      sequence: _nudge,
                      converter: const SingleMotionConverter(),
                      playing: hinting,
                      builder: (context, nudge, phase, child) =>
                          PageView.builder(
                            controller: controller,
                            reverse: true,
                            itemBuilder: (context, page) => Transform.translate(
                              offset: Offset(nudge, 0),
                              child: _Week(
                                days: CalendarWeek.daysOf(
                                  CalendarWeek.weeksBefore(thisWeek, page),
                                ),
                                selected: selected,
                                today: today,
                                goals: goals,
                                onSelect: onSelect,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
                const _Fade(alignment: AlignmentDirectional.centerStart),
                if (shown.value > 0)
                  const _Fade(alignment: AlignmentDirectional.centerEnd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Week extends ConsumerWidget {
  const _Week({
    required this.days,
    required this.selected,
    required this.today,
    required this.goals,
    required this.onSelect,
  });

  final List<DateTime> days;
  final DateTime selected;
  final DateTime today;
  final Goals? goals;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
    children: [
      for (final day in days)
        Expanded(
          child: switch (ref.exists(mfpDiaryProvider(day))) {
            true => _ring(day, ref.watch(mfpDiaryProvider(day))),
            false => _ring(day, null),
          },
        ),
    ],
  );

  Widget _ring(DateTime day, AsyncValue<Fetched<MfpDiaryDay>>? diary) {
    final eaten = switch (diary?.value) {
      Fetched(value: final diary) => loggedKilocalories(diary),
      null => null,
    };
    return _Day(
      day: day,
      selected: day == selected,
      state: _state(day, diary, eaten),
      progress: switch ((goals, eaten)) {
        (final goals?, final eaten?) => eaten / goals.kilocalories,
        _ => 0,
      },
      onTap: switch (day.isAfter(today)) {
        true => null,
        false => () => onSelect(day),
      },
    );
  }

  DayGoalState _state(
    DateTime day,
    AsyncValue<Fetched<MfpDiaryDay>>? diary,
    double? eaten,
  ) => switch (diary) {
    _ when day.isAfter(today) => DayGoalState.upcoming,
    AsyncValue(hasValue: true) => DayGoalState.of(
      day: day,
      today: today,
      goals: goals,
      kilocalories: eaten,
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
