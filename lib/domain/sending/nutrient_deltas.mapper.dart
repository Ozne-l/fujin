// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'nutrient_deltas.dart';

class NutrientDeltasMapper extends ClassMapperBase<NutrientDeltas> {
  NutrientDeltasMapper._();

  static NutrientDeltasMapper? _instance;
  static NutrientDeltasMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NutrientDeltasMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NutrientDeltas';

  static double _$entryKilocalories(NutrientDeltas v) => v.entryKilocalories;
  static const Field<NutrientDeltas, double> _f$entryKilocalories = Field(
    'entryKilocalories',
    _$entryKilocalories,
    key: r'entry_kilocalories',
  );
  static double _$kilocalories(NutrientDeltas v) => v.kilocalories;
  static const Field<NutrientDeltas, double> _f$kilocalories = Field(
    'kilocalories',
    _$kilocalories,
  );
  static double? _$protein(NutrientDeltas v) => v.protein;
  static const Field<NutrientDeltas, double> _f$protein = Field(
    'protein',
    _$protein,
    opt: true,
  );
  static double? _$carbohydrates(NutrientDeltas v) => v.carbohydrates;
  static const Field<NutrientDeltas, double> _f$carbohydrates = Field(
    'carbohydrates',
    _$carbohydrates,
    opt: true,
  );
  static double? _$fat(NutrientDeltas v) => v.fat;
  static const Field<NutrientDeltas, double> _f$fat = Field(
    'fat',
    _$fat,
    opt: true,
  );
  static double? _$fiber(NutrientDeltas v) => v.fiber;
  static const Field<NutrientDeltas, double> _f$fiber = Field(
    'fiber',
    _$fiber,
    opt: true,
  );

  @override
  final MappableFields<NutrientDeltas> fields = const {
    #entryKilocalories: _f$entryKilocalories,
    #kilocalories: _f$kilocalories,
    #protein: _f$protein,
    #carbohydrates: _f$carbohydrates,
    #fat: _f$fat,
    #fiber: _f$fiber,
  };
  @override
  final bool ignoreNull = true;

  static NutrientDeltas _instantiate(DecodingData data) {
    return NutrientDeltas(
      entryKilocalories: data.dec(_f$entryKilocalories),
      kilocalories: data.dec(_f$kilocalories),
      protein: data.dec(_f$protein),
      carbohydrates: data.dec(_f$carbohydrates),
      fat: data.dec(_f$fat),
      fiber: data.dec(_f$fiber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NutrientDeltas fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NutrientDeltas>(map);
  }

  static NutrientDeltas fromJson(String json) {
    return ensureInitialized().decodeJson<NutrientDeltas>(json);
  }
}

mixin NutrientDeltasMappable {
  String toJson() {
    return NutrientDeltasMapper.ensureInitialized().encodeJson<NutrientDeltas>(
      this as NutrientDeltas,
    );
  }

  Map<String, dynamic> toMap() {
    return NutrientDeltasMapper.ensureInitialized().encodeMap<NutrientDeltas>(
      this as NutrientDeltas,
    );
  }

  NutrientDeltasCopyWith<NutrientDeltas, NutrientDeltas, NutrientDeltas>
  get copyWith => _NutrientDeltasCopyWithImpl<NutrientDeltas, NutrientDeltas>(
    this as NutrientDeltas,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NutrientDeltasMapper.ensureInitialized().stringifyValue(
      this as NutrientDeltas,
    );
  }

  @override
  bool operator ==(Object other) {
    return NutrientDeltasMapper.ensureInitialized().equalsValue(
      this as NutrientDeltas,
      other,
    );
  }

  @override
  int get hashCode {
    return NutrientDeltasMapper.ensureInitialized().hashValue(
      this as NutrientDeltas,
    );
  }
}

extension NutrientDeltasValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NutrientDeltas, $Out> {
  NutrientDeltasCopyWith<$R, NutrientDeltas, $Out> get $asNutrientDeltas =>
      $base.as((v, t, t2) => _NutrientDeltasCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NutrientDeltasCopyWith<$R, $In extends NutrientDeltas, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    double? entryKilocalories,
    double? kilocalories,
    double? protein,
    double? carbohydrates,
    double? fat,
    double? fiber,
  });
  NutrientDeltasCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NutrientDeltasCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NutrientDeltas, $Out>
    implements NutrientDeltasCopyWith<$R, NutrientDeltas, $Out> {
  _NutrientDeltasCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NutrientDeltas> $mapper =
      NutrientDeltasMapper.ensureInitialized();
  @override
  $R call({
    double? entryKilocalories,
    double? kilocalories,
    Object? protein = $none,
    Object? carbohydrates = $none,
    Object? fat = $none,
    Object? fiber = $none,
  }) => $apply(
    FieldCopyWithData({
      if (entryKilocalories != null) #entryKilocalories: entryKilocalories,
      if (kilocalories != null) #kilocalories: kilocalories,
      if (protein != $none) #protein: protein,
      if (carbohydrates != $none) #carbohydrates: carbohydrates,
      if (fat != $none) #fat: fat,
      if (fiber != $none) #fiber: fiber,
    }),
  );
  @override
  NutrientDeltas $make(CopyWithData data) => NutrientDeltas(
    entryKilocalories: data.get(
      #entryKilocalories,
      or: $value.entryKilocalories,
    ),
    kilocalories: data.get(#kilocalories, or: $value.kilocalories),
    protein: data.get(#protein, or: $value.protein),
    carbohydrates: data.get(#carbohydrates, or: $value.carbohydrates),
    fat: data.get(#fat, or: $value.fat),
    fiber: data.get(#fiber, or: $value.fiber),
  );

  @override
  NutrientDeltasCopyWith<$R2, NutrientDeltas, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NutrientDeltasCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

