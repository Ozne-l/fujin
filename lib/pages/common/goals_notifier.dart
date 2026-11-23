import 'package:fujin/app/providers.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_timeline.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goalsProvider = NotifierProvider<GoalsNotifier, GoalTimeline>(
  GoalsNotifier.new,
);

final class GoalsNotifier extends Notifier<GoalTimeline> {
  @override
  GoalTimeline build() =>
      GoalTimeline(ref.watch(goalsRepositoryProvider).periods());

  void save(Goals goals) {
    final repository = ref.read(goalsRepositoryProvider)
      ..saveFrom(ref.read(todayProvider), goals);
    state = GoalTimeline(repository.periods());
  }
}
