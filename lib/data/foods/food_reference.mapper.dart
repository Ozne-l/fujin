// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food_reference.dart';

class FoodReferenceMapper extends ClassMapperBase<FoodReference> {
  FoodReferenceMapper._();

  static FoodReferenceMapper? _instance;
  static FoodReferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodReferenceMapper._());
      MfpReferenceMapper.ensureInitialized();
      EkkloReferenceMapper.ensureInitialized();
      OwnCopyReferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FoodReference';

  static String _$id(FoodReference v) => v.id;
  static const Field<FoodReference, String> _f$id = Field('id', _$id);
  static String _$foodId(FoodReference v) => v.foodId;
  static const Field<FoodReference, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static String _$externalId(FoodReference v) => v.externalId;
  static const Field<FoodReference, String> _f$externalId = Field(
    'externalId',
    _$externalId,
    key: r'external_id',
  );
  static DateTime _$updatedAt(FoodReference v) => v.updatedAt;
  static const Field<FoodReference, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(FoodReference v) => v.deletedAt;
  static const Field<FoodReference, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<FoodReference> fields = const {
    #id: _f$id,
    #foodId: _f$foodId,
    #externalId: _f$externalId,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static FoodReference _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'FoodReference',
      'kind',
      '${data.value['kind']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FoodReference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FoodReference>(map);
  }

  static FoodReference fromJson(String json) {
    return ensureInitialized().decodeJson<FoodReference>(json);
  }
}

mixin FoodReferenceMappable {
  String toJson();
  Map<String, dynamic> toMap();
  FoodReferenceCopyWith<FoodReference, FoodReference, FoodReference>
  get copyWith;
}

abstract class FoodReferenceCopyWith<$R, $In extends FoodReference, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  FoodReferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MfpReferenceMapper extends SubClassMapperBase<MfpReference> {
  MfpReferenceMapper._();

  static MfpReferenceMapper? _instance;
  static MfpReferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpReferenceMapper._());
      FoodReferenceMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MfpReference';

  static String _$id(MfpReference v) => v.id;
  static const Field<MfpReference, String> _f$id = Field('id', _$id);
  static String _$foodId(MfpReference v) => v.foodId;
  static const Field<MfpReference, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static String _$externalId(MfpReference v) => v.externalId;
  static const Field<MfpReference, String> _f$externalId = Field(
    'externalId',
    _$externalId,
    key: r'external_id',
  );
  static DateTime _$updatedAt(MfpReference v) => v.updatedAt;
  static const Field<MfpReference, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String? _$version(MfpReference v) => v.version;
  static const Field<MfpReference, String> _f$version = Field(
    'version',
    _$version,
    opt: true,
  );
  static DateTime? _$deletedAt(MfpReference v) => v.deletedAt;
  static const Field<MfpReference, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<MfpReference> fields = const {
    #id: _f$id,
    #foodId: _f$foodId,
    #externalId: _f$externalId,
    #updatedAt: _f$updatedAt,
    #version: _f$version,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'mfp';
  @override
  late final ClassMapperBase superMapper =
      FoodReferenceMapper.ensureInitialized();

  static MfpReference _instantiate(DecodingData data) {
    return MfpReference(
      id: data.dec(_f$id),
      foodId: data.dec(_f$foodId),
      externalId: data.dec(_f$externalId),
      updatedAt: data.dec(_f$updatedAt),
      version: data.dec(_f$version),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpReference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpReference>(map);
  }

  static MfpReference fromJson(String json) {
    return ensureInitialized().decodeJson<MfpReference>(json);
  }
}

mixin MfpReferenceMappable {
  String toJson() {
    return MfpReferenceMapper.ensureInitialized().encodeJson<MfpReference>(
      this as MfpReference,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpReferenceMapper.ensureInitialized().encodeMap<MfpReference>(
      this as MfpReference,
    );
  }

  MfpReferenceCopyWith<MfpReference, MfpReference, MfpReference> get copyWith =>
      _MfpReferenceCopyWithImpl<MfpReference, MfpReference>(
        this as MfpReference,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpReferenceMapper.ensureInitialized().stringifyValue(
      this as MfpReference,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpReferenceMapper.ensureInitialized().equalsValue(
      this as MfpReference,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpReferenceMapper.ensureInitialized().hashValue(
      this as MfpReference,
    );
  }
}

extension MfpReferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpReference, $Out> {
  MfpReferenceCopyWith<$R, MfpReference, $Out> get $asMfpReference =>
      $base.as((v, t, t2) => _MfpReferenceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpReferenceCopyWith<$R, $In extends MfpReference, $Out>
    implements FoodReferenceCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    String? version,
    DateTime? deletedAt,
  });
  MfpReferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpReferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpReference, $Out>
    implements MfpReferenceCopyWith<$R, MfpReference, $Out> {
  _MfpReferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpReference> $mapper =
      MfpReferenceMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    Object? version = $none,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (foodId != null) #foodId: foodId,
      if (externalId != null) #externalId: externalId,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (version != $none) #version: version,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  MfpReference $make(CopyWithData data) => MfpReference(
    id: data.get(#id, or: $value.id),
    foodId: data.get(#foodId, or: $value.foodId),
    externalId: data.get(#externalId, or: $value.externalId),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    version: data.get(#version, or: $value.version),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  MfpReferenceCopyWith<$R2, MfpReference, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpReferenceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloReferenceMapper extends SubClassMapperBase<EkkloReference> {
  EkkloReferenceMapper._();

  static EkkloReferenceMapper? _instance;
  static EkkloReferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloReferenceMapper._());
      FoodReferenceMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloReference';

  static String _$id(EkkloReference v) => v.id;
  static const Field<EkkloReference, String> _f$id = Field('id', _$id);
  static String _$foodId(EkkloReference v) => v.foodId;
  static const Field<EkkloReference, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static String _$externalId(EkkloReference v) => v.externalId;
  static const Field<EkkloReference, String> _f$externalId = Field(
    'externalId',
    _$externalId,
    key: r'external_id',
  );
  static DateTime _$updatedAt(EkkloReference v) => v.updatedAt;
  static const Field<EkkloReference, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String _$name(EkkloReference v) => v.name;
  static const Field<EkkloReference, String> _f$name = Field('name', _$name);
  static DateTime? _$deletedAt(EkkloReference v) => v.deletedAt;
  static const Field<EkkloReference, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<EkkloReference> fields = const {
    #id: _f$id,
    #foodId: _f$foodId,
    #externalId: _f$externalId,
    #updatedAt: _f$updatedAt,
    #name: _f$name,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'ekklo';
  @override
  late final ClassMapperBase superMapper =
      FoodReferenceMapper.ensureInitialized();

  static EkkloReference _instantiate(DecodingData data) {
    return EkkloReference(
      id: data.dec(_f$id),
      foodId: data.dec(_f$foodId),
      externalId: data.dec(_f$externalId),
      updatedAt: data.dec(_f$updatedAt),
      name: data.dec(_f$name),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloReference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloReference>(map);
  }

  static EkkloReference fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloReference>(json);
  }
}

mixin EkkloReferenceMappable {
  String toJson() {
    return EkkloReferenceMapper.ensureInitialized().encodeJson<EkkloReference>(
      this as EkkloReference,
    );
  }

  Map<String, dynamic> toMap() {
    return EkkloReferenceMapper.ensureInitialized().encodeMap<EkkloReference>(
      this as EkkloReference,
    );
  }

  EkkloReferenceCopyWith<EkkloReference, EkkloReference, EkkloReference>
  get copyWith => _EkkloReferenceCopyWithImpl<EkkloReference, EkkloReference>(
    this as EkkloReference,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return EkkloReferenceMapper.ensureInitialized().stringifyValue(
      this as EkkloReference,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloReferenceMapper.ensureInitialized().equalsValue(
      this as EkkloReference,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloReferenceMapper.ensureInitialized().hashValue(
      this as EkkloReference,
    );
  }
}

extension EkkloReferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloReference, $Out> {
  EkkloReferenceCopyWith<$R, EkkloReference, $Out> get $asEkkloReference =>
      $base.as((v, t, t2) => _EkkloReferenceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloReferenceCopyWith<$R, $In extends EkkloReference, $Out>
    implements FoodReferenceCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    String? name,
    DateTime? deletedAt,
  });
  EkkloReferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloReferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloReference, $Out>
    implements EkkloReferenceCopyWith<$R, EkkloReference, $Out> {
  _EkkloReferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloReference> $mapper =
      EkkloReferenceMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    String? name,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (foodId != null) #foodId: foodId,
      if (externalId != null) #externalId: externalId,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (name != null) #name: name,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  EkkloReference $make(CopyWithData data) => EkkloReference(
    id: data.get(#id, or: $value.id),
    foodId: data.get(#foodId, or: $value.foodId),
    externalId: data.get(#externalId, or: $value.externalId),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    name: data.get(#name, or: $value.name),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  EkkloReferenceCopyWith<$R2, EkkloReference, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloReferenceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OwnCopyReferenceMapper extends SubClassMapperBase<OwnCopyReference> {
  OwnCopyReferenceMapper._();

  static OwnCopyReferenceMapper? _instance;
  static OwnCopyReferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OwnCopyReferenceMapper._());
      FoodReferenceMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'OwnCopyReference';

  static String _$id(OwnCopyReference v) => v.id;
  static const Field<OwnCopyReference, String> _f$id = Field('id', _$id);
  static String _$foodId(OwnCopyReference v) => v.foodId;
  static const Field<OwnCopyReference, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static String _$externalId(OwnCopyReference v) => v.externalId;
  static const Field<OwnCopyReference, String> _f$externalId = Field(
    'externalId',
    _$externalId,
    key: r'external_id',
  );
  static DateTime _$updatedAt(OwnCopyReference v) => v.updatedAt;
  static const Field<OwnCopyReference, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String _$name(OwnCopyReference v) => v.name;
  static const Field<OwnCopyReference, String> _f$name = Field('name', _$name);
  static String _$unit(OwnCopyReference v) => v.unit;
  static const Field<OwnCopyReference, String> _f$unit = Field('unit', _$unit);
  static String? _$version(OwnCopyReference v) => v.version;
  static const Field<OwnCopyReference, String> _f$version = Field(
    'version',
    _$version,
    opt: true,
  );
  static DateTime? _$deletedAt(OwnCopyReference v) => v.deletedAt;
  static const Field<OwnCopyReference, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<OwnCopyReference> fields = const {
    #id: _f$id,
    #foodId: _f$foodId,
    #externalId: _f$externalId,
    #updatedAt: _f$updatedAt,
    #name: _f$name,
    #unit: _f$unit,
    #version: _f$version,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'own_copy';
  @override
  late final ClassMapperBase superMapper =
      FoodReferenceMapper.ensureInitialized();

  static OwnCopyReference _instantiate(DecodingData data) {
    return OwnCopyReference(
      id: data.dec(_f$id),
      foodId: data.dec(_f$foodId),
      externalId: data.dec(_f$externalId),
      updatedAt: data.dec(_f$updatedAt),
      name: data.dec(_f$name),
      unit: data.dec(_f$unit),
      version: data.dec(_f$version),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OwnCopyReference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OwnCopyReference>(map);
  }

  static OwnCopyReference fromJson(String json) {
    return ensureInitialized().decodeJson<OwnCopyReference>(json);
  }
}

mixin OwnCopyReferenceMappable {
  String toJson() {
    return OwnCopyReferenceMapper.ensureInitialized()
        .encodeJson<OwnCopyReference>(this as OwnCopyReference);
  }

  Map<String, dynamic> toMap() {
    return OwnCopyReferenceMapper.ensureInitialized()
        .encodeMap<OwnCopyReference>(this as OwnCopyReference);
  }

  OwnCopyReferenceCopyWith<OwnCopyReference, OwnCopyReference, OwnCopyReference>
  get copyWith =>
      _OwnCopyReferenceCopyWithImpl<OwnCopyReference, OwnCopyReference>(
        this as OwnCopyReference,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return OwnCopyReferenceMapper.ensureInitialized().stringifyValue(
      this as OwnCopyReference,
    );
  }

  @override
  bool operator ==(Object other) {
    return OwnCopyReferenceMapper.ensureInitialized().equalsValue(
      this as OwnCopyReference,
      other,
    );
  }

  @override
  int get hashCode {
    return OwnCopyReferenceMapper.ensureInitialized().hashValue(
      this as OwnCopyReference,
    );
  }
}

extension OwnCopyReferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OwnCopyReference, $Out> {
  OwnCopyReferenceCopyWith<$R, OwnCopyReference, $Out>
  get $asOwnCopyReference =>
      $base.as((v, t, t2) => _OwnCopyReferenceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OwnCopyReferenceCopyWith<$R, $In extends OwnCopyReference, $Out>
    implements FoodReferenceCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    String? name,
    String? unit,
    String? version,
    DateTime? deletedAt,
  });
  OwnCopyReferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _OwnCopyReferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OwnCopyReference, $Out>
    implements OwnCopyReferenceCopyWith<$R, OwnCopyReference, $Out> {
  _OwnCopyReferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OwnCopyReference> $mapper =
      OwnCopyReferenceMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? foodId,
    String? externalId,
    DateTime? updatedAt,
    String? name,
    String? unit,
    Object? version = $none,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (foodId != null) #foodId: foodId,
      if (externalId != null) #externalId: externalId,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (name != null) #name: name,
      if (unit != null) #unit: unit,
      if (version != $none) #version: version,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  OwnCopyReference $make(CopyWithData data) => OwnCopyReference(
    id: data.get(#id, or: $value.id),
    foodId: data.get(#foodId, or: $value.foodId),
    externalId: data.get(#externalId, or: $value.externalId),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    name: data.get(#name, or: $value.name),
    unit: data.get(#unit, or: $value.unit),
    version: data.get(#version, or: $value.version),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  OwnCopyReferenceCopyWith<$R2, OwnCopyReference, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _OwnCopyReferenceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

