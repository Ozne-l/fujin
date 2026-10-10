import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';

abstract final class BackupCodec {
  static const _format = 'format';
  static const _version = 'version';

  static Uint8List encode(Backup backup) => utf8.encode(backup.toJson());

  static Backup? decode(Uint8List bytes) {
    try {
      return switch (jsonDecode(utf8.decode(bytes))) {
        {_format: Backup.formatName, _version: Backup.currentVersion} &&
            final Map<String, Object?> file =>
          BackupMapper.fromMap(file),
        _ => null,
      };
    } on FormatException {
      return null;
    } on MapperException {
      return null;
    }
  }
}
