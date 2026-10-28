import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/pages/adding/edit_write_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<EditWriteNotifier, EditWriteState> editWriteProvider =
    NotifierProvider.autoDispose<EditWriteNotifier, EditWriteState>(
      EditWriteNotifier.new,
    );

final class EditWriteNotifier extends Notifier<EditWriteState> {
  @override
  EditWriteState build() => const EditWriteIdle();

  Future<EditOutcome?> save(
    AddDraft draft,
    PlannedEntry planned, {
    required String entryId,
    required DateTime date,
  }) {
    final editing = ref.read(editEntryServiceProvider);
    return _run(
      () => editing.save(draft, planned, entryId: entryId, date: date),
    );
  }

  Future<EditOutcome?> retryEkklo(EditedFood edited) {
    final editing = ref.read(editEntryServiceProvider);
    return _run(() => editing.retryEkklo(edited));
  }

  Future<EditOutcome?> finish(EditedFood edited) {
    final editing = ref.read(editEntryServiceProvider);
    return _run(() => editing.finish(edited));
  }

  Future<EditOutcome?> revert(EditedFood edited) {
    final editing = ref.read(editEntryServiceProvider);
    return _run(() => editing.revert(edited));
  }

  Future<EditOutcome?> _run(Future<EditOutcome> Function() write) async {
    if (state case EditWriteRunning()) return null;
    state = const EditWriteRunning();
    final outcome = await write();
    if (ref.mounted) state = const EditWriteIdle();
    return outcome;
  }
}
