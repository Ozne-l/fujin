import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fujin/data/backup/backup_files.dart';

final class PickerBackupFiles implements BackupFiles {
  const PickerBackupFiles();

  static const _mimeType = 'application/json';

  @override
  Future<bool> save({required String name, required Uint8List bytes}) async =>
      await FilePicker.saveFile(
        fileName: name,
        bytes: bytes,
        mimeType: _mimeType,
      ) !=
      null;

  @override
  Future<Uint8List?> open() async => switch (await FilePicker.pickFile()) {
    final file? => await file.readAsBytes(),
    null => null,
  };
}
