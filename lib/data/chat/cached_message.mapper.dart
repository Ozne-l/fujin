// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'cached_message.dart';

class CachedMessageMapper extends ClassMapperBase<CachedMessage> {
  CachedMessageMapper._();

  static CachedMessageMapper? _instance;
  static CachedMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CachedMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CachedMessage';

  static String _$id(CachedMessage v) => v.id;
  static const Field<CachedMessage, String> _f$id = Field('id', _$id);
  static String _$conversationId(CachedMessage v) => v.conversationId;
  static const Field<CachedMessage, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static DateTime _$createdAt(CachedMessage v) => v.createdAt;
  static const Field<CachedMessage, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
    hook: EpochMicrosecondsHook(),
  );
  static Map<String, Object?> _$json(CachedMessage v) => v.json;
  static const Field<CachedMessage, Map<String, Object?>> _f$json = Field(
    'json',
    _$json,
    hook: JsonTextHook(),
  );

  @override
  final MappableFields<CachedMessage> fields = const {
    #id: _f$id,
    #conversationId: _f$conversationId,
    #createdAt: _f$createdAt,
    #json: _f$json,
  };
  @override
  final bool ignoreNull = true;

  static CachedMessage _instantiate(DecodingData data) {
    return CachedMessage(
      id: data.dec(_f$id),
      conversationId: data.dec(_f$conversationId),
      createdAt: data.dec(_f$createdAt),
      json: data.dec(_f$json),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CachedMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CachedMessage>(map);
  }

  static CachedMessage fromJson(String json) {
    return ensureInitialized().decodeJson<CachedMessage>(json);
  }
}

mixin CachedMessageMappable {
  String toJson() {
    return CachedMessageMapper.ensureInitialized().encodeJson<CachedMessage>(
      this as CachedMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return CachedMessageMapper.ensureInitialized().encodeMap<CachedMessage>(
      this as CachedMessage,
    );
  }

  CachedMessageCopyWith<CachedMessage, CachedMessage, CachedMessage>
  get copyWith => _CachedMessageCopyWithImpl<CachedMessage, CachedMessage>(
    this as CachedMessage,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return CachedMessageMapper.ensureInitialized().stringifyValue(
      this as CachedMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return CachedMessageMapper.ensureInitialized().equalsValue(
      this as CachedMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return CachedMessageMapper.ensureInitialized().hashValue(
      this as CachedMessage,
    );
  }
}

extension CachedMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CachedMessage, $Out> {
  CachedMessageCopyWith<$R, CachedMessage, $Out> get $asCachedMessage =>
      $base.as((v, t, t2) => _CachedMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CachedMessageCopyWith<$R, $In extends CachedMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>
  get json;
  $R call({
    String? id,
    String? conversationId,
    DateTime? createdAt,
    Map<String, Object?>? json,
  });
  CachedMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CachedMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CachedMessage, $Out>
    implements CachedMessageCopyWith<$R, CachedMessage, $Out> {
  _CachedMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CachedMessage> $mapper =
      CachedMessageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>
  get json => MapCopyWith(
    $value.json,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(json: v),
  );
  @override
  $R call({
    String? id,
    String? conversationId,
    DateTime? createdAt,
    Map<String, Object?>? json,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (conversationId != null) #conversationId: conversationId,
      if (createdAt != null) #createdAt: createdAt,
      if (json != null) #json: json,
    }),
  );
  @override
  CachedMessage $make(CopyWithData data) => CachedMessage(
    id: data.get(#id, or: $value.id),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    json: data.get(#json, or: $value.json),
  );

  @override
  CachedMessageCopyWith<$R2, CachedMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CachedMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

