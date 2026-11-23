// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ekklo_weigh_in_link.dart';

class EkkloWeighInLinkMapper extends ClassMapperBase<EkkloWeighInLink> {
  EkkloWeighInLinkMapper._();

  static EkkloWeighInLinkMapper? _instance;
  static EkkloWeighInLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloWeighInLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloWeighInLink';

  static String _$id(EkkloWeighInLink v) => v.id;
  static const Field<EkkloWeighInLink, String> _f$id = Field('id', _$id);
  static String _$weighInId(EkkloWeighInLink v) => v.weighInId;
  static const Field<EkkloWeighInLink, String> _f$weighInId = Field(
    'weighInId',
    _$weighInId,
    key: r'weigh_in_id',
  );
  static DateTime _$date(EkkloWeighInLink v) => v.date;
  static const Field<EkkloWeighInLink, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static double _$kilograms(EkkloWeighInLink v) => v.kilograms;
  static const Field<EkkloWeighInLink, double> _f$kilograms = Field(
    'kilograms',
    _$kilograms,
  );
  static DateTime _$updatedAt(EkkloWeighInLink v) => v.updatedAt;
  static const Field<EkkloWeighInLink, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(EkkloWeighInLink v) => v.deletedAt;
  static const Field<EkkloWeighInLink, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<EkkloWeighInLink> fields = const {
    #id: _f$id,
    #weighInId: _f$weighInId,
    #date: _f$date,
    #kilograms: _f$kilograms,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static EkkloWeighInLink _instantiate(DecodingData data) {
    return EkkloWeighInLink(
      id: data.dec(_f$id),
      weighInId: data.dec(_f$weighInId),
      date: data.dec(_f$date),
      kilograms: data.dec(_f$kilograms),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloWeighInLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloWeighInLink>(map);
  }

  static EkkloWeighInLink fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloWeighInLink>(json);
  }
}

mixin EkkloWeighInLinkMappable {
  String toJson() {
    return EkkloWeighInLinkMapper.ensureInitialized()
        .encodeJson<EkkloWeighInLink>(this as EkkloWeighInLink);
  }

  Map<String, dynamic> toMap() {
    return EkkloWeighInLinkMapper.ensureInitialized()
        .encodeMap<EkkloWeighInLink>(this as EkkloWeighInLink);
  }

  EkkloWeighInLinkCopyWith<EkkloWeighInLink, EkkloWeighInLink, EkkloWeighInLink>
  get copyWith =>
      _EkkloWeighInLinkCopyWithImpl<EkkloWeighInLink, EkkloWeighInLink>(
        this as EkkloWeighInLink,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloWeighInLinkMapper.ensureInitialized().stringifyValue(
      this as EkkloWeighInLink,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloWeighInLinkMapper.ensureInitialized().equalsValue(
      this as EkkloWeighInLink,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloWeighInLinkMapper.ensureInitialized().hashValue(
      this as EkkloWeighInLink,
    );
  }
}

extension EkkloWeighInLinkValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloWeighInLink, $Out> {
  EkkloWeighInLinkCopyWith<$R, EkkloWeighInLink, $Out>
  get $asEkkloWeighInLink =>
      $base.as((v, t, t2) => _EkkloWeighInLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloWeighInLinkCopyWith<$R, $In extends EkkloWeighInLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? weighInId,
    DateTime? date,
    double? kilograms,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  EkkloWeighInLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloWeighInLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloWeighInLink, $Out>
    implements EkkloWeighInLinkCopyWith<$R, EkkloWeighInLink, $Out> {
  _EkkloWeighInLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloWeighInLink> $mapper =
      EkkloWeighInLinkMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? weighInId,
    DateTime? date,
    double? kilograms,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (weighInId != null) #weighInId: weighInId,
      if (date != null) #date: date,
      if (kilograms != null) #kilograms: kilograms,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  EkkloWeighInLink $make(CopyWithData data) => EkkloWeighInLink(
    id: data.get(#id, or: $value.id),
    weighInId: data.get(#weighInId, or: $value.weighInId),
    date: data.get(#date, or: $value.date),
    kilograms: data.get(#kilograms, or: $value.kilograms),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  EkkloWeighInLinkCopyWith<$R2, EkkloWeighInLink, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloWeighInLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

