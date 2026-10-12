import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/unattended/unattended_item.dart';

final class UnattendedItemRepository {
  const UnattendedItemRepository(this._database);

  final FujinDatabase _database;

  List<UnattendedItem> forDate(DateTime date) => [
    for (final row in _database.select(
      'SELECT * FROM unattended_item WHERE date = ? ORDER BY mfp_entry_id',
      [CalendarDateHook.format(date)],
    ))
      UnattendedItemMapper.fromMap(row),
  ];

  UnattendedItem? forEntry(String mfpEntryId) => switch (_database.select(
    'SELECT * FROM unattended_item WHERE mfp_entry_id = ?',
    [mfpEntryId],
  )) {
    [final row] => UnattendedItemMapper.fromMap(row),
    _ => null,
  };

  void forget(String mfpEntryId) => _database.execute(
    'DELETE FROM unattended_item WHERE mfp_entry_id = ?',
    [mfpEntryId],
  );

  void record(Iterable<UnattendedItem> items) => _database.transaction(() {
    for (final item in items) {
      _database.upsert(
        FujinTable.unattendedItem,
        item.toMap(),
        key: const [_mfpEntryId],
      );
    }
  });

  void forgetAll(Iterable<String> mfpEntryIds) =>
      _database.transaction(() => mfpEntryIds.forEach(forget));

  void prune(DateTime date, Set<String> mfpEntryIds) =>
      _database.transaction(() {
        for (final item in forDate(date)) {
          if (!mfpEntryIds.contains(item.mfpEntryId)) forget(item.mfpEntryId);
        }
      });

  static const _mfpEntryId = 'mfp_entry_id';
}
