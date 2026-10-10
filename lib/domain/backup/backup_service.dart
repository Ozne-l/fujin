import 'dart:typed_data';

import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/backup/backup_codec.dart';
import 'package:fujin/data/backup/backup_files.dart';
import 'package:fujin/data/backup/backup_repository.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

final class BackupService {
  const BackupService({
    required this._backups,
    required this._files,
    required this._clock,
  });

  static const _namePrefix = 'fujin-backup-';
  static const _nameExtension = '.json';

  final BackupRepository _backups;
  final BackupFiles _files;
  final DateTime Function() _clock;

  static String fileName(DateTime date) =>
      '$_namePrefix${CalendarDateHook.format(date)}$_nameExtension';

  Future<bool> export() {
    final now = _clock();
    return _files.save(
      name: fileName(now),
      bytes: BackupCodec.encode(_backups.snapshot(now)),
    );
  }

  Future<Uint8List?> pick() => _files.open();

  Backup? read(Uint8List bytes) => BackupCodec.decode(bytes);

  void restore(Backup backup) => _backups.restore(backup);
}
