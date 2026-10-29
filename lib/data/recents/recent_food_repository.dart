import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/data/recents/recent_food_row.dart';

final class RecentFoodRepository {
  const RecentFoodRepository(this._database, this._foods);

  static const _kept = 20;

  final FujinDatabase _database;
  final FoodRepository _foods;

  List<RecentFood> latest() => [
    for (final row in _database.select(
      'SELECT mfp.external_id AS mfp_food_id, food.name AS description, '
      'food.brand AS brand_name, recent.serving_value, recent.serving_unit, '
      'recent.servings, recent.kilocalories, recent.added_at '
      'FROM recent_food recent '
      'JOIN food ON food.id = recent.food_id '
      'JOIN food_reference mfp ON mfp.food_id = recent.food_id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      'WHERE food.deleted_at IS NULL AND food.name IS NOT NULL '
      'ORDER BY recent.added_at DESC, mfp.external_id LIMIT ?',
      [_kept],
    ))
      RecentFoodMapper.fromMap(row),
  ];

  void record(RecentFood food) => _database.transaction(() {
    final row = RecentFoodRow.of(
      food,
      foodId: _foods.describedMfpFood(
        food.mfpFoodId,
        name: food.description,
        brand: food.brandName,
      ),
    );
    _database
      ..upsert(FujinTable.recentFood, row.toMap(), key: const [_foodId])
      ..execute(
        'DELETE FROM recent_food WHERE food_id NOT IN '
        '(SELECT food_id FROM recent_food '
        'ORDER BY added_at DESC, food_id LIMIT ?)',
        [_kept],
      );
  });

  static const _foodId = 'food_id';
}
