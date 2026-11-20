// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_notification.dart';

class ChatNotificationMapper extends ClassMapperBase<ChatNotification> {
  ChatNotificationMapper._();

  static ChatNotificationMapper? _instance;
  static ChatNotificationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatNotificationMapper._());
      NotifiedMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatNotification';

  static String _$conversationId(ChatNotification v) => v.conversationId;
  static const Field<ChatNotification, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static List<NotifiedMessage> _$messages(ChatNotification v) => v.messages;
  static const Field<ChatNotification, List<NotifiedMessage>> _f$messages =
      Field('messages', _$messages);
  static String? _$coachName(ChatNotification v) => v.coachName;
  static const Field<ChatNotification, String> _f$coachName = Field(
    'coachName',
    _$coachName,
    key: r'coach_name',
    opt: true,
  );
  static String? _$ownerName(ChatNotification v) => v.ownerName;
  static const Field<ChatNotification, String> _f$ownerName = Field(
    'ownerName',
    _$ownerName,
    key: r'owner_name',
    opt: true,
  );

  @override
  final MappableFields<ChatNotification> fields = const {
    #conversationId: _f$conversationId,
    #messages: _f$messages,
    #coachName: _f$coachName,
    #ownerName: _f$ownerName,
  };
  @override
  final bool ignoreNull = true;

  static ChatNotification _instantiate(DecodingData data) {
    return ChatNotification(
      conversationId: data.dec(_f$conversationId),
      messages: data.dec(_f$messages),
      coachName: data.dec(_f$coachName),
      ownerName: data.dec(_f$ownerName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatNotification fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatNotification>(map);
  }

  static ChatNotification fromJson(String json) {
    return ensureInitialized().decodeJson<ChatNotification>(json);
  }
}

mixin ChatNotificationMappable {
  String toJson() {
    return ChatNotificationMapper.ensureInitialized()
        .encodeJson<ChatNotification>(this as ChatNotification);
  }

  Map<String, dynamic> toMap() {
    return ChatNotificationMapper.ensureInitialized()
        .encodeMap<ChatNotification>(this as ChatNotification);
  }

  ChatNotificationCopyWith<ChatNotification, ChatNotification, ChatNotification>
  get copyWith =>
      _ChatNotificationCopyWithImpl<ChatNotification, ChatNotification>(
        this as ChatNotification,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatNotificationMapper.ensureInitialized().stringifyValue(
      this as ChatNotification,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatNotificationMapper.ensureInitialized().equalsValue(
      this as ChatNotification,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatNotificationMapper.ensureInitialized().hashValue(
      this as ChatNotification,
    );
  }
}

extension ChatNotificationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatNotification, $Out> {
  ChatNotificationCopyWith<$R, ChatNotification, $Out>
  get $asChatNotification =>
      $base.as((v, t, t2) => _ChatNotificationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatNotificationCopyWith<$R, $In extends ChatNotification, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    NotifiedMessage,
    NotifiedMessageCopyWith<$R, NotifiedMessage, NotifiedMessage>
  >
  get messages;
  $R call({
    String? conversationId,
    List<NotifiedMessage>? messages,
    String? coachName,
    String? ownerName,
  });
  ChatNotificationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatNotificationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatNotification, $Out>
    implements ChatNotificationCopyWith<$R, ChatNotification, $Out> {
  _ChatNotificationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatNotification> $mapper =
      ChatNotificationMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    NotifiedMessage,
    NotifiedMessageCopyWith<$R, NotifiedMessage, NotifiedMessage>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  $R call({
    String? conversationId,
    List<NotifiedMessage>? messages,
    Object? coachName = $none,
    Object? ownerName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (conversationId != null) #conversationId: conversationId,
      if (messages != null) #messages: messages,
      if (coachName != $none) #coachName: coachName,
      if (ownerName != $none) #ownerName: ownerName,
    }),
  );
  @override
  ChatNotification $make(CopyWithData data) => ChatNotification(
    conversationId: data.get(#conversationId, or: $value.conversationId),
    messages: data.get(#messages, or: $value.messages),
    coachName: data.get(#coachName, or: $value.coachName),
    ownerName: data.get(#ownerName, or: $value.ownerName),
  );

  @override
  ChatNotificationCopyWith<$R2, ChatNotification, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatNotificationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

