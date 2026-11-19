// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_edit.dart';

class VideoEditMapper extends ClassMapperBase<VideoEdit> {
  VideoEditMapper._();

  static VideoEditMapper? _instance;
  static VideoEditMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoEditMapper._());
      VideoPassageMapper.ensureInitialized();
      CropAspectMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VideoEdit';

  static Duration _$duration(VideoEdit v) => v.duration;
  static const Field<VideoEdit, Duration> _f$duration = Field(
    'duration',
    _$duration,
    key: r'duration_ms',
    hook: MillisecondsHook(),
  );
  static Duration _$start(VideoEdit v) => v.start;
  static const Field<VideoEdit, Duration> _f$start = Field(
    'start',
    _$start,
    key: r'start_ms',
    hook: MillisecondsHook(),
  );
  static Duration _$end(VideoEdit v) => v.end;
  static const Field<VideoEdit, Duration> _f$end = Field(
    'end',
    _$end,
    key: r'end_ms',
    hook: MillisecondsHook(),
  );
  static List<VideoPassage> _$removed(VideoEdit v) => v.removed;
  static const Field<VideoEdit, List<VideoPassage>> _f$removed = Field(
    'removed',
    _$removed,
    opt: true,
    def: const [],
  );
  static Rect? _$crop(VideoEdit v) => v.crop;
  static const Field<VideoEdit, Rect> _f$crop = Field(
    'crop',
    _$crop,
    opt: true,
    hook: RectHook(),
  );
  static CropAspect _$aspect(VideoEdit v) => v.aspect;
  static const Field<VideoEdit, CropAspect> _f$aspect = Field(
    'aspect',
    _$aspect,
    opt: true,
    def: CropAspect.free,
  );
  static bool _$muted(VideoEdit v) => v.muted;
  static const Field<VideoEdit, bool> _f$muted = Field(
    'muted',
    _$muted,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<VideoEdit> fields = const {
    #duration: _f$duration,
    #start: _f$start,
    #end: _f$end,
    #removed: _f$removed,
    #crop: _f$crop,
    #aspect: _f$aspect,
    #muted: _f$muted,
  };
  @override
  final bool ignoreNull = true;

  static VideoEdit _instantiate(DecodingData data) {
    return VideoEdit(
      duration: data.dec(_f$duration),
      start: data.dec(_f$start),
      end: data.dec(_f$end),
      removed: data.dec(_f$removed),
      crop: data.dec(_f$crop),
      aspect: data.dec(_f$aspect),
      muted: data.dec(_f$muted),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VideoEdit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideoEdit>(map);
  }

  static VideoEdit fromJson(String json) {
    return ensureInitialized().decodeJson<VideoEdit>(json);
  }
}

mixin VideoEditMappable {
  String toJson() {
    return VideoEditMapper.ensureInitialized().encodeJson<VideoEdit>(
      this as VideoEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return VideoEditMapper.ensureInitialized().encodeMap<VideoEdit>(
      this as VideoEdit,
    );
  }

  VideoEditCopyWith<VideoEdit, VideoEdit, VideoEdit> get copyWith =>
      _VideoEditCopyWithImpl<VideoEdit, VideoEdit>(
        this as VideoEdit,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideoEditMapper.ensureInitialized().stringifyValue(
      this as VideoEdit,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideoEditMapper.ensureInitialized().equalsValue(
      this as VideoEdit,
      other,
    );
  }

  @override
  int get hashCode {
    return VideoEditMapper.ensureInitialized().hashValue(this as VideoEdit);
  }
}

extension VideoEditValueCopy<$R, $Out> on ObjectCopyWith<$R, VideoEdit, $Out> {
  VideoEditCopyWith<$R, VideoEdit, $Out> get $asVideoEdit =>
      $base.as((v, t, t2) => _VideoEditCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VideoEditCopyWith<$R, $In extends VideoEdit, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    VideoPassage,
    VideoPassageCopyWith<$R, VideoPassage, VideoPassage>
  >
  get removed;
  $R call({
    Duration? duration,
    Duration? start,
    Duration? end,
    List<VideoPassage>? removed,
    Rect? crop,
    CropAspect? aspect,
    bool? muted,
  });
  VideoEditCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VideoEditCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideoEdit, $Out>
    implements VideoEditCopyWith<$R, VideoEdit, $Out> {
  _VideoEditCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideoEdit> $mapper =
      VideoEditMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    VideoPassage,
    VideoPassageCopyWith<$R, VideoPassage, VideoPassage>
  >
  get removed => ListCopyWith(
    $value.removed,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(removed: v),
  );
  @override
  $R call({
    Duration? duration,
    Duration? start,
    Duration? end,
    List<VideoPassage>? removed,
    Object? crop = $none,
    CropAspect? aspect,
    bool? muted,
  }) => $apply(
    FieldCopyWithData({
      if (duration != null) #duration: duration,
      if (start != null) #start: start,
      if (end != null) #end: end,
      if (removed != null) #removed: removed,
      if (crop != $none) #crop: crop,
      if (aspect != null) #aspect: aspect,
      if (muted != null) #muted: muted,
    }),
  );
  @override
  VideoEdit $make(CopyWithData data) => VideoEdit(
    duration: data.get(#duration, or: $value.duration),
    start: data.get(#start, or: $value.start),
    end: data.get(#end, or: $value.end),
    removed: data.get(#removed, or: $value.removed),
    crop: data.get(#crop, or: $value.crop),
    aspect: data.get(#aspect, or: $value.aspect),
    muted: data.get(#muted, or: $value.muted),
  );

  @override
  VideoEditCopyWith<$R2, VideoEdit, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideoEditCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

