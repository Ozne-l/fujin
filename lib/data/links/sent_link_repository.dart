import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/links/sent_link.dart';

final class SentLinkRepository {
  const SentLinkRepository(this._database);

  final FujinDatabase _database;

  List<SentLink> forDate(DateTime date) => [
    for (final row in _database.select(
      'SELECT * FROM sent_link WHERE date = ? ORDER BY sent_at, mfp_entry_id',
      [CalendarDateHook.format(date)],
    ))
      SentLinkMapper.fromMap(row),
  ];

  List<SentLink> all() => [
    for (final row in _database.select(
      'SELECT * FROM sent_link ORDER BY date, sent_at, mfp_entry_id',
    ))
      SentLinkMapper.fromMap(row),
  ];

  void forgetDate(DateTime date) => _database.execute(
    'DELETE FROM sent_link WHERE date = ?',
    [CalendarDateHook.format(date)],
  );

  void replaceAll(Iterable<SentLink> links) => _database.transaction(() {
    _database.execute('DELETE FROM sent_link');
    for (final link in links) {
      _database.insert(FujinTable.sentLink, link.toMap());
    }
  });
}
