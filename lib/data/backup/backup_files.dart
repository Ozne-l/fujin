import 'dart:typed_data';

abstract interface class BackupFiles {
  Future<bool> save({required String name, required Uint8List bytes});

  Future<Uint8List?> open();
}
