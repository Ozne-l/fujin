// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'media_label.dart';

class MediaLabelMapper extends ClassMapperBase<MediaLabel> {
  MediaLabelMapper._();

  static MediaLabelMapper? _instance;
  static MediaLabelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MediaLabelMapper._());
      PhotosLabelMapper.ensureInitialized();
      VideosLabelMapper.ensureInitialized();
      VoiceLabelMapper.ensureInitialized();
      MixedLabelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MediaLabel';

  @override
  final MappableFields<MediaLabel> fields = const {};
  @override
  final bool ignoreNull = true;

  static MediaLabel _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'MediaLabel',
      'kind',
      '${data.value['kind']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MediaLabel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MediaLabel>(map);
  }

  static MediaLabel fromJson(String json) {
    return ensureInitialized().decodeJson<MediaLabel>(json);
  }
}

mixin MediaLabelMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MediaLabelCopyWith<MediaLabel, MediaLabel, MediaLabel> get copyWith;
}

abstract class MediaLabelCopyWith<$R, $In extends MediaLabel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MediaLabelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class PhotosLabelMapper extends SubClassMapperBase<PhotosLabel> {
  PhotosLabelMapper._();

  static PhotosLabelMapper? _instance;
  static PhotosLabelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhotosLabelMapper._());
      MediaLabelMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'PhotosLabel';

  static int _$count(PhotosLabel v) => v.count;
  static const Field<PhotosLabel, int> _f$count = Field('count', _$count);

  @override
  final MappableFields<PhotosLabel> fields = const {#count: _f$count};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'photos';
  @override
  late final ClassMapperBase superMapper = MediaLabelMapper.ensureInitialized();

  static PhotosLabel _instantiate(DecodingData data) {
    return PhotosLabel(data.dec(_f$count));
  }

  @override
  final Function instantiate = _instantiate;

  static PhotosLabel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhotosLabel>(map);
  }

  static PhotosLabel fromJson(String json) {
    return ensureInitialized().decodeJson<PhotosLabel>(json);
  }
}

mixin PhotosLabelMappable {
  String toJson() {
    return PhotosLabelMapper.ensureInitialized().encodeJson<PhotosLabel>(
      this as PhotosLabel,
    );
  }

  Map<String, dynamic> toMap() {
    return PhotosLabelMapper.ensureInitialized().encodeMap<PhotosLabel>(
      this as PhotosLabel,
    );
  }

  PhotosLabelCopyWith<PhotosLabel, PhotosLabel, PhotosLabel> get copyWith =>
      _PhotosLabelCopyWithImpl<PhotosLabel, PhotosLabel>(
        this as PhotosLabel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhotosLabelMapper.ensureInitialized().stringifyValue(
      this as PhotosLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhotosLabelMapper.ensureInitialized().equalsValue(
      this as PhotosLabel,
      other,
    );
  }

  @override
  int get hashCode {
    return PhotosLabelMapper.ensureInitialized().hashValue(this as PhotosLabel);
  }
}

extension PhotosLabelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhotosLabel, $Out> {
  PhotosLabelCopyWith<$R, PhotosLabel, $Out> get $asPhotosLabel =>
      $base.as((v, t, t2) => _PhotosLabelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhotosLabelCopyWith<$R, $In extends PhotosLabel, $Out>
    implements MediaLabelCopyWith<$R, $In, $Out> {
  @override
  $R call({int? count});
  PhotosLabelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhotosLabelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhotosLabel, $Out>
    implements PhotosLabelCopyWith<$R, PhotosLabel, $Out> {
  _PhotosLabelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhotosLabel> $mapper =
      PhotosLabelMapper.ensureInitialized();
  @override
  $R call({int? count}) =>
      $apply(FieldCopyWithData({if (count != null) #count: count}));
  @override
  PhotosLabel $make(CopyWithData data) =>
      PhotosLabel(data.get(#count, or: $value.count));

  @override
  PhotosLabelCopyWith<$R2, PhotosLabel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhotosLabelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VideosLabelMapper extends SubClassMapperBase<VideosLabel> {
  VideosLabelMapper._();

  static VideosLabelMapper? _instance;
  static VideosLabelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideosLabelMapper._());
      MediaLabelMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VideosLabel';

  static int _$count(VideosLabel v) => v.count;
  static const Field<VideosLabel, int> _f$count = Field('count', _$count);

  @override
  final MappableFields<VideosLabel> fields = const {#count: _f$count};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'videos';
  @override
  late final ClassMapperBase superMapper = MediaLabelMapper.ensureInitialized();

  static VideosLabel _instantiate(DecodingData data) {
    return VideosLabel(data.dec(_f$count));
  }

  @override
  final Function instantiate = _instantiate;

  static VideosLabel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideosLabel>(map);
  }

  static VideosLabel fromJson(String json) {
    return ensureInitialized().decodeJson<VideosLabel>(json);
  }
}

mixin VideosLabelMappable {
  String toJson() {
    return VideosLabelMapper.ensureInitialized().encodeJson<VideosLabel>(
      this as VideosLabel,
    );
  }

  Map<String, dynamic> toMap() {
    return VideosLabelMapper.ensureInitialized().encodeMap<VideosLabel>(
      this as VideosLabel,
    );
  }

  VideosLabelCopyWith<VideosLabel, VideosLabel, VideosLabel> get copyWith =>
      _VideosLabelCopyWithImpl<VideosLabel, VideosLabel>(
        this as VideosLabel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideosLabelMapper.ensureInitialized().stringifyValue(
      this as VideosLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideosLabelMapper.ensureInitialized().equalsValue(
      this as VideosLabel,
      other,
    );
  }

  @override
  int get hashCode {
    return VideosLabelMapper.ensureInitialized().hashValue(this as VideosLabel);
  }
}

extension VideosLabelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VideosLabel, $Out> {
  VideosLabelCopyWith<$R, VideosLabel, $Out> get $asVideosLabel =>
      $base.as((v, t, t2) => _VideosLabelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VideosLabelCopyWith<$R, $In extends VideosLabel, $Out>
    implements MediaLabelCopyWith<$R, $In, $Out> {
  @override
  $R call({int? count});
  VideosLabelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VideosLabelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideosLabel, $Out>
    implements VideosLabelCopyWith<$R, VideosLabel, $Out> {
  _VideosLabelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideosLabel> $mapper =
      VideosLabelMapper.ensureInitialized();
  @override
  $R call({int? count}) =>
      $apply(FieldCopyWithData({if (count != null) #count: count}));
  @override
  VideosLabel $make(CopyWithData data) =>
      VideosLabel(data.get(#count, or: $value.count));

  @override
  VideosLabelCopyWith<$R2, VideosLabel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideosLabelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VoiceLabelMapper extends SubClassMapperBase<VoiceLabel> {
  VoiceLabelMapper._();

  static VoiceLabelMapper? _instance;
  static VoiceLabelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceLabelMapper._());
      MediaLabelMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceLabel';

  @override
  final MappableFields<VoiceLabel> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'voice';
  @override
  late final ClassMapperBase superMapper = MediaLabelMapper.ensureInitialized();

  static VoiceLabel _instantiate(DecodingData data) {
    return VoiceLabel();
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceLabel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceLabel>(map);
  }

  static VoiceLabel fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceLabel>(json);
  }
}

mixin VoiceLabelMappable {
  String toJson() {
    return VoiceLabelMapper.ensureInitialized().encodeJson<VoiceLabel>(
      this as VoiceLabel,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceLabelMapper.ensureInitialized().encodeMap<VoiceLabel>(
      this as VoiceLabel,
    );
  }

  VoiceLabelCopyWith<VoiceLabel, VoiceLabel, VoiceLabel> get copyWith =>
      _VoiceLabelCopyWithImpl<VoiceLabel, VoiceLabel>(
        this as VoiceLabel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VoiceLabelMapper.ensureInitialized().stringifyValue(
      this as VoiceLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceLabelMapper.ensureInitialized().equalsValue(
      this as VoiceLabel,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceLabelMapper.ensureInitialized().hashValue(this as VoiceLabel);
  }
}

extension VoiceLabelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VoiceLabel, $Out> {
  VoiceLabelCopyWith<$R, VoiceLabel, $Out> get $asVoiceLabel =>
      $base.as((v, t, t2) => _VoiceLabelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceLabelCopyWith<$R, $In extends VoiceLabel, $Out>
    implements MediaLabelCopyWith<$R, $In, $Out> {
  @override
  $R call();
  VoiceLabelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoiceLabelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceLabel, $Out>
    implements VoiceLabelCopyWith<$R, VoiceLabel, $Out> {
  _VoiceLabelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceLabel> $mapper =
      VoiceLabelMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  VoiceLabel $make(CopyWithData data) => VoiceLabel();

  @override
  VoiceLabelCopyWith<$R2, VoiceLabel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceLabelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MixedLabelMapper extends SubClassMapperBase<MixedLabel> {
  MixedLabelMapper._();

  static MixedLabelMapper? _instance;
  static MixedLabelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MixedLabelMapper._());
      MediaLabelMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MixedLabel';

  static int? _$count(MixedLabel v) => v.count;
  static const Field<MixedLabel, int> _f$count = Field('count', _$count);

  @override
  final MappableFields<MixedLabel> fields = const {#count: _f$count};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'mixed';
  @override
  late final ClassMapperBase superMapper = MediaLabelMapper.ensureInitialized();

  static MixedLabel _instantiate(DecodingData data) {
    return MixedLabel(data.dec(_f$count));
  }

  @override
  final Function instantiate = _instantiate;

  static MixedLabel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MixedLabel>(map);
  }

  static MixedLabel fromJson(String json) {
    return ensureInitialized().decodeJson<MixedLabel>(json);
  }
}

mixin MixedLabelMappable {
  String toJson() {
    return MixedLabelMapper.ensureInitialized().encodeJson<MixedLabel>(
      this as MixedLabel,
    );
  }

  Map<String, dynamic> toMap() {
    return MixedLabelMapper.ensureInitialized().encodeMap<MixedLabel>(
      this as MixedLabel,
    );
  }

  MixedLabelCopyWith<MixedLabel, MixedLabel, MixedLabel> get copyWith =>
      _MixedLabelCopyWithImpl<MixedLabel, MixedLabel>(
        this as MixedLabel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MixedLabelMapper.ensureInitialized().stringifyValue(
      this as MixedLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    return MixedLabelMapper.ensureInitialized().equalsValue(
      this as MixedLabel,
      other,
    );
  }

  @override
  int get hashCode {
    return MixedLabelMapper.ensureInitialized().hashValue(this as MixedLabel);
  }
}

extension MixedLabelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MixedLabel, $Out> {
  MixedLabelCopyWith<$R, MixedLabel, $Out> get $asMixedLabel =>
      $base.as((v, t, t2) => _MixedLabelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MixedLabelCopyWith<$R, $In extends MixedLabel, $Out>
    implements MediaLabelCopyWith<$R, $In, $Out> {
  @override
  $R call({int? count});
  MixedLabelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MixedLabelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MixedLabel, $Out>
    implements MixedLabelCopyWith<$R, MixedLabel, $Out> {
  _MixedLabelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MixedLabel> $mapper =
      MixedLabelMapper.ensureInitialized();
  @override
  $R call({Object? count = $none}) =>
      $apply(FieldCopyWithData({if (count != $none) #count: count}));
  @override
  MixedLabel $make(CopyWithData data) =>
      MixedLabel(data.get(#count, or: $value.count));

  @override
  MixedLabelCopyWith<$R2, MixedLabel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MixedLabelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

