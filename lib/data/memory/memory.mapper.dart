// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'memory.dart';

class MemoryMapper extends ClassMapperBase<Memory> {
  MemoryMapper._();

  static MemoryMapper? _instance;
  static MemoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MemoryMapper._());
      MatchedFoodMapper.ensureInitialized();
      OwnCopyMapper.ensureInitialized();
      RememberedUnitMapper.ensureInitialized();
      MealMappingMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Memory';

  static List<MatchedFood> _$matches(Memory v) => v.matches;
  static const Field<Memory, List<MatchedFood>> _f$matches = Field(
    'matches',
    _$matches,
    opt: true,
    def: const [],
  );
  static List<OwnCopy> _$ownCopies(Memory v) => v.ownCopies;
  static const Field<Memory, List<OwnCopy>> _f$ownCopies = Field(
    'ownCopies',
    _$ownCopies,
    key: r'own_copies',
    opt: true,
    def: const [],
  );
  static List<RememberedUnit> _$units(Memory v) => v.units;
  static const Field<Memory, List<RememberedUnit>> _f$units = Field(
    'units',
    _$units,
    opt: true,
    def: const [],
  );
  static List<MealMapping> _$meals(Memory v) => v.meals;
  static const Field<Memory, List<MealMapping>> _f$meals = Field(
    'meals',
    _$meals,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<Memory> fields = const {
    #matches: _f$matches,
    #ownCopies: _f$ownCopies,
    #units: _f$units,
    #meals: _f$meals,
  };
  @override
  final bool ignoreNull = true;

  static Memory _instantiate(DecodingData data) {
    return Memory(
      matches: data.dec(_f$matches),
      ownCopies: data.dec(_f$ownCopies),
      units: data.dec(_f$units),
      meals: data.dec(_f$meals),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Memory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Memory>(map);
  }

  static Memory fromJson(String json) {
    return ensureInitialized().decodeJson<Memory>(json);
  }
}

mixin MemoryMappable {
  String toJson() {
    return MemoryMapper.ensureInitialized().encodeJson<Memory>(this as Memory);
  }

  Map<String, dynamic> toMap() {
    return MemoryMapper.ensureInitialized().encodeMap<Memory>(this as Memory);
  }

  MemoryCopyWith<Memory, Memory, Memory> get copyWith =>
      _MemoryCopyWithImpl<Memory, Memory>(this as Memory, $identity, $identity);
  @override
  String toString() {
    return MemoryMapper.ensureInitialized().stringifyValue(this as Memory);
  }

  @override
  bool operator ==(Object other) {
    return MemoryMapper.ensureInitialized().equalsValue(this as Memory, other);
  }

  @override
  int get hashCode {
    return MemoryMapper.ensureInitialized().hashValue(this as Memory);
  }
}

extension MemoryValueCopy<$R, $Out> on ObjectCopyWith<$R, Memory, $Out> {
  MemoryCopyWith<$R, Memory, $Out> get $asMemory =>
      $base.as((v, t, t2) => _MemoryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MemoryCopyWith<$R, $In extends Memory, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MatchedFood,
    MatchedFoodCopyWith<$R, MatchedFood, MatchedFood>
  >
  get matches;
  ListCopyWith<$R, OwnCopy, OwnCopyCopyWith<$R, OwnCopy, OwnCopy>>
  get ownCopies;
  ListCopyWith<
    $R,
    RememberedUnit,
    RememberedUnitCopyWith<$R, RememberedUnit, RememberedUnit>
  >
  get units;
  ListCopyWith<
    $R,
    MealMapping,
    MealMappingCopyWith<$R, MealMapping, MealMapping>
  >
  get meals;
  $R call({
    List<MatchedFood>? matches,
    List<OwnCopy>? ownCopies,
    List<RememberedUnit>? units,
    List<MealMapping>? meals,
  });
  MemoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MemoryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Memory, $Out>
    implements MemoryCopyWith<$R, Memory, $Out> {
  _MemoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Memory> $mapper = MemoryMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MatchedFood,
    MatchedFoodCopyWith<$R, MatchedFood, MatchedFood>
  >
  get matches => ListCopyWith(
    $value.matches,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(matches: v),
  );
  @override
  ListCopyWith<$R, OwnCopy, OwnCopyCopyWith<$R, OwnCopy, OwnCopy>>
  get ownCopies => ListCopyWith(
    $value.ownCopies,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ownCopies: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedUnit,
    RememberedUnitCopyWith<$R, RememberedUnit, RememberedUnit>
  >
  get units => ListCopyWith(
    $value.units,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(units: v),
  );
  @override
  ListCopyWith<
    $R,
    MealMapping,
    MealMappingCopyWith<$R, MealMapping, MealMapping>
  >
  get meals => ListCopyWith(
    $value.meals,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(meals: v),
  );
  @override
  $R call({
    List<MatchedFood>? matches,
    List<OwnCopy>? ownCopies,
    List<RememberedUnit>? units,
    List<MealMapping>? meals,
  }) => $apply(
    FieldCopyWithData({
      if (matches != null) #matches: matches,
      if (ownCopies != null) #ownCopies: ownCopies,
      if (units != null) #units: units,
      if (meals != null) #meals: meals,
    }),
  );
  @override
  Memory $make(CopyWithData data) => Memory(
    matches: data.get(#matches, or: $value.matches),
    ownCopies: data.get(#ownCopies, or: $value.ownCopies),
    units: data.get(#units, or: $value.units),
    meals: data.get(#meals, or: $value.meals),
  );

  @override
  MemoryCopyWith<$R2, Memory, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MemoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

