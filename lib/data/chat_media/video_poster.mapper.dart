// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_poster.dart';

class VideoPosterMapper extends ClassMapperBase<VideoPoster> {
  VideoPosterMapper._();

  static VideoPosterMapper? _instance;
  static VideoPosterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoPosterMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VideoPoster';

  static String _$path(VideoPoster v) => v.path;
  static const Field<VideoPoster, String> _f$path = Field('path', _$path);
  static int _$width(VideoPoster v) => v.width;
  static const Field<VideoPoster, int> _f$width = Field('width', _$width);
  static int _$height(VideoPoster v) => v.height;
  static const Field<VideoPoster, int> _f$height = Field('height', _$height);
  static Duration? _$duration(VideoPoster v) => v.duration;
  static const Field<VideoPoster, Duration> _f$duration = Field(
    'duration',
    _$duration,
    key: r'duration_ms',
    opt: true,
    hook: MillisecondsHook(),
  );

  @override
  final MappableFields<VideoPoster> fields = const {
    #path: _f$path,
    #width: _f$width,
    #height: _f$height,
    #duration: _f$duration,
  };
  @override
  final bool ignoreNull = true;

  static VideoPoster _instantiate(DecodingData data) {
    return VideoPoster(
      path: data.dec(_f$path),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      duration: data.dec(_f$duration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VideoPoster fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VideoPoster>(map);
  }

  static VideoPoster fromJson(String json) {
    return ensureInitialized().decodeJson<VideoPoster>(json);
  }
}

mixin VideoPosterMappable {
  String toJson() {
    return VideoPosterMapper.ensureInitialized().encodeJson<VideoPoster>(
      this as VideoPoster,
    );
  }

  Map<String, dynamic> toMap() {
    return VideoPosterMapper.ensureInitialized().encodeMap<VideoPoster>(
      this as VideoPoster,
    );
  }

  VideoPosterCopyWith<VideoPoster, VideoPoster, VideoPoster> get copyWith =>
      _VideoPosterCopyWithImpl<VideoPoster, VideoPoster>(
        this as VideoPoster,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VideoPosterMapper.ensureInitialized().stringifyValue(
      this as VideoPoster,
    );
  }

  @override
  bool operator ==(Object other) {
    return VideoPosterMapper.ensureInitialized().equalsValue(
      this as VideoPoster,
      other,
    );
  }

  @override
  int get hashCode {
    return VideoPosterMapper.ensureInitialized().hashValue(this as VideoPoster);
  }
}

extension VideoPosterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VideoPoster, $Out> {
  VideoPosterCopyWith<$R, VideoPoster, $Out> get $asVideoPoster =>
      $base.as((v, t, t2) => _VideoPosterCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VideoPosterCopyWith<$R, $In extends VideoPoster, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? path, int? width, int? height, Duration? duration});
  VideoPosterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VideoPosterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VideoPoster, $Out>
    implements VideoPosterCopyWith<$R, VideoPoster, $Out> {
  _VideoPosterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VideoPoster> $mapper =
      VideoPosterMapper.ensureInitialized();
  @override
  $R call({String? path, int? width, int? height, Object? duration = $none}) =>
      $apply(
        FieldCopyWithData({
          if (path != null) #path: path,
          if (width != null) #width: width,
          if (height != null) #height: height,
          if (duration != $none) #duration: duration,
        }),
      );
  @override
  VideoPoster $make(CopyWithData data) => VideoPoster(
    path: data.get(#path, or: $value.path),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    duration: data.get(#duration, or: $value.duration),
  );

  @override
  VideoPosterCopyWith<$R2, VideoPoster, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VideoPosterCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

