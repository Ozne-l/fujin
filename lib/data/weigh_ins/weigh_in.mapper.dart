// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'weigh_in.dart';

class WeighInMapper extends ClassMapperBase<WeighIn> {
  WeighInMapper._();

  static WeighInMapper? _instance;
  static WeighInMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WeighInMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'WeighIn';

  static String _$id(WeighIn v) => v.id;
  static const Field<WeighIn, String> _f$id = Field('id', _$id);
  static DateTime _$date(WeighIn v) => v.date;
  static const Field<WeighIn, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static double _$kilograms(WeighIn v) => v.kilograms;
  static const Field<WeighIn, double> _f$kilograms = Field(
    'kilograms',
    _$kilograms,
  );
  static DateTime _$updatedAt(WeighIn v) => v.updatedAt;
  static const Field<WeighIn, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(WeighIn v) => v.deletedAt;
  static const Field<WeighIn, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<WeighIn> fields = const {
    #id: _f$id,
    #date: _f$date,
    #kilograms: _f$kilograms,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static WeighIn _instantiate(DecodingData data) {
    return WeighIn(
      id: data.dec(_f$id),
      date: data.dec(_f$date),
      kilograms: data.dec(_f$kilograms),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WeighIn fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WeighIn>(map);
  }

  static WeighIn fromJson(String json) {
    return ensureInitialized().decodeJson<WeighIn>(json);
  }
}

mixin WeighInMappable {
  String toJson() {
    return WeighInMapper.ensureInitialized().encodeJson<WeighIn>(
      this as WeighIn,
    );
  }

  Map<String, dynamic> toMap() {
    return WeighInMapper.ensureInitialized().encodeMap<WeighIn>(
      this as WeighIn,
    );
  }

  WeighInCopyWith<WeighIn, WeighIn, WeighIn> get copyWith =>
      _WeighInCopyWithImpl<WeighIn, WeighIn>(
        this as WeighIn,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return WeighInMapper.ensureInitialized().stringifyValue(this as WeighIn);
  }

  @override
  bool operator ==(Object other) {
    return WeighInMapper.ensureInitialized().equalsValue(
      this as WeighIn,
      other,
    );
  }

  @override
  int get hashCode {
    return WeighInMapper.ensureInitialized().hashValue(this as WeighIn);
  }
}

extension WeighInValueCopy<$R, $Out> on ObjectCopyWith<$R, WeighIn, $Out> {
  WeighInCopyWith<$R, WeighIn, $Out> get $asWeighIn =>
      $base.as((v, t, t2) => _WeighInCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WeighInCopyWith<$R, $In extends WeighIn, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? date,
    double? kilograms,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  WeighInCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WeighInCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WeighIn, $Out>
    implements WeighInCopyWith<$R, WeighIn, $Out> {
  _WeighInCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WeighIn> $mapper =
      WeighInMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? date,
    double? kilograms,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (date != null) #date: date,
      if (kilograms != null) #kilograms: kilograms,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  WeighIn $make(CopyWithData data) => WeighIn(
    id: data.get(#id, or: $value.id),
    date: data.get(#date, or: $value.date),
    kilograms: data.get(#kilograms, or: $value.kilograms),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  WeighInCopyWith<$R2, WeighIn, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _WeighInCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

