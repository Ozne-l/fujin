import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/recents/recent_food.dart';

final class RecentFoodRepository {
  const RecentFoodRepository(this._database);

  static const _kept = 20;

  final FujinDatabase _database;

  List<RecentFood> latest() => [
    for (final row in _database.select(
      'SELECT * FROM recent_food ORDER BY added_at DESC, mfp_food_id LIMIT ?',
      [_kept],
    ))
      RecentFoodMapper.fromMap(row),
  ];

  void record(RecentFood food) => _database.transaction(() {
    _database
      ..upsert(FujinTable.recentFood, food.toMap(), key: const [_mfpFoodId])
      ..execute(
        'DELETE FROM recent_food WHERE mfp_food_id NOT IN '
        '(SELECT mfp_food_id FROM recent_food '
        'ORDER BY added_at DESC, mfp_food_id LIMIT ?)',
        [_kept],
      );
  });

  static const _mfpFoodId = 'mfp_food_id';
}
