// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food_nutrients.dart';

class FoodNutrientsMapper extends ClassMapperBase<FoodNutrients> {
  FoodNutrientsMapper._();

  static FoodNutrientsMapper? _instance;
  static FoodNutrientsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodNutrientsMapper._());
      EnergyUnitMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FoodNutrients';

  static double? _$energyValue(FoodNutrients v) => v.energyValue;
  static const Field<FoodNutrients, double> _f$energyValue = Field(
    'energyValue',
    _$energyValue,
    key: r'energy_value',
    opt: true,
  );
  static EnergyUnit? _$energyUnit(FoodNutrients v) => v.energyUnit;
  static const Field<FoodNutrients, EnergyUnit> _f$energyUnit = Field(
    'energyUnit',
    _$energyUnit,
    key: r'energy_unit',
    opt: true,
  );
  static double? _$protein(FoodNutrients v) => v.protein;
  static const Field<FoodNutrients, double> _f$protein = Field(
    'protein',
    _$protein,
    opt: true,
  );
  static double? _$carbohydrates(FoodNutrients v) => v.carbohydrates;
  static const Field<FoodNutrients, double> _f$carbohydrates = Field(
    'carbohydrates',
    _$carbohydrates,
    opt: true,
  );
  static double? _$netCarbs(FoodNutrients v) => v.netCarbs;
  static const Field<FoodNutrients, double> _f$netCarbs = Field(
    'netCarbs',
    _$netCarbs,
    key: r'net_carbs',
    opt: true,
  );
  static double? _$fiber(FoodNutrients v) => v.fiber;
  static const Field<FoodNutrients, double> _f$fiber = Field(
    'fiber',
    _$fiber,
    opt: true,
  );
  static double? _$sugar(FoodNutrients v) => v.sugar;
  static const Field<FoodNutrients, double> _f$sugar = Field(
    'sugar',
    _$sugar,
    opt: true,
  );
  static double? _$addedSugars(FoodNutrients v) => v.addedSugars;
  static const Field<FoodNutrients, double> _f$addedSugars = Field(
    'addedSugars',
    _$addedSugars,
    key: r'added_sugars',
    opt: true,
  );
  static double? _$sugarAlcohols(FoodNutrients v) => v.sugarAlcohols;
  static const Field<FoodNutrients, double> _f$sugarAlcohols = Field(
    'sugarAlcohols',
    _$sugarAlcohols,
    key: r'sugar_alcohols',
    opt: true,
  );
  static double? _$fat(FoodNutrients v) => v.fat;
  static const Field<FoodNutrients, double> _f$fat = Field(
    'fat',
    _$fat,
    opt: true,
  );
  static double? _$saturatedFat(FoodNutrients v) => v.saturatedFat;
  static const Field<FoodNutrients, double> _f$saturatedFat = Field(
    'saturatedFat',
    _$saturatedFat,
    key: r'saturated_fat',
    opt: true,
  );
  static double? _$monounsaturatedFat(FoodNutrients v) => v.monounsaturatedFat;
  static const Field<FoodNutrients, double> _f$monounsaturatedFat = Field(
    'monounsaturatedFat',
    _$monounsaturatedFat,
    key: r'monounsaturated_fat',
    opt: true,
  );
  static double? _$polyunsaturatedFat(FoodNutrients v) => v.polyunsaturatedFat;
  static const Field<FoodNutrients, double> _f$polyunsaturatedFat = Field(
    'polyunsaturatedFat',
    _$polyunsaturatedFat,
    key: r'polyunsaturated_fat',
    opt: true,
  );
  static double? _$transFat(FoodNutrients v) => v.transFat;
  static const Field<FoodNutrients, double> _f$transFat = Field(
    'transFat',
    _$transFat,
    key: r'trans_fat',
    opt: true,
  );
  static double? _$cholesterolMilligrams(FoodNutrients v) =>
      v.cholesterolMilligrams;
  static const Field<FoodNutrients, double> _f$cholesterolMilligrams = Field(
    'cholesterolMilligrams',
    _$cholesterolMilligrams,
    key: r'cholesterol_milligrams',
    opt: true,
  );
  static double? _$sodiumMilligrams(FoodNutrients v) => v.sodiumMilligrams;
  static const Field<FoodNutrients, double> _f$sodiumMilligrams = Field(
    'sodiumMilligrams',
    _$sodiumMilligrams,
    key: r'sodium_milligrams',
    opt: true,
  );
  static double? _$potassiumMilligrams(FoodNutrients v) =>
      v.potassiumMilligrams;
  static const Field<FoodNutrients, double> _f$potassiumMilligrams = Field(
    'potassiumMilligrams',
    _$potassiumMilligrams,
    key: r'potassium_milligrams',
    opt: true,
  );
  static double? _$vitaminA(FoodNutrients v) => v.vitaminA;
  static const Field<FoodNutrients, double> _f$vitaminA = Field(
    'vitaminA',
    _$vitaminA,
    key: r'vitamin_a',
    opt: true,
  );
  static double? _$vitaminC(FoodNutrients v) => v.vitaminC;
  static const Field<FoodNutrients, double> _f$vitaminC = Field(
    'vitaminC',
    _$vitaminC,
    key: r'vitamin_c',
    opt: true,
  );
  static double? _$vitaminD(FoodNutrients v) => v.vitaminD;
  static const Field<FoodNutrients, double> _f$vitaminD = Field(
    'vitaminD',
    _$vitaminD,
    key: r'vitamin_d',
    opt: true,
  );
  static double? _$calcium(FoodNutrients v) => v.calcium;
  static const Field<FoodNutrients, double> _f$calcium = Field(
    'calcium',
    _$calcium,
    opt: true,
  );
  static double? _$iron(FoodNutrients v) => v.iron;
  static const Field<FoodNutrients, double> _f$iron = Field(
    'iron',
    _$iron,
    opt: true,
  );

  @override
  final MappableFields<FoodNutrients> fields = const {
    #energyValue: _f$energyValue,
    #energyUnit: _f$energyUnit,
    #protein: _f$protein,
    #carbohydrates: _f$carbohydrates,
    #netCarbs: _f$netCarbs,
    #fiber: _f$fiber,
    #sugar: _f$sugar,
    #addedSugars: _f$addedSugars,
    #sugarAlcohols: _f$sugarAlcohols,
    #fat: _f$fat,
    #saturatedFat: _f$saturatedFat,
    #monounsaturatedFat: _f$monounsaturatedFat,
    #polyunsaturatedFat: _f$polyunsaturatedFat,
    #transFat: _f$transFat,
    #cholesterolMilligrams: _f$cholesterolMilligrams,
    #sodiumMilligrams: _f$sodiumMilligrams,
    #potassiumMilligrams: _f$potassiumMilligrams,
    #vitaminA: _f$vitaminA,
    #vitaminC: _f$vitaminC,
    #vitaminD: _f$vitaminD,
    #calcium: _f$calcium,
    #iron: _f$iron,
  };
  @override
  final bool ignoreNull = true;

  static FoodNutrients _instantiate(DecodingData data) {
    return FoodNutrients(
      energyValue: data.dec(_f$energyValue),
      energyUnit: data.dec(_f$energyUnit),
      protein: data.dec(_f$protein),
      carbohydrates: data.dec(_f$carbohydrates),
      netCarbs: data.dec(_f$netCarbs),
      fiber: data.dec(_f$fiber),
      sugar: data.dec(_f$sugar),
      addedSugars: data.dec(_f$addedSugars),
      sugarAlcohols: data.dec(_f$sugarAlcohols),
      fat: data.dec(_f$fat),
      saturatedFat: data.dec(_f$saturatedFat),
      monounsaturatedFat: data.dec(_f$monounsaturatedFat),
      polyunsaturatedFat: data.dec(_f$polyunsaturatedFat),
      transFat: data.dec(_f$transFat),
      cholesterolMilligrams: data.dec(_f$cholesterolMilligrams),
      sodiumMilligrams: data.dec(_f$sodiumMilligrams),
      potassiumMilligrams: data.dec(_f$potassiumMilligrams),
      vitaminA: data.dec(_f$vitaminA),
      vitaminC: data.dec(_f$vitaminC),
      vitaminD: data.dec(_f$vitaminD),
      calcium: data.dec(_f$calcium),
      iron: data.dec(_f$iron),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FoodNutrients fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FoodNutrients>(map);
  }

  static FoodNutrients fromJson(String json) {
    return ensureInitialized().decodeJson<FoodNutrients>(json);
  }
}

mixin FoodNutrientsMappable {
  String toJson() {
    return FoodNutrientsMapper.ensureInitialized().encodeJson<FoodNutrients>(
      this as FoodNutrients,
    );
  }

  Map<String, dynamic> toMap() {
    return FoodNutrientsMapper.ensureInitialized().encodeMap<FoodNutrients>(
      this as FoodNutrients,
    );
  }

  FoodNutrientsCopyWith<FoodNutrients, FoodNutrients, FoodNutrients>
  get copyWith => _FoodNutrientsCopyWithImpl<FoodNutrients, FoodNutrients>(
    this as FoodNutrients,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FoodNutrientsMapper.ensureInitialized().stringifyValue(
      this as FoodNutrients,
    );
  }

  @override
  bool operator ==(Object other) {
    return FoodNutrientsMapper.ensureInitialized().equalsValue(
      this as FoodNutrients,
      other,
    );
  }

  @override
  int get hashCode {
    return FoodNutrientsMapper.ensureInitialized().hashValue(
      this as FoodNutrients,
    );
  }
}

extension FoodNutrientsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FoodNutrients, $Out> {
  FoodNutrientsCopyWith<$R, FoodNutrients, $Out> get $asFoodNutrients =>
      $base.as((v, t, t2) => _FoodNutrientsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FoodNutrientsCopyWith<$R, $In extends FoodNutrients, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    double? energyValue,
    EnergyUnit? energyUnit,
    double? protein,
    double? carbohydrates,
    double? netCarbs,
    double? fiber,
    double? sugar,
    double? addedSugars,
    double? sugarAlcohols,
    double? fat,
    double? saturatedFat,
    double? monounsaturatedFat,
    double? polyunsaturatedFat,
    double? transFat,
    double? cholesterolMilligrams,
    double? sodiumMilligrams,
    double? potassiumMilligrams,
    double? vitaminA,
    double? vitaminC,
    double? vitaminD,
    double? calcium,
    double? iron,
  });
  FoodNutrientsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FoodNutrientsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FoodNutrients, $Out>
    implements FoodNutrientsCopyWith<$R, FoodNutrients, $Out> {
  _FoodNutrientsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FoodNutrients> $mapper =
      FoodNutrientsMapper.ensureInitialized();
  @override
  $R call({
    Object? energyValue = $none,
    Object? energyUnit = $none,
    Object? protein = $none,
    Object? carbohydrates = $none,
    Object? netCarbs = $none,
    Object? fiber = $none,
    Object? sugar = $none,
    Object? addedSugars = $none,
    Object? sugarAlcohols = $none,
    Object? fat = $none,
    Object? saturatedFat = $none,
    Object? monounsaturatedFat = $none,
    Object? polyunsaturatedFat = $none,
    Object? transFat = $none,
    Object? cholesterolMilligrams = $none,
    Object? sodiumMilligrams = $none,
    Object? potassiumMilligrams = $none,
    Object? vitaminA = $none,
    Object? vitaminC = $none,
    Object? vitaminD = $none,
    Object? calcium = $none,
    Object? iron = $none,
  }) => $apply(
    FieldCopyWithData({
      if (energyValue != $none) #energyValue: energyValue,
      if (energyUnit != $none) #energyUnit: energyUnit,
      if (protein != $none) #protein: protein,
      if (carbohydrates != $none) #carbohydrates: carbohydrates,
      if (netCarbs != $none) #netCarbs: netCarbs,
      if (fiber != $none) #fiber: fiber,
      if (sugar != $none) #sugar: sugar,
      if (addedSugars != $none) #addedSugars: addedSugars,
      if (sugarAlcohols != $none) #sugarAlcohols: sugarAlcohols,
      if (fat != $none) #fat: fat,
      if (saturatedFat != $none) #saturatedFat: saturatedFat,
      if (monounsaturatedFat != $none) #monounsaturatedFat: monounsaturatedFat,
      if (polyunsaturatedFat != $none) #polyunsaturatedFat: polyunsaturatedFat,
      if (transFat != $none) #transFat: transFat,
      if (cholesterolMilligrams != $none)
        #cholesterolMilligrams: cholesterolMilligrams,
      if (sodiumMilligrams != $none) #sodiumMilligrams: sodiumMilligrams,
      if (potassiumMilligrams != $none)
        #potassiumMilligrams: potassiumMilligrams,
      if (vitaminA != $none) #vitaminA: vitaminA,
      if (vitaminC != $none) #vitaminC: vitaminC,
      if (vitaminD != $none) #vitaminD: vitaminD,
      if (calcium != $none) #calcium: calcium,
      if (iron != $none) #iron: iron,
    }),
  );
  @override
  FoodNutrients $make(CopyWithData data) => FoodNutrients(
    energyValue: data.get(#energyValue, or: $value.energyValue),
    energyUnit: data.get(#energyUnit, or: $value.energyUnit),
    protein: data.get(#protein, or: $value.protein),
    carbohydrates: data.get(#carbohydrates, or: $value.carbohydrates),
    netCarbs: data.get(#netCarbs, or: $value.netCarbs),
    fiber: data.get(#fiber, or: $value.fiber),
    sugar: data.get(#sugar, or: $value.sugar),
    addedSugars: data.get(#addedSugars, or: $value.addedSugars),
    sugarAlcohols: data.get(#sugarAlcohols, or: $value.sugarAlcohols),
    fat: data.get(#fat, or: $value.fat),
    saturatedFat: data.get(#saturatedFat, or: $value.saturatedFat),
    monounsaturatedFat: data.get(
      #monounsaturatedFat,
      or: $value.monounsaturatedFat,
    ),
    polyunsaturatedFat: data.get(
      #polyunsaturatedFat,
      or: $value.polyunsaturatedFat,
    ),
    transFat: data.get(#transFat, or: $value.transFat),
    cholesterolMilligrams: data.get(
      #cholesterolMilligrams,
      or: $value.cholesterolMilligrams,
    ),
    sodiumMilligrams: data.get(#sodiumMilligrams, or: $value.sodiumMilligrams),
    potassiumMilligrams: data.get(
      #potassiumMilligrams,
      or: $value.potassiumMilligrams,
    ),
    vitaminA: data.get(#vitaminA, or: $value.vitaminA),
    vitaminC: data.get(#vitaminC, or: $value.vitaminC),
    vitaminD: data.get(#vitaminD, or: $value.vitaminD),
    calcium: data.get(#calcium, or: $value.calcium),
    iron: data.get(#iron, or: $value.iron),
  );

  @override
  FoodNutrientsCopyWith<$R2, FoodNutrients, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FoodNutrientsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

