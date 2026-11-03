import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';

abstract final class BackupCodec {
  static const _format = 'format';
  static const _barcodeLinks = 'barcode_links';

  static Uint8List encode(BackupV4 backup) => utf8.encode(backup.toJson());

  static Backup? decode(Uint8List bytes) {
    try {
      return switch (jsonDecode(utf8.decode(bytes))) {
        {
              _format: Backup.formatName,
              Backup.versionKey: BackupV2.versionWithoutBarcodeLinks,
            } &&
            final Map<String, Object?> file =>
          BackupMapper.fromMap({...file, _barcodeLinks: const <Object?>[]}),
        {_format: Backup.formatName} && final Map<String, Object?> file =>
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
