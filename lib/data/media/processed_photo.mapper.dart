// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'processed_photo.dart';

class ProcessedPhotoMapper extends ClassMapperBase<ProcessedPhoto> {
  ProcessedPhotoMapper._();

  static ProcessedPhotoMapper? _instance;
  static ProcessedPhotoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProcessedPhotoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProcessedPhoto';

  static String _$path(ProcessedPhoto v) => v.path;
  static const Field<ProcessedPhoto, String> _f$path = Field('path', _$path);
  static int _$width(ProcessedPhoto v) => v.width;
  static const Field<ProcessedPhoto, int> _f$width = Field('width', _$width);
  static int _$height(ProcessedPhoto v) => v.height;
  static const Field<ProcessedPhoto, int> _f$height = Field('height', _$height);
  static int _$bytes(ProcessedPhoto v) => v.bytes;
  static const Field<ProcessedPhoto, int> _f$bytes = Field('bytes', _$bytes);

  @override
  final MappableFields<ProcessedPhoto> fields = const {
    #path: _f$path,
    #width: _f$width,
    #height: _f$height,
    #bytes: _f$bytes,
  };
  @override
  final bool ignoreNull = true;

  static ProcessedPhoto _instantiate(DecodingData data) {
    return ProcessedPhoto(
      path: data.dec(_f$path),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      bytes: data.dec(_f$bytes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProcessedPhoto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProcessedPhoto>(map);
  }

  static ProcessedPhoto fromJson(String json) {
    return ensureInitialized().decodeJson<ProcessedPhoto>(json);
  }
}

mixin ProcessedPhotoMappable {
  String toJson() {
    return ProcessedPhotoMapper.ensureInitialized().encodeJson<ProcessedPhoto>(
      this as ProcessedPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return ProcessedPhotoMapper.ensureInitialized().encodeMap<ProcessedPhoto>(
      this as ProcessedPhoto,
    );
  }

  ProcessedPhotoCopyWith<ProcessedPhoto, ProcessedPhoto, ProcessedPhoto>
  get copyWith => _ProcessedPhotoCopyWithImpl<ProcessedPhoto, ProcessedPhoto>(
    this as ProcessedPhoto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ProcessedPhotoMapper.ensureInitialized().stringifyValue(
      this as ProcessedPhoto,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProcessedPhotoMapper.ensureInitialized().equalsValue(
      this as ProcessedPhoto,
      other,
    );
  }

  @override
  int get hashCode {
    return ProcessedPhotoMapper.ensureInitialized().hashValue(
      this as ProcessedPhoto,
    );
  }
}

extension ProcessedPhotoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProcessedPhoto, $Out> {
  ProcessedPhotoCopyWith<$R, ProcessedPhoto, $Out> get $asProcessedPhoto =>
      $base.as((v, t, t2) => _ProcessedPhotoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProcessedPhotoCopyWith<$R, $In extends ProcessedPhoto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? path, int? width, int? height, int? bytes});
  ProcessedPhotoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProcessedPhotoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProcessedPhoto, $Out>
    implements ProcessedPhotoCopyWith<$R, ProcessedPhoto, $Out> {
  _ProcessedPhotoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProcessedPhoto> $mapper =
      ProcessedPhotoMapper.ensureInitialized();
  @override
  $R call({String? path, int? width, int? height, int? bytes}) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (width != null) #width: width,
      if (height != null) #height: height,
      if (bytes != null) #bytes: bytes,
    }),
  );
  @override
  ProcessedPhoto $make(CopyWithData data) => ProcessedPhoto(
    path: data.get(#path, or: $value.path),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    bytes: data.get(#bytes, or: $value.bytes),
  );

  @override
  ProcessedPhotoCopyWith<$R2, ProcessedPhoto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProcessedPhotoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

