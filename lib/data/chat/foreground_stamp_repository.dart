import 'package:fujin/data/chat/foreground_stamp.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

final class ForegroundStampRepository {
  const ForegroundStampRepository(this._database);

  final FujinDatabase<CacheTable> _database;

  DateTime? last() => switch (_database.select(
    'SELECT * FROM chat_foreground WHERE id = ?',
    const [ForegroundStamp.onlyRow],
  )) {
    [final row] => ForegroundStampMapper.fromMap(row).at,
    _ => null,
  };

  void record(DateTime at) => _database.upsert(
    CacheTable.foreground,
    ForegroundStamp(at: at.toUtc()).toMap(),
    key: const [_id],
  );

  static const _id = 'id';
}
