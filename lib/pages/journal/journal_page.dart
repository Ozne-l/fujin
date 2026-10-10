import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/gold_separator.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/widgets/day_detail_sheet.dart';
import 'package:fujin/pages/journal/widgets/day_summary_card.dart';
import 'package:fujin/pages/journal/widgets/journal_header.dart';
import 'package:fujin/pages/journal/widgets/journal_problem_card.dart';
import 'package:fujin/pages/journal/widgets/loading_meal_card.dart';
import 'package:fujin/pages/journal/widgets/loading_summary_card.dart';
import 'package:fujin/pages/journal/widgets/meal_card.dart';
import 'package:fujin/pages/journal/widgets/unavailable_meal_card.dart';
import 'package:fujin/pages/journal/widgets/week_band.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JournalPage extends HookConsumerWidget {
  const JournalPage({super.key});

  static const _nothingNewDuration = Duration(seconds: 6);
  static const _offlineRetry = Duration(seconds: 15);
  static const _loadingMeals = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final day = ref.watch(selectedDayProvider);
    final today = ref.watch(todayProvider);
    final goals = ref.watch(goalsProvider);
    final journal = ref.watch(journalProvider(day));
    final notifier = ref.read(journalProvider(day).notifier);
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

    Future<void> signIn(FujinRoute route) async {
      final signedIn = await context.push<bool>(route.path);
      if (signedIn case true) await notifier.reload();
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
        child: RefreshIndicator(
          onRefresh: refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: JournalHeader(
                  day: day,
                  today: today,
                  link: switch ((day == today, goals)) {
                    (false, _) => (l10n.backToToday, () => select(today)),
                    (true, null) => (
                      l10n.setGoals,
                      () =>
                          unawaited(context.push<void>(FujinRoute.goals.path)),
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
                ],
                AsyncValue(value: BothSides(:final day) && final read) => [
                  summary(read, stale: false),
                  ..._meals(context, [
                    for (final meal in day.meals) MealCard(meal: meal),
                  ]),
                ],
                AsyncValue(value: MfpOnly() && final read) => [
                  ...problem(read.ekkloProblem),
                  summary(read, stale: false),
                  ..._meals(context, [
                    for (final MapEntry(key: name, value: kilocalories)
                        in read.mealKilocalories.entries)
                      UnavailableMealCard(
                        name: name,
                        kilocalories: kilocalories,
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
          AppLocalizations.of(context).mealsOfTheDay,
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
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: _nothingNewDuration,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: FujinSpace.s1,
          children: [
            Text(
              l10n.nothingNewTitle,
              style: FujinText.inter14Semibold.copyWith(
                color: FujinColorRole.textOnDark,
              ),
            ),
            Text(
              l10n.nothingNewDetail,
              style: FujinText.inter13Regular.copyWith(
                color: FujinColorRole.textOnDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
