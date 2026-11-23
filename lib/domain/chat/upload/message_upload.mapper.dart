// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message_upload.dart';

class MessageUploadMapper extends ClassMapperBase<MessageUpload> {
  MessageUploadMapper._();

  static MessageUploadMapper? _instance;
  static MessageUploadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageUploadMapper._());
      UploadPhaseMapper.ensureInitialized();
      UploadingMediaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageUpload';

  static String _$id(MessageUpload v) => v.id;
  static const Field<MessageUpload, String> _f$id = Field('id', _$id);
  static String _$conversationId(MessageUpload v) => v.conversationId;
  static const Field<MessageUpload, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static DateTime _$startedAt(MessageUpload v) => v.startedAt;
  static const Field<MessageUpload, DateTime> _f$startedAt = Field(
    'startedAt',
    _$startedAt,
    key: r'started_at',
  );
  static UploadPhase _$phase(MessageUpload v) => v.phase;
  static const Field<MessageUpload, UploadPhase> _f$phase = Field(
    'phase',
    _$phase,
  );
  static List<UploadingMedia> _$media(MessageUpload v) => v.media;
  static const Field<MessageUpload, List<UploadingMedia>> _f$media = Field(
    'media',
    _$media,
  );
  static String _$caption(MessageUpload v) => v.caption;
  static const Field<MessageUpload, String> _f$caption = Field(
    'caption',
    _$caption,
    opt: true,
    def: '',
  );
  static String? _$replyToId(MessageUpload v) => v.replyToId;
  static const Field<MessageUpload, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    key: r'reply_to_id',
    opt: true,
  );
  static int? _$durationSeconds(MessageUpload v) => v.durationSeconds;
  static const Field<MessageUpload, int> _f$durationSeconds = Field(
    'durationSeconds',
    _$durationSeconds,
    key: r'duration_seconds',
    opt: true,
  );
  static List<String> _$publicUrls(MessageUpload v) => v.publicUrls;
  static const Field<MessageUpload, List<String>> _f$publicUrls = Field(
    'publicUrls',
    _$publicUrls,
    key: r'public_urls',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<MessageUpload> fields = const {
    #id: _f$id,
    #conversationId: _f$conversationId,
    #startedAt: _f$startedAt,
    #phase: _f$phase,
    #media: _f$media,
    #caption: _f$caption,
    #replyToId: _f$replyToId,
    #durationSeconds: _f$durationSeconds,
    #publicUrls: _f$publicUrls,
  };
  @override
  final bool ignoreNull = true;

  static MessageUpload _instantiate(DecodingData data) {
    return MessageUpload(
      id: data.dec(_f$id),
      conversationId: data.dec(_f$conversationId),
      startedAt: data.dec(_f$startedAt),
      phase: data.dec(_f$phase),
      media: data.dec(_f$media),
      caption: data.dec(_f$caption),
      replyToId: data.dec(_f$replyToId),
      durationSeconds: data.dec(_f$durationSeconds),
      publicUrls: data.dec(_f$publicUrls),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageUpload fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageUpload>(map);
  }

  static MessageUpload fromJson(String json) {
    return ensureInitialized().decodeJson<MessageUpload>(json);
  }
}

mixin MessageUploadMappable {
  String toJson() {
    return MessageUploadMapper.ensureInitialized().encodeJson<MessageUpload>(
      this as MessageUpload,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageUploadMapper.ensureInitialized().encodeMap<MessageUpload>(
      this as MessageUpload,
    );
  }

  MessageUploadCopyWith<MessageUpload, MessageUpload, MessageUpload>
  get copyWith => _MessageUploadCopyWithImpl<MessageUpload, MessageUpload>(
    this as MessageUpload,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageUploadMapper.ensureInitialized().stringifyValue(
      this as MessageUpload,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageUploadMapper.ensureInitialized().equalsValue(
      this as MessageUpload,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageUploadMapper.ensureInitialized().hashValue(
      this as MessageUpload,
    );
  }
}

extension MessageUploadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageUpload, $Out> {
  MessageUploadCopyWith<$R, MessageUpload, $Out> get $asMessageUpload =>
      $base.as((v, t, t2) => _MessageUploadCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageUploadCopyWith<$R, $In extends MessageUpload, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UploadPhaseCopyWith<$R, UploadPhase, UploadPhase> get phase;
  ListCopyWith<
    $R,
    UploadingMedia,
    UploadingMediaCopyWith<$R, UploadingMedia, UploadingMedia>
  >
  get media;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get publicUrls;
  $R call({
    String? id,
    String? conversationId,
    DateTime? startedAt,
    UploadPhase? phase,
    List<UploadingMedia>? media,
    String? caption,
    String? replyToId,
    int? durationSeconds,
    List<String>? publicUrls,
  });
  MessageUploadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageUploadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageUpload, $Out>
    implements MessageUploadCopyWith<$R, MessageUpload, $Out> {
  _MessageUploadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageUpload> $mapper =
      MessageUploadMapper.ensureInitialized();
  @override
  UploadPhaseCopyWith<$R, UploadPhase, UploadPhase> get phase =>
      $value.phase.copyWith.$chain((v) => call(phase: v));
  @override
  ListCopyWith<
    $R,
    UploadingMedia,
    UploadingMediaCopyWith<$R, UploadingMedia, UploadingMedia>
  >
  get media => ListCopyWith(
    $value.media,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(media: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get publicUrls =>
      ListCopyWith(
        $value.publicUrls,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(publicUrls: v),
      );
  @override
  $R call({
    String? id,
    String? conversationId,
    DateTime? startedAt,
    UploadPhase? phase,
    List<UploadingMedia>? media,
    String? caption,
    Object? replyToId = $none,
    Object? durationSeconds = $none,
    List<String>? publicUrls,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (conversationId != null) #conversationId: conversationId,
      if (startedAt != null) #startedAt: startedAt,
      if (phase != null) #phase: phase,
      if (media != null) #media: media,
      if (caption != null) #caption: caption,
      if (replyToId != $none) #replyToId: replyToId,
      if (durationSeconds != $none) #durationSeconds: durationSeconds,
      if (publicUrls != null) #publicUrls: publicUrls,
    }),
  );
  @override
  MessageUpload $make(CopyWithData data) => MessageUpload(
    id: data.get(#id, or: $value.id),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    startedAt: data.get(#startedAt, or: $value.startedAt),
    phase: data.get(#phase, or: $value.phase),
    media: data.get(#media, or: $value.media),
    caption: data.get(#caption, or: $value.caption),
    replyToId: data.get(#replyToId, or: $value.replyToId),
    durationSeconds: data.get(#durationSeconds, or: $value.durationSeconds),
    publicUrls: data.get(#publicUrls, or: $value.publicUrls),
  );

  @override
  MessageUploadCopyWith<$R2, MessageUpload, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageUploadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

