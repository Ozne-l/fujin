// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'media_send.dart';

class MediaSendMapper extends ClassMapperBase<MediaSend> {
  MediaSendMapper._();

  static MediaSendMapper? _instance;
  static MediaSendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MediaSendMapper._());
      EditedMediaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MediaSend';

  static List<EditedMedia> _$media(MediaSend v) => v.media;
  static const Field<MediaSend, List<EditedMedia>> _f$media = Field(
    'media',
    _$media,
  );
  static String _$caption(MediaSend v) => v.caption;
  static const Field<MediaSend, String> _f$caption = Field(
    'caption',
    _$caption,
    opt: true,
    def: '',
  );
  static String? _$replyToId(MediaSend v) => v.replyToId;
  static const Field<MediaSend, String> _f$replyToId = Field(
    'replyToId',
    _$replyToId,
    key: r'reply_to_id',
    opt: true,
  );

  @override
  final MappableFields<MediaSend> fields = const {
    #media: _f$media,
    #caption: _f$caption,
    #replyToId: _f$replyToId,
  };
  @override
  final bool ignoreNull = true;

  static MediaSend _instantiate(DecodingData data) {
    return MediaSend(
      media: data.dec(_f$media),
      caption: data.dec(_f$caption),
      replyToId: data.dec(_f$replyToId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MediaSend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MediaSend>(map);
  }

  static MediaSend fromJson(String json) {
    return ensureInitialized().decodeJson<MediaSend>(json);
  }
}

mixin MediaSendMappable {
  String toJson() {
    return MediaSendMapper.ensureInitialized().encodeJson<MediaSend>(
      this as MediaSend,
    );
  }

  Map<String, dynamic> toMap() {
    return MediaSendMapper.ensureInitialized().encodeMap<MediaSend>(
      this as MediaSend,
    );
  }

  MediaSendCopyWith<MediaSend, MediaSend, MediaSend> get copyWith =>
      _MediaSendCopyWithImpl<MediaSend, MediaSend>(
        this as MediaSend,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MediaSendMapper.ensureInitialized().stringifyValue(
      this as MediaSend,
    );
  }

  @override
  bool operator ==(Object other) {
    return MediaSendMapper.ensureInitialized().equalsValue(
      this as MediaSend,
      other,
    );
  }

  @override
  int get hashCode {
    return MediaSendMapper.ensureInitialized().hashValue(this as MediaSend);
  }
}

extension MediaSendValueCopy<$R, $Out> on ObjectCopyWith<$R, MediaSend, $Out> {
  MediaSendCopyWith<$R, MediaSend, $Out> get $asMediaSend =>
      $base.as((v, t, t2) => _MediaSendCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MediaSendCopyWith<$R, $In extends MediaSend, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    EditedMedia,
    EditedMediaCopyWith<$R, EditedMedia, EditedMedia>
  >
  get media;
  $R call({List<EditedMedia>? media, String? caption, String? replyToId});
  MediaSendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MediaSendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MediaSend, $Out>
    implements MediaSendCopyWith<$R, MediaSend, $Out> {
  _MediaSendCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MediaSend> $mapper =
      MediaSendMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    EditedMedia,
    EditedMediaCopyWith<$R, EditedMedia, EditedMedia>
  >
  get media => ListCopyWith(
    $value.media,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(media: v),
  );
  @override
  $R call({
    List<EditedMedia>? media,
    String? caption,
    Object? replyToId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (media != null) #media: media,
      if (caption != null) #caption: caption,
      if (replyToId != $none) #replyToId: replyToId,
    }),
  );
  @override
  MediaSend $make(CopyWithData data) => MediaSend(
    media: data.get(#media, or: $value.media),
    caption: data.get(#caption, or: $value.caption),
    replyToId: data.get(#replyToId, or: $value.replyToId),
  );

  @override
  MediaSendCopyWith<$R2, MediaSend, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MediaSendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

