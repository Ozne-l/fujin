// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_passage.dart';

class VideoPassageMapper extends ClassMapperBase<VideoPassage> {
  VideoPassageMapper._();

  static VideoPassageMapper? _instance;
  static VideoPassageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoPassageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VideoPassage';

  static Duration _$start(VideoPassage v) => v.start;
  static const Field<VideoPassage, Duration> _f$start = Field(
    'start',
    _$start,
    key: r'start_ms',
    hook: MillisecondsHook(),
  );
  static Duration _$end(VideoPassage v) => v.end;
  static const Field<VideoPassage, Duration> _f$end = Field(
    'end',
    _$end,
    key: r'end_ms',
    hook: MillisecondsHook(),
  );

  @override
  final MappableFields<VideoPassage> fields = const {
    #start: _f$start,
    #end: _f$end,
  };
  @override
  final bool ignoreNull = true;

  static VideoPassage _instantiate(DecodingData data) {
    return VideoPassage(start: data.dec(_f$start), end: data.dec(_f$end));
  }

  @override
  final Function instantiate = _instantiate;

  static VideoPassage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideoPassage>(map);
  }

  static VideoPassage fromJson(String json) {
    return ensureInitialized().decodeJson<VideoPassage>(json);
  }
}

mixin VideoPassageMappable {
  String toJson() {
    return VideoPassageMapper.ensureInitialized().encodeJson<VideoPassage>(
      this as VideoPassage,
    );
  }

  Map<String, dynamic> toMap() {
    return VideoPassageMapper.ensureInitialized().encodeMap<VideoPassage>(
      this as VideoPassage,
    );
  }

  VideoPassageCopyWith<VideoPassage, VideoPassage, VideoPassage> get copyWith =>
      _VideoPassageCopyWithImpl<VideoPassage, VideoPassage>(
        this as VideoPassage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideoPassageMapper.ensureInitialized().stringifyValue(
      this as VideoPassage,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideoPassageMapper.ensureInitialized().equalsValue(
      this as VideoPassage,
      other,
    );
  }

  @override
  int get hashCode {
    return VideoPassageMapper.ensureInitialized().hashValue(
      this as VideoPassage,
    );
  }
}

extension VideoPassageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VideoPassage, $Out> {
  VideoPassageCopyWith<$R, VideoPassage, $Out> get $asVideoPassage =>
      $base.as((v, t, t2) => _VideoPassageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VideoPassageCopyWith<$R, $In extends VideoPassage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Duration? start, Duration? end});
  VideoPassageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VideoPassageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideoPassage, $Out>
    implements VideoPassageCopyWith<$R, VideoPassage, $Out> {
  _VideoPassageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideoPassage> $mapper =
      VideoPassageMapper.ensureInitialized();
  @override
  $R call({Duration? start, Duration? end}) => $apply(
    FieldCopyWithData({
      if (start != null) #start: start,
      if (end != null) #end: end,
    }),
  );
  @override
  VideoPassage $make(CopyWithData data) => VideoPassage(
    start: data.get(#start, or: $value.start),
    end: data.get(#end, or: $value.end),
  );

  @override
  VideoPassageCopyWith<$R2, VideoPassage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideoPassageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

