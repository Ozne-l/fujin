// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'goal_period.dart';

class GoalPeriodMapper extends ClassMapperBase<GoalPeriod> {
  GoalPeriodMapper._();

  static GoalPeriodMapper? _instance;
  static GoalPeriodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GoalPeriodMapper._());
      GoalsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GoalPeriod';

  static DateTime _$startsOn(GoalPeriod v) => v.startsOn;
  static const Field<GoalPeriod, DateTime> _f$startsOn = Field(
    'startsOn',
    _$startsOn,
    key: r'starts_on',
    hook: CalendarDateHook(),
  );
  static Goals _$goals(GoalPeriod v) => v.goals;
  static const Field<GoalPeriod, Goals> _f$goals = Field('goals', _$goals);

  @override
  final MappableFields<GoalPeriod> fields = const {
    #startsOn: _f$startsOn,
    #goals: _f$goals,
  };
  @override
  final bool ignoreNull = true;

  @override
  final MappingHook hook = const FlatFieldHook(GoalPeriod._goals);
  static GoalPeriod _instantiate(DecodingData data) {
    return GoalPeriod(
      startsOn: data.dec(_f$startsOn),
      goals: data.dec(_f$goals),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GoalPeriod fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GoalPeriod>(map);
  }

  static GoalPeriod fromJson(String json) {
    return ensureInitialized().decodeJson<GoalPeriod>(json);
  }
}

mixin GoalPeriodMappable {
  String toJson() {
    return GoalPeriodMapper.ensureInitialized().encodeJson<GoalPeriod>(
      this as GoalPeriod,
    );
  }

  Map<String, dynamic> toMap() {
    return GoalPeriodMapper.ensureInitialized().encodeMap<GoalPeriod>(
      this as GoalPeriod,
    );
  }

  GoalPeriodCopyWith<GoalPeriod, GoalPeriod, GoalPeriod> get copyWith =>
      _GoalPeriodCopyWithImpl<GoalPeriod, GoalPeriod>(
        this as GoalPeriod,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return GoalPeriodMapper.ensureInitialized().stringifyValue(
      this as GoalPeriod,
    );
  }

  @override
  bool operator ==(Object other) {
    return GoalPeriodMapper.ensureInitialized().equalsValue(
      this as GoalPeriod,
      other,
    );
  }

  @override
  int get hashCode {
    return GoalPeriodMapper.ensureInitialized().hashValue(this as GoalPeriod);
  }
}

extension GoalPeriodValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GoalPeriod, $Out> {
  GoalPeriodCopyWith<$R, GoalPeriod, $Out> get $asGoalPeriod =>
      $base.as((v, t, t2) => _GoalPeriodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GoalPeriodCopyWith<$R, $In extends GoalPeriod, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  GoalsCopyWith<$R, Goals, Goals> get goals;
  $R call({DateTime? startsOn, Goals? goals});
  GoalPeriodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GoalPeriodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GoalPeriod, $Out>
    implements GoalPeriodCopyWith<$R, GoalPeriod, $Out> {
  _GoalPeriodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GoalPeriod> $mapper =
      GoalPeriodMapper.ensureInitialized();
  @override
  GoalsCopyWith<$R, Goals, Goals> get goals =>
      $value.goals.copyWith.$chain((v) => call(goals: v));
  @override
  $R call({DateTime? startsOn, Goals? goals}) => $apply(
    FieldCopyWithData({
      if (startsOn != null) #startsOn: startsOn,
      if (goals != null) #goals: goals,
    }),
  );
  @override
  GoalPeriod $make(CopyWithData data) => GoalPeriod(
    startsOn: data.get(#startsOn, or: $value.startsOn),
    goals: data.get(#goals, or: $value.goals),
  );

  @override
  GoalPeriodCopyWith<$R2, GoalPeriod, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _GoalPeriodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

