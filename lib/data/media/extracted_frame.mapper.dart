// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'extracted_frame.dart';

class ExtractedFrameMapper extends ClassMapperBase<ExtractedFrame> {
  ExtractedFrameMapper._();

  static ExtractedFrameMapper? _instance;
  static ExtractedFrameMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExtractedFrameMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ExtractedFrame';

  static String _$path(ExtractedFrame v) => v.path;
  static const Field<ExtractedFrame, String> _f$path = Field('path', _$path);
  static int _$width(ExtractedFrame v) => v.width;
  static const Field<ExtractedFrame, int> _f$width = Field('width', _$width);
  static int _$height(ExtractedFrame v) => v.height;
  static const Field<ExtractedFrame, int> _f$height = Field('height', _$height);

  @override
  final MappableFields<ExtractedFrame> fields = const {
    #path: _f$path,
    #width: _f$width,
    #height: _f$height,
  };
  @override
  final bool ignoreNull = true;

  static ExtractedFrame _instantiate(DecodingData data) {
    return ExtractedFrame(
      path: data.dec(_f$path),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExtractedFrame fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExtractedFrame>(map);
  }

  static ExtractedFrame fromJson(String json) {
    return ensureInitialized().decodeJson<ExtractedFrame>(json);
  }
}

mixin ExtractedFrameMappable {
  String toJson() {
    return ExtractedFrameMapper.ensureInitialized().encodeJson<ExtractedFrame>(
      this as ExtractedFrame,
    );
  }

  Map<String, dynamic> toMap() {
    return ExtractedFrameMapper.ensureInitialized().encodeMap<ExtractedFrame>(
      this as ExtractedFrame,
    );
  }

  ExtractedFrameCopyWith<ExtractedFrame, ExtractedFrame, ExtractedFrame>
  get copyWith => _ExtractedFrameCopyWithImpl<ExtractedFrame, ExtractedFrame>(
    this as ExtractedFrame,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ExtractedFrameMapper.ensureInitialized().stringifyValue(
      this as ExtractedFrame,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExtractedFrameMapper.ensureInitialized().equalsValue(
      this as ExtractedFrame,
      other,
    );
  }

  @override
  int get hashCode {
    return ExtractedFrameMapper.ensureInitialized().hashValue(
      this as ExtractedFrame,
    );
  }
}

extension ExtractedFrameValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExtractedFrame, $Out> {
  ExtractedFrameCopyWith<$R, ExtractedFrame, $Out> get $asExtractedFrame =>
      $base.as((v, t, t2) => _ExtractedFrameCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExtractedFrameCopyWith<$R, $In extends ExtractedFrame, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? path, int? width, int? height});
  ExtractedFrameCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExtractedFrameCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExtractedFrame, $Out>
    implements ExtractedFrameCopyWith<$R, ExtractedFrame, $Out> {
  _ExtractedFrameCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExtractedFrame> $mapper =
      ExtractedFrameMapper.ensureInitialized();
  @override
  $R call({String? path, int? width, int? height}) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (width != null) #width: width,
      if (height != null) #height: height,
    }),
  );
  @override
  ExtractedFrame $make(CopyWithData data) => ExtractedFrame(
    path: data.get(#path, or: $value.path),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
  );

  @override
  ExtractedFrameCopyWith<$R2, ExtractedFrame, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExtractedFrameCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

