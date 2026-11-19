// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message_in_progress.dart';

class MessageInProgressMapper extends ClassMapperBase<MessageInProgress> {
  MessageInProgressMapper._();

  static MessageInProgressMapper? _instance;
  static MessageInProgressMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageInProgressMapper._());
      MessageInProgressStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageInProgress';

  static String _$id(MessageInProgress v) => v.id;
  static const Field<MessageInProgress, String> _f$id = Field('id', _$id);
  static String _$conversationId(MessageInProgress v) => v.conversationId;
  static const Field<MessageInProgress, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static DateTime _$startedAt(MessageInProgress v) => v.startedAt;
  static const Field<MessageInProgress, DateTime> _f$startedAt = Field(
    'startedAt',
    _$startedAt,
    key: r'started_at',
  );
  static MessageInProgressState _$state(MessageInProgress v) => v.state;
  static const Field<MessageInProgress, MessageInProgressState> _f$state =
      Field('state', _$state);
  static String? _$caption(MessageInProgress v) => v.caption;
  static const Field<MessageInProgress, String> _f$caption = Field(
    'caption',
    _$caption,
    opt: true,
  );
  static String? _$replyToId(MessageInProgress v) => v.replyToId;
  static const Field<MessageInProgress, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    key: r'reply_to_id',
    opt: true,
  );
  static int? _$durationSeconds(MessageInProgress v) => v.durationSeconds;
  static const Field<MessageInProgress, int> _f$durationSeconds = Field(
    'durationSeconds',
    _$durationSeconds,
    key: r'duration_seconds',
    opt: true,
  );

  @override
  final MappableFields<MessageInProgress> fields = const {
    #id: _f$id,
    #conversationId: _f$conversationId,
    #startedAt: _f$startedAt,
    #state: _f$state,
    #caption: _f$caption,
    #replyToId: _f$replyToId,
    #durationSeconds: _f$durationSeconds,
  };
  @override
  final bool ignoreNull = true;

  static MessageInProgress _instantiate(DecodingData data) {
    return MessageInProgress(
      id: data.dec(_f$id),
      conversationId: data.dec(_f$conversationId),
      startedAt: data.dec(_f$startedAt),
      state: data.dec(_f$state),
      caption: data.dec(_f$caption),
      replyToId: data.dec(_f$replyToId),
      durationSeconds: data.dec(_f$durationSeconds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageInProgress fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageInProgress>(map);
  }

  static MessageInProgress fromJson(String json) {
    return ensureInitialized().decodeJson<MessageInProgress>(json);
  }
}

mixin MessageInProgressMappable {
  String toJson() {
    return MessageInProgressMapper.ensureInitialized()
        .encodeJson<MessageInProgress>(this as MessageInProgress);
  }

  Map<String, dynamic> toMap() {
    return MessageInProgressMapper.ensureInitialized()
        .encodeMap<MessageInProgress>(this as MessageInProgress);
  }

  MessageInProgressCopyWith<
    MessageInProgress,
    MessageInProgress,
    MessageInProgress
  >
  get copyWith =>
      _MessageInProgressCopyWithImpl<MessageInProgress, MessageInProgress>(
        this as MessageInProgress,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageInProgressMapper.ensureInitialized().stringifyValue(
      this as MessageInProgress,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageInProgressMapper.ensureInitialized().equalsValue(
      this as MessageInProgress,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageInProgressMapper.ensureInitialized().hashValue(
      this as MessageInProgress,
    );
  }
}

extension MessageInProgressValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageInProgress, $Out> {
  MessageInProgressCopyWith<$R, MessageInProgress, $Out>
  get $asMessageInProgress => $base.as(
    (v, t, t2) => _MessageInProgressCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class MessageInProgressCopyWith<
  $R,
  $In extends MessageInProgress,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? conversationId,
    DateTime? startedAt,
    MessageInProgressState? state,
    String? caption,
    String? replyToId,
    int? durationSeconds,
  });
  MessageInProgressCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageInProgressCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageInProgress, $Out>
    implements MessageInProgressCopyWith<$R, MessageInProgress, $Out> {
  _MessageInProgressCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageInProgress> $mapper =
      MessageInProgressMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? conversationId,
    DateTime? startedAt,
    MessageInProgressState? state,
    Object? caption = $none,
    Object? replyToId = $none,
    Object? durationSeconds = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (conversationId != null) #conversationId: conversationId,
      if (startedAt != null) #startedAt: startedAt,
      if (state != null) #state: state,
      if (caption != $none) #caption: caption,
      if (replyToId != $none) #replyToId: replyToId,
      if (durationSeconds != $none) #durationSeconds: durationSeconds,
    }),
  );
  @override
  MessageInProgress $make(CopyWithData data) => MessageInProgress(
    id: data.get(#id, or: $value.id),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    startedAt: data.get(#startedAt, or: $value.startedAt),
    state: data.get(#state, or: $value.state),
    caption: data.get(#caption, or: $value.caption),
    replyToId: data.get(#replyToId, or: $value.replyToId),
    durationSeconds: data.get(#durationSeconds, or: $value.durationSeconds),
  );

  @override
  MessageInProgressCopyWith<$R2, MessageInProgress, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageInProgressCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

