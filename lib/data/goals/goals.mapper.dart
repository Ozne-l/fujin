// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'goals.dart';

class GoalsMapper extends ClassMapperBase<Goals> {
  GoalsMapper._();

  static GoalsMapper? _instance;
  static GoalsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GoalsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Goals';

  static double _$kilocalories(Goals v) => v.kilocalories;
  static const Field<Goals, double> _f$kilocalories = Field(
    'kilocalories',
    _$kilocalories,
  );
  static double? _$protein(Goals v) => v.protein;
  static const Field<Goals, double> _f$protein = Field(
    'protein',
    _$protein,
    opt: true,
  );
  static double? _$carbohydrates(Goals v) => v.carbohydrates;
  static const Field<Goals, double> _f$carbohydrates = Field(
    'carbohydrates',
    _$carbohydrates,
    opt: true,
  );
  static double? _$fat(Goals v) => v.fat;
  static const Field<Goals, double> _f$fat = Field('fat', _$fat, opt: true);
  static double? _$fiber(Goals v) => v.fiber;
  static const Field<Goals, double> _f$fiber = Field(
    'fiber',
    _$fiber,
    opt: true,
  );

  @override
  final MappableFields<Goals> fields = const {
    #kilocalories: _f$kilocalories,
    #protein: _f$protein,
    #carbohydrates: _f$carbohydrates,
    #fat: _f$fat,
    #fiber: _f$fiber,
  };
  @override
  final bool ignoreNull = true;

  static Goals _instantiate(DecodingData data) {
    return Goals(
      kilocalories: data.dec(_f$kilocalories),
      protein: data.dec(_f$protein),
      carbohydrates: data.dec(_f$carbohydrates),
      fat: data.dec(_f$fat),
      fiber: data.dec(_f$fiber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Goals fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Goals>(map);
  }

  static Goals fromJson(String json) {
    return ensureInitialized().decodeJson<Goals>(json);
  }
}

mixin GoalsMappable {
  String toJson() {
    return GoalsMapper.ensureInitialized().encodeJson<Goals>(this as Goals);
  }

  Map<String, dynamic> toMap() {
    return GoalsMapper.ensureInitialized().encodeMap<Goals>(this as Goals);
  }

  GoalsCopyWith<Goals, Goals, Goals> get copyWith =>
      _GoalsCopyWithImpl<Goals, Goals>(this as Goals, $identity, $identity);
  @override
  String toString() {
    return GoalsMapper.ensureInitialized().stringifyValue(this as Goals);
  }

  @override
  bool operator ==(Object other) {
    return GoalsMapper.ensureInitialized().equalsValue(this as Goals, other);
  }

  @override
  int get hashCode {
    return GoalsMapper.ensureInitialized().hashValue(this as Goals);
  }
}

extension GoalsValueCopy<$R, $Out> on ObjectCopyWith<$R, Goals, $Out> {
  GoalsCopyWith<$R, Goals, $Out> get $asGoals =>
      $base.as((v, t, t2) => _GoalsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GoalsCopyWith<$R, $In extends Goals, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    double? kilocalories,
    double? protein,
    double? carbohydrates,
    double? fat,
    double? fiber,
  });
  GoalsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GoalsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Goals, $Out>
    implements GoalsCopyWith<$R, Goals, $Out> {
  _GoalsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Goals> $mapper = GoalsMapper.ensureInitialized();
  @override
  $R call({
    double? kilocalories,
    Object? protein = $none,
    Object? carbohydrates = $none,
    Object? fat = $none,
    Object? fiber = $none,
  }) => $apply(
    FieldCopyWithData({
      if (kilocalories != null) #kilocalories: kilocalories,
      if (protein != $none) #protein: protein,
      if (carbohydrates != $none) #carbohydrates: carbohydrates,
      if (fat != $none) #fat: fat,
      if (fiber != $none) #fiber: fiber,
    }),
  );
  @override
  Goals $make(CopyWithData data) => Goals(
    kilocalories: data.get(#kilocalories, or: $value.kilocalories),
    protein: data.get(#protein, or: $value.protein),
    carbohydrates: data.get(#carbohydrates, or: $value.carbohydrates),
    fat: data.get(#fat, or: $value.fat),
    fiber: data.get(#fiber, or: $value.fiber),
  );

  @override
  GoalsCopyWith<$R2, Goals, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GoalsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

