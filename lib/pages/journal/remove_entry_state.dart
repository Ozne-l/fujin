import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/pages/journal/entry_removal.dart';

part 'remove_entry_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class RemoveEntryState with RemoveEntryStateMappable {
  const RemoveEntryState();
}

@MappableClass(discriminatorValue: 'idle')
final class RemoveEntryIdle extends RemoveEntryState
    with RemoveEntryIdleMappable {
  const RemoveEntryIdle();
}

@MappableClass(discriminatorValue: 'done')
final class RemoveEntryDone extends RemoveEntryState
    with RemoveEntryDoneMappable {
  const RemoveEntryDone(this.removal);

  final EntryRemoval removal;
}
