import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

final class ForegroundStampRepository {
  const ForegroundStampRepository(this._database);

  final FujinDatabase<CacheTable> _database;

  DateTime? last() => switch (_database.select(
    'SELECT at FROM chat_foreground WHERE id = ?',
    const [_onlyRow],
  )) {
    [{_at: final String at}] => DateTime.parse(at),
    _ => null,
  };

  void record(DateTime at) => _database.upsert(
    CacheTable.foreground,
    {_id: _onlyRow, _at: at.toUtc().toIso8601String()},
    key: const [_id],
  );

  static const _id = 'id';
  static const _at = 'at';
  static const _onlyRow = 1;
}
