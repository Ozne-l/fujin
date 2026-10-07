// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sent_link.dart';

class SentLinkMapper extends ClassMapperBase<SentLink> {
  SentLinkMapper._();

  static SentLinkMapper? _instance;
  static SentLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SentLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SentLink';

  static String _$mfpEntryId(SentLink v) => v.mfpEntryId;
  static const Field<SentLink, String> _f$mfpEntryId = Field(
    'mfpEntryId',
    _$mfpEntryId,
    key: r'mfp_entry_id',
  );
  static DateTime _$date(SentLink v) => v.date;
  static const Field<SentLink, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static String _$mfpFoodId(SentLink v) => v.mfpFoodId;
  static const Field<SentLink, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$mfpMealName(SentLink v) => v.mfpMealName;
  static const Field<SentLink, String> _f$mfpMealName = Field(
    'mfpMealName',
    _$mfpMealName,
    key: r'mfp_meal_name',
  );
  static double _$mfpServings(SentLink v) => v.mfpServings;
  static const Field<SentLink, double> _f$mfpServings = Field(
    'mfpServings',
    _$mfpServings,
    key: r'mfp_servings',
  );
  static double _$mfpServingValue(SentLink v) => v.mfpServingValue;
  static const Field<SentLink, double> _f$mfpServingValue = Field(
    'mfpServingValue',
    _$mfpServingValue,
    key: r'mfp_serving_value',
  );
  static String _$mfpServingUnit(SentLink v) => v.mfpServingUnit;
  static const Field<SentLink, String> _f$mfpServingUnit = Field(
    'mfpServingUnit',
    _$mfpServingUnit,
    key: r'mfp_serving_unit',
  );
  static String _$ekkloMealId(SentLink v) => v.ekkloMealId;
  static const Field<SentLink, String> _f$ekkloMealId = Field(
    'ekkloMealId',
    _$ekkloMealId,
    key: r'ekklo_meal_id',
  );
  static String _$ekkloItemId(SentLink v) => v.ekkloItemId;
  static const Field<SentLink, String> _f$ekkloItemId = Field(
    'ekkloItemId',
    _$ekkloItemId,
    key: r'ekklo_item_id',
  );
  static DateTime _$sentAt(SentLink v) => v.sentAt;
  static const Field<SentLink, DateTime> _f$sentAt = Field(
    'sentAt',
    _$sentAt,
    key: r'sent_at',
  );

  @override
  final MappableFields<SentLink> fields = const {
    #mfpEntryId: _f$mfpEntryId,
    #date: _f$date,
    #mfpFoodId: _f$mfpFoodId,
    #mfpMealName: _f$mfpMealName,
    #mfpServings: _f$mfpServings,
    #mfpServingValue: _f$mfpServingValue,
    #mfpServingUnit: _f$mfpServingUnit,
    #ekkloMealId: _f$ekkloMealId,
    #ekkloItemId: _f$ekkloItemId,
    #sentAt: _f$sentAt,
  };
  @override
  final bool ignoreNull = true;

  static SentLink _instantiate(DecodingData data) {
    return SentLink(
      mfpEntryId: data.dec(_f$mfpEntryId),
      date: data.dec(_f$date),
      mfpFoodId: data.dec(_f$mfpFoodId),
      mfpMealName: data.dec(_f$mfpMealName),
      mfpServings: data.dec(_f$mfpServings),
      mfpServingValue: data.dec(_f$mfpServingValue),
      mfpServingUnit: data.dec(_f$mfpServingUnit),
      ekkloMealId: data.dec(_f$ekkloMealId),
      ekkloItemId: data.dec(_f$ekkloItemId),
      sentAt: data.dec(_f$sentAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SentLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SentLink>(map);
  }

  static SentLink fromJson(String json) {
    return ensureInitialized().decodeJson<SentLink>(json);
  }
}

mixin SentLinkMappable {
  String toJson() {
    return SentLinkMapper.ensureInitialized().encodeJson<SentLink>(
      this as SentLink,
    );
  }

  Map<String, dynamic> toMap() {
    return SentLinkMapper.ensureInitialized().encodeMap<SentLink>(
      this as SentLink,
    );
  }

  SentLinkCopyWith<SentLink, SentLink, SentLink> get copyWith =>
      _SentLinkCopyWithImpl<SentLink, SentLink>(
        this as SentLink,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SentLinkMapper.ensureInitialized().stringifyValue(this as SentLink);
  }

  @override
  bool operator ==(Object other) {
    return SentLinkMapper.ensureInitialized().equalsValue(
      this as SentLink,
      other,
    );
  }

  @override
  int get hashCode {
    return SentLinkMapper.ensureInitialized().hashValue(this as SentLink);
  }
}

extension SentLinkValueCopy<$R, $Out> on ObjectCopyWith<$R, SentLink, $Out> {
  SentLinkCopyWith<$R, SentLink, $Out> get $asSentLink =>
      $base.as((v, t, t2) => _SentLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SentLinkCopyWith<$R, $In extends SentLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? mfpEntryId,
    DateTime? date,
    String? mfpFoodId,
    String? mfpMealName,
    double? mfpServings,
    double? mfpServingValue,
    String? mfpServingUnit,
    String? ekkloMealId,
    String? ekkloItemId,
    DateTime? sentAt,
  });
  SentLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SentLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SentLink, $Out>
    implements SentLinkCopyWith<$R, SentLink, $Out> {
  _SentLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SentLink> $mapper =
      SentLinkMapper.ensureInitialized();
  @override
  $R call({
    String? mfpEntryId,
    DateTime? date,
    String? mfpFoodId,
    String? mfpMealName,
    double? mfpServings,
    double? mfpServingValue,
    String? mfpServingUnit,
    String? ekkloMealId,
    String? ekkloItemId,
    DateTime? sentAt,
  }) => $apply(
    FieldCopyWithData({
      if (mfpEntryId != null) #mfpEntryId: mfpEntryId,
      if (date != null) #date: date,
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (mfpMealName != null) #mfpMealName: mfpMealName,
      if (mfpServings != null) #mfpServings: mfpServings,
      if (mfpServingValue != null) #mfpServingValue: mfpServingValue,
      if (mfpServingUnit != null) #mfpServingUnit: mfpServingUnit,
      if (ekkloMealId != null) #ekkloMealId: ekkloMealId,
      if (ekkloItemId != null) #ekkloItemId: ekkloItemId,
      if (sentAt != null) #sentAt: sentAt,
    }),
  );
  @override
  SentLink $make(CopyWithData data) => SentLink(
    mfpEntryId: data.get(#mfpEntryId, or: $value.mfpEntryId),
    date: data.get(#date, or: $value.date),
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    mfpMealName: data.get(#mfpMealName, or: $value.mfpMealName),
    mfpServings: data.get(#mfpServings, or: $value.mfpServings),
    mfpServingValue: data.get(#mfpServingValue, or: $value.mfpServingValue),
    mfpServingUnit: data.get(#mfpServingUnit, or: $value.mfpServingUnit),
    ekkloMealId: data.get(#ekkloMealId, or: $value.ekkloMealId),
    ekkloItemId: data.get(#ekkloItemId, or: $value.ekkloItemId),
    sentAt: data.get(#sentAt, or: $value.sentAt),
  );

  @override
  SentLinkCopyWith<$R2, SentLink, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SentLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

