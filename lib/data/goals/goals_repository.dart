import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/goals/goals.dart';

final class GoalsRepository {
  const GoalsRepository(this._database);

  final FujinDatabase _database;

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
    },
    key: const [_id],
  );

  void replace(Goals? goals) => switch (goals) {
    final goals? => save(goals),
    null => _database.execute('DELETE FROM goals'),
  };

  static const _id = 'id';
  static const _onlyRow = 1;
}
