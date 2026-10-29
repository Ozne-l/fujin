// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food_serving.dart';

class FoodServingMapper extends ClassMapperBase<FoodServing> {
  FoodServingMapper._();

  static FoodServingMapper? _instance;
  static FoodServingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodServingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FoodServing';

  static String _$id(FoodServing v) => v.id;
  static const Field<FoodServing, String> _f$id = Field('id', _$id);
  static String _$foodId(FoodServing v) => v.foodId;
  static const Field<FoodServing, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static int _$position(FoodServing v) => v.position;
  static const Field<FoodServing, int> _f$position = Field(
    'position',
    _$position,
  );
  static double _$value(FoodServing v) => v.value;
  static const Field<FoodServing, double> _f$value = Field('value', _$value);
  static String _$unit(FoodServing v) => v.unit;
  static const Field<FoodServing, String> _f$unit = Field('unit', _$unit);
  static DateTime _$updatedAt(FoodServing v) => v.updatedAt;
  static const Field<FoodServing, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static double? _$nutritionMultiplier(FoodServing v) => v.nutritionMultiplier;
  static const Field<FoodServing, double> _f$nutritionMultiplier = Field(
    'nutritionMultiplier',
    _$nutritionMultiplier,
    key: r'nutrition_multiplier',
    opt: true,
  );
  static DateTime? _$deletedAt(FoodServing v) => v.deletedAt;
  static const Field<FoodServing, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<FoodServing> fields = const {
    #id: _f$id,
    #foodId: _f$foodId,
    #position: _f$position,
    #value: _f$value,
    #unit: _f$unit,
    #updatedAt: _f$updatedAt,
    #nutritionMultiplier: _f$nutritionMultiplier,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static FoodServing _instantiate(DecodingData data) {
    return FoodServing(
      id: data.dec(_f$id),
      foodId: data.dec(_f$foodId),
      position: data.dec(_f$position),
      value: data.dec(_f$value),
      unit: data.dec(_f$unit),
      updatedAt: data.dec(_f$updatedAt),
      nutritionMultiplier: data.dec(_f$nutritionMultiplier),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FoodServing fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FoodServing>(map);
  }

  static FoodServing fromJson(String json) {
    return ensureInitialized().decodeJson<FoodServing>(json);
  }
}

mixin FoodServingMappable {
  String toJson() {
    return FoodServingMapper.ensureInitialized().encodeJson<FoodServing>(
      this as FoodServing,
    );
  }

  Map<String, dynamic> toMap() {
    return FoodServingMapper.ensureInitialized().encodeMap<FoodServing>(
      this as FoodServing,
    );
  }

  FoodServingCopyWith<FoodServing, FoodServing, FoodServing> get copyWith =>
      _FoodServingCopyWithImpl<FoodServing, FoodServing>(
        this as FoodServing,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FoodServingMapper.ensureInitialized().stringifyValue(
      this as FoodServing,
    );
  }

  @override
  bool operator ==(Object other) {
    return FoodServingMapper.ensureInitialized().equalsValue(
      this as FoodServing,
      other,
    );
  }

  @override
  int get hashCode {
    return FoodServingMapper.ensureInitialized().hashValue(this as FoodServing);
  }
}

extension FoodServingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FoodServing, $Out> {
  FoodServingCopyWith<$R, FoodServing, $Out> get $asFoodServing =>
      $base.as((v, t, t2) => _FoodServingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FoodServingCopyWith<$R, $In extends FoodServing, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? foodId,
    int? position,
    double? value,
    String? unit,
    DateTime? updatedAt,
    double? nutritionMultiplier,
    DateTime? deletedAt,
  });
  FoodServingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FoodServingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FoodServing, $Out>
    implements FoodServingCopyWith<$R, FoodServing, $Out> {
  _FoodServingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FoodServing> $mapper =
      FoodServingMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? foodId,
    int? position,
    double? value,
    String? unit,
    DateTime? updatedAt,
    Object? nutritionMultiplier = $none,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (foodId != null) #foodId: foodId,
      if (position != null) #position: position,
      if (value != null) #value: value,
      if (unit != null) #unit: unit,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (nutritionMultiplier != $none)
        #nutritionMultiplier: nutritionMultiplier,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  FoodServing $make(CopyWithData data) => FoodServing(
    id: data.get(#id, or: $value.id),
    foodId: data.get(#foodId, or: $value.foodId),
    position: data.get(#position, or: $value.position),
    value: data.get(#value, or: $value.value),
    unit: data.get(#unit, or: $value.unit),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    nutritionMultiplier: data.get(
      #nutritionMultiplier,
      or: $value.nutritionMultiplier,
    ),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  FoodServingCopyWith<$R2, FoodServing, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FoodServingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

