import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/editing/remove_outcome.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/pages/journal/entry_removal.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<RemoveEntryNotifier, RemoveEntryState>
removeEntryProvider =
    NotifierProvider.autoDispose<RemoveEntryNotifier, RemoveEntryState>(
      RemoveEntryNotifier.new,
    );

final class RemoveEntryNotifier extends Notifier<RemoveEntryState> {
  @override
  RemoveEntryState build() => const RemoveEntryIdle();

  Future<void> remove(EntryRemoval removal) =>
      _run(removal, removedFromEkklo: false);

  Future<void> retry(RemoveEntryFailed failed) =>
      _run(failed.removal, removedFromEkklo: failed.removedFromEkklo);

  Future<void> _run(
    EntryRemoval removal, {
    required bool removedFromEkklo,
  }) async {
    if (state case RemoveEntryRunning()) return;
    state = RemoveEntryRunning(removal);
    final outcome = await ref
        .read(removeEntryServiceProvider)
        .remove(entryId: removal.entryId, date: removal.entry.date);
    if (!ref.mounted) return;
    state = switch (outcome) {
      Removed(:final ekkloRemoved) => RemoveEntryDone(
        removal,
        ekkloRemoved: ekkloRemoved || removedFromEkklo,
      ),
      StillInMfp(:final error) => _failed(
        removal,
        error,
        removedFromEkklo: true,
      ),
      NotRemoved(:final error) => _failed(
        removal,
        error,
        removedFromEkklo: removedFromEkklo,
      ),
    };
  }

  RemoveEntryFailed _failed(
    EntryRemoval removal,
    Object error, {
    required bool removedFromEkklo,
  }) => RemoveEntryFailed(
    removal,
    ReadProblem.of(error),
    removedFromEkklo: removedFromEkklo,
    blockedInDev:
        SendFailure.of(error, ref.read(appEnvironmentProvider)) ==
        SendFailure.blockedInDev,
  );
}
