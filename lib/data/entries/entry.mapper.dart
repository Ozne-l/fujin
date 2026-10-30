// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'entry.dart';

class EntryMapper extends ClassMapperBase<Entry> {
  EntryMapper._();

  static EntryMapper? _instance;
  static EntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EntryMapper._());
      FoodNutrientsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Entry';

  static String _$id(Entry v) => v.id;
  static const Field<Entry, String> _f$id = Field('id', _$id);
  static DateTime _$date(Entry v) => v.date;
  static const Field<Entry, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static String _$mealId(Entry v) => v.mealId;
  static const Field<Entry, String> _f$mealId = Field(
    'mealId',
    _$mealId,
    key: r'meal_id',
  );
  static String _$foodId(Entry v) => v.foodId;
  static const Field<Entry, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static double _$servingValue(Entry v) => v.servingValue;
  static const Field<Entry, double> _f$servingValue = Field(
    'servingValue',
    _$servingValue,
    key: r'serving_value',
  );
  static String _$servingUnit(Entry v) => v.servingUnit;
  static const Field<Entry, String> _f$servingUnit = Field(
    'servingUnit',
    _$servingUnit,
    key: r'serving_unit',
  );
  static double _$servings(Entry v) => v.servings;
  static const Field<Entry, double> _f$servings = Field('servings', _$servings);
  static DateTime _$updatedAt(Entry v) => v.updatedAt;
  static const Field<Entry, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static double? _$nutritionMultiplier(Entry v) => v.nutritionMultiplier;
  static const Field<Entry, double> _f$nutritionMultiplier = Field(
    'nutritionMultiplier',
    _$nutritionMultiplier,
    key: r'nutrition_multiplier',
    opt: true,
  );
  static FoodNutrients _$nutrients(Entry v) => v.nutrients;
  static const Field<Entry, FoodNutrients> _f$nutrients = Field(
    'nutrients',
    _$nutrients,
    opt: true,
    def: const FoodNutrients(),
  );
  static DateTime? _$deletedAt(Entry v) => v.deletedAt;
  static const Field<Entry, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<Entry> fields = const {
    #id: _f$id,
    #date: _f$date,
    #mealId: _f$mealId,
    #foodId: _f$foodId,
    #servingValue: _f$servingValue,
    #servingUnit: _f$servingUnit,
    #servings: _f$servings,
    #updatedAt: _f$updatedAt,
    #nutritionMultiplier: _f$nutritionMultiplier,
    #nutrients: _f$nutrients,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final MappingHook hook = const FlatNutrientsHook();
  static Entry _instantiate(DecodingData data) {
    return Entry(
      id: data.dec(_f$id),
      date: data.dec(_f$date),
      mealId: data.dec(_f$mealId),
      foodId: data.dec(_f$foodId),
      servingValue: data.dec(_f$servingValue),
      servingUnit: data.dec(_f$servingUnit),
      servings: data.dec(_f$servings),
      updatedAt: data.dec(_f$updatedAt),
      nutritionMultiplier: data.dec(_f$nutritionMultiplier),
      nutrients: data.dec(_f$nutrients),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Entry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Entry>(map);
  }

  static Entry fromJson(String json) {
    return ensureInitialized().decodeJson<Entry>(json);
  }
}

mixin EntryMappable {
  String toJson() {
    return EntryMapper.ensureInitialized().encodeJson<Entry>(this as Entry);
  }

  Map<String, dynamic> toMap() {
    return EntryMapper.ensureInitialized().encodeMap<Entry>(this as Entry);
  }

  EntryCopyWith<Entry, Entry, Entry> get copyWith =>
      _EntryCopyWithImpl<Entry, Entry>(this as Entry, $identity, $identity);
  @override
  String toString() {
    return EntryMapper.ensureInitialized().stringifyValue(this as Entry);
  }

  @override
  bool operator ==(Object other) {
    return EntryMapper.ensureInitialized().equalsValue(this as Entry, other);
  }

  @override
  int get hashCode {
    return EntryMapper.ensureInitialized().hashValue(this as Entry);
  }
}

extension EntryValueCopy<$R, $Out> on ObjectCopyWith<$R, Entry, $Out> {
  EntryCopyWith<$R, Entry, $Out> get $asEntry =>
      $base.as((v, t, t2) => _EntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EntryCopyWith<$R, $In extends Entry, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  FoodNutrientsCopyWith<$R, FoodNutrients, FoodNutrients> get nutrients;
  $R call({
    String? id,
    DateTime? date,
    String? mealId,
    String? foodId,
    double? servingValue,
    String? servingUnit,
    double? servings,
    DateTime? updatedAt,
    double? nutritionMultiplier,
    FoodNutrients? nutrients,
    DateTime? deletedAt,
  });
  EntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EntryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Entry, $Out>
    implements EntryCopyWith<$R, Entry, $Out> {
  _EntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Entry> $mapper = EntryMapper.ensureInitialized();
  @override
  FoodNutrientsCopyWith<$R, FoodNutrients, FoodNutrients> get nutrients =>
      $value.nutrients.copyWith.$chain((v) => call(nutrients: v));
  @override
  $R call({
    String? id,
    DateTime? date,
    String? mealId,
    String? foodId,
    double? servingValue,
    String? servingUnit,
    double? servings,
    DateTime? updatedAt,
    Object? nutritionMultiplier = $none,
    FoodNutrients? nutrients,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (date != null) #date: date,
      if (mealId != null) #mealId: mealId,
      if (foodId != null) #foodId: foodId,
      if (servingValue != null) #servingValue: servingValue,
      if (servingUnit != null) #servingUnit: servingUnit,
      if (servings != null) #servings: servings,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (nutritionMultiplier != $none)
        #nutritionMultiplier: nutritionMultiplier,
      if (nutrients != null) #nutrients: nutrients,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  Entry $make(CopyWithData data) => Entry(
    id: data.get(#id, or: $value.id),
    date: data.get(#date, or: $value.date),
    mealId: data.get(#mealId, or: $value.mealId),
    foodId: data.get(#foodId, or: $value.foodId),
    servingValue: data.get(#servingValue, or: $value.servingValue),
    servingUnit: data.get(#servingUnit, or: $value.servingUnit),
    servings: data.get(#servings, or: $value.servings),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    nutritionMultiplier: data.get(
      #nutritionMultiplier,
      or: $value.nutritionMultiplier,
    ),
    nutrients: data.get(#nutrients, or: $value.nutrients),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  EntryCopyWith<$R2, Entry, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

