// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'copied_meal.dart';

class CopiedMealMapper extends ClassMapperBase<CopiedMeal> {
  CopiedMealMapper._();

  static CopiedMealMapper? _instance;
  static CopiedMealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CopiedMealMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CopiedMeal';

  static String _$id(CopiedMeal v) => v.id;
  static const Field<CopiedMeal, String> _f$id = Field('id', _$id);
  static String _$mfpMealName(CopiedMeal v) => v.mfpMealName;
  static const Field<CopiedMeal, String> _f$mfpMealName = Field(
    'mfpMealName',
    _$mfpMealName,
    key: r'mfp_meal_name',
  );

  @override
  final MappableFields<CopiedMeal> fields = const {
    #id: _f$id,
    #mfpMealName: _f$mfpMealName,
  };
  @override
  final bool ignoreNull = true;

  static CopiedMeal _instantiate(DecodingData data) {
    return CopiedMeal(
      id: data.dec(_f$id),
      mfpMealName: data.dec(_f$mfpMealName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CopiedMeal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CopiedMeal>(map);
  }

  static CopiedMeal fromJson(String json) {
    return ensureInitialized().decodeJson<CopiedMeal>(json);
  }
}

mixin CopiedMealMappable {
  String toJson() {
    return CopiedMealMapper.ensureInitialized().encodeJson<CopiedMeal>(
      this as CopiedMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return CopiedMealMapper.ensureInitialized().encodeMap<CopiedMeal>(
      this as CopiedMeal,
    );
  }

  CopiedMealCopyWith<CopiedMeal, CopiedMeal, CopiedMeal> get copyWith =>
      _CopiedMealCopyWithImpl<CopiedMeal, CopiedMeal>(
        this as CopiedMeal,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CopiedMealMapper.ensureInitialized().stringifyValue(
      this as CopiedMeal,
    );
  }

  @override
  bool operator ==(Object other) {
    return CopiedMealMapper.ensureInitialized().equalsValue(
      this as CopiedMeal,
      other,
    );
  }

  @override
  int get hashCode {
    return CopiedMealMapper.ensureInitialized().hashValue(this as CopiedMeal);
  }
}

extension CopiedMealValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CopiedMeal, $Out> {
  CopiedMealCopyWith<$R, CopiedMeal, $Out> get $asCopiedMeal =>
      $base.as((v, t, t2) => _CopiedMealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CopiedMealCopyWith<$R, $In extends CopiedMeal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? mfpMealName});
  CopiedMealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CopiedMealCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CopiedMeal, $Out>
    implements CopiedMealCopyWith<$R, CopiedMeal, $Out> {
  _CopiedMealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CopiedMeal> $mapper =
      CopiedMealMapper.ensureInitialized();
  @override
  $R call({String? id, String? mfpMealName}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (mfpMealName != null) #mfpMealName: mfpMealName,
    }),
  );
  @override
  CopiedMeal $make(CopyWithData data) => CopiedMeal(
    id: data.get(#id, or: $value.id),
    mfpMealName: data.get(#mfpMealName, or: $value.mfpMealName),
  );

  @override
  CopiedMealCopyWith<$R2, CopiedMeal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CopiedMealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

