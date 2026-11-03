import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/meals/connector_meal.dart';
import 'package:fujin/data/meals/meal.dart';
import 'package:fujin/data/memory/meal_mapping.dart';

final class MealRepository {
  const MealRepository(this._database, this._clock);

  final FujinDatabase _database;
  final DateTime Function() _clock;

  List<MealMapping> mappings() => [
    for (final row in _database.select(
      'SELECT mfp.name AS mfp_meal_name, ekklo.name AS ekklo_meal_name '
      'FROM meal '
      'JOIN meal_mapping mfp ON mfp.meal_id = meal.id '
      "AND mfp.connector = 'mfp' AND mfp.deleted_at IS NULL "
      'JOIN meal_mapping ekklo ON ekklo.meal_id = meal.id '
      "AND ekklo.connector = 'ekklo' AND ekklo.deleted_at IS NULL "
      'WHERE meal.deleted_at IS NULL '
      'ORDER BY mfp.name',
    ))
      MealMappingMapper.fromMap(row),
  ];

  void map(MealMapping mapping) => _database.transaction(() {
    final now = _now();
    final mealId =
        mealOfMfp(mapping.mfpMealName) ??
        _addMeal(mapping.mfpMealName, id: FujinId.at(now), now: now);
    final ekklo = ConnectorMeal(
      id: FujinId.at(now),
      mealId: mealId,
      connector: Connector.ekklo,
      name: mapping.ekkloMealName,
      updatedAt: now,
    );
    switch (_database.select(
      'SELECT * FROM meal_mapping '
      "WHERE meal_id = ? AND connector = 'ekklo' AND deleted_at IS NULL",
      [mealId],
    )) {
      case [final row]
          when ConnectorMealMapper.fromMap(row).name == mapping.ekkloMealName:
        return;
      case [final row]:
        _saveMapping(ekklo.copyWith(id: ConnectorMealMapper.fromMap(row).id));
      case _:
        _saveMapping(ekklo);
    }
  });

  String? mealOfMfp(String mfpMealName) => switch (_database.select(
    'SELECT meal.id FROM meal '
    'JOIN meal_mapping mfp ON mfp.meal_id = meal.id '
    "WHERE mfp.connector = 'mfp' AND mfp.name = ? "
    'AND mfp.deleted_at IS NULL AND meal.deleted_at IS NULL',
    [mfpMealName],
  )) {
    [{_id: final String id}] => id,
    _ => null,
  };

  String mfpMeal(String mfpMealName, {required String id}) =>
      _database.transaction(
        () =>
            mealOfMfp(mfpMealName) ??
            _addMeal(mfpMealName, id: id, now: _now()),
      );

  void arrange(List<String> mfpMealNames) => _database.transaction(() {
    final now = _now();
    final named = <String>{
      for (final name in mfpMealNames) mfpMeal(name, id: FujinId.at(now)),
    };
    final order = [
      ...named,
      for (final {_id: String id} in _database.select(
        'SELECT id FROM meal WHERE deleted_at IS NULL ORDER BY position, id',
      ))
        if (!named.contains(id)) id,
    ];
    final at = now.toIso8601String();
    for (final (position, id) in order.indexed) {
      _database.execute(
        'UPDATE meal SET position = ?, updated_at = ? '
        'WHERE id = ? AND position <> ?',
        [position, at, id, position],
      );
    }
  });

  void forgetEkkloMappings() => _database.softDelete(
    FujinTable.mealMapping,
    "connector = 'ekklo'",
    const [],
    _now(),
  );

  List<Meal> meals() => [
    for (final row in _database.select('SELECT * FROM meal ORDER BY id'))
      MealMapper.fromMap(row),
  ];

  List<ConnectorMeal> connectorMeals() => [
    for (final row in _database.select(
      'SELECT * FROM meal_mapping ORDER BY meal_id, connector, id',
    ))
      ConnectorMealMapper.fromMap(row),
  ];

  void deleteAll() => _database.execute('DELETE FROM meal');

  void restore({
    required List<Meal> meals,
    required List<ConnectorMeal> connectorMeals,
  }) => _database.transaction(() {
    for (final meal in meals) {
      _database.insert(FujinTable.meal, meal.toMap());
    }
    for (final connectorMeal in connectorMeals) {
      _database.insert(FujinTable.mealMapping, connectorMeal.toMap());
    }
  });

  DateTime _now() => _clock().toUtc();

  String _addMeal(
    String mfpMealName, {
    required String id,
    required DateTime now,
  }) {
    final meal = Meal(
      id: id,
      name: mfpMealName,
      position: _nextPosition(),
      updatedAt: now,
    );
    _database.insert(FujinTable.meal, meal.toMap());
    _saveMapping(
      ConnectorMeal(
        id: FujinId.at(now),
        mealId: meal.id,
        connector: Connector.mfp,
        name: mfpMealName,
        updatedAt: now,
      ),
    );
    return meal.id;
  }

  int _nextPosition() => switch (_database.select(
    'SELECT max(position) + 1 AS next FROM meal WHERE deleted_at IS NULL',
  )) {
    [{_next: final int next}] => next,
    _ => 0,
  };

  void _saveMapping(ConnectorMeal mapping) => _database.upsert(
    FujinTable.mealMapping,
    mapping.toMap(),
    key: const [_id],
  );

  static const _id = 'id';
  static const _next = 'next';
}
