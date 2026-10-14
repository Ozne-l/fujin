import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/gold_separator.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/common/souffle_refresh.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/journal_snack_bar.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/undo_add_notifier.dart';
import 'package:fujin/pages/journal/undo_add_state.dart';
import 'package:fujin/pages/journal/widgets/day_detail_sheet.dart';
import 'package:fujin/pages/journal/widgets/day_summary_card.dart';
import 'package:fujin/pages/journal/widgets/diary_meal_card.dart';
import 'package:fujin/pages/journal/widgets/journal_header.dart';
import 'package:fujin/pages/journal/widgets/journal_problem_card.dart';
import 'package:fujin/pages/journal/widgets/loading_meal_card.dart';
import 'package:fujin/pages/journal/widgets/loading_summary_card.dart';
import 'package:fujin/pages/journal/widgets/meal_card.dart';
import 'package:fujin/pages/journal/widgets/week_band.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JournalPage extends HookConsumerWidget {
  const JournalPage({super.key});

  static const _nothingNewDuration = Duration(seconds: 6);
  static const _offlineRetry = Duration(seconds: 15);
  static const _loadingMeals = 3;
  static const _undoneDuration = Duration(seconds: 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    final today = ref.watch(todayProvider);
    final goals = ref.watch(goalsProvider);
    final journal = ref.watch(journalProvider(day));
    final notifier = ref.read(journalProvider(day).notifier);
    final undo = ref.read(undoAddProvider.notifier);
    final lifecycle = useAppLifecycleState();
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

    void rereadDayOf(AddedFood added) {
      switch (SelectedDay.calendarDay(added.entry.date)) {
        case final addedDay when addedDay == day:
          unawaited(notifier.reload());
        case final addedDay:
          ref
            ..invalidate(mfpDiaryProvider(addedDay))
            ..invalidate(ekkloMealsProvider(addedDay));
      }
    }

    ref.listen(undoAddProvider, (previous, next) {
      switch (next) {
        case UndoAddDone(:final added):
          rereadDayOf(added);
          _showUndone(context);
        case UndoAddFailed(
          :final added,
          :final problem,
          :final removedFromEkklo,
        ):
          rereadDayOf(added);
          _showUndoFailed(
            context,
            added,
            problem,
            removedFromEkklo: removedFromEkklo,
            onRetry: () => unawaited(undo.undo(added)),
          );
        case UndoAddIdle() || UndoAddRunning():
          break;
      }
    });

    Future<void> add(String meal) async {
      final added = await context.push<AddedFood>(
        FujinRoute.addFood.forMeal(day, meal),
      );
      ref.invalidate(memoryProvider);
      await notifier.reload();
      if (!context.mounted) return;
      if (added case final added?) {
        JournalSnackBar.added(
          context,
          added,
          onUndo: () => unawaited(undo.undo(added)),
        );
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
      body: SafeArea(
        bottom: false,
        child: SouffleRefresh(
          onRefresh: refresh,
          slivers: [
            SliverToBoxAdapter(
              child: JournalHeader(
                day: day,
                today: today,
                link: switch ((day == today, goals)) {
                  (false, _) => (context.intl.backToToday, () => select(today)),
                  (true, null) => (
                    context.intl.setGoals,
                    () => unawaited(context.push<void>(FujinRoute.goals.path)),
                  ),
                  (true, Goals()) => null,
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
              sliver: SliverToBoxAdapter(
                child: WeekBand(
                  selected: day,
                  today: today,
                  goals: goals,
                  onSelect: select,
                ),
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
                height: FujinSpace.s8 + MediaQuery.paddingOf(context).bottom,
              ),
            ),
          ],
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
            color: FujinColorRole.textSecondary,
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

  static void _showUndone(BuildContext context) {
    JournalSnackBar.show(
      context,
      duration: _undoneDuration,
      content: SnackBarContent(
        glyph: SnackBarGlyph.undone,
        title: context.intl.addUndone,
        detail: context.intl.addUndoneDetail,
      ),
    );
  }

  static void _showUndoFailed(
    BuildContext context,
    AddedFood added,
    ReadProblem problem, {
    required bool removedFromEkklo,
    required VoidCallback onRetry,
  }) {
    final (title, detail) = switch (removedFromEkklo) {
      true => (
        context.intl.addStillInMfp,
        context.intl.addStillInMfpDetail(productName(added.entry.food)),
      ),
      false => (
        context.intl.addNotUndone,
        JournalText.problemHeadline(context.intl, problem),
      ),
    };
    JournalSnackBar.show(
      context,
      duration: JournalSnackBar.undoWindow,
      content: SnackBarContent(
        glyph: SnackBarGlyph.alert,
        title: title,
        detail: detail,
        action: (context.intl.tryAgain, onRetry),
      ),
    );
  }
}
