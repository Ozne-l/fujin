// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation_state.dart';

class ConversationStateMapper extends ClassMapperBase<ConversationState> {
  ConversationStateMapper._();

  static ConversationStateMapper? _instance;
  static ConversationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationStateMapper._());
      EkkloConversationMapper.ensureInitialized();
      EkkloMessageMapper.ensureInitialized();
      ChatLinkMapper.ensureInitialized();
      PendingTextMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConversationState';

  static String _$conversationId(ConversationState v) => v.conversationId;
  static const Field<ConversationState, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static String? _$ownerId(ConversationState v) => v.ownerId;
  static const Field<ConversationState, String> _f$ownerId = Field(
    'ownerId',
    _$ownerId,
    key: r'owner_id',
  );
  static EkkloConversation? _$conversation(ConversationState v) =>
      v.conversation;
  static const Field<ConversationState, EkkloConversation> _f$conversation =
      Field('conversation', _$conversation);
  static List<EkkloMessage> _$messages(ConversationState v) => v.messages;
  static const Field<ConversationState, List<EkkloMessage>> _f$messages = Field(
    'messages',
    _$messages,
  );
  static ChatLink _$link(ConversationState v) => v.link;
  static const Field<ConversationState, ChatLink> _f$link = Field(
    'link',
    _$link,
  );
  static bool _$loadingNewest(ConversationState v) => v.loadingNewest;
  static const Field<ConversationState, bool> _f$loadingNewest = Field(
    'loadingNewest',
    _$loadingNewest,
    key: r'loading_newest',
  );
  static bool _$loadingOlder(ConversationState v) => v.loadingOlder;
  static const Field<ConversationState, bool> _f$loadingOlder = Field(
    'loadingOlder',
    _$loadingOlder,
    key: r'loading_older',
  );
  static bool _$hasOlder(ConversationState v) => v.hasOlder;
  static const Field<ConversationState, bool> _f$hasOlder = Field(
    'hasOlder',
    _$hasOlder,
    key: r'has_older',
  );
  static bool _$protectsCapture(ConversationState v) => v.protectsCapture;
  static const Field<ConversationState, bool> _f$protectsCapture = Field(
    'protectsCapture',
    _$protectsCapture,
    key: r'protects_capture',
  );
  static List<PendingText> _$pendingTexts(ConversationState v) =>
      v.pendingTexts;
  static const Field<ConversationState, List<PendingText>> _f$pendingTexts =
      Field(
        'pendingTexts',
        _$pendingTexts,
        key: r'pending_texts',
        opt: true,
        def: const [],
      );
  static Set<String> _$deleting(ConversationState v) => v.deleting;
  static const Field<ConversationState, Set<String>> _f$deleting = Field(
    'deleting',
    _$deleting,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ConversationState> fields = const {
    #conversationId: _f$conversationId,
    #ownerId: _f$ownerId,
    #conversation: _f$conversation,
    #messages: _f$messages,
    #link: _f$link,
    #loadingNewest: _f$loadingNewest,
    #loadingOlder: _f$loadingOlder,
    #hasOlder: _f$hasOlder,
    #protectsCapture: _f$protectsCapture,
    #pendingTexts: _f$pendingTexts,
    #deleting: _f$deleting,
  };
  @override
  final bool ignoreNull = true;

  static ConversationState _instantiate(DecodingData data) {
    return ConversationState(
      conversationId: data.dec(_f$conversationId),
      ownerId: data.dec(_f$ownerId),
      conversation: data.dec(_f$conversation),
      messages: data.dec(_f$messages),
      link: data.dec(_f$link),
      loadingNewest: data.dec(_f$loadingNewest),
      loadingOlder: data.dec(_f$loadingOlder),
      hasOlder: data.dec(_f$hasOlder),
      protectsCapture: data.dec(_f$protectsCapture),
      pendingTexts: data.dec(_f$pendingTexts),
      deleting: data.dec(_f$deleting),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConversationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConversationState>(map);
  }

  static ConversationState fromJson(String json) {
    return ensureInitialized().decodeJson<ConversationState>(json);
  }
}

mixin ConversationStateMappable {
  String toJson() {
    return ConversationStateMapper.ensureInitialized()
        .encodeJson<ConversationState>(this as ConversationState);
  }

  Map<String, dynamic> toMap() {
    return ConversationStateMapper.ensureInitialized()
        .encodeMap<ConversationState>(this as ConversationState);
  }

  ConversationStateCopyWith<
    ConversationState,
    ConversationState,
    ConversationState
  >
  get copyWith =>
      _ConversationStateCopyWithImpl<ConversationState, ConversationState>(
        this as ConversationState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ConversationStateMapper.ensureInitialized().stringifyValue(
      this as ConversationState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConversationStateMapper.ensureInitialized().equalsValue(
      this as ConversationState,
      other,
    );
  }

  @override
  int get hashCode {
    return ConversationStateMapper.ensureInitialized().hashValue(
      this as ConversationState,
    );
  }
}

extension ConversationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConversationState, $Out> {
  ConversationStateCopyWith<$R, ConversationState, $Out>
  get $asConversationState => $base.as(
    (v, t, t2) => _ConversationStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConversationStateCopyWith<
  $R,
  $In extends ConversationState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  EkkloConversationCopyWith<$R, EkkloConversation, EkkloConversation>?
  get conversation;
  ListCopyWith<
    $R,
    EkkloMessage,
    EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage>
  >
  get messages;
  ListCopyWith<
    $R,
    PendingText,
    PendingTextCopyWith<$R, PendingText, PendingText>
  >
  get pendingTexts;
  $R call({
    String? conversationId,
    String? ownerId,
    EkkloConversation? conversation,
    List<EkkloMessage>? messages,
    ChatLink? link,
    bool? loadingNewest,
    bool? loadingOlder,
    bool? hasOlder,
    bool? protectsCapture,
    List<PendingText>? pendingTexts,
    Set<String>? deleting,
  });
  ConversationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConversationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConversationState, $Out>
    implements ConversationStateCopyWith<$R, ConversationState, $Out> {
  _ConversationStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConversationState> $mapper =
      ConversationStateMapper.ensureInitialized();
  @override
  EkkloConversationCopyWith<$R, EkkloConversation, EkkloConversation>?
  get conversation =>
      $value.conversation?.copyWith.$chain((v) => call(conversation: v));
  @override
  ListCopyWith<
    $R,
    EkkloMessage,
    EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  ListCopyWith<
    $R,
    PendingText,
    PendingTextCopyWith<$R, PendingText, PendingText>
  >
  get pendingTexts => ListCopyWith(
    $value.pendingTexts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(pendingTexts: v),
  );
  @override
  $R call({
    String? conversationId,
    Object? ownerId = $none,
    Object? conversation = $none,
    List<EkkloMessage>? messages,
    ChatLink? link,
    bool? loadingNewest,
    bool? loadingOlder,
    bool? hasOlder,
    bool? protectsCapture,
    List<PendingText>? pendingTexts,
    Set<String>? deleting,
  }) => $apply(
    FieldCopyWithData({
      if (conversationId != null) #conversationId: conversationId,
      if (ownerId != $none) #ownerId: ownerId,
      if (conversation != $none) #conversation: conversation,
      if (messages != null) #messages: messages,
      if (link != null) #link: link,
      if (loadingNewest != null) #loadingNewest: loadingNewest,
      if (loadingOlder != null) #loadingOlder: loadingOlder,
      if (hasOlder != null) #hasOlder: hasOlder,
      if (protectsCapture != null) #protectsCapture: protectsCapture,
      if (pendingTexts != null) #pendingTexts: pendingTexts,
      if (deleting != null) #deleting: deleting,
    }),
  );
  @override
  ConversationState $make(CopyWithData data) => ConversationState(
    conversationId: data.get(#conversationId, or: $value.conversationId),
    ownerId: data.get(#ownerId, or: $value.ownerId),
    conversation: data.get(#conversation, or: $value.conversation),
    messages: data.get(#messages, or: $value.messages),
    link: data.get(#link, or: $value.link),
    loadingNewest: data.get(#loadingNewest, or: $value.loadingNewest),
    loadingOlder: data.get(#loadingOlder, or: $value.loadingOlder),
    hasOlder: data.get(#hasOlder, or: $value.hasOlder),
    protectsCapture: data.get(#protectsCapture, or: $value.protectsCapture),
    pendingTexts: data.get(#pendingTexts, or: $value.pendingTexts),
    deleting: data.get(#deleting, or: $value.deleting),
  );

  @override
  ConversationStateCopyWith<$R2, ConversationState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConversationStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

