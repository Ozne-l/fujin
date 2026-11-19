// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_change.dart';

class ChatChangeMapper extends ClassMapperBase<ChatChange> {
  ChatChangeMapper._();

  static ChatChangeMapper? _instance;
  static ChatChangeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatChangeMapper._());
      MessageSavedMapper.ensureInitialized();
      MessageRemovedMapper.ensureInitialized();
      NothingChangedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatChange';

  @override
  final MappableFields<ChatChange> fields = const {};
  @override
  final bool ignoreNull = true;

  static ChatChange _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'ChatChange',
      'change',
      '${data.value['change']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatChange fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatChange>(map);
  }

  static ChatChange fromJson(String json) {
    return ensureInitialized().decodeJson<ChatChange>(json);
  }
}

mixin ChatChangeMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ChatChangeCopyWith<ChatChange, ChatChange, ChatChange> get copyWith;
}

abstract class ChatChangeCopyWith<$R, $In extends ChatChange, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ChatChangeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MessageSavedMapper extends SubClassMapperBase<MessageSaved> {
  MessageSavedMapper._();

  static MessageSavedMapper? _instance;
  static MessageSavedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageSavedMapper._());
      ChatChangeMapper.ensureInitialized().addSubMapper(_instance!);
      EkkloMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageSaved';

  static EkkloMessage _$message(MessageSaved v) => v.message;
  static const Field<MessageSaved, EkkloMessage> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<MessageSaved> fields = const {#message: _f$message};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'change';
  @override
  final dynamic discriminatorValue = 'saved';
  @override
  late final ClassMapperBase superMapper = ChatChangeMapper.ensureInitialized();

  static MessageSaved _instantiate(DecodingData data) {
    return MessageSaved(data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static MessageSaved fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageSaved>(map);
  }

  static MessageSaved fromJson(String json) {
    return ensureInitialized().decodeJson<MessageSaved>(json);
  }
}

mixin MessageSavedMappable {
  String toJson() {
    return MessageSavedMapper.ensureInitialized().encodeJson<MessageSaved>(
      this as MessageSaved,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageSavedMapper.ensureInitialized().encodeMap<MessageSaved>(
      this as MessageSaved,
    );
  }

  MessageSavedCopyWith<MessageSaved, MessageSaved, MessageSaved> get copyWith =>
      _MessageSavedCopyWithImpl<MessageSaved, MessageSaved>(
        this as MessageSaved,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageSavedMapper.ensureInitialized().stringifyValue(
      this as MessageSaved,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageSavedMapper.ensureInitialized().equalsValue(
      this as MessageSaved,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageSavedMapper.ensureInitialized().hashValue(
      this as MessageSaved,
    );
  }
}

extension MessageSavedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageSaved, $Out> {
  MessageSavedCopyWith<$R, MessageSaved, $Out> get $asMessageSaved =>
      $base.as((v, t, t2) => _MessageSavedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageSavedCopyWith<$R, $In extends MessageSaved, $Out>
    implements ChatChangeCopyWith<$R, $In, $Out> {
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message;
  @override
  $R call({EkkloMessage? message});
  MessageSavedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageSavedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageSaved, $Out>
    implements MessageSavedCopyWith<$R, MessageSaved, $Out> {
  _MessageSavedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageSaved> $mapper =
      MessageSavedMapper.ensureInitialized();
  @override
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message =>
      $value.message.copyWith.$chain((v) => call(message: v));
  @override
  $R call({EkkloMessage? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  MessageSaved $make(CopyWithData data) =>
      MessageSaved(data.get(#message, or: $value.message));

  @override
  MessageSavedCopyWith<$R2, MessageSaved, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageSavedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageRemovedMapper extends SubClassMapperBase<MessageRemoved> {
  MessageRemovedMapper._();

  static MessageRemovedMapper? _instance;
  static MessageRemovedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageRemovedMapper._());
      ChatChangeMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageRemoved';

  static String _$conversationId(MessageRemoved v) => v.conversationId;
  static const Field<MessageRemoved, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static String _$messageId(MessageRemoved v) => v.messageId;
  static const Field<MessageRemoved, String> _f$messageId = Field(
    'messageId',
    _$messageId,
    key: r'message_id',
  );

  @override
  final MappableFields<MessageRemoved> fields = const {
    #conversationId: _f$conversationId,
    #messageId: _f$messageId,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'change';
  @override
  final dynamic discriminatorValue = 'removed';
  @override
  late final ClassMapperBase superMapper = ChatChangeMapper.ensureInitialized();

  static MessageRemoved _instantiate(DecodingData data) {
    return MessageRemoved(
      conversationId: data.dec(_f$conversationId),
      messageId: data.dec(_f$messageId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageRemoved fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageRemoved>(map);
  }

  static MessageRemoved fromJson(String json) {
    return ensureInitialized().decodeJson<MessageRemoved>(json);
  }
}

mixin MessageRemovedMappable {
  String toJson() {
    return MessageRemovedMapper.ensureInitialized().encodeJson<MessageRemoved>(
      this as MessageRemoved,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageRemovedMapper.ensureInitialized().encodeMap<MessageRemoved>(
      this as MessageRemoved,
    );
  }

  MessageRemovedCopyWith<MessageRemoved, MessageRemoved, MessageRemoved>
  get copyWith => _MessageRemovedCopyWithImpl<MessageRemoved, MessageRemoved>(
    this as MessageRemoved,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageRemovedMapper.ensureInitialized().stringifyValue(
      this as MessageRemoved,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageRemovedMapper.ensureInitialized().equalsValue(
      this as MessageRemoved,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageRemovedMapper.ensureInitialized().hashValue(
      this as MessageRemoved,
    );
  }
}

extension MessageRemovedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageRemoved, $Out> {
  MessageRemovedCopyWith<$R, MessageRemoved, $Out> get $asMessageRemoved =>
      $base.as((v, t, t2) => _MessageRemovedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageRemovedCopyWith<$R, $In extends MessageRemoved, $Out>
    implements ChatChangeCopyWith<$R, $In, $Out> {
  @override
  $R call({String? conversationId, String? messageId});
  MessageRemovedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageRemovedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageRemoved, $Out>
    implements MessageRemovedCopyWith<$R, MessageRemoved, $Out> {
  _MessageRemovedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageRemoved> $mapper =
      MessageRemovedMapper.ensureInitialized();
  @override
  $R call({String? conversationId, String? messageId}) => $apply(
    FieldCopyWithData({
      if (conversationId != null) #conversationId: conversationId,
      if (messageId != null) #messageId: messageId,
    }),
  );
  @override
  MessageRemoved $make(CopyWithData data) => MessageRemoved(
    conversationId: data.get(#conversationId, or: $value.conversationId),
    messageId: data.get(#messageId, or: $value.messageId),
  );

  @override
  MessageRemovedCopyWith<$R2, MessageRemoved, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageRemovedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NothingChangedMapper extends SubClassMapperBase<NothingChanged> {
  NothingChangedMapper._();

  static NothingChangedMapper? _instance;
  static NothingChangedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NothingChangedMapper._());
      ChatChangeMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NothingChanged';

  @override
  final MappableFields<NothingChanged> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'change';
  @override
  final dynamic discriminatorValue = 'none';
  @override
  late final ClassMapperBase superMapper = ChatChangeMapper.ensureInitialized();

  static NothingChanged _instantiate(DecodingData data) {
    return NothingChanged();
  }

  @override
  final Function instantiate = _instantiate;

  static NothingChanged fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NothingChanged>(map);
  }

  static NothingChanged fromJson(String json) {
    return ensureInitialized().decodeJson<NothingChanged>(json);
  }
}

mixin NothingChangedMappable {
  String toJson() {
    return NothingChangedMapper.ensureInitialized().encodeJson<NothingChanged>(
      this as NothingChanged,
    );
  }

  Map<String, dynamic> toMap() {
    return NothingChangedMapper.ensureInitialized().encodeMap<NothingChanged>(
      this as NothingChanged,
    );
  }

  NothingChangedCopyWith<NothingChanged, NothingChanged, NothingChanged>
  get copyWith => _NothingChangedCopyWithImpl<NothingChanged, NothingChanged>(
    this as NothingChanged,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NothingChangedMapper.ensureInitialized().stringifyValue(
      this as NothingChanged,
    );
  }

  @override
  bool operator ==(Object other) {
    return NothingChangedMapper.ensureInitialized().equalsValue(
      this as NothingChanged,
      other,
    );
  }

  @override
  int get hashCode {
    return NothingChangedMapper.ensureInitialized().hashValue(
      this as NothingChanged,
    );
  }
}

extension NothingChangedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NothingChanged, $Out> {
  NothingChangedCopyWith<$R, NothingChanged, $Out> get $asNothingChanged =>
      $base.as((v, t, t2) => _NothingChangedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NothingChangedCopyWith<$R, $In extends NothingChanged, $Out>
    implements ChatChangeCopyWith<$R, $In, $Out> {
  @override
  $R call();
  NothingChangedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NothingChangedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NothingChanged, $Out>
    implements NothingChangedCopyWith<$R, NothingChanged, $Out> {
  _NothingChangedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NothingChanged> $mapper =
      NothingChangedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  NothingChanged $make(CopyWithData data) => NothingChanged();

  @override
  NothingChangedCopyWith<$R2, NothingChanged, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NothingChangedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

