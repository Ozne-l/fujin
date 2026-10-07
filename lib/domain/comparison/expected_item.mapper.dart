// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'expected_item.dart';

class ExpectedItemMapper extends ClassMapperBase<ExpectedItem> {
  ExpectedItemMapper._();

  static ExpectedItemMapper? _instance;
  static ExpectedItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExpectedItemMapper._());
      EkkloQuantityTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExpectedItem';

  static String _$ekkloMealName(ExpectedItem v) => v.ekkloMealName;
  static const Field<ExpectedItem, String> _f$ekkloMealName = Field(
    'ekkloMealName',
    _$ekkloMealName,
    key: r'ekklo_meal_name',
  );
  static String _$ekkloFoodId(ExpectedItem v) => v.ekkloFoodId;
  static const Field<ExpectedItem, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'ekklo_food_id',
  );
  static double _$quantity(ExpectedItem v) => v.quantity;
  static const Field<ExpectedItem, double> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static EkkloQuantityType _$quantityType(ExpectedItem v) => v.quantityType;
  static const Field<ExpectedItem, EkkloQuantityType> _f$quantityType = Field(
    'quantityType',
    _$quantityType,
    key: r'quantity_type',
  );

  @override
  final MappableFields<ExpectedItem> fields = const {
    #ekkloMealName: _f$ekkloMealName,
    #ekkloFoodId: _f$ekkloFoodId,
    #quantity: _f$quantity,
    #quantityType: _f$quantityType,
  };
  @override
  final bool ignoreNull = true;

  static ExpectedItem _instantiate(DecodingData data) {
    return ExpectedItem(
      ekkloMealName: data.dec(_f$ekkloMealName),
      ekkloFoodId: data.dec(_f$ekkloFoodId),
      quantity: data.dec(_f$quantity),
      quantityType: data.dec(_f$quantityType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExpectedItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExpectedItem>(map);
  }

  static ExpectedItem fromJson(String json) {
    return ensureInitialized().decodeJson<ExpectedItem>(json);
  }
}

mixin ExpectedItemMappable {
  String toJson() {
    return ExpectedItemMapper.ensureInitialized().encodeJson<ExpectedItem>(
      this as ExpectedItem,
    );
  }

  Map<String, dynamic> toMap() {
    return ExpectedItemMapper.ensureInitialized().encodeMap<ExpectedItem>(
      this as ExpectedItem,
    );
  }

  ExpectedItemCopyWith<ExpectedItem, ExpectedItem, ExpectedItem> get copyWith =>
      _ExpectedItemCopyWithImpl<ExpectedItem, ExpectedItem>(
        this as ExpectedItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ExpectedItemMapper.ensureInitialized().stringifyValue(
      this as ExpectedItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExpectedItemMapper.ensureInitialized().equalsValue(
      this as ExpectedItem,
      other,
    );
  }

  @override
  int get hashCode {
    return ExpectedItemMapper.ensureInitialized().hashValue(
      this as ExpectedItem,
    );
  }
}

extension ExpectedItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExpectedItem, $Out> {
  ExpectedItemCopyWith<$R, ExpectedItem, $Out> get $asExpectedItem =>
      $base.as((v, t, t2) => _ExpectedItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExpectedItemCopyWith<$R, $In extends ExpectedItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? ekkloMealName,
    String? ekkloFoodId,
    double? quantity,
    EkkloQuantityType? quantityType,
  });
  ExpectedItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExpectedItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExpectedItem, $Out>
    implements ExpectedItemCopyWith<$R, ExpectedItem, $Out> {
  _ExpectedItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExpectedItem> $mapper =
      ExpectedItemMapper.ensureInitialized();
  @override
  $R call({
    String? ekkloMealName,
    String? ekkloFoodId,
    double? quantity,
    EkkloQuantityType? quantityType,
  }) => $apply(
    FieldCopyWithData({
      if (ekkloMealName != null) #ekkloMealName: ekkloMealName,
      if (ekkloFoodId != null) #ekkloFoodId: ekkloFoodId,
      if (quantity != null) #quantity: quantity,
      if (quantityType != null) #quantityType: quantityType,
    }),
  );
  @override
  ExpectedItem $make(CopyWithData data) => ExpectedItem(
    ekkloMealName: data.get(#ekkloMealName, or: $value.ekkloMealName),
    ekkloFoodId: data.get(#ekkloFoodId, or: $value.ekkloFoodId),
    quantity: data.get(#quantity, or: $value.quantity),
    quantityType: data.get(#quantityType, or: $value.quantityType),
  );

  @override
  ExpectedItemCopyWith<$R2, ExpectedItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExpectedItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

