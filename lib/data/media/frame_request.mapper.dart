// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'frame_request.dart';

class FrameRequestMapper extends ClassMapperBase<FrameRequest> {
  FrameRequestMapper._();

  static FrameRequestMapper? _instance;
  static FrameRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FrameRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FrameRequest';

  static String _$source(FrameRequest v) => v.source;
  static const Field<FrameRequest, String> _f$source = Field(
    'source',
    _$source,
  );
  static String _$output(FrameRequest v) => v.output;
  static const Field<FrameRequest, String> _f$output = Field(
    'output',
    _$output,
  );
  static Duration _$at(FrameRequest v) => v.at;
  static const Field<FrameRequest, Duration> _f$at = Field(
    'at',
    _$at,
    key: r'at_ms',
    hook: MillisecondsHook(),
  );
  static int _$maxSize(FrameRequest v) => v.maxSize;
  static const Field<FrameRequest, int> _f$maxSize = Field(
    'maxSize',
    _$maxSize,
    key: r'max_size',
  );

  @override
  final MappableFields<FrameRequest> fields = const {
    #source: _f$source,
    #output: _f$output,
    #at: _f$at,
    #maxSize: _f$maxSize,
  };
  @override
  final bool ignoreNull = true;

  static FrameRequest _instantiate(DecodingData data) {
    return FrameRequest(
      source: data.dec(_f$source),
      output: data.dec(_f$output),
      at: data.dec(_f$at),
      maxSize: data.dec(_f$maxSize),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FrameRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FrameRequest>(map);
  }

  static FrameRequest fromJson(String json) {
    return ensureInitialized().decodeJson<FrameRequest>(json);
  }
}

mixin FrameRequestMappable {
  String toJson() {
    return FrameRequestMapper.ensureInitialized().encodeJson<FrameRequest>(
      this as FrameRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return FrameRequestMapper.ensureInitialized().encodeMap<FrameRequest>(
      this as FrameRequest,
    );
  }

  FrameRequestCopyWith<FrameRequest, FrameRequest, FrameRequest> get copyWith =>
      _FrameRequestCopyWithImpl<FrameRequest, FrameRequest>(
        this as FrameRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FrameRequestMapper.ensureInitialized().stringifyValue(
      this as FrameRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return FrameRequestMapper.ensureInitialized().equalsValue(
      this as FrameRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return FrameRequestMapper.ensureInitialized().hashValue(
      this as FrameRequest,
    );
  }
}

extension FrameRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FrameRequest, $Out> {
  FrameRequestCopyWith<$R, FrameRequest, $Out> get $asFrameRequest =>
      $base.as((v, t, t2) => _FrameRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FrameRequestCopyWith<$R, $In extends FrameRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? source, String? output, Duration? at, int? maxSize});
  FrameRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FrameRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FrameRequest, $Out>
    implements FrameRequestCopyWith<$R, FrameRequest, $Out> {
  _FrameRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FrameRequest> $mapper =
      FrameRequestMapper.ensureInitialized();
  @override
  $R call({String? source, String? output, Duration? at, int? maxSize}) =>
      $apply(
        FieldCopyWithData({
          if (source != null) #source: source,
          if (output != null) #output: output,
          if (at != null) #at: at,
          if (maxSize != null) #maxSize: maxSize,
        }),
      );
  @override
  FrameRequest $make(CopyWithData data) => FrameRequest(
    source: data.get(#source, or: $value.source),
    output: data.get(#output, or: $value.output),
    at: data.get(#at, or: $value.at),
    maxSize: data.get(#maxSize, or: $value.maxSize),
  );

  @override
  FrameRequestCopyWith<$R2, FrameRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FrameRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

