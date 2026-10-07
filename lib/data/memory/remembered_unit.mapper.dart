// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'remembered_unit.dart';

class RememberedUnitMapper extends ClassMapperBase<RememberedUnit> {
  RememberedUnitMapper._();

  static RememberedUnitMapper? _instance;
  static RememberedUnitMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RememberedUnitMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RememberedUnit';

  static String _$mfpFoodId(RememberedUnit v) => v.mfpFoodId;
  static const Field<RememberedUnit, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$mfpUnit(RememberedUnit v) => v.mfpUnit;
  static const Field<RememberedUnit, String> _f$mfpUnit = Field(
    'mfpUnit',
    _$mfpUnit,
    key: r'mfp_unit',
  );
  static double _$grams(RememberedUnit v) => v.grams;
  static const Field<RememberedUnit, double> _f$grams = Field('grams', _$grams);

  @override
  final MappableFields<RememberedUnit> fields = const {
    #mfpFoodId: _f$mfpFoodId,
    #mfpUnit: _f$mfpUnit,
    #grams: _f$grams,
  };
  @override
  final bool ignoreNull = true;

  static RememberedUnit _instantiate(DecodingData data) {
    return RememberedUnit(
      mfpFoodId: data.dec(_f$mfpFoodId),
      mfpUnit: data.dec(_f$mfpUnit),
      grams: data.dec(_f$grams),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RememberedUnit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RememberedUnit>(map);
  }

  static RememberedUnit fromJson(String json) {
    return ensureInitialized().decodeJson<RememberedUnit>(json);
  }
}

mixin RememberedUnitMappable {
  String toJson() {
    return RememberedUnitMapper.ensureInitialized().encodeJson<RememberedUnit>(
      this as RememberedUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return RememberedUnitMapper.ensureInitialized().encodeMap<RememberedUnit>(
      this as RememberedUnit,
    );
  }

  RememberedUnitCopyWith<RememberedUnit, RememberedUnit, RememberedUnit>
  get copyWith => _RememberedUnitCopyWithImpl<RememberedUnit, RememberedUnit>(
    this as RememberedUnit,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RememberedUnitMapper.ensureInitialized().stringifyValue(
      this as RememberedUnit,
    );
  }

  @override
  bool operator ==(Object other) {
    return RememberedUnitMapper.ensureInitialized().equalsValue(
      this as RememberedUnit,
      other,
    );
  }

  @override
  int get hashCode {
    return RememberedUnitMapper.ensureInitialized().hashValue(
      this as RememberedUnit,
    );
  }
}

extension RememberedUnitValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RememberedUnit, $Out> {
  RememberedUnitCopyWith<$R, RememberedUnit, $Out> get $asRememberedUnit =>
      $base.as((v, t, t2) => _RememberedUnitCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RememberedUnitCopyWith<$R, $In extends RememberedUnit, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? mfpFoodId, String? mfpUnit, double? grams});
  RememberedUnitCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RememberedUnitCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RememberedUnit, $Out>
    implements RememberedUnitCopyWith<$R, RememberedUnit, $Out> {
  _RememberedUnitCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RememberedUnit> $mapper =
      RememberedUnitMapper.ensureInitialized();
  @override
  $R call({String? mfpFoodId, String? mfpUnit, double? grams}) => $apply(
    FieldCopyWithData({
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (mfpUnit != null) #mfpUnit: mfpUnit,
      if (grams != null) #grams: grams,
    }),
  );
  @override
  RememberedUnit $make(CopyWithData data) => RememberedUnit(
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    mfpUnit: data.get(#mfpUnit, or: $value.mfpUnit),
    grams: data.get(#grams, or: $value.grams),
  );

  @override
  RememberedUnitCopyWith<$R2, RememberedUnit, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RememberedUnitCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

