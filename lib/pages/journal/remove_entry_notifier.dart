import 'package:fujin/app/providers.dart';
import 'package:fujin/pages/journal/entry_removal.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<RemoveEntryNotifier, RemoveEntryState>
removeEntryProvider =
    NotifierProvider.autoDispose<RemoveEntryNotifier, RemoveEntryState>(
      RemoveEntryNotifier.new,
    );

final class RemoveEntryNotifier extends Notifier<RemoveEntryState> {
  @override
  RemoveEntryState build() => const RemoveEntryIdle();

  void remove(EntryRemoval removal) {
    if (ref.read(removeEntryServiceProvider).remove(removal.entryId) case _?) {
      state = RemoveEntryDone(removal);
    }
  }
}
