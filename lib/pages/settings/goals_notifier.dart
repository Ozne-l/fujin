import 'package:fujin/app/providers.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goalsProvider = NotifierProvider<GoalsNotifier, Goals?>(
  GoalsNotifier.new,
);

final class GoalsNotifier extends Notifier<Goals?> {
  @override
  Goals? build() => ref.watch(goalsRepositoryProvider).load();

  void save(Goals goals) {
    ref.read(goalsRepositoryProvider).save(goals);
    state = goals;
  }
}
