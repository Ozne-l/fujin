// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food_barcode.dart';

class FoodBarcodeMapper extends ClassMapperBase<FoodBarcode> {
  FoodBarcodeMapper._();

  static FoodBarcodeMapper? _instance;
  static FoodBarcodeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodBarcodeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FoodBarcode';

  static String _$id(FoodBarcode v) => v.id;
  static const Field<FoodBarcode, String> _f$id = Field('id', _$id);
  static String _$barcode(FoodBarcode v) => v.barcode;
  static const Field<FoodBarcode, String> _f$barcode = Field(
    'barcode',
    _$barcode,
  );
  static String _$foodId(FoodBarcode v) => v.foodId;
  static const Field<FoodBarcode, String> _f$foodId = Field(
    'foodId',
    _$foodId,
    key: r'food_id',
  );
  static DateTime _$updatedAt(FoodBarcode v) => v.updatedAt;
  static const Field<FoodBarcode, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(FoodBarcode v) => v.deletedAt;
  static const Field<FoodBarcode, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<FoodBarcode> fields = const {
    #id: _f$id,
    #barcode: _f$barcode,
    #foodId: _f$foodId,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static FoodBarcode _instantiate(DecodingData data) {
    return FoodBarcode(
      id: data.dec(_f$id),
      barcode: data.dec(_f$barcode),
      foodId: data.dec(_f$foodId),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FoodBarcode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FoodBarcode>(map);
  }

  static FoodBarcode fromJson(String json) {
    return ensureInitialized().decodeJson<FoodBarcode>(json);
  }
}

mixin FoodBarcodeMappable {
  String toJson() {
    return FoodBarcodeMapper.ensureInitialized().encodeJson<FoodBarcode>(
      this as FoodBarcode,
    );
  }

  Map<String, dynamic> toMap() {
    return FoodBarcodeMapper.ensureInitialized().encodeMap<FoodBarcode>(
      this as FoodBarcode,
    );
  }

  FoodBarcodeCopyWith<FoodBarcode, FoodBarcode, FoodBarcode> get copyWith =>
      _FoodBarcodeCopyWithImpl<FoodBarcode, FoodBarcode>(
        this as FoodBarcode,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FoodBarcodeMapper.ensureInitialized().stringifyValue(
      this as FoodBarcode,
    );
  }

  @override
  bool operator ==(Object other) {
    return FoodBarcodeMapper.ensureInitialized().equalsValue(
      this as FoodBarcode,
      other,
    );
  }

  @override
  int get hashCode {
    return FoodBarcodeMapper.ensureInitialized().hashValue(this as FoodBarcode);
  }
}

extension FoodBarcodeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FoodBarcode, $Out> {
  FoodBarcodeCopyWith<$R, FoodBarcode, $Out> get $asFoodBarcode =>
      $base.as((v, t, t2) => _FoodBarcodeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FoodBarcodeCopyWith<$R, $In extends FoodBarcode, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? barcode,
    String? foodId,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  FoodBarcodeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FoodBarcodeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FoodBarcode, $Out>
    implements FoodBarcodeCopyWith<$R, FoodBarcode, $Out> {
  _FoodBarcodeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FoodBarcode> $mapper =
      FoodBarcodeMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? barcode,
    String? foodId,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (barcode != null) #barcode: barcode,
      if (foodId != null) #foodId: foodId,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  FoodBarcode $make(CopyWithData data) => FoodBarcode(
    id: data.get(#id, or: $value.id),
    barcode: data.get(#barcode, or: $value.barcode),
    foodId: data.get(#foodId, or: $value.foodId),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  FoodBarcodeCopyWith<$R2, FoodBarcode, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FoodBarcodeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

