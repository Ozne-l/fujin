// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mfp_link.dart';

class MfpLinkMapper extends ClassMapperBase<MfpLink> {
  MfpLinkMapper._();

  static MfpLinkMapper? _instance;
  static MfpLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MfpLink';

  static String _$id(MfpLink v) => v.id;
  static const Field<MfpLink, String> _f$id = Field('id', _$id);
  static String _$entryId(MfpLink v) => v.entryId;
  static const Field<MfpLink, String> _f$entryId = Field(
    'entryId',
    _$entryId,
    key: r'entry_id',
  );
  static String _$mfpEntryId(MfpLink v) => v.mfpEntryId;
  static const Field<MfpLink, String> _f$mfpEntryId = Field(
    'mfpEntryId',
    _$mfpEntryId,
    key: r'mfp_entry_id',
  );
  static DateTime _$date(MfpLink v) => v.date;
  static const Field<MfpLink, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static String _$mealName(MfpLink v) => v.mealName;
  static const Field<MfpLink, String> _f$mealName = Field(
    'mealName',
    _$mealName,
    key: r'meal_name',
  );
  static String _$foodId(MfpLink v) => v.foodId;
  static const Field<MfpLink, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static double _$servings(MfpLink v) => v.servings;
  static const Field<MfpLink, double> _f$servings = Field(
    'servings',
    _$servings,
  );
  static double _$servingValue(MfpLink v) => v.servingValue;
  static const Field<MfpLink, double> _f$servingValue = Field(
    'servingValue',
    _$servingValue,
    key: r'serving_value',
  );
  static String _$servingUnit(MfpLink v) => v.servingUnit;
  static const Field<MfpLink, String> _f$servingUnit = Field(
    'servingUnit',
    _$servingUnit,
    key: r'serving_unit',
  );
  static DateTime _$updatedAt(MfpLink v) => v.updatedAt;
  static const Field<MfpLink, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String? _$foodVersion(MfpLink v) => v.foodVersion;
  static const Field<MfpLink, String> _f$foodVersion = Field(
    'foodVersion',
    _$foodVersion,
    key: r'food_version',
    opt: true,
  );
  static DateTime? _$deletedAt(MfpLink v) => v.deletedAt;
  static const Field<MfpLink, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<MfpLink> fields = const {
    #id: _f$id,
    #entryId: _f$entryId,
    #mfpEntryId: _f$mfpEntryId,
    #date: _f$date,
    #mealName: _f$mealName,
    #foodId: _f$foodId,
    #servings: _f$servings,
    #servingValue: _f$servingValue,
    #servingUnit: _f$servingUnit,
    #updatedAt: _f$updatedAt,
    #foodVersion: _f$foodVersion,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static MfpLink _instantiate(DecodingData data) {
    return MfpLink(
      id: data.dec(_f$id),
      entryId: data.dec(_f$entryId),
      mfpEntryId: data.dec(_f$mfpEntryId),
      date: data.dec(_f$date),
      mealName: data.dec(_f$mealName),
      foodId: data.dec(_f$foodId),
      servings: data.dec(_f$servings),
      servingValue: data.dec(_f$servingValue),
      servingUnit: data.dec(_f$servingUnit),
      updatedAt: data.dec(_f$updatedAt),
      foodVersion: data.dec(_f$foodVersion),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpLink>(map);
  }

  static MfpLink fromJson(String json) {
    return ensureInitialized().decodeJson<MfpLink>(json);
  }
}

mixin MfpLinkMappable {
  String toJson() {
    return MfpLinkMapper.ensureInitialized().encodeJson<MfpLink>(
      this as MfpLink,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpLinkMapper.ensureInitialized().encodeMap<MfpLink>(
      this as MfpLink,
    );
  }

  MfpLinkCopyWith<MfpLink, MfpLink, MfpLink> get copyWith =>
      _MfpLinkCopyWithImpl<MfpLink, MfpLink>(
        this as MfpLink,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpLinkMapper.ensureInitialized().stringifyValue(this as MfpLink);
  }

  @override
  bool operator ==(Object other) {
    return MfpLinkMapper.ensureInitialized().equalsValue(
      this as MfpLink,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpLinkMapper.ensureInitialized().hashValue(this as MfpLink);
  }
}

extension MfpLinkValueCopy<$R, $Out> on ObjectCopyWith<$R, MfpLink, $Out> {
  MfpLinkCopyWith<$R, MfpLink, $Out> get $asMfpLink =>
      $base.as((v, t, t2) => _MfpLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpLinkCopyWith<$R, $In extends MfpLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? entryId,
    String? mfpEntryId,
    DateTime? date,
    String? mealName,
    String? foodId,
    double? servings,
    double? servingValue,
    String? servingUnit,
    DateTime? updatedAt,
    String? foodVersion,
    DateTime? deletedAt,
  });
  MfpLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpLink, $Out>
    implements MfpLinkCopyWith<$R, MfpLink, $Out> {
  _MfpLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpLink> $mapper =
      MfpLinkMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? entryId,
    String? mfpEntryId,
    DateTime? date,
    String? mealName,
    String? foodId,
    double? servings,
    double? servingValue,
    String? servingUnit,
    DateTime? updatedAt,
    Object? foodVersion = $none,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (entryId != null) #entryId: entryId,
      if (mfpEntryId != null) #mfpEntryId: mfpEntryId,
      if (date != null) #date: date,
      if (mealName != null) #mealName: mealName,
      if (foodId != null) #foodId: foodId,
      if (servings != null) #servings: servings,
      if (servingValue != null) #servingValue: servingValue,
      if (servingUnit != null) #servingUnit: servingUnit,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (foodVersion != $none) #foodVersion: foodVersion,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  MfpLink $make(CopyWithData data) => MfpLink(
    id: data.get(#id, or: $value.id),
    entryId: data.get(#entryId, or: $value.entryId),
    mfpEntryId: data.get(#mfpEntryId, or: $value.mfpEntryId),
    date: data.get(#date, or: $value.date),
    mealName: data.get(#mealName, or: $value.mealName),
    foodId: data.get(#foodId, or: $value.foodId),
    servings: data.get(#servings, or: $value.servings),
    servingValue: data.get(#servingValue, or: $value.servingValue),
    servingUnit: data.get(#servingUnit, or: $value.servingUnit),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    foodVersion: data.get(#foodVersion, or: $value.foodVersion),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  MfpLinkCopyWith<$R2, MfpLink, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MfpLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

