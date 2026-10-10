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

  void add(SentLink link) =>
      _database.insert(FujinTable.sentLink, link.toMap());

  void remove(String mfpEntryId) => _database.execute(
    'DELETE FROM sent_link WHERE mfp_entry_id = ?',
    [mfpEntryId],
  );

  void replace({
    required Iterable<SentLink> dropped,
    required Iterable<SentLink> adopted,
  }) => _database.transaction(() {
    for (final link in dropped) {
      remove(link.mfpEntryId);
    }
    adopted.forEach(add);
  });

  void replaceAll(Iterable<SentLink> links) => _database.transaction(() {
    _database.execute('DELETE FROM sent_link');
    links.forEach(add);
  });
}
