// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'cached_owner.dart';

class CachedOwnerMapper extends ClassMapperBase<CachedOwner> {
  CachedOwnerMapper._();

  static CachedOwnerMapper? _instance;
  static CachedOwnerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CachedOwnerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CachedOwner';

  static Map<String, Object?> _$json(CachedOwner v) => v.json;
  static const Field<CachedOwner, Map<String, Object?>> _f$json = Field(
    'json',
    _$json,
    hook: JsonTextHook(),
  );
  static int _$id(CachedOwner v) => v.id;
  static const Field<CachedOwner, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: CachedOwner.onlyRow,
  );

  @override
  final MappableFields<CachedOwner> fields = const {#json: _f$json, #id: _f$id};
  @override
  final bool ignoreNull = true;

  static CachedOwner _instantiate(DecodingData data) {
    return CachedOwner(json: data.dec(_f$json), id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static CachedOwner fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CachedOwner>(map);
  }

  static CachedOwner fromJson(String json) {
    return ensureInitialized().decodeJson<CachedOwner>(json);
  }
}

mixin CachedOwnerMappable {
  String toJson() {
    return CachedOwnerMapper.ensureInitialized().encodeJson<CachedOwner>(
      this as CachedOwner,
    );
  }

  Map<String, dynamic> toMap() {
    return CachedOwnerMapper.ensureInitialized().encodeMap<CachedOwner>(
      this as CachedOwner,
    );
  }

  CachedOwnerCopyWith<CachedOwner, CachedOwner, CachedOwner> get copyWith =>
      _CachedOwnerCopyWithImpl<CachedOwner, CachedOwner>(
        this as CachedOwner,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CachedOwnerMapper.ensureInitialized().stringifyValue(
      this as CachedOwner,
    );
  }

  @override
  bool operator ==(Object other) {
    return CachedOwnerMapper.ensureInitialized().equalsValue(
      this as CachedOwner,
      other,
    );
  }

  @override
  int get hashCode {
    return CachedOwnerMapper.ensureInitialized().hashValue(this as CachedOwner);
  }
}

extension CachedOwnerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CachedOwner, $Out> {
  CachedOwnerCopyWith<$R, CachedOwner, $Out> get $asCachedOwner =>
      $base.as((v, t, t2) => _CachedOwnerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CachedOwnerCopyWith<$R, $In extends CachedOwner, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>
  get json;
  $R call({Map<String, Object?>? json, int? id});
  CachedOwnerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CachedOwnerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CachedOwner, $Out>
    implements CachedOwnerCopyWith<$R, CachedOwner, $Out> {
  _CachedOwnerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CachedOwner> $mapper =
      CachedOwnerMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>
  get json => MapCopyWith(
    $value.json,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(json: v),
  );
  @override
  $R call({Map<String, Object?>? json, int? id}) => $apply(
    FieldCopyWithData({if (json != null) #json: json, if (id != null) #id: id}),
  );
  @override
  CachedOwner $make(CopyWithData data) => CachedOwner(
    json: data.get(#json, or: $value.json),
    id: data.get(#id, or: $value.id),
  );

  @override
  CachedOwnerCopyWith<$R2, CachedOwner, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CachedOwnerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

