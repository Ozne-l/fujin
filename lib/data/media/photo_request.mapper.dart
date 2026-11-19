// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'photo_request.dart';

class PhotoRequestMapper extends ClassMapperBase<PhotoRequest> {
  PhotoRequestMapper._();

  static PhotoRequestMapper? _instance;
  static PhotoRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhotoRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhotoRequest';

  static String _$source(PhotoRequest v) => v.source;
  static const Field<PhotoRequest, String> _f$source = Field(
    'source',
    _$source,
  );
  static String _$output(PhotoRequest v) => v.output;
  static const Field<PhotoRequest, String> _f$output = Field(
    'output',
    _$output,
  );
  static Rect? _$crop(PhotoRequest v) => v.crop;
  static const Field<PhotoRequest, Rect> _f$crop = Field(
    'crop',
    _$crop,
    opt: true,
    hook: RectHook(),
  );
  static int _$quarterTurns(PhotoRequest v) => v.quarterTurns;
  static const Field<PhotoRequest, int> _f$quarterTurns = Field(
    'quarterTurns',
    _$quarterTurns,
    key: r'quarter_turns',
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<PhotoRequest> fields = const {
    #source: _f$source,
    #output: _f$output,
    #crop: _f$crop,
    #quarterTurns: _f$quarterTurns,
  };
  @override
  final bool ignoreNull = true;

  static PhotoRequest _instantiate(DecodingData data) {
    return PhotoRequest(
      source: data.dec(_f$source),
      output: data.dec(_f$output),
      crop: data.dec(_f$crop),
      quarterTurns: data.dec(_f$quarterTurns),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhotoRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhotoRequest>(map);
  }

  static PhotoRequest fromJson(String json) {
    return ensureInitialized().decodeJson<PhotoRequest>(json);
  }
}

mixin PhotoRequestMappable {
  String toJson() {
    return PhotoRequestMapper.ensureInitialized().encodeJson<PhotoRequest>(
      this as PhotoRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return PhotoRequestMapper.ensureInitialized().encodeMap<PhotoRequest>(
      this as PhotoRequest,
    );
  }

  PhotoRequestCopyWith<PhotoRequest, PhotoRequest, PhotoRequest> get copyWith =>
      _PhotoRequestCopyWithImpl<PhotoRequest, PhotoRequest>(
        this as PhotoRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhotoRequestMapper.ensureInitialized().stringifyValue(
      this as PhotoRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhotoRequestMapper.ensureInitialized().equalsValue(
      this as PhotoRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return PhotoRequestMapper.ensureInitialized().hashValue(
      this as PhotoRequest,
    );
  }
}

extension PhotoRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhotoRequest, $Out> {
  PhotoRequestCopyWith<$R, PhotoRequest, $Out> get $asPhotoRequest =>
      $base.as((v, t, t2) => _PhotoRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhotoRequestCopyWith<$R, $In extends PhotoRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? source, String? output, Rect? crop, int? quarterTurns});
  PhotoRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhotoRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhotoRequest, $Out>
    implements PhotoRequestCopyWith<$R, PhotoRequest, $Out> {
  _PhotoRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhotoRequest> $mapper =
      PhotoRequestMapper.ensureInitialized();
  @override
  $R call({
    String? source,
    String? output,
    Object? crop = $none,
    int? quarterTurns,
  }) => $apply(
    FieldCopyWithData({
      if (source != null) #source: source,
      if (output != null) #output: output,
      if (crop != $none) #crop: crop,
      if (quarterTurns != null) #quarterTurns: quarterTurns,
    }),
  );
  @override
  PhotoRequest $make(CopyWithData data) => PhotoRequest(
    source: data.get(#source, or: $value.source),
    output: data.get(#output, or: $value.output),
    crop: data.get(#crop, or: $value.crop),
    quarterTurns: data.get(#quarterTurns, or: $value.quarterTurns),
  );

  @override
  PhotoRequestCopyWith<$R2, PhotoRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhotoRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

