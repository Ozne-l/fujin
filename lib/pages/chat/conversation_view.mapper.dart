// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation_view.dart';

class ConversationViewMapper extends ClassMapperBase<ConversationView> {
  ConversationViewMapper._();

  static ConversationViewMapper? _instance;
  static ConversationViewMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationViewMapper._());
      EkkloPersonMapper.ensureInitialized();
      ThreadItemMapper.ensureInitialized();
      ChatLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConversationView';

  static String _$conversationId(ConversationView v) => v.conversationId;
  static const Field<ConversationView, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );
  static EkkloPerson? _$coach(ConversationView v) => v.coach;
  static const Field<ConversationView, EkkloPerson> _f$coach = Field(
    'coach',
    _$coach,
  );
  static List<ThreadItem> _$newestFirst(ConversationView v) => v.newestFirst;
  static const Field<ConversationView, List<ThreadItem>> _f$newestFirst = Field(
    'newestFirst',
    _$newestFirst,
    key: r'newest_first',
  );
  static ChatLink _$link(ConversationView v) => v.link;
  static const Field<ConversationView, ChatLink> _f$link = Field(
    'link',
    _$link,
  );
  static bool _$loadingNewest(ConversationView v) => v.loadingNewest;
  static const Field<ConversationView, bool> _f$loadingNewest = Field(
    'loadingNewest',
    _$loadingNewest,
    key: r'loading_newest',
  );
  static bool _$loadingOlder(ConversationView v) => v.loadingOlder;
  static const Field<ConversationView, bool> _f$loadingOlder = Field(
    'loadingOlder',
    _$loadingOlder,
    key: r'loading_older',
  );
  static bool _$hasOlder(ConversationView v) => v.hasOlder;
  static const Field<ConversationView, bool> _f$hasOlder = Field(
    'hasOlder',
    _$hasOlder,
    key: r'has_older',
  );
  static bool _$canSend(ConversationView v) => v.canSend;
  static const Field<ConversationView, bool> _f$canSend = Field(
    'canSend',
    _$canSend,
    key: r'can_send',
  );
  static bool _$protectsCapture(ConversationView v) => v.protectsCapture;
  static const Field<ConversationView, bool> _f$protectsCapture = Field(
    'protectsCapture',
    _$protectsCapture,
    key: r'protects_capture',
  );

  @override
  final MappableFields<ConversationView> fields = const {
    #conversationId: _f$conversationId,
    #coach: _f$coach,
    #newestFirst: _f$newestFirst,
    #link: _f$link,
    #loadingNewest: _f$loadingNewest,
    #loadingOlder: _f$loadingOlder,
    #hasOlder: _f$hasOlder,
    #canSend: _f$canSend,
    #protectsCapture: _f$protectsCapture,
  };
  @override
  final bool ignoreNull = true;

  static ConversationView _instantiate(DecodingData data) {
    return ConversationView(
      conversationId: data.dec(_f$conversationId),
      coach: data.dec(_f$coach),
      newestFirst: data.dec(_f$newestFirst),
      link: data.dec(_f$link),
      loadingNewest: data.dec(_f$loadingNewest),
      loadingOlder: data.dec(_f$loadingOlder),
      hasOlder: data.dec(_f$hasOlder),
      canSend: data.dec(_f$canSend),
      protectsCapture: data.dec(_f$protectsCapture),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConversationView fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConversationView>(map);
  }

  static ConversationView fromJson(String json) {
    return ensureInitialized().decodeJson<ConversationView>(json);
  }
}

mixin ConversationViewMappable {
  String toJson() {
    return ConversationViewMapper.ensureInitialized()
        .encodeJson<ConversationView>(this as ConversationView);
  }

  Map<String, dynamic> toMap() {
    return ConversationViewMapper.ensureInitialized()
        .encodeMap<ConversationView>(this as ConversationView);
  }

  ConversationViewCopyWith<ConversationView, ConversationView, ConversationView>
  get copyWith =>
      _ConversationViewCopyWithImpl<ConversationView, ConversationView>(
        this as ConversationView,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ConversationViewMapper.ensureInitialized().stringifyValue(
      this as ConversationView,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConversationViewMapper.ensureInitialized().equalsValue(
      this as ConversationView,
      other,
    );
  }

  @override
  int get hashCode {
    return ConversationViewMapper.ensureInitialized().hashValue(
      this as ConversationView,
    );
  }
}

extension ConversationViewValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConversationView, $Out> {
  ConversationViewCopyWith<$R, ConversationView, $Out>
  get $asConversationView =>
      $base.as((v, t, t2) => _ConversationViewCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConversationViewCopyWith<$R, $In extends ConversationView, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EkkloPersonCopyWith<$R, EkkloPerson, EkkloPerson>? get coach;
  ListCopyWith<$R, ThreadItem, ThreadItemCopyWith<$R, ThreadItem, ThreadItem>>
  get newestFirst;
  $R call({
    String? conversationId,
    EkkloPerson? coach,
    List<ThreadItem>? newestFirst,
    ChatLink? link,
    bool? loadingNewest,
    bool? loadingOlder,
    bool? hasOlder,
    bool? canSend,
    bool? protectsCapture,
  });
  ConversationViewCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConversationViewCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConversationView, $Out>
    implements ConversationViewCopyWith<$R, ConversationView, $Out> {
  _ConversationViewCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConversationView> $mapper =
      ConversationViewMapper.ensureInitialized();
  @override
  EkkloPersonCopyWith<$R, EkkloPerson, EkkloPerson>? get coach =>
      $value.coach?.copyWith.$chain((v) => call(coach: v));
  @override
  ListCopyWith<$R, ThreadItem, ThreadItemCopyWith<$R, ThreadItem, ThreadItem>>
  get newestFirst => ListCopyWith(
    $value.newestFirst,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(newestFirst: v),
  );
  @override
  $R call({
    String? conversationId,
    Object? coach = $none,
    List<ThreadItem>? newestFirst,
    ChatLink? link,
    bool? loadingNewest,
    bool? loadingOlder,
    bool? hasOlder,
    bool? canSend,
    bool? protectsCapture,
  }) => $apply(
    FieldCopyWithData({
      if (conversationId != null) #conversationId: conversationId,
      if (coach != $none) #coach: coach,
      if (newestFirst != null) #newestFirst: newestFirst,
      if (link != null) #link: link,
      if (loadingNewest != null) #loadingNewest: loadingNewest,
      if (loadingOlder != null) #loadingOlder: loadingOlder,
      if (hasOlder != null) #hasOlder: hasOlder,
      if (canSend != null) #canSend: canSend,
      if (protectsCapture != null) #protectsCapture: protectsCapture,
    }),
  );
  @override
  ConversationView $make(CopyWithData data) => ConversationView(
    conversationId: data.get(#conversationId, or: $value.conversationId),
    coach: data.get(#coach, or: $value.coach),
    newestFirst: data.get(#newestFirst, or: $value.newestFirst),
    link: data.get(#link, or: $value.link),
    loadingNewest: data.get(#loadingNewest, or: $value.loadingNewest),
    loadingOlder: data.get(#loadingOlder, or: $value.loadingOlder),
    hasOlder: data.get(#hasOlder, or: $value.hasOlder),
    canSend: data.get(#canSend, or: $value.canSend),
    protectsCapture: data.get(#protectsCapture, or: $value.protectsCapture),
  );

  @override
  ConversationViewCopyWith<$R2, ConversationView, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConversationViewCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

