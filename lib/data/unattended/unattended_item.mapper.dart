// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'unattended_item.dart';

class UnattendedItemMapper extends ClassMapperBase<UnattendedItem> {
  UnattendedItemMapper._();

  static UnattendedItemMapper? _instance;
  static UnattendedItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UnattendedItemMapper._());
      EkkloQuantityTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UnattendedItem';

  static String _$mfpEntryId(UnattendedItem v) => v.mfpEntryId;
  static const Field<UnattendedItem, String> _f$mfpEntryId = Field(
    'mfpEntryId',
    _$mfpEntryId,
    key: r'mfp_entry_id',
  );
  static DateTime _$date(UnattendedItem v) => v.date;
  static const Field<UnattendedItem, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static String _$ekkloMealName(UnattendedItem v) => v.ekkloMealName;
  static const Field<UnattendedItem, String> _f$ekkloMealName = Field(
    'ekkloMealName',
    _$ekkloMealName,
    key: r'ekklo_meal_name',
  );
  static String _$ekkloFoodId(UnattendedItem v) => v.ekkloFoodId;
  static const Field<UnattendedItem, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'ekklo_food_id',
  );
  static double _$quantity(UnattendedItem v) => v.quantity;
  static const Field<UnattendedItem, double> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static EkkloQuantityType _$quantityType(UnattendedItem v) => v.quantityType;
  static const Field<UnattendedItem, EkkloQuantityType> _f$quantityType = Field(
    'quantityType',
    _$quantityType,
    key: r'quantity_type',
  );

  @override
  final MappableFields<UnattendedItem> fields = const {
    #mfpEntryId: _f$mfpEntryId,
    #date: _f$date,
    #ekkloMealName: _f$ekkloMealName,
    #ekkloFoodId: _f$ekkloFoodId,
    #quantity: _f$quantity,
    #quantityType: _f$quantityType,
  };
  @override
  final bool ignoreNull = true;

  static UnattendedItem _instantiate(DecodingData data) {
    return UnattendedItem(
      mfpEntryId: data.dec(_f$mfpEntryId),
      date: data.dec(_f$date),
      ekkloMealName: data.dec(_f$ekkloMealName),
      ekkloFoodId: data.dec(_f$ekkloFoodId),
      quantity: data.dec(_f$quantity),
      quantityType: data.dec(_f$quantityType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UnattendedItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UnattendedItem>(map);
  }

  static UnattendedItem fromJson(String json) {
    return ensureInitialized().decodeJson<UnattendedItem>(json);
  }
}

mixin UnattendedItemMappable {
  String toJson() {
    return UnattendedItemMapper.ensureInitialized().encodeJson<UnattendedItem>(
      this as UnattendedItem,
    );
  }

  Map<String, dynamic> toMap() {
    return UnattendedItemMapper.ensureInitialized().encodeMap<UnattendedItem>(
      this as UnattendedItem,
    );
  }

  UnattendedItemCopyWith<UnattendedItem, UnattendedItem, UnattendedItem>
  get copyWith => _UnattendedItemCopyWithImpl<UnattendedItem, UnattendedItem>(
    this as UnattendedItem,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UnattendedItemMapper.ensureInitialized().stringifyValue(
      this as UnattendedItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return UnattendedItemMapper.ensureInitialized().equalsValue(
      this as UnattendedItem,
      other,
    );
  }

  @override
  int get hashCode {
    return UnattendedItemMapper.ensureInitialized().hashValue(
      this as UnattendedItem,
    );
  }
}

extension UnattendedItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UnattendedItem, $Out> {
  UnattendedItemCopyWith<$R, UnattendedItem, $Out> get $asUnattendedItem =>
      $base.as((v, t, t2) => _UnattendedItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UnattendedItemCopyWith<$R, $In extends UnattendedItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? mfpEntryId,
    DateTime? date,
    String? ekkloMealName,
    String? ekkloFoodId,
    double? quantity,
    EkkloQuantityType? quantityType,
  });
  UnattendedItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UnattendedItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UnattendedItem, $Out>
    implements UnattendedItemCopyWith<$R, UnattendedItem, $Out> {
  _UnattendedItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UnattendedItem> $mapper =
      UnattendedItemMapper.ensureInitialized();
  @override
  $R call({
    String? mfpEntryId,
    DateTime? date,
    String? ekkloMealName,
    String? ekkloFoodId,
    double? quantity,
    EkkloQuantityType? quantityType,
  }) => $apply(
    FieldCopyWithData({
      if (mfpEntryId != null) #mfpEntryId: mfpEntryId,
      if (date != null) #date: date,
      if (ekkloMealName != null) #ekkloMealName: ekkloMealName,
      if (ekkloFoodId != null) #ekkloFoodId: ekkloFoodId,
      if (quantity != null) #quantity: quantity,
      if (quantityType != null) #quantityType: quantityType,
    }),
  );
  @override
  UnattendedItem $make(CopyWithData data) => UnattendedItem(
    mfpEntryId: data.get(#mfpEntryId, or: $value.mfpEntryId),
    date: data.get(#date, or: $value.date),
    ekkloMealName: data.get(#ekkloMealName, or: $value.ekkloMealName),
    ekkloFoodId: data.get(#ekkloFoodId, or: $value.ekkloFoodId),
    quantity: data.get(#quantity, or: $value.quantity),
    quantityType: data.get(#quantityType, or: $value.quantityType),
  );

  @override
  UnattendedItemCopyWith<$R2, UnattendedItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UnattendedItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

