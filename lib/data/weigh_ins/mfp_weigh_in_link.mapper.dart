// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mfp_weigh_in_link.dart';

class MfpWeighInLinkMapper extends ClassMapperBase<MfpWeighInLink> {
  MfpWeighInLinkMapper._();

  static MfpWeighInLinkMapper? _instance;
  static MfpWeighInLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpWeighInLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MfpWeighInLink';

  static String _$id(MfpWeighInLink v) => v.id;
  static const Field<MfpWeighInLink, String> _f$id = Field('id', _$id);
  static String _$weighInId(MfpWeighInLink v) => v.weighInId;
  static const Field<MfpWeighInLink, String> _f$weighInId = Field(
    'weighInId',
    _$weighInId,
    key: r'weigh_in_id',
  );
  static String _$measurementId(MfpWeighInLink v) => v.measurementId;
  static const Field<MfpWeighInLink, String> _f$measurementId = Field(
    'measurementId',
    _$measurementId,
    key: r'measurement_id',
  );
  static DateTime _$date(MfpWeighInLink v) => v.date;
  static const Field<MfpWeighInLink, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static double _$kilograms(MfpWeighInLink v) => v.kilograms;
  static const Field<MfpWeighInLink, double> _f$kilograms = Field(
    'kilograms',
    _$kilograms,
  );
  static DateTime _$updatedAt(MfpWeighInLink v) => v.updatedAt;
  static const Field<MfpWeighInLink, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(MfpWeighInLink v) => v.deletedAt;
  static const Field<MfpWeighInLink, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<MfpWeighInLink> fields = const {
    #id: _f$id,
    #weighInId: _f$weighInId,
    #measurementId: _f$measurementId,
    #date: _f$date,
    #kilograms: _f$kilograms,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static MfpWeighInLink _instantiate(DecodingData data) {
    return MfpWeighInLink(
      id: data.dec(_f$id),
      weighInId: data.dec(_f$weighInId),
      measurementId: data.dec(_f$measurementId),
      date: data.dec(_f$date),
      kilograms: data.dec(_f$kilograms),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpWeighInLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpWeighInLink>(map);
  }

  static MfpWeighInLink fromJson(String json) {
    return ensureInitialized().decodeJson<MfpWeighInLink>(json);
  }
}

mixin MfpWeighInLinkMappable {
  String toJson() {
    return MfpWeighInLinkMapper.ensureInitialized().encodeJson<MfpWeighInLink>(
      this as MfpWeighInLink,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpWeighInLinkMapper.ensureInitialized().encodeMap<MfpWeighInLink>(
      this as MfpWeighInLink,
    );
  }

  MfpWeighInLinkCopyWith<MfpWeighInLink, MfpWeighInLink, MfpWeighInLink>
  get copyWith => _MfpWeighInLinkCopyWithImpl<MfpWeighInLink, MfpWeighInLink>(
    this as MfpWeighInLink,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MfpWeighInLinkMapper.ensureInitialized().stringifyValue(
      this as MfpWeighInLink,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpWeighInLinkMapper.ensureInitialized().equalsValue(
      this as MfpWeighInLink,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpWeighInLinkMapper.ensureInitialized().hashValue(
      this as MfpWeighInLink,
    );
  }
}

extension MfpWeighInLinkValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpWeighInLink, $Out> {
  MfpWeighInLinkCopyWith<$R, MfpWeighInLink, $Out> get $asMfpWeighInLink =>
      $base.as((v, t, t2) => _MfpWeighInLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpWeighInLinkCopyWith<$R, $In extends MfpWeighInLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? weighInId,
    String? measurementId,
    DateTime? date,
    double? kilograms,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  MfpWeighInLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MfpWeighInLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpWeighInLink, $Out>
    implements MfpWeighInLinkCopyWith<$R, MfpWeighInLink, $Out> {
  _MfpWeighInLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpWeighInLink> $mapper =
      MfpWeighInLinkMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? weighInId,
    String? measurementId,
    DateTime? date,
    double? kilograms,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (weighInId != null) #weighInId: weighInId,
      if (measurementId != null) #measurementId: measurementId,
      if (date != null) #date: date,
      if (kilograms != null) #kilograms: kilograms,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  MfpWeighInLink $make(CopyWithData data) => MfpWeighInLink(
    id: data.get(#id, or: $value.id),
    weighInId: data.get(#weighInId, or: $value.weighInId),
    measurementId: data.get(#measurementId, or: $value.measurementId),
    date: data.get(#date, or: $value.date),
    kilograms: data.get(#kilograms, or: $value.kilograms),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  MfpWeighInLinkCopyWith<$R2, MfpWeighInLink, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpWeighInLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

