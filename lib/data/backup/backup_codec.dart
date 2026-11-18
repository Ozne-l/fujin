import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

abstract final class BackupCodec {
  static const _format = 'format';
  static const _barcodeLinks = 'barcode_links';

  static Uint8List encode(BackupV4 backup) => utf8.encode(backup.toJson());

  static Backup? decode(Uint8List bytes) {
    try {
      return switch (_read(jsonDecode(utf8.decode(bytes)))) {
        BackupV2(:final matches, :final units)
            when !_unitsMatched(matches, units) =>
          null,
        final backup => backup,
      };
    } on FormatException {
      return null;
    } on MapperException {
      return null;
    }
  }

  static Backup? _read(Object? json) => switch (json) {
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

  static bool _unitsMatched(
    List<MatchedFood> matches,
    List<RememberedUnit> units,
  ) {
    final matched = {for (final match in matches) match.mfpFoodId};
    return units.every((unit) => matched.contains(unit.mfpFoodId));
  }
}
