// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'linked_item.dart';

class LinkedItemMapper extends ClassMapperBase<LinkedItem> {
  LinkedItemMapper._();

  static LinkedItemMapper? _instance;
  static LinkedItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LinkedItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LinkedItem';

  static String _$ekkloMealId(LinkedItem v) => v.ekkloMealId;
  static const Field<LinkedItem, String> _f$ekkloMealId = Field(
    'ekkloMealId',
    _$ekkloMealId,
    key: r'ekklo_meal_id',
  );
  static String _$ekkloItemId(LinkedItem v) => v.ekkloItemId;
  static const Field<LinkedItem, String> _f$ekkloItemId = Field(
    'ekkloItemId',
    _$ekkloItemId,
    key: r'ekklo_item_id',
  );
  static String _$mealId(LinkedItem v) => v.mealId;
  static const Field<LinkedItem, String> _f$mealId = Field(
    'mealId',
    _$mealId,
    key: r'meal_id',
  );
  static String _$foodId(LinkedItem v) => v.foodId;
  static const Field<LinkedItem, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static double _$servings(LinkedItem v) => v.servings;
  static const Field<LinkedItem, double> _f$servings = Field(
    'servings',
    _$servings,
  );
  static double _$servingValue(LinkedItem v) => v.servingValue;
  static const Field<LinkedItem, double> _f$servingValue = Field(
    'servingValue',
    _$servingValue,
    key: r'serving_value',
  );
  static String _$servingUnit(LinkedItem v) => v.servingUnit;
  static const Field<LinkedItem, String> _f$servingUnit = Field(
    'servingUnit',
    _$servingUnit,
    key: r'serving_unit',
  );
  static DateTime _$sentAt(LinkedItem v) => v.sentAt;
  static const Field<LinkedItem, DateTime> _f$sentAt = Field(
    'sentAt',
    _$sentAt,
    key: r'sent_at',
  );

  @override
  final MappableFields<LinkedItem> fields = const {
    #ekkloMealId: _f$ekkloMealId,
    #ekkloItemId: _f$ekkloItemId,
    #mealId: _f$mealId,
    #foodId: _f$foodId,
    #servings: _f$servings,
    #servingValue: _f$servingValue,
    #servingUnit: _f$servingUnit,
    #sentAt: _f$sentAt,
  };
  @override
  final bool ignoreNull = true;

  static LinkedItem _instantiate(DecodingData data) {
    return LinkedItem(
      ekkloMealId: data.dec(_f$ekkloMealId),
      ekkloItemId: data.dec(_f$ekkloItemId),
      mealId: data.dec(_f$mealId),
      foodId: data.dec(_f$foodId),
      servings: data.dec(_f$servings),
      servingValue: data.dec(_f$servingValue),
      servingUnit: data.dec(_f$servingUnit),
      sentAt: data.dec(_f$sentAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LinkedItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LinkedItem>(map);
  }

  static LinkedItem fromJson(String json) {
    return ensureInitialized().decodeJson<LinkedItem>(json);
  }
}

mixin LinkedItemMappable {
  String toJson() {
    return LinkedItemMapper.ensureInitialized().encodeJson<LinkedItem>(
      this as LinkedItem,
    );
  }

  Map<String, dynamic> toMap() {
    return LinkedItemMapper.ensureInitialized().encodeMap<LinkedItem>(
      this as LinkedItem,
    );
  }

  LinkedItemCopyWith<LinkedItem, LinkedItem, LinkedItem> get copyWith =>
      _LinkedItemCopyWithImpl<LinkedItem, LinkedItem>(
        this as LinkedItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LinkedItemMapper.ensureInitialized().stringifyValue(
      this as LinkedItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return LinkedItemMapper.ensureInitialized().equalsValue(
      this as LinkedItem,
      other,
    );
  }

  @override
  int get hashCode {
    return LinkedItemMapper.ensureInitialized().hashValue(this as LinkedItem);
  }
}

extension LinkedItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LinkedItem, $Out> {
  LinkedItemCopyWith<$R, LinkedItem, $Out> get $asLinkedItem =>
      $base.as((v, t, t2) => _LinkedItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LinkedItemCopyWith<$R, $In extends LinkedItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? ekkloMealId,
    String? ekkloItemId,
    String? mealId,
    String? foodId,
    double? servings,
    double? servingValue,
    String? servingUnit,
    DateTime? sentAt,
  });
  LinkedItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LinkedItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LinkedItem, $Out>
    implements LinkedItemCopyWith<$R, LinkedItem, $Out> {
  _LinkedItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LinkedItem> $mapper =
      LinkedItemMapper.ensureInitialized();
  @override
  $R call({
    String? ekkloMealId,
    String? ekkloItemId,
    String? mealId,
    String? foodId,
    double? servings,
    double? servingValue,
    String? servingUnit,
    DateTime? sentAt,
  }) => $apply(
    FieldCopyWithData({
      if (ekkloMealId != null) #ekkloMealId: ekkloMealId,
      if (ekkloItemId != null) #ekkloItemId: ekkloItemId,
      if (mealId != null) #mealId: mealId,
      if (foodId != null) #foodId: foodId,
      if (servings != null) #servings: servings,
      if (servingValue != null) #servingValue: servingValue,
      if (servingUnit != null) #servingUnit: servingUnit,
      if (sentAt != null) #sentAt: sentAt,
    }),
  );
  @override
  LinkedItem $make(CopyWithData data) => LinkedItem(
    ekkloMealId: data.get(#ekkloMealId, or: $value.ekkloMealId),
    ekkloItemId: data.get(#ekkloItemId, or: $value.ekkloItemId),
    mealId: data.get(#mealId, or: $value.mealId),
    foodId: data.get(#foodId, or: $value.foodId),
    servings: data.get(#servings, or: $value.servings),
    servingValue: data.get(#servingValue, or: $value.servingValue),
    servingUnit: data.get(#servingUnit, or: $value.servingUnit),
    sentAt: data.get(#sentAt, or: $value.sentAt),
  );

  @override
  LinkedItemCopyWith<$R2, LinkedItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LinkedItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

