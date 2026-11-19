// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_state.dart';

class ChatStateMapper extends ClassMapperBase<ChatState> {
  ChatStateMapper._();

  static ChatStateMapper? _instance;
  static ChatStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatStateMapper._());
      ChatUnknownMapper.ensureInitialized();
      ChatAbsentMapper.ensureInitialized();
      ChatPresentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatState';

  @override
  final MappableFields<ChatState> fields = const {};
  @override
  final bool ignoreNull = true;

  static ChatState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'ChatState',
      'chat',
      '${data.value['chat']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatState>(map);
  }

  static ChatState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatState>(json);
  }
}

mixin ChatStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ChatStateCopyWith<ChatState, ChatState, ChatState> get copyWith;
}

abstract class ChatStateCopyWith<$R, $In extends ChatState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ChatStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ChatUnknownMapper extends SubClassMapperBase<ChatUnknown> {
  ChatUnknownMapper._();

  static ChatUnknownMapper? _instance;
  static ChatUnknownMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatUnknownMapper._());
      ChatStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ChatUnknown';

  @override
  final MappableFields<ChatUnknown> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'chat';
  @override
  final dynamic discriminatorValue = 'unknown';
  @override
  late final ClassMapperBase superMapper = ChatStateMapper.ensureInitialized();

  static ChatUnknown _instantiate(DecodingData data) {
    return ChatUnknown();
  }

  @override
  final Function instantiate = _instantiate;

  static ChatUnknown fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatUnknown>(map);
  }

  static ChatUnknown fromJson(String json) {
    return ensureInitialized().decodeJson<ChatUnknown>(json);
  }
}

mixin ChatUnknownMappable {
  String toJson() {
    return ChatUnknownMapper.ensureInitialized().encodeJson<ChatUnknown>(
      this as ChatUnknown,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatUnknownMapper.ensureInitialized().encodeMap<ChatUnknown>(
      this as ChatUnknown,
    );
  }

  ChatUnknownCopyWith<ChatUnknown, ChatUnknown, ChatUnknown> get copyWith =>
      _ChatUnknownCopyWithImpl<ChatUnknown, ChatUnknown>(
        this as ChatUnknown,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatUnknownMapper.ensureInitialized().stringifyValue(
      this as ChatUnknown,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatUnknownMapper.ensureInitialized().equalsValue(
      this as ChatUnknown,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatUnknownMapper.ensureInitialized().hashValue(this as ChatUnknown);
  }
}

extension ChatUnknownValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatUnknown, $Out> {
  ChatUnknownCopyWith<$R, ChatUnknown, $Out> get $asChatUnknown =>
      $base.as((v, t, t2) => _ChatUnknownCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatUnknownCopyWith<$R, $In extends ChatUnknown, $Out>
    implements ChatStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ChatUnknownCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatUnknownCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatUnknown, $Out>
    implements ChatUnknownCopyWith<$R, ChatUnknown, $Out> {
  _ChatUnknownCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatUnknown> $mapper =
      ChatUnknownMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ChatUnknown $make(CopyWithData data) => ChatUnknown();

  @override
  ChatUnknownCopyWith<$R2, ChatUnknown, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatUnknownCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatAbsentMapper extends SubClassMapperBase<ChatAbsent> {
  ChatAbsentMapper._();

  static ChatAbsentMapper? _instance;
  static ChatAbsentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatAbsentMapper._());
      ChatStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ChatAbsent';

  @override
  final MappableFields<ChatAbsent> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'chat';
  @override
  final dynamic discriminatorValue = 'absent';
  @override
  late final ClassMapperBase superMapper = ChatStateMapper.ensureInitialized();

  static ChatAbsent _instantiate(DecodingData data) {
    return ChatAbsent();
  }

  @override
  final Function instantiate = _instantiate;

  static ChatAbsent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatAbsent>(map);
  }

  static ChatAbsent fromJson(String json) {
    return ensureInitialized().decodeJson<ChatAbsent>(json);
  }
}

mixin ChatAbsentMappable {
  String toJson() {
    return ChatAbsentMapper.ensureInitialized().encodeJson<ChatAbsent>(
      this as ChatAbsent,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatAbsentMapper.ensureInitialized().encodeMap<ChatAbsent>(
      this as ChatAbsent,
    );
  }

  ChatAbsentCopyWith<ChatAbsent, ChatAbsent, ChatAbsent> get copyWith =>
      _ChatAbsentCopyWithImpl<ChatAbsent, ChatAbsent>(
        this as ChatAbsent,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatAbsentMapper.ensureInitialized().stringifyValue(
      this as ChatAbsent,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatAbsentMapper.ensureInitialized().equalsValue(
      this as ChatAbsent,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatAbsentMapper.ensureInitialized().hashValue(this as ChatAbsent);
  }
}

extension ChatAbsentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatAbsent, $Out> {
  ChatAbsentCopyWith<$R, ChatAbsent, $Out> get $asChatAbsent =>
      $base.as((v, t, t2) => _ChatAbsentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatAbsentCopyWith<$R, $In extends ChatAbsent, $Out>
    implements ChatStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ChatAbsentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatAbsentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatAbsent, $Out>
    implements ChatAbsentCopyWith<$R, ChatAbsent, $Out> {
  _ChatAbsentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatAbsent> $mapper =
      ChatAbsentMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ChatAbsent $make(CopyWithData data) => ChatAbsent();

  @override
  ChatAbsentCopyWith<$R2, ChatAbsent, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatAbsentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatPresentMapper extends SubClassMapperBase<ChatPresent> {
  ChatPresentMapper._();

  static ChatPresentMapper? _instance;
  static ChatPresentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatPresentMapper._());
      ChatStateMapper.ensureInitialized().addSubMapper(_instance!);
      EkkloUserMapper.ensureInitialized();
      EkkloConversationMapper.ensureInitialized();
      ChatLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatPresent';

  static EkkloUser _$owner(ChatPresent v) => v.owner;
  static const Field<ChatPresent, EkkloUser> _f$owner = Field('owner', _$owner);
  static List<EkkloConversation> _$conversations(ChatPresent v) =>
      v.conversations;
  static const Field<ChatPresent, List<EkkloConversation>> _f$conversations =
      Field('conversations', _$conversations);
  static ChatLink _$link(ChatPresent v) => v.link;
  static const Field<ChatPresent, ChatLink> _f$link = Field('link', _$link);

  @override
  final MappableFields<ChatPresent> fields = const {
    #owner: _f$owner,
    #conversations: _f$conversations,
    #link: _f$link,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'chat';
  @override
  final dynamic discriminatorValue = 'present';
  @override
  late final ClassMapperBase superMapper = ChatStateMapper.ensureInitialized();

  static ChatPresent _instantiate(DecodingData data) {
    return ChatPresent(
      owner: data.dec(_f$owner),
      conversations: data.dec(_f$conversations),
      link: data.dec(_f$link),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatPresent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatPresent>(map);
  }

  static ChatPresent fromJson(String json) {
    return ensureInitialized().decodeJson<ChatPresent>(json);
  }
}

mixin ChatPresentMappable {
  String toJson() {
    return ChatPresentMapper.ensureInitialized().encodeJson<ChatPresent>(
      this as ChatPresent,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatPresentMapper.ensureInitialized().encodeMap<ChatPresent>(
      this as ChatPresent,
    );
  }

  ChatPresentCopyWith<ChatPresent, ChatPresent, ChatPresent> get copyWith =>
      _ChatPresentCopyWithImpl<ChatPresent, ChatPresent>(
        this as ChatPresent,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatPresentMapper.ensureInitialized().stringifyValue(
      this as ChatPresent,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatPresentMapper.ensureInitialized().equalsValue(
      this as ChatPresent,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatPresentMapper.ensureInitialized().hashValue(this as ChatPresent);
  }
}

extension ChatPresentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatPresent, $Out> {
  ChatPresentCopyWith<$R, ChatPresent, $Out> get $asChatPresent =>
      $base.as((v, t, t2) => _ChatPresentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatPresentCopyWith<$R, $In extends ChatPresent, $Out>
    implements ChatStateCopyWith<$R, $In, $Out> {
  EkkloUserCopyWith<$R, EkkloUser, EkkloUser> get owner;
  ListCopyWith<
    $R,
    EkkloConversation,
    EkkloConversationCopyWith<$R, EkkloConversation, EkkloConversation>
  >
  get conversations;
  @override
  $R call({
    EkkloUser? owner,
    List<EkkloConversation>? conversations,
    ChatLink? link,
  });
  ChatPresentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatPresentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatPresent, $Out>
    implements ChatPresentCopyWith<$R, ChatPresent, $Out> {
  _ChatPresentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatPresent> $mapper =
      ChatPresentMapper.ensureInitialized();
  @override
  EkkloUserCopyWith<$R, EkkloUser, EkkloUser> get owner =>
      $value.owner.copyWith.$chain((v) => call(owner: v));
  @override
  ListCopyWith<
    $R,
    EkkloConversation,
    EkkloConversationCopyWith<$R, EkkloConversation, EkkloConversation>
  >
  get conversations => ListCopyWith(
    $value.conversations,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(conversations: v),
  );
  @override
  $R call({
    EkkloUser? owner,
    List<EkkloConversation>? conversations,
    ChatLink? link,
  }) => $apply(
    FieldCopyWithData({
      if (owner != null) #owner: owner,
      if (conversations != null) #conversations: conversations,
      if (link != null) #link: link,
    }),
  );
  @override
  ChatPresent $make(CopyWithData data) => ChatPresent(
    owner: data.get(#owner, or: $value.owner),
    conversations: data.get(#conversations, or: $value.conversations),
    link: data.get(#link, or: $value.link),
  );

  @override
  ChatPresentCopyWith<$R2, ChatPresent, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatPresentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

