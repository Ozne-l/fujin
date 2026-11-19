// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'cached_conversation.dart';

class CachedConversationMapper extends ClassMapperBase<CachedConversation> {
  CachedConversationMapper._();

  static CachedConversationMapper? _instance;
  static CachedConversationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CachedConversationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CachedConversation';

  static String _$id(CachedConversation v) => v.id;
  static const Field<CachedConversation, String> _f$id = Field('id', _$id);
  static Map<String, Object?> _$json(CachedConversation v) => v.json;
  static const Field<CachedConversation, Map<String, Object?>> _f$json = Field(
    'json',
    _$json,
    hook: JsonTextHook(),
  );

  @override
  final MappableFields<CachedConversation> fields = const {
    #id: _f$id,
    #json: _f$json,
  };
  @override
  final bool ignoreNull = true;

  static CachedConversation _instantiate(DecodingData data) {
    return CachedConversation(id: data.dec(_f$id), json: data.dec(_f$json));
  }

  @override
  final Function instantiate = _instantiate;

  static CachedConversation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CachedConversation>(map);
  }

  static CachedConversation fromJson(String json) {
    return ensureInitialized().decodeJson<CachedConversation>(json);
  }
}

mixin CachedConversationMappable {
  String toJson() {
    return CachedConversationMapper.ensureInitialized()
        .encodeJson<CachedConversation>(this as CachedConversation);
  }

  Map<String, dynamic> toMap() {
    return CachedConversationMapper.ensureInitialized()
        .encodeMap<CachedConversation>(this as CachedConversation);
  }

  CachedConversationCopyWith<
    CachedConversation,
    CachedConversation,
    CachedConversation
  >
  get copyWith =>
      _CachedConversationCopyWithImpl<CachedConversation, CachedConversation>(
        this as CachedConversation,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CachedConversationMapper.ensureInitialized().stringifyValue(
      this as CachedConversation,
    );
  }

  @override
  bool operator ==(Object other) {
    return CachedConversationMapper.ensureInitialized().equalsValue(
      this as CachedConversation,
      other,
    );
  }

  @override
  int get hashCode {
    return CachedConversationMapper.ensureInitialized().hashValue(
      this as CachedConversation,
    );
  }
}

extension CachedConversationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CachedConversation, $Out> {
  CachedConversationCopyWith<$R, CachedConversation, $Out>
  get $asCachedConversation => $base.as(
    (v, t, t2) => _CachedConversationCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CachedConversationCopyWith<
  $R,
  $In extends CachedConversation,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>
  get json;
  $R call({String? id, Map<String, Object?>? json});
  CachedConversationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CachedConversationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CachedConversation, $Out>
    implements CachedConversationCopyWith<$R, CachedConversation, $Out> {
  _CachedConversationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CachedConversation> $mapper =
      CachedConversationMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>
  get json => MapCopyWith(
    $value.json,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(json: v),
  );
  @override
  $R call({String? id, Map<String, Object?>? json}) => $apply(
    FieldCopyWithData({if (id != null) #id: id, if (json != null) #json: json}),
  );
  @override
  CachedConversation $make(CopyWithData data) => CachedConversation(
    id: data.get(#id, or: $value.id),
    json: data.get(#json, or: $value.json),
  );

  @override
  CachedConversationCopyWith<$R2, CachedConversation, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CachedConversationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

