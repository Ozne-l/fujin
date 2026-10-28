import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/journal/read_problem.dart';
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

@MappableClass(discriminatorValue: 'running')
final class RemoveEntryRunning extends RemoveEntryState
    with RemoveEntryRunningMappable {
  const RemoveEntryRunning(this.removal);

  final EntryRemoval removal;
}

@MappableClass(discriminatorValue: 'done')
final class RemoveEntryDone extends RemoveEntryState
    with RemoveEntryDoneMappable {
  const RemoveEntryDone(this.removal, {required this.ekkloRemoved});

  final EntryRemoval removal;
  final bool ekkloRemoved;
}

@MappableClass(discriminatorValue: 'failed')
final class RemoveEntryFailed extends RemoveEntryState
    with RemoveEntryFailedMappable {
  const RemoveEntryFailed(
    this.removal,
    this.problem, {
    required this.removedFromEkklo,
    required this.blockedInDev,
  });

  final EntryRemoval removal;
  final ReadProblem problem;
  final bool removedFromEkklo;
  final bool blockedInDev;
}
