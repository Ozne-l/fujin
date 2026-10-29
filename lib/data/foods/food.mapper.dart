// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'food.dart';

class FoodMapper extends ClassMapperBase<Food> {
  FoodMapper._();

  static FoodMapper? _instance;
  static FoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FoodMapper._());
      FoodNutrientsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Food';

  static String _$id(Food v) => v.id;
  static const Field<Food, String> _f$id = Field('id', _$id);
  static DateTime _$updatedAt(Food v) => v.updatedAt;
  static const Field<Food, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String? _$name(Food v) => v.name;
  static const Field<Food, String> _f$name = Field('name', _$name, opt: true);
  static String? _$brand(Food v) => v.brand;
  static const Field<Food, String> _f$brand = Field(
    'brand',
    _$brand,
    opt: true,
  );
  static FoodNutrients _$nutrients(Food v) => v.nutrients;
  static const Field<Food, FoodNutrients> _f$nutrients = Field(
    'nutrients',
    _$nutrients,
    opt: true,
    def: const FoodNutrients(),
  );
  static DateTime? _$deletedAt(Food v) => v.deletedAt;
  static const Field<Food, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<Food> fields = const {
    #id: _f$id,
    #updatedAt: _f$updatedAt,
    #name: _f$name,
    #brand: _f$brand,
    #nutrients: _f$nutrients,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final MappingHook hook = const FlatNutrientsHook();
  static Food _instantiate(DecodingData data) {
    return Food(
      id: data.dec(_f$id),
      updatedAt: data.dec(_f$updatedAt),
      name: data.dec(_f$name),
      brand: data.dec(_f$brand),
      nutrients: data.dec(_f$nutrients),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Food fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Food>(map);
  }

  static Food fromJson(String json) {
    return ensureInitialized().decodeJson<Food>(json);
  }
}

mixin FoodMappable {
  String toJson() {
    return FoodMapper.ensureInitialized().encodeJson<Food>(this as Food);
  }

  Map<String, dynamic> toMap() {
    return FoodMapper.ensureInitialized().encodeMap<Food>(this as Food);
  }

  FoodCopyWith<Food, Food, Food> get copyWith =>
      _FoodCopyWithImpl<Food, Food>(this as Food, $identity, $identity);
  @override
  String toString() {
    return FoodMapper.ensureInitialized().stringifyValue(this as Food);
  }

  @override
  bool operator ==(Object other) {
    return FoodMapper.ensureInitialized().equalsValue(this as Food, other);
  }

  @override
  int get hashCode {
    return FoodMapper.ensureInitialized().hashValue(this as Food);
  }
}

extension FoodValueCopy<$R, $Out> on ObjectCopyWith<$R, Food, $Out> {
  FoodCopyWith<$R, Food, $Out> get $asFood =>
      $base.as((v, t, t2) => _FoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FoodCopyWith<$R, $In extends Food, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  FoodNutrientsCopyWith<$R, FoodNutrients, FoodNutrients> get nutrients;
  $R call({
    String? id,
    DateTime? updatedAt,
    String? name,
    String? brand,
    FoodNutrients? nutrients,
    DateTime? deletedAt,
  });
  FoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FoodCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Food, $Out>
    implements FoodCopyWith<$R, Food, $Out> {
  _FoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Food> $mapper = FoodMapper.ensureInitialized();
  @override
  FoodNutrientsCopyWith<$R, FoodNutrients, FoodNutrients> get nutrients =>
      $value.nutrients.copyWith.$chain((v) => call(nutrients: v));
  @override
  $R call({
    String? id,
    DateTime? updatedAt,
    Object? name = $none,
    Object? brand = $none,
    FoodNutrients? nutrients,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (name != $none) #name: name,
      if (brand != $none) #brand: brand,
      if (nutrients != null) #nutrients: nutrients,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  Food $make(CopyWithData data) => Food(
    id: data.get(#id, or: $value.id),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    name: data.get(#name, or: $value.name),
    brand: data.get(#brand, or: $value.brand),
    nutrients: data.get(#nutrients, or: $value.nutrients),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  FoodCopyWith<$R2, Food, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

