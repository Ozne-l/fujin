import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/widgets/day_summary_card.dart';
import 'package:fujin/pages/journal/widgets/gold_separator.dart';
import 'package:fujin/pages/journal/widgets/journal_header.dart';
import 'package:fujin/pages/journal/widgets/journal_problem_card.dart';
import 'package:fujin/pages/journal/widgets/meal_card.dart';
import 'package:fujin/pages/journal/widgets/week_band.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JournalPage extends HookConsumerWidget {
  const JournalPage({super.key});

  static const _nothingNewDuration = Duration(seconds: 6);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    final today = ref.watch(todayProvider);
    final journal = ref.watch(journalProvider(day));
    final notifier = ref.read(journalProvider(day).notifier);

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
      await notifier.reload();
    }

    Future<void> signIn(FujinRoute route) async {
      final signedIn = await context.push<bool>(route.path);
      if (signedIn case true) await notifier.reload();
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: JournalHeader(day: day, today: today),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
                sliver: SliverToBoxAdapter(
                  child: WeekBand(
                    week: SelectedDay.weekOf(day),
                    selected: day,
                    today: today,
                    onSelect: ref.read(selectedDayProvider.notifier).select,
                  ),
                ),
              ),
              ...switch (journal) {
                AsyncValue(value: final JournalDay loaded) => _loaded(
                  context,
                  loaded,
                  () => unawaited(send()),
                ),
                AsyncError(:final error) => [
                  SliverToBoxAdapter(
                    child: JournalProblemCard(
                      error: error,
                      onSignIn: (route) => unawaited(signIn(route)),
                    ),
                  ),
                ],
                _ => [
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              },
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _loaded(
    BuildContext context,
    JournalDay day,
    VoidCallback onSend,
  ) => [
    SliverToBoxAdapter(
      child: DaySummaryCard(day: day, onSend: onSend),
    ),
    const SliverToBoxAdapter(child: GoldSeparator()),
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
      itemCount: day.meals.length,
      itemBuilder: (context, index) => MealCard(meal: day.meals[index]),
      separatorBuilder: (context, index) =>
          const SizedBox(height: FujinSpace.s3),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: FujinSpace.s8)),
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
