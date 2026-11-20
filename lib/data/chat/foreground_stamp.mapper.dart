// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'foreground_stamp.dart';

class ForegroundStampMapper extends ClassMapperBase<ForegroundStamp> {
  ForegroundStampMapper._();

  static ForegroundStampMapper? _instance;
  static ForegroundStampMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ForegroundStampMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ForegroundStamp';

  static DateTime _$at(ForegroundStamp v) => v.at;
  static const Field<ForegroundStamp, DateTime> _f$at = Field('at', _$at);
  static int _$id(ForegroundStamp v) => v.id;
  static const Field<ForegroundStamp, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: ForegroundStamp.onlyRow,
  );

  @override
  final MappableFields<ForegroundStamp> fields = const {#at: _f$at, #id: _f$id};
  @override
  final bool ignoreNull = true;

  static ForegroundStamp _instantiate(DecodingData data) {
    return ForegroundStamp(at: data.dec(_f$at), id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static ForegroundStamp fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ForegroundStamp>(map);
  }

  static ForegroundStamp fromJson(String json) {
    return ensureInitialized().decodeJson<ForegroundStamp>(json);
  }
}

mixin ForegroundStampMappable {
  String toJson() {
    return ForegroundStampMapper.ensureInitialized()
        .encodeJson<ForegroundStamp>(this as ForegroundStamp);
  }

  Map<String, dynamic> toMap() {
    return ForegroundStampMapper.ensureInitialized().encodeMap<ForegroundStamp>(
      this as ForegroundStamp,
    );
  }

  ForegroundStampCopyWith<ForegroundStamp, ForegroundStamp, ForegroundStamp>
  get copyWith =>
      _ForegroundStampCopyWithImpl<ForegroundStamp, ForegroundStamp>(
        this as ForegroundStamp,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ForegroundStampMapper.ensureInitialized().stringifyValue(
      this as ForegroundStamp,
    );
  }

  @override
  bool operator ==(Object other) {
    return ForegroundStampMapper.ensureInitialized().equalsValue(
      this as ForegroundStamp,
      other,
    );
  }

  @override
  int get hashCode {
    return ForegroundStampMapper.ensureInitialized().hashValue(
      this as ForegroundStamp,
    );
  }
}

extension ForegroundStampValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ForegroundStamp, $Out> {
  ForegroundStampCopyWith<$R, ForegroundStamp, $Out> get $asForegroundStamp =>
      $base.as((v, t, t2) => _ForegroundStampCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ForegroundStampCopyWith<$R, $In extends ForegroundStamp, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({DateTime? at, int? id});
  ForegroundStampCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ForegroundStampCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ForegroundStamp, $Out>
    implements ForegroundStampCopyWith<$R, ForegroundStamp, $Out> {
  _ForegroundStampCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ForegroundStamp> $mapper =
      ForegroundStampMapper.ensureInitialized();
  @override
  $R call({DateTime? at, int? id}) => $apply(
    FieldCopyWithData({if (at != null) #at: at, if (id != null) #id: id}),
  );
  @override
  ForegroundStamp $make(CopyWithData data) => ForegroundStamp(
    at: data.get(#at, or: $value.at),
    id: data.get(#id, or: $value.id),
  );

  @override
  ForegroundStampCopyWith<$R2, ForegroundStamp, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ForegroundStampCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

