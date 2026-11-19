// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_probe.dart';

class VideoProbeMapper extends ClassMapperBase<VideoProbe> {
  VideoProbeMapper._();

  static VideoProbeMapper? _instance;
  static VideoProbeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoProbeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VideoProbe';

  static int _$uprightWidth(VideoProbe v) => v.uprightWidth;
  static const Field<VideoProbe, int> _f$uprightWidth = Field(
    'uprightWidth',
    _$uprightWidth,
    key: r'upright_width',
  );
  static int _$uprightHeight(VideoProbe v) => v.uprightHeight;
  static const Field<VideoProbe, int> _f$uprightHeight = Field(
    'uprightHeight',
    _$uprightHeight,
    key: r'upright_height',
  );
  static int _$rotation(VideoProbe v) => v.rotation;
  static const Field<VideoProbe, int> _f$rotation = Field(
    'rotation',
    _$rotation,
  );
  static Duration _$duration(VideoProbe v) => v.duration;
  static const Field<VideoProbe, Duration> _f$duration = Field(
    'duration',
    _$duration,
    key: r'duration_ms',
    hook: MillisecondsHook(),
  );
  static bool _$hdr(VideoProbe v) => v.hdr;
  static const Field<VideoProbe, bool> _f$hdr = Field('hdr', _$hdr);

  @override
  final MappableFields<VideoProbe> fields = const {
    #uprightWidth: _f$uprightWidth,
    #uprightHeight: _f$uprightHeight,
    #rotation: _f$rotation,
    #duration: _f$duration,
    #hdr: _f$hdr,
  };
  @override
  final bool ignoreNull = true;

  static VideoProbe _instantiate(DecodingData data) {
    return VideoProbe(
      uprightWidth: data.dec(_f$uprightWidth),
      uprightHeight: data.dec(_f$uprightHeight),
      rotation: data.dec(_f$rotation),
      duration: data.dec(_f$duration),
      hdr: data.dec(_f$hdr),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VideoProbe fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideoProbe>(map);
  }

  static VideoProbe fromJson(String json) {
    return ensureInitialized().decodeJson<VideoProbe>(json);
  }
}

mixin VideoProbeMappable {
  String toJson() {
    return VideoProbeMapper.ensureInitialized().encodeJson<VideoProbe>(
      this as VideoProbe,
    );
  }

  Map<String, dynamic> toMap() {
    return VideoProbeMapper.ensureInitialized().encodeMap<VideoProbe>(
      this as VideoProbe,
    );
  }

  VideoProbeCopyWith<VideoProbe, VideoProbe, VideoProbe> get copyWith =>
      _VideoProbeCopyWithImpl<VideoProbe, VideoProbe>(
        this as VideoProbe,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideoProbeMapper.ensureInitialized().stringifyValue(
      this as VideoProbe,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideoProbeMapper.ensureInitialized().equalsValue(
      this as VideoProbe,
      other,
    );
  }

  @override
  int get hashCode {
    return VideoProbeMapper.ensureInitialized().hashValue(this as VideoProbe);
  }
}

extension VideoProbeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VideoProbe, $Out> {
  VideoProbeCopyWith<$R, VideoProbe, $Out> get $asVideoProbe =>
      $base.as((v, t, t2) => _VideoProbeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VideoProbeCopyWith<$R, $In extends VideoProbe, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? uprightWidth,
    int? uprightHeight,
    int? rotation,
    Duration? duration,
    bool? hdr,
  });
  VideoProbeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VideoProbeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideoProbe, $Out>
    implements VideoProbeCopyWith<$R, VideoProbe, $Out> {
  _VideoProbeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideoProbe> $mapper =
      VideoProbeMapper.ensureInitialized();
  @override
  $R call({
    int? uprightWidth,
    int? uprightHeight,
    int? rotation,
    Duration? duration,
    bool? hdr,
  }) => $apply(
    FieldCopyWithData({
      if (uprightWidth != null) #uprightWidth: uprightWidth,
      if (uprightHeight != null) #uprightHeight: uprightHeight,
      if (rotation != null) #rotation: rotation,
      if (duration != null) #duration: duration,
      if (hdr != null) #hdr: hdr,
    }),
  );
  @override
  VideoProbe $make(CopyWithData data) => VideoProbe(
    uprightWidth: data.get(#uprightWidth, or: $value.uprightWidth),
    uprightHeight: data.get(#uprightHeight, or: $value.uprightHeight),
    rotation: data.get(#rotation, or: $value.rotation),
    duration: data.get(#duration, or: $value.duration),
    hdr: data.get(#hdr, or: $value.hdr),
  );

  @override
  VideoProbeCopyWith<$R2, VideoProbe, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideoProbeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

