import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/goals/goals.dart';

final class GoalsRepository {
  const GoalsRepository(this._database, this._clock);

  final FujinDatabase _database;
  final DateTime Function() _clock;

  Goals? load() =>
      switch (_database.select('SELECT * FROM goals WHERE id = ?', const [
        _onlyRow,
      ])) {
        [final row] => GoalsMapper.fromMap(row),
        _ => null,
      };

  void save(Goals goals) => _database.upsert(
    FujinTable.goals,
    {
      _id: _onlyRow,
      ...goals.toMap(),
      _updatedAt: _clock().toUtc().toIso8601String(),
    },
    key: const [_id],
  );

  void replace(Goals? goals) => switch (goals) {
    final goals? => save(goals),
    null => _database.execute('DELETE FROM goals'),
  };

  static const _id = 'id';
  static const _updatedAt = 'updated_at';
  static const _onlyRow = 1;
}
