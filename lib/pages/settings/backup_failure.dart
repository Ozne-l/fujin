import 'package:dart_mappable/dart_mappable.dart';

part 'backup_failure.mapper.dart';

@MappableEnum()
enum BackupFailure { unreadable, notWritten }
