import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_shortcut.dart';
import 'package:fujin/pages/adding/edit_write_notifier.dart';
import 'package:fujin/pages/common/appearance_corner.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/gold_separator.dart';
import 'package:fujin/pages/common/header_layout.dart';
import 'package:fujin/pages/common/scroll_extent_listener.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/common/souffle_refresh.dart';
import 'package:fujin/pages/journal/entry_removal.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/journal_snack_bar.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:fujin/pages/journal/removal_reason.dart';
import 'package:fujin/pages/journal/remove_entry_notifier.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/widgets/day_detail_sheet.dart';
import 'package:fujin/pages/journal/widgets/day_summary_card.dart';
import 'package:fujin/pages/journal/widgets/diary_meal_card.dart';
import 'package:fujin/pages/journal/widgets/journal_brand.dart';
import 'package:fujin/pages/journal/widgets/journal_header.dart';
import 'package:fujin/pages/journal/widgets/journal_problem_card.dart';
import 'package:fujin/pages/journal/widgets/loading_meal_card.dart';
import 'package:fujin/pages/journal/widgets/loading_summary_card.dart';
import 'package:fujin/pages/journal/widgets/meal_card.dart';
import 'package:fujin/pages/journal/widgets/remove_sheet.dart';
import 'package:fujin/pages/journal/widgets/swipe_row.dart';
import 'package:fujin/pages/journal/widgets/week_band.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JournalPage extends HookConsumerWidget {
  const JournalPage({super.key});

  static const _nothingNewDuration = Duration(seconds: 6);
  static const _offlineRetry = Duration(seconds: 15);
  static const _loadingMeals = 3;
  static const double _top = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    final today = ref.watch(todayProvider);
    final goals = ref.watch(goalsProvider);
    final journal = ref.watch(journalProvider(day));
    final notifier = ref.read(journalProvider(day).notifier);
    final removed = useState<String?>(null);
    final removable = AddShortcut.possible(ref);
    final lifecycle = useAppLifecycleState();
    final scrolled = useValueNotifier(_top);
    final offline = switch (journal) {
      AsyncValue(:final error?) => ReadProblem.of(error) == ReadProblem.offline,
      AsyncValue(value: MfpOnly(ekkloProblem: ReadProblem.offline)) => true,
      _ => false,
    };

    useOnAppLifecycleStateChange((previous, current) {
      switch (current) {
        case AppLifecycleState.resumed:
          unawaited(notifier.reload());
        case AppLifecycleState.detached ||
            AppLifecycleState.inactive ||
            AppLifecycleState.hidden ||
            AppLifecycleState.paused:
          break;
      }
    });

    useEffect(() {
      scheduleMicrotask(() => unawaited(notifier.revalidate()));
      return null;
    }, [day]);

    useEffect(() {
      final retrying = switch ((offline, lifecycle)) {
        (true, AppLifecycleState.resumed || null) => Timer.periodic(
          _offlineRetry,
          (_) => unawaited(notifier.reload()),
        ),
        _ => null,
      };
      return retrying?.cancel;
    }, [offline, lifecycle, notifier]);

    Future<void> refresh() async {
      final outcome = await notifier.refresh();
      if (!context.mounted) return;
      switch (outcome) {
        case RefreshOutcome.nothingNew:
          _showNothingNew(context);
        case RefreshOutcome.changed:
          break;
      }
    }

    Future<void> send() async {
      await context.push<void>(FujinRoute.send.forDate(day));
      ref.invalidate(memoryProvider);
      await notifier.reload();
    }

    void reloadShown() => unawaited(
      ref
          .read(journalProvider(ref.read(selectedDayProvider)).notifier)
          .reload(),
    );

    void rereadDaysOf(Iterable<DateTime> dates) {
      final shown = ref.read(selectedDayProvider);
      for (final changedDay in {...dates.map(SelectedDay.calendarDay)}) {
        switch (changedDay) {
          case _ when changedDay == shown:
            reloadShown();
          case _:
            ref
              ..invalidate(mfpDiaryProvider(changedDay))
              ..invalidate(ekkloMealsProvider(changedDay));
        }
      }
    }

    void rereadDayOf(DateTime date) => rereadDaysOf([date]);

    ref.listen(removeEntryProvider, (previous, next) {
      switch (next) {
        case RemoveEntryDone(:final removal) && final done:
          if (removal.reason == RemovalReason.delete) {
            removed.value = removal.entryId;
          }
          rereadDayOf(removal.entry.date);
          JournalSnackBar.removed(context, done);
        case RemoveEntryFailed(:final removal) && final failed:
          rereadDayOf(removal.entry.date);
          JournalSnackBar.removeFailed(
            context,
            failed,
            onRetry: () => unawaited(
              ref.read(removeEntryProvider.notifier).retry(failed),
            ),
          );
        case RemoveEntryIdle() || RemoveEntryRunning():
          break;
      }
    });

    void remove(ComparedEntry compared) {
      if (compared.entry.id case final entryId?) {
        unawaited(
          showRemoveSheet(
            context,
            removal: EntryRemoval(
              entryId: entryId,
              entry: compared.entry,
              reason: RemovalReason.delete,
            ),
            inEkklo: switch (compared.status) {
              InEkklo() || ToUpdate() => true,
              ToSend() => false,
            },
          ),
        );
      }
    }

    void settleEdit(EditOutcome outcome) {
      Future<void> follow(
        Future<EditOutcome?> Function(EditWriteNotifier writer) write,
      ) async {
        if (await write(ref.read(editWriteProvider.notifier)) case final next?
            when context.mounted) {
          settleEdit(next);
        }
      }

      switch (outcome) {
        case Edited(:final edited):
          rereadDaysOf([edited.original.date, edited.entry.date]);
          JournalSnackBar.edited(
            context,
            edited,
            onUndo: () => unawaited(follow((writer) => writer.revert(edited))),
            onSee: () => ref
                .read(selectedDayProvider.notifier)
                .select(edited.entry.date),
          );
        case EkkloNotUpdated(:final edited):
          rereadDaysOf([edited.original.date, edited.entry.date]);
          JournalSnackBar.ekkloNotUpdated(
            context,
            edited,
            onRetry: () =>
                unawaited(follow((writer) => writer.retryEkklo(edited))),
          );
        case OldEntryKept(:final edited):
          rereadDaysOf([edited.original.date, edited.entry.date]);
          JournalSnackBar.oldEntryKept(
            context,
            edited,
            onRetry: () => unawaited(follow((writer) => writer.finish(edited))),
          );
        case NotEdited(:final error):
          reloadShown();
          ScaffoldMessenger.of(context).showWriteProblem(
            context.intl,
            error,
            ref.read(appEnvironmentProvider),
          );
        case EditFoodChanged():
          reloadShown();
          ScaffoldMessenger.of(
            context,
          ).showProblem(context.intl, ReadProblem.unknown);
      }
    }

    Future<void> edit(ComparedEntry compared) async {
      if (compared.entry.id case final entryId?) {
        final outcome = await context.push<EditOutcome>(
          FujinRoute.editFood.forEntry(day, entryId),
        );
        if (outcome != null && context.mounted) settleEdit(outcome);
      }
    }

    Future<void> add(String meal) async {
      final added = await context.push<AddedFood>(
        FujinRoute.addFood.forMeal(day, meal),
      );
      if (!context.mounted) return;
      switch (added) {
        case final added?:
          AddShortcut.added(context, ref, added);
        case null:
          ref.invalidate(memoryProvider);
      }
    }

    Future<void> signIn(FujinRoute route) async {
      final signedIn = await context.push<bool>(route.path);
      if (signedIn case true) {
        ref
          ..invalidate(mfpDiaryProvider)
          ..invalidate(ekkloMealsProvider);
        await notifier.reload();
      }
    }

    final select = ref.read(selectedDayProvider.notifier).select;

    List<Widget> problem(ReadProblem problem, {DateTime? readAt}) => [
      SliverToBoxAdapter(
        child: JournalProblemCard(
          problem: problem,
          readAt: readAt,
          onSignIn: (route) => unawaited(signIn(route)),
          onRetry: () => unawaited(notifier.reload()),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: FujinSpace.s3)),
    ];

    Widget summary(JournalRead read, {required bool stale}) =>
        SliverToBoxAdapter(
          child: DaySummaryCard(
            read: read,
            goals: goals,
            stale: stale,
            onSend: () => unawaited(send()),
            onDetail: () {
              if (read case BothSides(:final day)) {
                unawaited(
                  showDayDetailSheet(
                    context,
                    day: day,
                    onSend: () => unawaited(send()),
                  ),
                );
              }
            },
          ),
        );

    return Scaffold(
      body: AppearanceCorner(
        child: ScrollExtentListener(
          scrolled: scrolled,
          child: HeaderLayout(
            header: JournalHeader(
              day: day,
              today: today,
              scrolled: scrolled,
              link: switch ((day == today, goals)) {
                (false, _) => (
                  context.intl.backToToday,
                  () => select(today),
                ),
                (true, null) => (
                  context.intl.setGoals,
                  () => unawaited(
                    context.push<void>(FujinRoute.goals.path),
                  ),
                ),
                (true, Goals()) => null,
              },
              band: WeekBand(
                selected: day,
                today: today,
                goals: goals,
                onSelect: select,
              ),
            ),
            body: (context, extent) => SwipeRow.group(
              child: SouffleRefresh(
                onRefresh: refresh,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top,
                    ),
                    sliver: const SliverToBoxAdapter(child: JournalBrand()),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          extent -
                          MediaQuery.paddingOf(context).top -
                          JournalBrand.extent(context),
                    ),
                  ),
                  ...switch (journal) {
                    AsyncValue(value: final read?, error: final error?) => [
                      ...problem(ReadProblem.of(error), readAt: read.readAt),
                      summary(read, stale: true),
                      ...switch (read.diaryMeals) {
                        [] => const <Widget>[],
                        final meals => _meals(context, [
                          for (final meal in meals)
                            DiaryMealCard(key: ValueKey(meal.name), meal: meal),
                        ]),
                      },
                    ],
                    AsyncValue(value: BothSides(:final day) && final read) => [
                      summary(read, stale: false),
                      ..._meals(context, [
                        for (final meal in day.meals)
                          MealCard(
                            key: ValueKey((day.date, meal.name)),
                            meal: meal,
                            onAdd: () => unawaited(add(meal.name)),
                            groupTag: day.date,
                            removable: removable,
                            removedEntryId: removed.value,
                            onOpen: (compared) => unawaited(edit(compared)),
                            onRemove: remove,
                          ),
                      ]),
                    ],
                    AsyncValue(value: MfpOnly() && final read) => [
                      ...problem(read.ekkloProblem),
                      summary(read, stale: false),
                      ..._meals(context, [
                        for (final meal in read.diaryMeals)
                          DiaryMealCard(
                            key: ValueKey(meal.name),
                            meal: meal,
                            note: context.intl.ekkloUnavailable,
                          ),
                      ]),
                    ],
                    AsyncValue(value: EkkloOnly() && final read) => [
                      ...problem(read.mfpProblem),
                      summary(read, stale: false),
                    ],
                    AsyncError(:final error) => problem(ReadProblem.of(error)),
                    AsyncLoading() => [
                      const SliverToBoxAdapter(child: LoadingSummaryCard()),
                      ..._meals(context, [
                        for (var index = 0; index < _loadingMeals; index++)
                          const LoadingMealCard(),
                      ]),
                    ],
                  },
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          FujinSpace.s8 + MediaQuery.paddingOf(context).bottom,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<Widget> _meals(BuildContext context, List<Widget> cards) => [
    const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: FujinSize.screenMargin,
          vertical: FujinSpace.s4,
        ),
        child: GoldSeparator(volute: true),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsetsDirectional.only(
        start: FujinSize.textInset,
        bottom: FujinSpace.s3,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          context.intl.mealsOfTheDay,
          style: FujinText.inter12Medium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ),
    ),
    SliverList.separated(
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
      separatorBuilder: (context, index) =>
          const SizedBox(height: FujinSpace.s3),
    ),
  ];

  static void _showNothingNew(BuildContext context) {
    JournalSnackBar.show(
      context,
      duration: _nothingNewDuration,
      content: SnackBarContent(
        glyph: SnackBarGlyph.refresh,
        title: context.intl.nothingNewTitle,
        detail: context.intl.nothingNewDetail,
      ),
    );
  }
}
