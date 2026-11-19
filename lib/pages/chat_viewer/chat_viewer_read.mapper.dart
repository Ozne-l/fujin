// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_viewer_read.dart';

class ChatViewerReadMapper extends ClassMapperBase<ChatViewerRead> {
  ChatViewerReadMapper._();

  static ChatViewerReadMapper? _instance;
  static ChatViewerReadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatViewerReadMapper._());
      EkkloPersonMapper.ensureInitialized();
      EkkloMediaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatViewerRead';

  static bool _$mine(ChatViewerRead v) => v.mine;
  static const Field<ChatViewerRead, bool> _f$mine = Field('mine', _$mine);
  static EkkloPerson? _$coach(ChatViewerRead v) => v.coach;
  static const Field<ChatViewerRead, EkkloPerson> _f$coach = Field(
    'coach',
    _$coach,
  );
  static DateTime _$createdAt(ChatViewerRead v) => v.createdAt;
  static const Field<ChatViewerRead, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String _$caption(ChatViewerRead v) => v.caption;
  static const Field<ChatViewerRead, String> _f$caption = Field(
    'caption',
    _$caption,
  );
  static List<EkkloMedia> _$media(ChatViewerRead v) => v.media;
  static const Field<ChatViewerRead, List<EkkloMedia>> _f$media = Field(
    'media',
    _$media,
  );

  @override
  final MappableFields<ChatViewerRead> fields = const {
    #mine: _f$mine,
    #coach: _f$coach,
    #createdAt: _f$createdAt,
    #caption: _f$caption,
    #media: _f$media,
  };
  @override
  final bool ignoreNull = true;

  static ChatViewerRead _instantiate(DecodingData data) {
    return ChatViewerRead(
      mine: data.dec(_f$mine),
      coach: data.dec(_f$coach),
      createdAt: data.dec(_f$createdAt),
      caption: data.dec(_f$caption),
      media: data.dec(_f$media),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatViewerRead fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatViewerRead>(map);
  }

  static ChatViewerRead fromJson(String json) {
    return ensureInitialized().decodeJson<ChatViewerRead>(json);
  }
}

mixin ChatViewerReadMappable {
  String toJson() {
    return ChatViewerReadMapper.ensureInitialized().encodeJson<ChatViewerRead>(
      this as ChatViewerRead,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatViewerReadMapper.ensureInitialized().encodeMap<ChatViewerRead>(
      this as ChatViewerRead,
    );
  }

  ChatViewerReadCopyWith<ChatViewerRead, ChatViewerRead, ChatViewerRead>
  get copyWith => _ChatViewerReadCopyWithImpl<ChatViewerRead, ChatViewerRead>(
    this as ChatViewerRead,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ChatViewerReadMapper.ensureInitialized().stringifyValue(
      this as ChatViewerRead,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatViewerReadMapper.ensureInitialized().equalsValue(
      this as ChatViewerRead,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatViewerReadMapper.ensureInitialized().hashValue(
      this as ChatViewerRead,
    );
  }
}

extension ChatViewerReadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatViewerRead, $Out> {
  ChatViewerReadCopyWith<$R, ChatViewerRead, $Out> get $asChatViewerRead =>
      $base.as((v, t, t2) => _ChatViewerReadCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatViewerReadCopyWith<$R, $In extends ChatViewerRead, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EkkloPersonCopyWith<$R, EkkloPerson, EkkloPerson>? get coach;
  ListCopyWith<$R, EkkloMedia, EkkloMediaCopyWith<$R, EkkloMedia, EkkloMedia>>
  get media;
  $R call({
    bool? mine,
    EkkloPerson? coach,
    DateTime? createdAt,
    String? caption,
    List<EkkloMedia>? media,
  });
  ChatViewerReadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatViewerReadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatViewerRead, $Out>
    implements ChatViewerReadCopyWith<$R, ChatViewerRead, $Out> {
  _ChatViewerReadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatViewerRead> $mapper =
      ChatViewerReadMapper.ensureInitialized();
  @override
  EkkloPersonCopyWith<$R, EkkloPerson, EkkloPerson>? get coach =>
      $value.coach?.copyWith.$chain((v) => call(coach: v));
  @override
  ListCopyWith<$R, EkkloMedia, EkkloMediaCopyWith<$R, EkkloMedia, EkkloMedia>>
  get media => ListCopyWith(
    $value.media,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(media: v),
  );
  @override
  $R call({
    bool? mine,
    Object? coach = $none,
    DateTime? createdAt,
    String? caption,
    List<EkkloMedia>? media,
  }) => $apply(
    FieldCopyWithData({
      if (mine != null) #mine: mine,
      if (coach != $none) #coach: coach,
      if (createdAt != null) #createdAt: createdAt,
      if (caption != null) #caption: caption,
      if (media != null) #media: media,
    }),
  );
  @override
  ChatViewerRead $make(CopyWithData data) => ChatViewerRead(
    mine: data.get(#mine, or: $value.mine),
    coach: data.get(#coach, or: $value.coach),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    caption: data.get(#caption, or: $value.caption),
    media: data.get(#media, or: $value.media),
  );

  @override
  ChatViewerReadCopyWith<$R2, ChatViewerRead, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatViewerReadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

