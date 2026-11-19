// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'upload_marker.dart';

class UploadMarkerMapper extends ClassMapperBase<UploadMarker> {
  UploadMarkerMapper._();

  static UploadMarkerMapper? _instance;
  static UploadMarkerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadMarkerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UploadMarker';

  static String _$publicUrl(UploadMarker v) => v.publicUrl;
  static const Field<UploadMarker, String> _f$publicUrl = Field(
    'publicUrl',
    _$publicUrl,
    key: r'public_url',
  );
  static DateTime _$at(UploadMarker v) => v.at;
  static const Field<UploadMarker, DateTime> _f$at = Field('at', _$at);

  @override
  final MappableFields<UploadMarker> fields = const {
    #publicUrl: _f$publicUrl,
    #at: _f$at,
  };
  @override
  final bool ignoreNull = true;

  static UploadMarker _instantiate(DecodingData data) {
    return UploadMarker(publicUrl: data.dec(_f$publicUrl), at: data.dec(_f$at));
  }

  @override
  final Function instantiate = _instantiate;

  static UploadMarker fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadMarker>(map);
  }

  static UploadMarker fromJson(String json) {
    return ensureInitialized().decodeJson<UploadMarker>(json);
  }
}

mixin UploadMarkerMappable {
  String toJson() {
    return UploadMarkerMapper.ensureInitialized().encodeJson<UploadMarker>(
      this as UploadMarker,
    );
  }

  Map<String, dynamic> toMap() {
    return UploadMarkerMapper.ensureInitialized().encodeMap<UploadMarker>(
      this as UploadMarker,
    );
  }

  UploadMarkerCopyWith<UploadMarker, UploadMarker, UploadMarker> get copyWith =>
      _UploadMarkerCopyWithImpl<UploadMarker, UploadMarker>(
        this as UploadMarker,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UploadMarkerMapper.ensureInitialized().stringifyValue(
      this as UploadMarker,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadMarkerMapper.ensureInitialized().equalsValue(
      this as UploadMarker,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadMarkerMapper.ensureInitialized().hashValue(
      this as UploadMarker,
    );
  }
}

extension UploadMarkerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadMarker, $Out> {
  UploadMarkerCopyWith<$R, UploadMarker, $Out> get $asUploadMarker =>
      $base.as((v, t, t2) => _UploadMarkerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadMarkerCopyWith<$R, $In extends UploadMarker, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? publicUrl, DateTime? at});
  UploadMarkerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UploadMarkerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadMarker, $Out>
    implements UploadMarkerCopyWith<$R, UploadMarker, $Out> {
  _UploadMarkerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadMarker> $mapper =
      UploadMarkerMapper.ensureInitialized();
  @override
  $R call({String? publicUrl, DateTime? at}) => $apply(
    FieldCopyWithData({
      if (publicUrl != null) #publicUrl: publicUrl,
      if (at != null) #at: at,
    }),
  );
  @override
  UploadMarker $make(CopyWithData data) => UploadMarker(
    publicUrl: data.get(#publicUrl, or: $value.publicUrl),
    at: data.get(#at, or: $value.at),
  );

  @override
  UploadMarkerCopyWith<$R2, UploadMarker, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadMarkerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

