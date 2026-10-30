import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';
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

  void forgetDate(DateTime date) => _database.execute(
    'DELETE FROM unattended_item WHERE date = ?',
    [CalendarDateHook.format(date)],
  );
}
