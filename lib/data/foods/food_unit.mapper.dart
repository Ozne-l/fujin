// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food_unit.dart';

class FoodUnitMapper extends ClassMapperBase<FoodUnit> {
  FoodUnitMapper._();

  static FoodUnitMapper? _instance;
  static FoodUnitMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodUnitMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FoodUnit';

  static String _$id(FoodUnit v) => v.id;
  static const Field<FoodUnit, String> _f$id = Field('id', _$id);
  static String _$foodId(FoodUnit v) => v.foodId;
  static const Field<FoodUnit, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static String _$unit(FoodUnit v) => v.unit;
  static const Field<FoodUnit, String> _f$unit = Field('unit', _$unit);
  static double _$grams(FoodUnit v) => v.grams;
  static const Field<FoodUnit, double> _f$grams = Field('grams', _$grams);
  static DateTime _$updatedAt(FoodUnit v) => v.updatedAt;
  static const Field<FoodUnit, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(FoodUnit v) => v.deletedAt;
  static const Field<FoodUnit, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<FoodUnit> fields = const {
    #id: _f$id,
    #foodId: _f$foodId,
    #unit: _f$unit,
    #grams: _f$grams,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static FoodUnit _instantiate(DecodingData data) {
    return FoodUnit(
      id: data.dec(_f$id),
      foodId: data.dec(_f$foodId),
      unit: data.dec(_f$unit),
      grams: data.dec(_f$grams),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FoodUnit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FoodUnit>(map);
  }

  static FoodUnit fromJson(String json) {
    return ensureInitialized().decodeJson<FoodUnit>(json);
  }
}

mixin FoodUnitMappable {
  String toJson() {
    return FoodUnitMapper.ensureInitialized().encodeJson<FoodUnit>(
      this as FoodUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return FoodUnitMapper.ensureInitialized().encodeMap<FoodUnit>(
      this as FoodUnit,
    );
  }

  FoodUnitCopyWith<FoodUnit, FoodUnit, FoodUnit> get copyWith =>
      _FoodUnitCopyWithImpl<FoodUnit, FoodUnit>(
        this as FoodUnit,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FoodUnitMapper.ensureInitialized().stringifyValue(this as FoodUnit);
  }

  @override
  bool operator ==(Object other) {
    return FoodUnitMapper.ensureInitialized().equalsValue(
      this as FoodUnit,
      other,
    );
  }

  @override
  int get hashCode {
    return FoodUnitMapper.ensureInitialized().hashValue(this as FoodUnit);
  }
}

extension FoodUnitValueCopy<$R, $Out> on ObjectCopyWith<$R, FoodUnit, $Out> {
  FoodUnitCopyWith<$R, FoodUnit, $Out> get $asFoodUnit =>
      $base.as((v, t, t2) => _FoodUnitCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FoodUnitCopyWith<$R, $In extends FoodUnit, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? foodId,
    String? unit,
    double? grams,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  FoodUnitCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FoodUnitCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FoodUnit, $Out>
    implements FoodUnitCopyWith<$R, FoodUnit, $Out> {
  _FoodUnitCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FoodUnit> $mapper =
      FoodUnitMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? foodId,
    String? unit,
    double? grams,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (foodId != null) #foodId: foodId,
      if (unit != null) #unit: unit,
      if (grams != null) #grams: grams,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  FoodUnit $make(CopyWithData data) => FoodUnit(
    id: data.get(#id, or: $value.id),
    foodId: data.get(#foodId, or: $value.foodId),
    unit: data.get(#unit, or: $value.unit),
    grams: data.get(#grams, or: $value.grams),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  FoodUnitCopyWith<$R2, FoodUnit, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FoodUnitCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

