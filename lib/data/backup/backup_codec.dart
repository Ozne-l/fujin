import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';

abstract final class BackupCodec {
  static const _format = 'format';
  static const _version = 'version';
  static const _barcodeLinks = 'barcode_links';
  static const _versionWithMemory = 2;
  static const _versionWithoutBarcodeLinks = 1;

  static Uint8List encode(BackupV3 backup) => utf8.encode(backup.toJson());

  static Backup? decode(Uint8List bytes) {
    try {
      return switch (jsonDecode(utf8.decode(bytes))) {
        {_format: Backup.formatName, _version: BackupV3.currentVersion} &&
            final Map<String, Object?> file =>
          BackupV3Mapper.fromMap(file),
        {_format: Backup.formatName, _version: _versionWithMemory} &&
            final Map<String, Object?> file =>
          BackupV2Mapper.fromMap(file),
        {
              _format: Backup.formatName,
              _version: _versionWithoutBarcodeLinks,
            } &&
            final Map<String, Object?> file =>
          BackupV2Mapper.fromMap({...file, _barcodeLinks: const <Object?>[]}),
        _ => null,
      };
    } on FormatException {
      return null;
    } on MapperException {
      return null;
    }
  }
}
