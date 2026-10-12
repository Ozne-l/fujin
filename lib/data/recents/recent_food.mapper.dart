// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'recent_food.dart';

class RecentFoodMapper extends ClassMapperBase<RecentFood> {
  RecentFoodMapper._();

  static RecentFoodMapper? _instance;
  static RecentFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RecentFoodMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RecentFood';

  static String _$mfpFoodId(RecentFood v) => v.mfpFoodId;
  static const Field<RecentFood, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$description(RecentFood v) => v.description;
  static const Field<RecentFood, String> _f$description = Field(
    'description',
    _$description,
  );
  static double _$servingValue(RecentFood v) => v.servingValue;
  static const Field<RecentFood, double> _f$servingValue = Field(
    'servingValue',
    _$servingValue,
    key: r'serving_value',
  );
  static String _$servingUnit(RecentFood v) => v.servingUnit;
  static const Field<RecentFood, String> _f$servingUnit = Field(
    'servingUnit',
    _$servingUnit,
    key: r'serving_unit',
  );
  static double _$servings(RecentFood v) => v.servings;
  static const Field<RecentFood, double> _f$servings = Field(
    'servings',
    _$servings,
  );
  static DateTime _$addedAt(RecentFood v) => v.addedAt;
  static const Field<RecentFood, DateTime> _f$addedAt = Field(
    'addedAt',
    _$addedAt,
    key: r'added_at',
  );
  static String? _$brandName(RecentFood v) => v.brandName;
  static const Field<RecentFood, String> _f$brandName = Field(
    'brandName',
    _$brandName,
    key: r'brand_name',
    opt: true,
  );
  static double? _$kilocalories(RecentFood v) => v.kilocalories;
  static const Field<RecentFood, double> _f$kilocalories = Field(
    'kilocalories',
    _$kilocalories,
    opt: true,
  );

  @override
  final MappableFields<RecentFood> fields = const {
    #mfpFoodId: _f$mfpFoodId,
    #description: _f$description,
    #servingValue: _f$servingValue,
    #servingUnit: _f$servingUnit,
    #servings: _f$servings,
    #addedAt: _f$addedAt,
    #brandName: _f$brandName,
    #kilocalories: _f$kilocalories,
  };
  @override
  final bool ignoreNull = true;

  static RecentFood _instantiate(DecodingData data) {
    return RecentFood(
      mfpFoodId: data.dec(_f$mfpFoodId),
      description: data.dec(_f$description),
      servingValue: data.dec(_f$servingValue),
      servingUnit: data.dec(_f$servingUnit),
      servings: data.dec(_f$servings),
      addedAt: data.dec(_f$addedAt),
      brandName: data.dec(_f$brandName),
      kilocalories: data.dec(_f$kilocalories),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RecentFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RecentFood>(map);
  }

  static RecentFood fromJson(String json) {
    return ensureInitialized().decodeJson<RecentFood>(json);
  }
}

mixin RecentFoodMappable {
  String toJson() {
    return RecentFoodMapper.ensureInitialized().encodeJson<RecentFood>(
      this as RecentFood,
    );
  }

  Map<String, dynamic> toMap() {
    return RecentFoodMapper.ensureInitialized().encodeMap<RecentFood>(
      this as RecentFood,
    );
  }

  RecentFoodCopyWith<RecentFood, RecentFood, RecentFood> get copyWith =>
      _RecentFoodCopyWithImpl<RecentFood, RecentFood>(
        this as RecentFood,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RecentFoodMapper.ensureInitialized().stringifyValue(
      this as RecentFood,
    );
  }

  @override
  bool operator ==(Object other) {
    return RecentFoodMapper.ensureInitialized().equalsValue(
      this as RecentFood,
      other,
    );
  }

  @override
  int get hashCode {
    return RecentFoodMapper.ensureInitialized().hashValue(this as RecentFood);
  }
}

extension RecentFoodValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RecentFood, $Out> {
  RecentFoodCopyWith<$R, RecentFood, $Out> get $asRecentFood =>
      $base.as((v, t, t2) => _RecentFoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RecentFoodCopyWith<$R, $In extends RecentFood, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? mfpFoodId,
    String? description,
    double? servingValue,
    String? servingUnit,
    double? servings,
    DateTime? addedAt,
    String? brandName,
    double? kilocalories,
  });
  RecentFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RecentFoodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RecentFood, $Out>
    implements RecentFoodCopyWith<$R, RecentFood, $Out> {
  _RecentFoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RecentFood> $mapper =
      RecentFoodMapper.ensureInitialized();
  @override
  $R call({
    String? mfpFoodId,
    String? description,
    double? servingValue,
    String? servingUnit,
    double? servings,
    DateTime? addedAt,
    Object? brandName = $none,
    Object? kilocalories = $none,
  }) => $apply(
    FieldCopyWithData({
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (description != null) #description: description,
      if (servingValue != null) #servingValue: servingValue,
      if (servingUnit != null) #servingUnit: servingUnit,
      if (servings != null) #servings: servings,
      if (addedAt != null) #addedAt: addedAt,
      if (brandName != $none) #brandName: brandName,
      if (kilocalories != $none) #kilocalories: kilocalories,
    }),
  );
  @override
  RecentFood $make(CopyWithData data) => RecentFood(
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    description: data.get(#description, or: $value.description),
    servingValue: data.get(#servingValue, or: $value.servingValue),
    servingUnit: data.get(#servingUnit, or: $value.servingUnit),
    servings: data.get(#servings, or: $value.servings),
    addedAt: data.get(#addedAt, or: $value.addedAt),
    brandName: data.get(#brandName, or: $value.brandName),
    kilocalories: data.get(#kilocalories, or: $value.kilocalories),
  );

  @override
  RecentFoodCopyWith<$R2, RecentFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RecentFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

