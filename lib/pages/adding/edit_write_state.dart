import 'package:dart_mappable/dart_mappable.dart';

part 'edit_write_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class EditWriteState with EditWriteStateMappable {
  const EditWriteState();
}

@MappableClass(discriminatorValue: 'idle')
final class EditWriteIdle extends EditWriteState with EditWriteIdleMappable {
  const EditWriteIdle();
}

@MappableClass(discriminatorValue: 'running')
final class EditWriteRunning extends EditWriteState
    with EditWriteRunningMappable {
  const EditWriteRunning();
}
