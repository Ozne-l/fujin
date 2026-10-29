// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'recent_food_row.dart';

class RecentFoodRowMapper extends ClassMapperBase<RecentFoodRow> {
  RecentFoodRowMapper._();

  static RecentFoodRowMapper? _instance;
  static RecentFoodRowMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RecentFoodRowMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RecentFoodRow';

  static String _$foodId(RecentFoodRow v) => v.foodId;
  static const Field<RecentFoodRow, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static double _$servingValue(RecentFoodRow v) => v.servingValue;
  static const Field<RecentFoodRow, double> _f$servingValue = Field(
    'servingValue',
    _$servingValue,
    key: r'serving_value',
  );
  static String _$servingUnit(RecentFoodRow v) => v.servingUnit;
  static const Field<RecentFoodRow, String> _f$servingUnit = Field(
    'servingUnit',
    _$servingUnit,
    key: r'serving_unit',
  );
  static double _$servings(RecentFoodRow v) => v.servings;
  static const Field<RecentFoodRow, double> _f$servings = Field(
    'servings',
    _$servings,
  );
  static DateTime _$addedAt(RecentFoodRow v) => v.addedAt;
  static const Field<RecentFoodRow, DateTime> _f$addedAt = Field(
    'addedAt',
    _$addedAt,
    key: r'added_at',
  );
  static double? _$kilocalories(RecentFoodRow v) => v.kilocalories;
  static const Field<RecentFoodRow, double> _f$kilocalories = Field(
    'kilocalories',
    _$kilocalories,
    opt: true,
  );

  @override
  final MappableFields<RecentFoodRow> fields = const {
    #foodId: _f$foodId,
    #servingValue: _f$servingValue,
    #servingUnit: _f$servingUnit,
    #servings: _f$servings,
    #addedAt: _f$addedAt,
    #kilocalories: _f$kilocalories,
  };
  @override
  final bool ignoreNull = true;

  static RecentFoodRow _instantiate(DecodingData data) {
    return RecentFoodRow(
      foodId: data.dec(_f$foodId),
      servingValue: data.dec(_f$servingValue),
      servingUnit: data.dec(_f$servingUnit),
      servings: data.dec(_f$servings),
      addedAt: data.dec(_f$addedAt),
      kilocalories: data.dec(_f$kilocalories),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RecentFoodRow fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RecentFoodRow>(map);
  }

  static RecentFoodRow fromJson(String json) {
    return ensureInitialized().decodeJson<RecentFoodRow>(json);
  }
}

mixin RecentFoodRowMappable {
  String toJson() {
    return RecentFoodRowMapper.ensureInitialized().encodeJson<RecentFoodRow>(
      this as RecentFoodRow,
    );
  }

  Map<String, dynamic> toMap() {
    return RecentFoodRowMapper.ensureInitialized().encodeMap<RecentFoodRow>(
      this as RecentFoodRow,
    );
  }

  RecentFoodRowCopyWith<RecentFoodRow, RecentFoodRow, RecentFoodRow>
  get copyWith => _RecentFoodRowCopyWithImpl<RecentFoodRow, RecentFoodRow>(
    this as RecentFoodRow,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RecentFoodRowMapper.ensureInitialized().stringifyValue(
      this as RecentFoodRow,
    );
  }

  @override
  bool operator ==(Object other) {
    return RecentFoodRowMapper.ensureInitialized().equalsValue(
      this as RecentFoodRow,
      other,
    );
  }

  @override
  int get hashCode {
    return RecentFoodRowMapper.ensureInitialized().hashValue(
      this as RecentFoodRow,
    );
  }
}

extension RecentFoodRowValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RecentFoodRow, $Out> {
  RecentFoodRowCopyWith<$R, RecentFoodRow, $Out> get $asRecentFoodRow =>
      $base.as((v, t, t2) => _RecentFoodRowCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RecentFoodRowCopyWith<$R, $In extends RecentFoodRow, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? foodId,
    double? servingValue,
    String? servingUnit,
    double? servings,
    DateTime? addedAt,
    double? kilocalories,
  });
  RecentFoodRowCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RecentFoodRowCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RecentFoodRow, $Out>
    implements RecentFoodRowCopyWith<$R, RecentFoodRow, $Out> {
  _RecentFoodRowCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RecentFoodRow> $mapper =
      RecentFoodRowMapper.ensureInitialized();
  @override
  $R call({
    String? foodId,
    double? servingValue,
    String? servingUnit,
    double? servings,
    DateTime? addedAt,
    Object? kilocalories = $none,
  }) => $apply(
    FieldCopyWithData({
      if (foodId != null) #foodId: foodId,
      if (servingValue != null) #servingValue: servingValue,
      if (servingUnit != null) #servingUnit: servingUnit,
      if (servings != null) #servings: servings,
      if (addedAt != null) #addedAt: addedAt,
      if (kilocalories != $none) #kilocalories: kilocalories,
    }),
  );
  @override
  RecentFoodRow $make(CopyWithData data) => RecentFoodRow(
    foodId: data.get(#foodId, or: $value.foodId),
    servingValue: data.get(#servingValue, or: $value.servingValue),
    servingUnit: data.get(#servingUnit, or: $value.servingUnit),
    servings: data.get(#servings, or: $value.servings),
    addedAt: data.get(#addedAt, or: $value.addedAt),
    kilocalories: data.get(#kilocalories, or: $value.kilocalories),
  );

  @override
  RecentFoodRowCopyWith<$R2, RecentFoodRow, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RecentFoodRowCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

