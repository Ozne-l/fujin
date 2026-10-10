import 'dart:typed_data';

import 'package:fujin/data/backup/backup_files.dart';

final class FakeBackupFiles implements BackupFiles {
  final saved = <String, Uint8List>{};
  Uint8List? picked;

  @override
  Future<bool> save({required String name, required Uint8List bytes}) async {
    saved[name] = bytes;
    return true;
  }

  @override
  Future<Uint8List?> open() async => picked;
}
