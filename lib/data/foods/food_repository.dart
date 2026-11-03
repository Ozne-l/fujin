import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/foods/food_barcode.dart';
import 'package:fujin/data/foods/food_nutrients.dart';
import 'package:fujin/data/foods/food_reference.dart';
import 'package:fujin/data/foods/food_serving.dart';
import 'package:fujin/data/foods/food_unit.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class FoodRepository {
  const FoodRepository(this._database, this._clock);

  final FujinDatabase _database;
  final DateTime Function() _clock;

  String mfpFood(String mfpFoodId, {String? name}) => _database.transaction(
    () => switch (foodOfMfp(mfpFoodId)) {
      final food? => _described(
        food,
        name: name ?? food.name,
        brand: food.brand,
      ),
      null => _addMfpFood(
        mfpFoodId,
        id: FujinId.at(_now()),
        name: name,
        brand: null,
      ),
    },
  );

  String describedMfpFood(
    String mfpFoodId, {
    required String name,
    required String? brand,
  }) => _database.transaction(
    () => switch (foodOfMfp(mfpFoodId)) {
      final food? => _described(food, name: name, brand: brand),
      null => _addMfpFood(
        mfpFoodId,
        id: FujinId.at(_now()),
        name: name,
        brand: brand,
      ),
    },
  );

  String copiedMfpFood(
    String mfpFoodId, {
    required String id,
    required String? name,
    required String? brand,
  }) => _database.transaction(
    () => switch (foodOfMfp(mfpFoodId)) {
      final food? when food.name == null => _described(
        food,
        name: name,
        brand: brand,
      ),
      final food? => food.id,
      null => _addMfpFood(mfpFoodId, id: id, name: name, brand: brand),
    },
  );

  void fill(MfpFood mfpFood) => _database.transaction(() {
    final now = _now();
    switch ((_mfpReference(mfpFood.id), foodOfMfp(mfpFood.id))) {
      case (final reference?, final food?)
          when reference.version != mfpFood.version || !_hasServings(food.id):
        _database.softDelete(FujinTable.foodServing, 'food_id = ?', [
          food.id,
        ], now);
        _saveFood(
          food.copyWith(
            name: mfpFood.description,
            brand: mfpFood.brandName,
            nutrients: FoodNutrients.ofMfp(mfpFood.nutrients),
            verified: mfpFood.verified ?? food.verified,
            updatedAt: now,
          ),
        );
        _saveReference(
          reference.copyWith(version: mfpFood.version, updatedAt: now),
        );
        for (final (position, serving) in mfpFood.servingSizes.indexed) {
          _database.insert(
            FujinTable.foodServing,
            FoodServing(
              id: FujinId.at(now),
              foodId: food.id,
              position: position,
              value: serving.value,
              unit: serving.unit,
              nutritionMultiplier: serving.nutritionMultiplier,
              updatedAt: now,
            ).toMap(),
          );
        }
      case (_?, final food?)
          when mfpFood.verified != null && mfpFood.verified != food.verified:
        _saveFood(food.copyWith(verified: mfpFood.verified, updatedAt: now));
      case _:
        return;
    }
  });

  MfpFood? onPhone(String mfpFoodId) => _phoneCopies(
    _database.select(
      '$_versionedMfpFoods AND mfp.external_id = ?',
      [mfpFoodId],
    ),
  ).firstOrNull;

  List<MfpFood> onPhoneFoods() => _phoneCopies(
    _database.select(
      '$_versionedMfpFoods ORDER BY food.name, mfp.external_id',
    ),
  );

  List<String> mfpFoodsWithoutServings() => [
    for (final {_mfpFoodId: String mfpFoodId} in _database.select(
      'SELECT mfp.external_id AS mfp_food_id FROM food '
      'JOIN food_reference mfp ON mfp.food_id = food.id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      'WHERE food.deleted_at IS NULL AND NOT EXISTS ( '
      'SELECT 1 FROM food_serving serving '
      'WHERE serving.food_id = food.id AND serving.deleted_at IS NULL '
      ') ORDER BY mfp.external_id',
    ))
      mfpFoodId,
  ];

  List<MatchedFood> matches() => [
    for (final row in _database.select(
      'SELECT mfp.external_id AS mfp_food_id, '
      'food.name AS mfp_description, ekklo.external_id AS ekklo_food_id, '
      'ekklo.name AS ekklo_food_name '
      'FROM food_reference ekklo '
      'JOIN food ON food.id = ekklo.food_id '
      'JOIN food_reference mfp ON mfp.food_id = ekklo.food_id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      "WHERE ekklo.kind = 'ekklo' AND ekklo.deleted_at IS NULL "
      'AND food.deleted_at IS NULL '
      'ORDER BY food.name, mfp.external_id',
    ))
      MatchedFoodMapper.fromMap(row),
  ];

  List<OwnCopy> ownCopies() => [
    for (final row in _database.select(
      'SELECT mfp.external_id AS mfp_food_id, '
      'food.name AS mfp_description, copy.external_id AS ekklo_food_id, '
      'copy.name AS ekklo_food_name, copy.unit AS mfp_unit, '
      'copy.version AS mfp_food_version '
      'FROM food_reference copy '
      'JOIN food ON food.id = copy.food_id '
      'JOIN food_reference mfp ON mfp.food_id = copy.food_id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      "WHERE copy.kind = 'own_copy' AND copy.deleted_at IS NULL "
      'AND food.deleted_at IS NULL '
      'ORDER BY food.name, copy.unit',
    ))
      OwnCopyMapper.fromMap(row),
  ];

  List<RememberedUnit> rememberedUnits() => [
    for (final row in _database.select(
      'SELECT mfp.external_id AS mfp_food_id, unit.unit AS mfp_unit, '
      'unit.grams '
      'FROM food_unit unit '
      'JOIN food_reference mfp ON mfp.food_id = unit.food_id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      'WHERE unit.deleted_at IS NULL '
      'ORDER BY mfp.external_id, unit.unit',
    ))
      RememberedUnitMapper.fromMap(row),
  ];

  List<BarcodeLink> barcodeLinks() => [
    for (final row in _database.select(
      'SELECT link.barcode, mfp.external_id AS mfp_food_id '
      'FROM barcode_link link '
      'JOIN food_reference mfp ON mfp.food_id = link.food_id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      'WHERE link.deleted_at IS NULL '
      'ORDER BY link.barcode',
    ))
      BarcodeLinkMapper.fromMap(row),
  ];

  String? barcodeFood(String barcode) => switch (_database.select(
    'SELECT mfp.external_id AS mfp_food_id '
    'FROM barcode_link link '
    'JOIN food_reference mfp ON mfp.food_id = link.food_id '
    "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
    'WHERE link.barcode = ? AND link.deleted_at IS NULL',
    [barcode],
  )) {
    [{_mfpFoodId: final String mfpFoodId}] => mfpFoodId,
    _ => null,
  };

  bool isMatched(String foodId) => _ekkloReference(foodId) != null;

  void match(
    String foodId, {
    required String ekkloFoodId,
    required String name,
  }) => _database.transaction(() {
    final now = _now();
    _database.softDelete(
      FujinTable.foodReference,
      "food_id = ? AND kind = 'own_copy'",
      [foodId],
      now,
    );
    final reference = EkkloReference(
      id: FujinId.at(now),
      foodId: foodId,
      externalId: ekkloFoodId,
      name: name,
      updatedAt: now,
    );
    switch (_ekkloReference(foodId)) {
      case final current?
          when current.externalId == ekkloFoodId && current.name == name:
        return;
      case final current?:
        _saveReference(reference.copyWith(id: current.id));
      case null:
        _saveReference(reference);
    }
  });

  void ownCopy(
    String foodId, {
    required String ekkloFoodId,
    required String name,
    required String unit,
    required String? version,
  }) => _database.transaction(() {
    final now = _now();
    _forgetMatch(foodId, now);
    final reference = OwnCopyReference(
      id: FujinId.at(now),
      foodId: foodId,
      externalId: ekkloFoodId,
      name: name,
      unit: unit,
      version: version,
      updatedAt: now,
    );
    switch (_ownCopyReference(foodId, unit)) {
      case final current?
          when current.externalId == ekkloFoodId &&
              current.name == name &&
              current.version == version:
        return;
      case final current?:
        _saveReference(reference.copyWith(id: current.id));
      case null:
        _saveReference(reference);
    }
  });

  void forgetMatch(String foodId) =>
      _database.transaction(() => _forgetMatch(foodId, _now()));

  void forgetOwnCopy(String foodId, String unit) => _database.softDelete(
    FujinTable.foodReference,
    "food_id = ? AND kind = 'own_copy' AND unit = ?",
    [foodId, unit],
    _now(),
  );

  void saveUnit(String foodId, String unit, double grams) {
    final now = _now();
    final weight = FoodUnit(
      id: FujinId.at(now),
      foodId: foodId,
      unit: unit,
      grams: grams,
      updatedAt: now,
    );
    switch (_database.select(
      'SELECT * FROM food_unit '
      'WHERE food_id = ? AND unit = ? AND deleted_at IS NULL',
      [foodId, unit],
    )) {
      case [final row] when FoodUnitMapper.fromMap(row).grams == grams:
        return;
      case [final row]:
        _saveUnit(weight.copyWith(id: FoodUnitMapper.fromMap(row).id));
      case _:
        _saveUnit(weight);
    }
  }

  void linkBarcode(String barcode, String foodId) {
    final now = _now();
    final link = FoodBarcode(
      id: FujinId.at(now),
      barcode: barcode,
      foodId: foodId,
      updatedAt: now,
    );
    switch (_database.select(
      'SELECT * FROM barcode_link WHERE barcode = ? AND deleted_at IS NULL',
      [barcode],
    )) {
      case [final row] when FoodBarcodeMapper.fromMap(row).foodId == foodId:
        return;
      case [final row]:
        _saveBarcode(link.copyWith(id: FoodBarcodeMapper.fromMap(row).id));
      case _:
        _saveBarcode(link);
    }
  }

  void forgetMemory() => _database.transaction(() {
    final now = _now();
    _database
      ..softDelete(
        FujinTable.foodReference,
        "kind IN ('ekklo', 'own_copy')",
        const [],
        now,
      )
      ..softDelete(FujinTable.foodUnit, 'TRUE', const [], now)
      ..softDelete(FujinTable.barcodeLink, 'TRUE', const [], now);
  });

  List<Food> foods() => [
    for (final row in _database.select('SELECT * FROM food ORDER BY id'))
      FoodMapper.fromMap(row),
  ];

  List<FoodServing> servings() => [
    for (final row in _database.select(
      'SELECT * FROM food_serving ORDER BY food_id, position, id',
    ))
      FoodServingMapper.fromMap(row),
  ];

  List<FoodUnit> units() => [
    for (final row in _database.select(
      'SELECT * FROM food_unit ORDER BY food_id, unit, id',
    ))
      FoodUnitMapper.fromMap(row),
  ];

  List<FoodReference> references() => [
    for (final row in _database.select(
      'SELECT * FROM food_reference ORDER BY food_id, kind, id',
    ))
      FoodReferenceMapper.fromMap(row),
  ];

  List<FoodBarcode> barcodes() => [
    for (final row in _database.select(
      'SELECT * FROM barcode_link ORDER BY barcode, id',
    ))
      FoodBarcodeMapper.fromMap(row),
  ];

  void deleteAll() => _database.execute('DELETE FROM food');

  void restore({
    required List<Food> foods,
    required List<FoodServing> servings,
    required List<FoodUnit> units,
    required List<FoodReference> references,
    required List<FoodBarcode> barcodes,
  }) => _database.transaction(() {
    for (final food in foods) {
      _database.insert(FujinTable.food, food.toMap());
    }
    for (final serving in servings) {
      _database.insert(FujinTable.foodServing, serving.toMap());
    }
    for (final unit in units) {
      _database.insert(FujinTable.foodUnit, unit.toMap());
    }
    for (final reference in references) {
      _database.insert(FujinTable.foodReference, reference.toMap());
    }
    for (final barcode in barcodes) {
      _database.insert(FujinTable.barcodeLink, barcode.toMap());
    }
  });

  DateTime _now() => _clock().toUtc();

  String _described(
    Food food, {
    required String? name,
    required String? brand,
  }) {
    if (food.name != name || food.brand != brand) {
      _saveFood(food.copyWith(name: name, brand: brand, updatedAt: _now()));
    }
    return food.id;
  }

  String _addMfpFood(
    String mfpFoodId, {
    required String id,
    required String? name,
    required String? brand,
  }) {
    final now = _now();
    final food = Food(
      id: id,
      name: name,
      brand: brand,
      updatedAt: now,
    );
    _saveFood(food);
    _saveReference(
      MfpReference(
        id: FujinId.at(now),
        foodId: food.id,
        externalId: mfpFoodId,
        updatedAt: now,
      ),
    );
    return food.id;
  }

  Food? foodOfMfp(String mfpFoodId) => switch (_database.select(
    'SELECT food.* FROM food '
    'JOIN food_reference mfp ON mfp.food_id = food.id '
    "WHERE mfp.kind = 'mfp' AND mfp.external_id = ? "
    'AND mfp.deleted_at IS NULL AND food.deleted_at IS NULL',
    [mfpFoodId],
  )) {
    [final row] => FoodMapper.fromMap(row),
    _ => null,
  };

  MfpReference? _mfpReference(String mfpFoodId) => switch (_database.select(
    'SELECT * FROM food_reference '
    "WHERE kind = 'mfp' AND external_id = ? AND deleted_at IS NULL",
    [mfpFoodId],
  )) {
    [final row] => MfpReferenceMapper.fromMap(row),
    _ => null,
  };

  EkkloReference? _ekkloReference(String foodId) => switch (_database.select(
    'SELECT * FROM food_reference '
    "WHERE food_id = ? AND kind = 'ekklo' AND deleted_at IS NULL",
    [foodId],
  )) {
    [final row] => EkkloReferenceMapper.fromMap(row),
    _ => null,
  };

  OwnCopyReference? _ownCopyReference(String foodId, String unit) =>
      switch (_database.select(
        'SELECT * FROM food_reference '
        "WHERE food_id = ? AND kind = 'own_copy' AND unit = ? "
        'AND deleted_at IS NULL',
        [foodId, unit],
      )) {
        [final row] => OwnCopyReferenceMapper.fromMap(row),
        _ => null,
      };

  List<MfpFood> _phoneCopies(Iterable<Map<String, Object?>> rows) => [
    for (final row in rows)
      if ((row[_mfpFoodId], row[_mfpFoodVersion]) case (
        final String mfpFoodId,
        final String version,
      ))
        ?_phoneCopy(
          FoodMapper.fromMap(row),
          mfpFoodId: mfpFoodId,
          version: version,
        ),
  ];

  MfpFood? _phoneCopy(
    Food food, {
    required String mfpFoodId,
    required String version,
  }) => switch ((food.name, _servingSizes(food.id))) {
    (final name?, final servings)
        when servings.isNotEmpty && food.nutrients != const FoodNutrients() =>
      MfpFood(
        id: mfpFoodId,
        version: version,
        description: name,
        brandName: food.brand,
        verified: food.verified,
        servingSizes: servings,
        nutrients: food.nutrients.toMfp(),
      ),
    _ => null,
  };

  List<MfpServingSize> _servingSizes(String foodId) => [
    for (final row in _database.select(
      'SELECT * FROM food_serving '
      'WHERE food_id = ? AND deleted_at IS NULL ORDER BY position, id',
      [foodId],
    ))
      FoodServingMapper.fromMap(row).toMfp(),
  ];

  bool _hasServings(String foodId) => _database.select(
    'SELECT 1 FROM food_serving WHERE food_id = ? AND deleted_at IS NULL',
    [foodId],
  ).isNotEmpty;

  void _forgetMatch(String foodId, DateTime now) {
    _database
      ..softDelete(
        FujinTable.foodReference,
        "food_id = ? AND kind = 'ekklo'",
        [foodId],
        now,
      )
      ..softDelete(FujinTable.foodUnit, 'food_id = ?', [foodId], now);
  }

  void _saveFood(Food food) =>
      _database.upsert(FujinTable.food, food.toMap(), key: const [_id]);

  void _saveReference(FoodReference reference) => _database.upsert(
    FujinTable.foodReference,
    reference.toMap(),
    key: const [_id],
  );

  void _saveUnit(FoodUnit unit) =>
      _database.upsert(FujinTable.foodUnit, unit.toMap(), key: const [_id]);

  void _saveBarcode(FoodBarcode barcode) => _database.upsert(
    FujinTable.barcodeLink,
    barcode.toMap(),
    key: const [_id],
  );

  static const _id = 'id';
  static const _mfpFoodId = 'mfp_food_id';
  static const _mfpFoodVersion = 'mfp_food_version';
  static const _versionedMfpFoods =
      'SELECT food.*, mfp.external_id AS mfp_food_id, '
      'mfp.version AS mfp_food_version '
      'FROM food '
      'JOIN food_reference mfp ON mfp.food_id = food.id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      'WHERE mfp.version IS NOT NULL AND food.deleted_at IS NULL';
}
