// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_export_request.dart';

class VideoExportRequestMapper extends ClassMapperBase<VideoExportRequest> {
  VideoExportRequestMapper._();

  static VideoExportRequestMapper? _instance;
  static VideoExportRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoExportRequestMapper._());
      KeptPassageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VideoExportRequest';

  static String _$source(VideoExportRequest v) => v.source;
  static const Field<VideoExportRequest, String> _f$source = Field(
    'source',
    _$source,
  );
  static String _$output(VideoExportRequest v) => v.output;
  static const Field<VideoExportRequest, String> _f$output = Field(
    'output',
    _$output,
  );
  static String _$poster(VideoExportRequest v) => v.poster;
  static const Field<VideoExportRequest, String> _f$poster = Field(
    'poster',
    _$poster,
  );
  static List<KeptPassage> _$passages(VideoExportRequest v) => v.passages;
  static const Field<VideoExportRequest, List<KeptPassage>> _f$passages = Field(
    'passages',
    _$passages,
    opt: true,
    def: const [],
  );
  static Rect? _$crop(VideoExportRequest v) => v.crop;
  static const Field<VideoExportRequest, Rect> _f$crop = Field(
    'crop',
    _$crop,
    opt: true,
    hook: RectHook(),
  );
  static bool _$muted(VideoExportRequest v) => v.muted;
  static const Field<VideoExportRequest, bool> _f$muted = Field(
    'muted',
    _$muted,
    opt: true,
    def: false,
  );
  static String? _$recipient(VideoExportRequest v) => v.recipient;
  static const Field<VideoExportRequest, String> _f$recipient = Field(
    'recipient',
    _$recipient,
    opt: true,
  );
  static int _$position(VideoExportRequest v) => v.position;
  static const Field<VideoExportRequest, int> _f$position = Field(
    'position',
    _$position,
    opt: true,
    def: 1,
  );
  static int _$count(VideoExportRequest v) => v.count;
  static const Field<VideoExportRequest, int> _f$count = Field(
    'count',
    _$count,
    opt: true,
    def: 1,
  );

  @override
  final MappableFields<VideoExportRequest> fields = const {
    #source: _f$source,
    #output: _f$output,
    #poster: _f$poster,
    #passages: _f$passages,
    #crop: _f$crop,
    #muted: _f$muted,
    #recipient: _f$recipient,
    #position: _f$position,
    #count: _f$count,
  };
  @override
  final bool ignoreNull = true;

  static VideoExportRequest _instantiate(DecodingData data) {
    return VideoExportRequest(
      source: data.dec(_f$source),
      output: data.dec(_f$output),
      poster: data.dec(_f$poster),
      passages: data.dec(_f$passages),
      crop: data.dec(_f$crop),
      muted: data.dec(_f$muted),
      recipient: data.dec(_f$recipient),
      position: data.dec(_f$position),
      count: data.dec(_f$count),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VideoExportRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideoExportRequest>(map);
  }

  static VideoExportRequest fromJson(String json) {
    return ensureInitialized().decodeJson<VideoExportRequest>(json);
  }
}

mixin VideoExportRequestMappable {
  String toJson() {
    return VideoExportRequestMapper.ensureInitialized()
        .encodeJson<VideoExportRequest>(this as VideoExportRequest);
  }

  Map<String, dynamic> toMap() {
    return VideoExportRequestMapper.ensureInitialized()
        .encodeMap<VideoExportRequest>(this as VideoExportRequest);
  }

  VideoExportRequestCopyWith<
    VideoExportRequest,
    VideoExportRequest,
    VideoExportRequest
  >
  get copyWith =>
      _VideoExportRequestCopyWithImpl<VideoExportRequest, VideoExportRequest>(
        this as VideoExportRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideoExportRequestMapper.ensureInitialized().stringifyValue(
      this as VideoExportRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideoExportRequestMapper.ensureInitialized().equalsValue(
      this as VideoExportRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return VideoExportRequestMapper.ensureInitialized().hashValue(
      this as VideoExportRequest,
    );
  }
}

extension VideoExportRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VideoExportRequest, $Out> {
  VideoExportRequestCopyWith<$R, VideoExportRequest, $Out>
  get $asVideoExportRequest => $base.as(
    (v, t, t2) => _VideoExportRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VideoExportRequestCopyWith<
  $R,
  $In extends VideoExportRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    KeptPassage,
    KeptPassageCopyWith<$R, KeptPassage, KeptPassage>
  >
  get passages;
  $R call({
    String? source,
    String? output,
    String? poster,
    List<KeptPassage>? passages,
    Rect? crop,
    bool? muted,
    String? recipient,
    int? position,
    int? count,
  });
  VideoExportRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VideoExportRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideoExportRequest, $Out>
    implements VideoExportRequestCopyWith<$R, VideoExportRequest, $Out> {
  _VideoExportRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideoExportRequest> $mapper =
      VideoExportRequestMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    KeptPassage,
    KeptPassageCopyWith<$R, KeptPassage, KeptPassage>
  >
  get passages => ListCopyWith(
    $value.passages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(passages: v),
  );
  @override
  $R call({
    String? source,
    String? output,
    String? poster,
    List<KeptPassage>? passages,
    Object? crop = $none,
    bool? muted,
    Object? recipient = $none,
    int? position,
    int? count,
  }) => $apply(
    FieldCopyWithData({
      if (source != null) #source: source,
      if (output != null) #output: output,
      if (poster != null) #poster: poster,
      if (passages != null) #passages: passages,
      if (crop != $none) #crop: crop,
      if (muted != null) #muted: muted,
      if (recipient != $none) #recipient: recipient,
      if (position != null) #position: position,
      if (count != null) #count: count,
    }),
  );
  @override
  VideoExportRequest $make(CopyWithData data) => VideoExportRequest(
    source: data.get(#source, or: $value.source),
    output: data.get(#output, or: $value.output),
    poster: data.get(#poster, or: $value.poster),
    passages: data.get(#passages, or: $value.passages),
    crop: data.get(#crop, or: $value.crop),
    muted: data.get(#muted, or: $value.muted),
    recipient: data.get(#recipient, or: $value.recipient),
    position: data.get(#position, or: $value.position),
    count: data.get(#count, or: $value.count),
  );

  @override
  VideoExportRequestCopyWith<$R2, VideoExportRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideoExportRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

