// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'unattended_expectation.dart';

class UnattendedExpectationMapper
    extends ClassMapperBase<UnattendedExpectation> {
  UnattendedExpectationMapper._();

  static UnattendedExpectationMapper? _instance;
  static UnattendedExpectationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UnattendedExpectationMapper._());
      EkkloQuantityTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UnattendedExpectation';

  static String _$ekkloMealName(UnattendedExpectation v) => v.ekkloMealName;
  static const Field<UnattendedExpectation, String> _f$ekkloMealName = Field(
    'ekkloMealName',
    _$ekkloMealName,
    key: r'unattended_meal_name',
  );
  static String _$ekkloFoodId(UnattendedExpectation v) => v.ekkloFoodId;
  static const Field<UnattendedExpectation, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'unattended_food_id',
  );
  static double _$quantity(UnattendedExpectation v) => v.quantity;
  static const Field<UnattendedExpectation, double> _f$quantity = Field(
    'quantity',
    _$quantity,
    key: r'unattended_quantity',
  );
  static EkkloQuantityType _$quantityType(UnattendedExpectation v) =>
      v.quantityType;
  static const Field<UnattendedExpectation, EkkloQuantityType> _f$quantityType =
      Field('quantityType', _$quantityType, key: r'unattended_quantity_type');

  @override
  final MappableFields<UnattendedExpectation> fields = const {
    #ekkloMealName: _f$ekkloMealName,
    #ekkloFoodId: _f$ekkloFoodId,
    #quantity: _f$quantity,
    #quantityType: _f$quantityType,
  };
  @override
  final bool ignoreNull = true;

  static UnattendedExpectation _instantiate(DecodingData data) {
    return UnattendedExpectation(
      ekkloMealName: data.dec(_f$ekkloMealName),
      ekkloFoodId: data.dec(_f$ekkloFoodId),
      quantity: data.dec(_f$quantity),
      quantityType: data.dec(_f$quantityType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UnattendedExpectation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UnattendedExpectation>(map);
  }

  static UnattendedExpectation fromJson(String json) {
    return ensureInitialized().decodeJson<UnattendedExpectation>(json);
  }
}

mixin UnattendedExpectationMappable {
  String toJson() {
    return UnattendedExpectationMapper.ensureInitialized()
        .encodeJson<UnattendedExpectation>(this as UnattendedExpectation);
  }

  Map<String, dynamic> toMap() {
    return UnattendedExpectationMapper.ensureInitialized()
        .encodeMap<UnattendedExpectation>(this as UnattendedExpectation);
  }

  UnattendedExpectationCopyWith<
    UnattendedExpectation,
    UnattendedExpectation,
    UnattendedExpectation
  >
  get copyWith =>
      _UnattendedExpectationCopyWithImpl<
        UnattendedExpectation,
        UnattendedExpectation
      >(this as UnattendedExpectation, $identity, $identity);
  @override
  String toString() {
    return UnattendedExpectationMapper.ensureInitialized().stringifyValue(
      this as UnattendedExpectation,
    );
  }

  @override
  bool operator ==(Object other) {
    return UnattendedExpectationMapper.ensureInitialized().equalsValue(
      this as UnattendedExpectation,
      other,
    );
  }

  @override
  int get hashCode {
    return UnattendedExpectationMapper.ensureInitialized().hashValue(
      this as UnattendedExpectation,
    );
  }
}

extension UnattendedExpectationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UnattendedExpectation, $Out> {
  UnattendedExpectationCopyWith<$R, UnattendedExpectation, $Out>
  get $asUnattendedExpectation => $base.as(
    (v, t, t2) => _UnattendedExpectationCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UnattendedExpectationCopyWith<
  $R,
  $In extends UnattendedExpectation,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? ekkloMealName,
    String? ekkloFoodId,
    double? quantity,
    EkkloQuantityType? quantityType,
  });
  UnattendedExpectationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UnattendedExpectationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UnattendedExpectation, $Out>
    implements UnattendedExpectationCopyWith<$R, UnattendedExpectation, $Out> {
  _UnattendedExpectationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UnattendedExpectation> $mapper =
      UnattendedExpectationMapper.ensureInitialized();
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
  UnattendedExpectation $make(CopyWithData data) => UnattendedExpectation(
    ekkloMealName: data.get(#ekkloMealName, or: $value.ekkloMealName),
    ekkloFoodId: data.get(#ekkloFoodId, or: $value.ekkloFoodId),
    quantity: data.get(#quantity, or: $value.quantity),
    quantityType: data.get(#quantityType, or: $value.quantityType),
  );

  @override
  UnattendedExpectationCopyWith<$R2, UnattendedExpectation, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UnattendedExpectationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

