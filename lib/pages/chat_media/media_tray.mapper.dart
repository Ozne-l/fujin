// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'media_tray.dart';

class MediaTrayMapper extends ClassMapperBase<MediaTray> {
  MediaTrayMapper._();

  static MediaTrayMapper? _instance;
  static MediaTrayMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MediaTrayMapper._());
      EditedMediaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MediaTray';

  static List<EditedMedia> _$media(MediaTray v) => v.media;
  static const Field<MediaTray, List<EditedMedia>> _f$media = Field(
    'media',
    _$media,
    opt: true,
    def: const [],
  );
  static int _$selected(MediaTray v) => v.selected;
  static const Field<MediaTray, int> _f$selected = Field(
    'selected',
    _$selected,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<MediaTray> fields = const {
    #media: _f$media,
    #selected: _f$selected,
  };
  @override
  final bool ignoreNull = true;

  static MediaTray _instantiate(DecodingData data) {
    return MediaTray(
      media: data.dec(_f$media),
      selected: data.dec(_f$selected),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MediaTray fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MediaTray>(map);
  }

  static MediaTray fromJson(String json) {
    return ensureInitialized().decodeJson<MediaTray>(json);
  }
}

mixin MediaTrayMappable {
  String toJson() {
    return MediaTrayMapper.ensureInitialized().encodeJson<MediaTray>(
      this as MediaTray,
    );
  }

  Map<String, dynamic> toMap() {
    return MediaTrayMapper.ensureInitialized().encodeMap<MediaTray>(
      this as MediaTray,
    );
  }

  MediaTrayCopyWith<MediaTray, MediaTray, MediaTray> get copyWith =>
      _MediaTrayCopyWithImpl<MediaTray, MediaTray>(
        this as MediaTray,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MediaTrayMapper.ensureInitialized().stringifyValue(
      this as MediaTray,
    );
  }

  @override
  bool operator ==(Object other) {
    return MediaTrayMapper.ensureInitialized().equalsValue(
      this as MediaTray,
      other,
    );
  }

  @override
  int get hashCode {
    return MediaTrayMapper.ensureInitialized().hashValue(this as MediaTray);
  }
}

extension MediaTrayValueCopy<$R, $Out> on ObjectCopyWith<$R, MediaTray, $Out> {
  MediaTrayCopyWith<$R, MediaTray, $Out> get $asMediaTray =>
      $base.as((v, t, t2) => _MediaTrayCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MediaTrayCopyWith<$R, $In extends MediaTray, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    EditedMedia,
    EditedMediaCopyWith<$R, EditedMedia, EditedMedia>
  >
  get media;
  $R call({List<EditedMedia>? media, int? selected});
  MediaTrayCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MediaTrayCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MediaTray, $Out>
    implements MediaTrayCopyWith<$R, MediaTray, $Out> {
  _MediaTrayCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MediaTray> $mapper =
      MediaTrayMapper.ensureInitialized();
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
  $R call({List<EditedMedia>? media, int? selected}) => $apply(
    FieldCopyWithData({
      if (media != null) #media: media,
      if (selected != null) #selected: selected,
    }),
  );
  @override
  MediaTray $make(CopyWithData data) => MediaTray(
    media: data.get(#media, or: $value.media),
    selected: data.get(#selected, or: $value.selected),
  );

  @override
  MediaTrayCopyWith<$R2, MediaTray, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MediaTrayCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

