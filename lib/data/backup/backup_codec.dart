import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

abstract final class BackupCodec {
  static const _format = 'format';
  static const _barcodeLinks = 'barcode_links';
  static const _goals = 'goals';
  static const _goalPeriods = 'goal_periods';
  static const _startsOn = 'starts_on';
  static const _exportedAt = 'exported_at';

  static Uint8List encode(BackupV5 backup) => utf8.encode(backup.toJson());

  static Backup? decode(Uint8List bytes) {
    try {
      return switch (_read(jsonDecode(utf8.decode(bytes)))) {
        final BackupV2 memory when !_importable(memory) => null,
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
          Backup.versionKey: final int version,
        } &&
        final Map<String, Object?> file =>
      BackupMapper.fromMap({...file, ..._upgrade(file, version)}),
    _ => null,
  };

  static Map<String, Object?> _upgrade(
    Map<String, Object?> file,
    int version,
  ) => {
    if (version == BackupV2.versionWithoutBarcodeLinks)
      _barcodeLinks: const <Object?>[],
    if (file case {
      _goals: final Map<String, Object?> goals,
      _exportedAt: final String exportedAt,
    })
      _goalPeriods: [
        {
          _startsOn: CalendarDateHook.format(
            DateTime.parse(exportedAt).toLocal(),
          ),
          ...goals,
        },
      ],
  };

  static bool _importable(BackupV2 memory) {
    final matched = {for (final match in memory.matches) match.mfpFoodId};
    return memory.ownCopies.every(
          (copy) => !matched.contains(copy.mfpFoodId),
        ) &&
        memory.units.every((unit) => matched.contains(unit.mfpFoodId));
  }
}
