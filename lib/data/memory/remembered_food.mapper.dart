// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'remembered_food.dart';

class RememberedFoodMapper extends ClassMapperBase<RememberedFood> {
  RememberedFoodMapper._();

  static RememberedFoodMapper? _instance;
  static RememberedFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RememberedFoodMapper._());
      MatchedFoodMapper.ensureInitialized();
      OwnCopyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RememberedFood';

  static String _$mfpFoodId(RememberedFood v) => v.mfpFoodId;
  static const Field<RememberedFood, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$mfpDescription(RememberedFood v) => v.mfpDescription;
  static const Field<RememberedFood, String> _f$mfpDescription = Field(
    'mfpDescription',
    _$mfpDescription,
    key: r'mfp_description',
  );
  static String _$ekkloFoodId(RememberedFood v) => v.ekkloFoodId;
  static const Field<RememberedFood, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'ekklo_food_id',
  );
  static String _$ekkloFoodName(RememberedFood v) => v.ekkloFoodName;
  static const Field<RememberedFood, String> _f$ekkloFoodName = Field(
    'ekkloFoodName',
    _$ekkloFoodName,
    key: r'ekklo_food_name',
  );

  @override
  final MappableFields<RememberedFood> fields = const {
    #mfpFoodId: _f$mfpFoodId,
    #mfpDescription: _f$mfpDescription,
    #ekkloFoodId: _f$ekkloFoodId,
    #ekkloFoodName: _f$ekkloFoodName,
  };
  @override
  final bool ignoreNull = true;

  static RememberedFood _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'RememberedFood',
      'kind',
      '${data.value['kind']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RememberedFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RememberedFood>(map);
  }

  static RememberedFood fromJson(String json) {
    return ensureInitialized().decodeJson<RememberedFood>(json);
  }
}

mixin RememberedFoodMappable {
  String toJson();
  Map<String, dynamic> toMap();
  RememberedFoodCopyWith<RememberedFood, RememberedFood, RememberedFood>
  get copyWith;
}

abstract class RememberedFoodCopyWith<$R, $In extends RememberedFood, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? mfpFoodId,
    String? mfpDescription,
    String? ekkloFoodId,
    String? ekkloFoodName,
  });
  RememberedFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class MatchedFoodMapper extends SubClassMapperBase<MatchedFood> {
  MatchedFoodMapper._();

  static MatchedFoodMapper? _instance;
  static MatchedFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchedFoodMapper._());
      RememberedFoodMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MatchedFood';

  static String _$mfpFoodId(MatchedFood v) => v.mfpFoodId;
  static const Field<MatchedFood, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$mfpDescription(MatchedFood v) => v.mfpDescription;
  static const Field<MatchedFood, String> _f$mfpDescription = Field(
    'mfpDescription',
    _$mfpDescription,
    key: r'mfp_description',
  );
  static String _$ekkloFoodId(MatchedFood v) => v.ekkloFoodId;
  static const Field<MatchedFood, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'ekklo_food_id',
  );
  static String _$ekkloFoodName(MatchedFood v) => v.ekkloFoodName;
  static const Field<MatchedFood, String> _f$ekkloFoodName = Field(
    'ekkloFoodName',
    _$ekkloFoodName,
    key: r'ekklo_food_name',
  );

  @override
  final MappableFields<MatchedFood> fields = const {
    #mfpFoodId: _f$mfpFoodId,
    #mfpDescription: _f$mfpDescription,
    #ekkloFoodId: _f$ekkloFoodId,
    #ekkloFoodName: _f$ekkloFoodName,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'ekklo';
  @override
  late final ClassMapperBase superMapper =
      RememberedFoodMapper.ensureInitialized();

  static MatchedFood _instantiate(DecodingData data) {
    return MatchedFood(
      mfpFoodId: data.dec(_f$mfpFoodId),
      mfpDescription: data.dec(_f$mfpDescription),
      ekkloFoodId: data.dec(_f$ekkloFoodId),
      ekkloFoodName: data.dec(_f$ekkloFoodName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchedFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchedFood>(map);
  }

  static MatchedFood fromJson(String json) {
    return ensureInitialized().decodeJson<MatchedFood>(json);
  }
}

mixin MatchedFoodMappable {
  String toJson() {
    return MatchedFoodMapper.ensureInitialized().encodeJson<MatchedFood>(
      this as MatchedFood,
    );
  }

  Map<String, dynamic> toMap() {
    return MatchedFoodMapper.ensureInitialized().encodeMap<MatchedFood>(
      this as MatchedFood,
    );
  }

  MatchedFoodCopyWith<MatchedFood, MatchedFood, MatchedFood> get copyWith =>
      _MatchedFoodCopyWithImpl<MatchedFood, MatchedFood>(
        this as MatchedFood,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MatchedFoodMapper.ensureInitialized().stringifyValue(
      this as MatchedFood,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchedFoodMapper.ensureInitialized().equalsValue(
      this as MatchedFood,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchedFoodMapper.ensureInitialized().hashValue(this as MatchedFood);
  }
}

extension MatchedFoodValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchedFood, $Out> {
  MatchedFoodCopyWith<$R, MatchedFood, $Out> get $asMatchedFood =>
      $base.as((v, t, t2) => _MatchedFoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchedFoodCopyWith<$R, $In extends MatchedFood, $Out>
    implements RememberedFoodCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? mfpFoodId,
    String? mfpDescription,
    String? ekkloFoodId,
    String? ekkloFoodName,
  });
  MatchedFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MatchedFoodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchedFood, $Out>
    implements MatchedFoodCopyWith<$R, MatchedFood, $Out> {
  _MatchedFoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchedFood> $mapper =
      MatchedFoodMapper.ensureInitialized();
  @override
  $R call({
    String? mfpFoodId,
    String? mfpDescription,
    String? ekkloFoodId,
    String? ekkloFoodName,
  }) => $apply(
    FieldCopyWithData({
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (mfpDescription != null) #mfpDescription: mfpDescription,
      if (ekkloFoodId != null) #ekkloFoodId: ekkloFoodId,
      if (ekkloFoodName != null) #ekkloFoodName: ekkloFoodName,
    }),
  );
  @override
  MatchedFood $make(CopyWithData data) => MatchedFood(
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    mfpDescription: data.get(#mfpDescription, or: $value.mfpDescription),
    ekkloFoodId: data.get(#ekkloFoodId, or: $value.ekkloFoodId),
    ekkloFoodName: data.get(#ekkloFoodName, or: $value.ekkloFoodName),
  );

  @override
  MatchedFoodCopyWith<$R2, MatchedFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchedFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OwnCopyMapper extends SubClassMapperBase<OwnCopy> {
  OwnCopyMapper._();

  static OwnCopyMapper? _instance;
  static OwnCopyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OwnCopyMapper._());
      RememberedFoodMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'OwnCopy';

  static String _$mfpFoodId(OwnCopy v) => v.mfpFoodId;
  static const Field<OwnCopy, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$mfpDescription(OwnCopy v) => v.mfpDescription;
  static const Field<OwnCopy, String> _f$mfpDescription = Field(
    'mfpDescription',
    _$mfpDescription,
    key: r'mfp_description',
  );
  static String _$ekkloFoodId(OwnCopy v) => v.ekkloFoodId;
  static const Field<OwnCopy, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'ekklo_food_id',
  );
  static String _$ekkloFoodName(OwnCopy v) => v.ekkloFoodName;
  static const Field<OwnCopy, String> _f$ekkloFoodName = Field(
    'ekkloFoodName',
    _$ekkloFoodName,
    key: r'ekklo_food_name',
  );
  static String _$mfpUnit(OwnCopy v) => v.mfpUnit;
  static const Field<OwnCopy, String> _f$mfpUnit = Field(
    'mfpUnit',
    _$mfpUnit,
    key: r'mfp_unit',
  );
  static String? _$mfpFoodVersion(OwnCopy v) => v.mfpFoodVersion;
  static const Field<OwnCopy, String> _f$mfpFoodVersion = Field(
    'mfpFoodVersion',
    _$mfpFoodVersion,
    key: r'mfp_food_version',
    opt: true,
  );

  @override
  final MappableFields<OwnCopy> fields = const {
    #mfpFoodId: _f$mfpFoodId,
    #mfpDescription: _f$mfpDescription,
    #ekkloFoodId: _f$ekkloFoodId,
    #ekkloFoodName: _f$ekkloFoodName,
    #mfpUnit: _f$mfpUnit,
    #mfpFoodVersion: _f$mfpFoodVersion,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'own_copy';
  @override
  late final ClassMapperBase superMapper =
      RememberedFoodMapper.ensureInitialized();

  static OwnCopy _instantiate(DecodingData data) {
    return OwnCopy(
      mfpFoodId: data.dec(_f$mfpFoodId),
      mfpDescription: data.dec(_f$mfpDescription),
      ekkloFoodId: data.dec(_f$ekkloFoodId),
      ekkloFoodName: data.dec(_f$ekkloFoodName),
      mfpUnit: data.dec(_f$mfpUnit),
      mfpFoodVersion: data.dec(_f$mfpFoodVersion),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OwnCopy fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OwnCopy>(map);
  }

  static OwnCopy fromJson(String json) {
    return ensureInitialized().decodeJson<OwnCopy>(json);
  }
}

mixin OwnCopyMappable {
  String toJson() {
    return OwnCopyMapper.ensureInitialized().encodeJson<OwnCopy>(
      this as OwnCopy,
    );
  }

  Map<String, dynamic> toMap() {
    return OwnCopyMapper.ensureInitialized().encodeMap<OwnCopy>(
      this as OwnCopy,
    );
  }

  OwnCopyCopyWith<OwnCopy, OwnCopy, OwnCopy> get copyWith =>
      _OwnCopyCopyWithImpl<OwnCopy, OwnCopy>(
        this as OwnCopy,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return OwnCopyMapper.ensureInitialized().stringifyValue(this as OwnCopy);
  }

  @override
  bool operator ==(Object other) {
    return OwnCopyMapper.ensureInitialized().equalsValue(
      this as OwnCopy,
      other,
    );
  }

  @override
  int get hashCode {
    return OwnCopyMapper.ensureInitialized().hashValue(this as OwnCopy);
  }
}

extension OwnCopyValueCopy<$R, $Out> on ObjectCopyWith<$R, OwnCopy, $Out> {
  OwnCopyCopyWith<$R, OwnCopy, $Out> get $asOwnCopy =>
      $base.as((v, t, t2) => _OwnCopyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OwnCopyCopyWith<$R, $In extends OwnCopy, $Out>
    implements RememberedFoodCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? mfpFoodId,
    String? mfpDescription,
    String? ekkloFoodId,
    String? ekkloFoodName,
    String? mfpUnit,
    String? mfpFoodVersion,
  });
  OwnCopyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OwnCopyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OwnCopy, $Out>
    implements OwnCopyCopyWith<$R, OwnCopy, $Out> {
  _OwnCopyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OwnCopy> $mapper =
      OwnCopyMapper.ensureInitialized();
  @override
  $R call({
    String? mfpFoodId,
    String? mfpDescription,
    String? ekkloFoodId,
    String? ekkloFoodName,
    String? mfpUnit,
    Object? mfpFoodVersion = $none,
  }) => $apply(
    FieldCopyWithData({
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (mfpDescription != null) #mfpDescription: mfpDescription,
      if (ekkloFoodId != null) #ekkloFoodId: ekkloFoodId,
      if (ekkloFoodName != null) #ekkloFoodName: ekkloFoodName,
      if (mfpUnit != null) #mfpUnit: mfpUnit,
      if (mfpFoodVersion != $none) #mfpFoodVersion: mfpFoodVersion,
    }),
  );
  @override
  OwnCopy $make(CopyWithData data) => OwnCopy(
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    mfpDescription: data.get(#mfpDescription, or: $value.mfpDescription),
    ekkloFoodId: data.get(#ekkloFoodId, or: $value.ekkloFoodId),
    ekkloFoodName: data.get(#ekkloFoodName, or: $value.ekkloFoodName),
    mfpUnit: data.get(#mfpUnit, or: $value.mfpUnit),
    mfpFoodVersion: data.get(#mfpFoodVersion, or: $value.mfpFoodVersion),
  );

  @override
  OwnCopyCopyWith<$R2, OwnCopy, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _OwnCopyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

