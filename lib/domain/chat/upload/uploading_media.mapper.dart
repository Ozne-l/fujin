// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'uploading_media.dart';

class UploadingMediaMapper extends ClassMapperBase<UploadingMedia> {
  UploadingMediaMapper._();

  static UploadingMediaMapper? _instance;
  static UploadingMediaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadingMediaMapper._());
      ChatMediaKindMapper.ensureInitialized();
      EditedMediaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UploadingMedia';

  static String _$id(UploadingMedia v) => v.id;
  static const Field<UploadingMedia, String> _f$id = Field('id', _$id);
  static ChatMediaKind _$kind(UploadingMedia v) => v.kind;
  static const Field<UploadingMedia, ChatMediaKind> _f$kind = Field(
    'kind',
    _$kind,
  );
  static EditedMedia? _$media(UploadingMedia v) => v.media;
  static const Field<UploadingMedia, EditedMedia> _f$media = Field(
    'media',
    _$media,
    opt: true,
  );
  static int? _$percent(UploadingMedia v) => v.percent;
  static const Field<UploadingMedia, int> _f$percent = Field(
    'percent',
    _$percent,
    opt: true,
  );
  static int? _$originalBytes(UploadingMedia v) => v.originalBytes;
  static const Field<UploadingMedia, int> _f$originalBytes = Field(
    'originalBytes',
    _$originalBytes,
    key: r'original_bytes',
    opt: true,
  );

  @override
  final MappableFields<UploadingMedia> fields = const {
    #id: _f$id,
    #kind: _f$kind,
    #media: _f$media,
    #percent: _f$percent,
    #originalBytes: _f$originalBytes,
  };
  @override
  final bool ignoreNull = true;

  static UploadingMedia _instantiate(DecodingData data) {
    return UploadingMedia(
      id: data.dec(_f$id),
      kind: data.dec(_f$kind),
      media: data.dec(_f$media),
      percent: data.dec(_f$percent),
      originalBytes: data.dec(_f$originalBytes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UploadingMedia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadingMedia>(map);
  }

  static UploadingMedia fromJson(String json) {
    return ensureInitialized().decodeJson<UploadingMedia>(json);
  }
}

mixin UploadingMediaMappable {
  String toJson() {
    return UploadingMediaMapper.ensureInitialized().encodeJson<UploadingMedia>(
      this as UploadingMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return UploadingMediaMapper.ensureInitialized().encodeMap<UploadingMedia>(
      this as UploadingMedia,
    );
  }

  UploadingMediaCopyWith<UploadingMedia, UploadingMedia, UploadingMedia>
  get copyWith => _UploadingMediaCopyWithImpl<UploadingMedia, UploadingMedia>(
    this as UploadingMedia,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UploadingMediaMapper.ensureInitialized().stringifyValue(
      this as UploadingMedia,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadingMediaMapper.ensureInitialized().equalsValue(
      this as UploadingMedia,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadingMediaMapper.ensureInitialized().hashValue(
      this as UploadingMedia,
    );
  }
}

extension UploadingMediaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadingMedia, $Out> {
  UploadingMediaCopyWith<$R, UploadingMedia, $Out> get $asUploadingMedia =>
      $base.as((v, t, t2) => _UploadingMediaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadingMediaCopyWith<$R, $In extends UploadingMedia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EditedMediaCopyWith<$R, EditedMedia, EditedMedia>? get media;
  $R call({
    String? id,
    ChatMediaKind? kind,
    EditedMedia? media,
    int? percent,
    int? originalBytes,
  });
  UploadingMediaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UploadingMediaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadingMedia, $Out>
    implements UploadingMediaCopyWith<$R, UploadingMedia, $Out> {
  _UploadingMediaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadingMedia> $mapper =
      UploadingMediaMapper.ensureInitialized();
  @override
  EditedMediaCopyWith<$R, EditedMedia, EditedMedia>? get media =>
      $value.media?.copyWith.$chain((v) => call(media: v));
  @override
  $R call({
    String? id,
    ChatMediaKind? kind,
    Object? media = $none,
    Object? percent = $none,
    Object? originalBytes = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (kind != null) #kind: kind,
      if (media != $none) #media: media,
      if (percent != $none) #percent: percent,
      if (originalBytes != $none) #originalBytes: originalBytes,
    }),
  );
  @override
  UploadingMedia $make(CopyWithData data) => UploadingMedia(
    id: data.get(#id, or: $value.id),
    kind: data.get(#kind, or: $value.kind),
    media: data.get(#media, or: $value.media),
    percent: data.get(#percent, or: $value.percent),
    originalBytes: data.get(#originalBytes, or: $value.originalBytes),
  );

  @override
  UploadingMediaCopyWith<$R2, UploadingMedia, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadingMediaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

