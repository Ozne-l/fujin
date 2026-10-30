// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'copied_food.dart';

class CopiedFoodMapper extends ClassMapperBase<CopiedFood> {
  CopiedFoodMapper._();

  static CopiedFoodMapper? _instance;
  static CopiedFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CopiedFoodMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CopiedFood';

  static String _$id(CopiedFood v) => v.id;
  static const Field<CopiedFood, String> _f$id = Field('id', _$id);
  static String _$mfpFoodId(CopiedFood v) => v.mfpFoodId;
  static const Field<CopiedFood, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String? _$name(CopiedFood v) => v.name;
  static const Field<CopiedFood, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$brand(CopiedFood v) => v.brand;
  static const Field<CopiedFood, String> _f$brand = Field(
    'brand',
    _$brand,
    opt: true,
  );

  @override
  final MappableFields<CopiedFood> fields = const {
    #id: _f$id,
    #mfpFoodId: _f$mfpFoodId,
    #name: _f$name,
    #brand: _f$brand,
  };
  @override
  final bool ignoreNull = true;

  static CopiedFood _instantiate(DecodingData data) {
    return CopiedFood(
      id: data.dec(_f$id),
      mfpFoodId: data.dec(_f$mfpFoodId),
      name: data.dec(_f$name),
      brand: data.dec(_f$brand),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CopiedFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CopiedFood>(map);
  }

  static CopiedFood fromJson(String json) {
    return ensureInitialized().decodeJson<CopiedFood>(json);
  }
}

mixin CopiedFoodMappable {
  String toJson() {
    return CopiedFoodMapper.ensureInitialized().encodeJson<CopiedFood>(
      this as CopiedFood,
    );
  }

  Map<String, dynamic> toMap() {
    return CopiedFoodMapper.ensureInitialized().encodeMap<CopiedFood>(
      this as CopiedFood,
    );
  }

  CopiedFoodCopyWith<CopiedFood, CopiedFood, CopiedFood> get copyWith =>
      _CopiedFoodCopyWithImpl<CopiedFood, CopiedFood>(
        this as CopiedFood,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CopiedFoodMapper.ensureInitialized().stringifyValue(
      this as CopiedFood,
    );
  }

  @override
  bool operator ==(Object other) {
    return CopiedFoodMapper.ensureInitialized().equalsValue(
      this as CopiedFood,
      other,
    );
  }

  @override
  int get hashCode {
    return CopiedFoodMapper.ensureInitialized().hashValue(this as CopiedFood);
  }
}

extension CopiedFoodValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CopiedFood, $Out> {
  CopiedFoodCopyWith<$R, CopiedFood, $Out> get $asCopiedFood =>
      $base.as((v, t, t2) => _CopiedFoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CopiedFoodCopyWith<$R, $In extends CopiedFood, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? mfpFoodId, String? name, String? brand});
  CopiedFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CopiedFoodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CopiedFood, $Out>
    implements CopiedFoodCopyWith<$R, CopiedFood, $Out> {
  _CopiedFoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CopiedFood> $mapper =
      CopiedFoodMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? mfpFoodId,
    Object? name = $none,
    Object? brand = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (name != $none) #name: name,
      if (brand != $none) #brand: brand,
    }),
  );
  @override
  CopiedFood $make(CopyWithData data) => CopiedFood(
    id: data.get(#id, or: $value.id),
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    name: data.get(#name, or: $value.name),
    brand: data.get(#brand, or: $value.brand),
  );

  @override
  CopiedFoodCopyWith<$R2, CopiedFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CopiedFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

