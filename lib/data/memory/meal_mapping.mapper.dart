// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'meal_mapping.dart';

class MealMappingMapper extends ClassMapperBase<MealMapping> {
  MealMappingMapper._();

  static MealMappingMapper? _instance;
  static MealMappingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealMappingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MealMapping';

  static String _$mfpMealName(MealMapping v) => v.mfpMealName;
  static const Field<MealMapping, String> _f$mfpMealName = Field(
    'mfpMealName',
    _$mfpMealName,
    key: r'mfp_meal_name',
  );
  static String _$ekkloMealName(MealMapping v) => v.ekkloMealName;
  static const Field<MealMapping, String> _f$ekkloMealName = Field(
    'ekkloMealName',
    _$ekkloMealName,
    key: r'ekklo_meal_name',
  );

  @override
  final MappableFields<MealMapping> fields = const {
    #mfpMealName: _f$mfpMealName,
    #ekkloMealName: _f$ekkloMealName,
  };
  @override
  final bool ignoreNull = true;

  static MealMapping _instantiate(DecodingData data) {
    return MealMapping(
      mfpMealName: data.dec(_f$mfpMealName),
      ekkloMealName: data.dec(_f$ekkloMealName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MealMapping fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MealMapping>(map);
  }

  static MealMapping fromJson(String json) {
    return ensureInitialized().decodeJson<MealMapping>(json);
  }
}

mixin MealMappingMappable {
  String toJson() {
    return MealMappingMapper.ensureInitialized().encodeJson<MealMapping>(
      this as MealMapping,
    );
  }

  Map<String, dynamic> toMap() {
    return MealMappingMapper.ensureInitialized().encodeMap<MealMapping>(
      this as MealMapping,
    );
  }

  MealMappingCopyWith<MealMapping, MealMapping, MealMapping> get copyWith =>
      _MealMappingCopyWithImpl<MealMapping, MealMapping>(
        this as MealMapping,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MealMappingMapper.ensureInitialized().stringifyValue(
      this as MealMapping,
    );
  }

  @override
  bool operator ==(Object other) {
    return MealMappingMapper.ensureInitialized().equalsValue(
      this as MealMapping,
      other,
    );
  }

  @override
  int get hashCode {
    return MealMappingMapper.ensureInitialized().hashValue(this as MealMapping);
  }
}

extension MealMappingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MealMapping, $Out> {
  MealMappingCopyWith<$R, MealMapping, $Out> get $asMealMapping =>
      $base.as((v, t, t2) => _MealMappingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MealMappingCopyWith<$R, $In extends MealMapping, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? mfpMealName, String? ekkloMealName});
  MealMappingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MealMappingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MealMapping, $Out>
    implements MealMappingCopyWith<$R, MealMapping, $Out> {
  _MealMappingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MealMapping> $mapper =
      MealMappingMapper.ensureInitialized();
  @override
  $R call({String? mfpMealName, String? ekkloMealName}) => $apply(
    FieldCopyWithData({
      if (mfpMealName != null) #mfpMealName: mfpMealName,
      if (ekkloMealName != null) #ekkloMealName: ekkloMealName,
    }),
  );
  @override
  MealMapping $make(CopyWithData data) => MealMapping(
    mfpMealName: data.get(#mfpMealName, or: $value.mfpMealName),
    ekkloMealName: data.get(#ekkloMealName, or: $value.ekkloMealName),
  );

  @override
  MealMappingCopyWith<$R2, MealMapping, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MealMappingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

