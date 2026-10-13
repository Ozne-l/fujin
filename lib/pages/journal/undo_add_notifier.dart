import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/undo_outcome.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/pages/journal/undo_add_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<UndoAddNotifier, UndoAddState> undoAddProvider =
    NotifierProvider.autoDispose<UndoAddNotifier, UndoAddState>(
      UndoAddNotifier.new,
    );

final class UndoAddNotifier extends Notifier<UndoAddState> {
  @override
  UndoAddState build() => const UndoAddIdle();

  Future<void> undo(AddedFood added) async {
    if (state case UndoAddRunning()) return;
    state = const UndoAddRunning();
    final outcome = await ref.read(addFoodServiceProvider).undo(added);
    if (!ref.mounted) return;
    state = switch (outcome) {
      Undone() => UndoAddDone(added),
      StillInMfp(:final error) => UndoAddFailed(
        added,
        ReadProblem.of(error),
        removedFromEkklo: true,
      ),
      NotUndone(:final error) => UndoAddFailed(
        added,
        ReadProblem.of(error),
        removedFromEkklo: false,
      ),
    };
  }
}
