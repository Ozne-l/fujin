// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'exported_video.dart';

class ExportedVideoMapper extends ClassMapperBase<ExportedVideo> {
  ExportedVideoMapper._();

  static ExportedVideoMapper? _instance;
  static ExportedVideoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExportedVideoMapper._());
      VideoOutcomeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExportedVideo';

  static String _$path(ExportedVideo v) => v.path;
  static const Field<ExportedVideo, String> _f$path = Field('path', _$path);
  static int _$bytes(ExportedVideo v) => v.bytes;
  static const Field<ExportedVideo, int> _f$bytes = Field('bytes', _$bytes);
  static Duration _$duration(ExportedVideo v) => v.duration;
  static const Field<ExportedVideo, Duration> _f$duration = Field(
    'duration',
    _$duration,
    key: r'duration_ms',
    hook: MillisecondsHook(),
  );
  static int _$uprightWidth(ExportedVideo v) => v.uprightWidth;
  static const Field<ExportedVideo, int> _f$uprightWidth = Field(
    'uprightWidth',
    _$uprightWidth,
    key: r'upright_width',
  );
  static int _$uprightHeight(ExportedVideo v) => v.uprightHeight;
  static const Field<ExportedVideo, int> _f$uprightHeight = Field(
    'uprightHeight',
    _$uprightHeight,
    key: r'upright_height',
  );
  static VideoOutcome _$outcome(ExportedVideo v) => v.outcome;
  static const Field<ExportedVideo, VideoOutcome> _f$outcome = Field(
    'outcome',
    _$outcome,
  );
  static String? _$poster(ExportedVideo v) => v.poster;
  static const Field<ExportedVideo, String> _f$poster = Field(
    'poster',
    _$poster,
    opt: true,
  );

  @override
  final MappableFields<ExportedVideo> fields = const {
    #path: _f$path,
    #bytes: _f$bytes,
    #duration: _f$duration,
    #uprightWidth: _f$uprightWidth,
    #uprightHeight: _f$uprightHeight,
    #outcome: _f$outcome,
    #poster: _f$poster,
  };
  @override
  final bool ignoreNull = true;

  static ExportedVideo _instantiate(DecodingData data) {
    return ExportedVideo(
      path: data.dec(_f$path),
      bytes: data.dec(_f$bytes),
      duration: data.dec(_f$duration),
      uprightWidth: data.dec(_f$uprightWidth),
      uprightHeight: data.dec(_f$uprightHeight),
      outcome: data.dec(_f$outcome),
      poster: data.dec(_f$poster),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExportedVideo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExportedVideo>(map);
  }

  static ExportedVideo fromJson(String json) {
    return ensureInitialized().decodeJson<ExportedVideo>(json);
  }
}

mixin ExportedVideoMappable {
  String toJson() {
    return ExportedVideoMapper.ensureInitialized().encodeJson<ExportedVideo>(
      this as ExportedVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return ExportedVideoMapper.ensureInitialized().encodeMap<ExportedVideo>(
      this as ExportedVideo,
    );
  }

  ExportedVideoCopyWith<ExportedVideo, ExportedVideo, ExportedVideo>
  get copyWith => _ExportedVideoCopyWithImpl<ExportedVideo, ExportedVideo>(
    this as ExportedVideo,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ExportedVideoMapper.ensureInitialized().stringifyValue(
      this as ExportedVideo,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExportedVideoMapper.ensureInitialized().equalsValue(
      this as ExportedVideo,
      other,
    );
  }

  @override
  int get hashCode {
    return ExportedVideoMapper.ensureInitialized().hashValue(
      this as ExportedVideo,
    );
  }
}

extension ExportedVideoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExportedVideo, $Out> {
  ExportedVideoCopyWith<$R, ExportedVideo, $Out> get $asExportedVideo =>
      $base.as((v, t, t2) => _ExportedVideoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExportedVideoCopyWith<$R, $In extends ExportedVideo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? path,
    int? bytes,
    Duration? duration,
    int? uprightWidth,
    int? uprightHeight,
    VideoOutcome? outcome,
    String? poster,
  });
  ExportedVideoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExportedVideoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExportedVideo, $Out>
    implements ExportedVideoCopyWith<$R, ExportedVideo, $Out> {
  _ExportedVideoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExportedVideo> $mapper =
      ExportedVideoMapper.ensureInitialized();
  @override
  $R call({
    String? path,
    int? bytes,
    Duration? duration,
    int? uprightWidth,
    int? uprightHeight,
    VideoOutcome? outcome,
    Object? poster = $none,
  }) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (bytes != null) #bytes: bytes,
      if (duration != null) #duration: duration,
      if (uprightWidth != null) #uprightWidth: uprightWidth,
      if (uprightHeight != null) #uprightHeight: uprightHeight,
      if (outcome != null) #outcome: outcome,
      if (poster != $none) #poster: poster,
    }),
  );
  @override
  ExportedVideo $make(CopyWithData data) => ExportedVideo(
    path: data.get(#path, or: $value.path),
    bytes: data.get(#bytes, or: $value.bytes),
    duration: data.get(#duration, or: $value.duration),
    uprightWidth: data.get(#uprightWidth, or: $value.uprightWidth),
    uprightHeight: data.get(#uprightHeight, or: $value.uprightHeight),
    outcome: data.get(#outcome, or: $value.outcome),
    poster: data.get(#poster, or: $value.poster),
  );

  @override
  ExportedVideoCopyWith<$R2, ExportedVideo, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExportedVideoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

