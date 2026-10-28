import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/add_stage.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/undo_outcome.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/pages/adding/add_write_state.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<AddWriteNotifier, AddWriteState> addWriteProvider =
    NotifierProvider.autoDispose<AddWriteNotifier, AddWriteState>(
      AddWriteNotifier.new,
    );

final class AddWriteNotifier extends Notifier<AddWriteState> {
  @override
  AddWriteState build() => const AddWriteIdle();

  bool get _busy => switch (state) {
    AddWriteRunning() || AddWriteEkkloFailed(undoing: true) => true,
    AddWriteIdle() ||
    AddWriteDone() ||
    AddWriteFailed() ||
    AddWriteEkkloFailed() => false,
  };

  Future<AddOutcome?> add(
    AddDraft draft,
    PlannedEntry planned, {
    String? barcodeToLink,
  }) async {
    if (_busy) return null;
    state = const AddWriteRunning(AddStage.mfp);
    final outcome = await ref
        .read(addFoodServiceProvider)
        .add(draft, planned, onStage: _stage, barcodeToLink: barcodeToLink);
    _settle(outcome);
    return outcome;
  }

  Future<void> retryEkklo(AddedFood added) async {
    if (_busy) return;
    state = const AddWriteRunning(AddStage.ekklo);
    _settle(await ref.read(addFoodServiceProvider).retryEkklo(added));
  }

  Future<UndoOutcome?> undo() async {
    if (_busy) return null;
    if (state case final AddWriteEkkloFailed failed) {
      state = failed.copyWith(undoing: true);
      final outcome = await ref.read(addFoodServiceProvider).undo(failed.added);
      if (ref.mounted) {
        state = switch (outcome) {
          Undone() => const AddWriteIdle(),
          StillInMfp() || NotUndone() => failed,
        };
      }
      return outcome;
    }
    return null;
  }

  void dismiss() {
    if (state case AddWriteFailed()) state = const AddWriteIdle();
  }

  void _stage(AddStage stage) {
    if (ref.mounted) state = AddWriteRunning(stage);
  }

  void _settle(AddOutcome outcome) {
    if (!ref.mounted) return;
    state = switch (outcome) {
      Added(:final added) => AddWriteDone(added),
      FoodChanged() => const AddWriteIdle(),
      NotAdded(:final error) => AddWriteFailed(
        ReadProblem.of(error),
        blockedInDev:
            SendFailure.of(error, ref.read(appEnvironmentProvider)) ==
            SendFailure.blockedInDev,
      ),
      EkkloFailed(:final added, :final error) => AddWriteEkkloFailed(
        added,
        ReadProblem.of(error),
      ),
    };
  }
}
