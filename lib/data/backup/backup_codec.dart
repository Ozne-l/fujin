import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

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

  static bool _unitsMatched(
    List<MatchedFood> matches,
    List<RememberedUnit> units,
  ) {
    final matched = {for (final match in matches) match.mfpFoodId};
    return units.every((unit) => matched.contains(unit.mfpFoodId));
  }
}
