import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/goals/goal_period.dart';
import 'package:fujin/data/goals/goals.dart';

final class GoalsRepository {
  const GoalsRepository(this._database, this._clock);

  final FujinDatabase<FujinTable> _database;
  final DateTime Function() _clock;

  List<GoalPeriod> periods() => [
    for (final row in _database.select(
      'SELECT * FROM goals ORDER BY starts_on',
    ))
      GoalPeriodMapper.fromMap(row),
  ];

  void saveFrom(DateTime day, Goals goals) => _database.transaction(() {
    final startsOn = CalendarDateHook.format(day);
    _database
      ..execute('DELETE FROM goals WHERE starts_on > ?', [startsOn])
      ..upsert(
        FujinTable.goals,
        {_startsOn: startsOn, ...goals.toMap(), _updatedAt: _stamp()},
        key: const [_startsOn],
      );
  });

  void replaceAll(Iterable<GoalPeriod> periods) => _database.transaction(() {
    _database.execute('DELETE FROM goals');
    for (final period in periods) {
      _database.insert(FujinTable.goals, {
        ...period.toMap(),
        _updatedAt: _stamp(),
      });
    }
  });

  String _stamp() => _clock().toUtc().toIso8601String();

  static const _startsOn = 'starts_on';
  static const _updatedAt = 'updated_at';
}
