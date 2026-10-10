import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/pages/settings/backup_failure.dart';

part 'backup_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class BackupState with BackupStateMappable {
  const BackupState();
}

@MappableClass(discriminatorValue: 'idle')
final class BackupIdle extends BackupState with BackupIdleMappable {
  const BackupIdle();
}

@MappableClass(discriminatorValue: 'running')
final class BackupRunning extends BackupState with BackupRunningMappable {
  const BackupRunning();
}

@MappableClass(discriminatorValue: 'opened')
final class BackupOpened extends BackupState with BackupOpenedMappable {
  const BackupOpened(this.backup);

  final Backup backup;
}

@MappableClass(discriminatorValue: 'exported')
final class BackupExported extends BackupState with BackupExportedMappable {
  const BackupExported();
}

@MappableClass(discriminatorValue: 'imported')
final class BackupImported extends BackupState with BackupImportedMappable {
  const BackupImported();
}

@MappableClass(discriminatorValue: 'failed')
final class BackupFailed extends BackupState with BackupFailedMappable {
  const BackupFailed(this.failure);

  final BackupFailure failure;
}
