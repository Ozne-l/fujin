// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'add_write_state.dart';

class AddWriteStateMapper extends ClassMapperBase<AddWriteState> {
  AddWriteStateMapper._();

  static AddWriteStateMapper? _instance;
  static AddWriteStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddWriteStateMapper._());
      AddWriteIdleMapper.ensureInitialized();
      AddWriteRunningMapper.ensureInitialized();
      AddWriteDoneMapper.ensureInitialized();
      AddWriteFailedMapper.ensureInitialized();
      AddWriteEkkloFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddWriteState';

  @override
  final MappableFields<AddWriteState> fields = const {};
  @override
  final bool ignoreNull = true;

  static AddWriteState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'AddWriteState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddWriteState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddWriteState>(map);
  }

  static AddWriteState fromJson(String json) {
    return ensureInitialized().decodeJson<AddWriteState>(json);
  }
}

mixin AddWriteStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  AddWriteStateCopyWith<AddWriteState, AddWriteState, AddWriteState>
  get copyWith;
}

abstract class AddWriteStateCopyWith<$R, $In extends AddWriteState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  AddWriteStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class AddWriteIdleMapper extends SubClassMapperBase<AddWriteIdle> {
  AddWriteIdleMapper._();

  static AddWriteIdleMapper? _instance;
  static AddWriteIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddWriteIdleMapper._());
      AddWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'AddWriteIdle';

  @override
  final MappableFields<AddWriteIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      AddWriteStateMapper.ensureInitialized();

  static AddWriteIdle _instantiate(DecodingData data) {
    return AddWriteIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static AddWriteIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddWriteIdle>(map);
  }

  static AddWriteIdle fromJson(String json) {
    return ensureInitialized().decodeJson<AddWriteIdle>(json);
  }
}

mixin AddWriteIdleMappable {
  String toJson() {
    return AddWriteIdleMapper.ensureInitialized().encodeJson<AddWriteIdle>(
      this as AddWriteIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return AddWriteIdleMapper.ensureInitialized().encodeMap<AddWriteIdle>(
      this as AddWriteIdle,
    );
  }

  AddWriteIdleCopyWith<AddWriteIdle, AddWriteIdle, AddWriteIdle> get copyWith =>
      _AddWriteIdleCopyWithImpl<AddWriteIdle, AddWriteIdle>(
        this as AddWriteIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddWriteIdleMapper.ensureInitialized().stringifyValue(
      this as AddWriteIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddWriteIdleMapper.ensureInitialized().equalsValue(
      this as AddWriteIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return AddWriteIdleMapper.ensureInitialized().hashValue(
      this as AddWriteIdle,
    );
  }
}

extension AddWriteIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddWriteIdle, $Out> {
  AddWriteIdleCopyWith<$R, AddWriteIdle, $Out> get $asAddWriteIdle =>
      $base.as((v, t, t2) => _AddWriteIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddWriteIdleCopyWith<$R, $In extends AddWriteIdle, $Out>
    implements AddWriteStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AddWriteIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddWriteIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddWriteIdle, $Out>
    implements AddWriteIdleCopyWith<$R, AddWriteIdle, $Out> {
  _AddWriteIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddWriteIdle> $mapper =
      AddWriteIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AddWriteIdle $make(CopyWithData data) => AddWriteIdle();

  @override
  AddWriteIdleCopyWith<$R2, AddWriteIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddWriteIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddWriteRunningMapper extends SubClassMapperBase<AddWriteRunning> {
  AddWriteRunningMapper._();

  static AddWriteRunningMapper? _instance;
  static AddWriteRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddWriteRunningMapper._());
      AddWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
      AddStageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddWriteRunning';

  static AddStage _$stage(AddWriteRunning v) => v.stage;
  static const Field<AddWriteRunning, AddStage> _f$stage = Field(
    'stage',
    _$stage,
  );

  @override
  final MappableFields<AddWriteRunning> fields = const {#stage: _f$stage};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      AddWriteStateMapper.ensureInitialized();

  static AddWriteRunning _instantiate(DecodingData data) {
    return AddWriteRunning(data.dec(_f$stage));
  }

  @override
  final Function instantiate = _instantiate;

  static AddWriteRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddWriteRunning>(map);
  }

  static AddWriteRunning fromJson(String json) {
    return ensureInitialized().decodeJson<AddWriteRunning>(json);
  }
}

mixin AddWriteRunningMappable {
  String toJson() {
    return AddWriteRunningMapper.ensureInitialized()
        .encodeJson<AddWriteRunning>(this as AddWriteRunning);
  }

  Map<String, dynamic> toMap() {
    return AddWriteRunningMapper.ensureInitialized().encodeMap<AddWriteRunning>(
      this as AddWriteRunning,
    );
  }

  AddWriteRunningCopyWith<AddWriteRunning, AddWriteRunning, AddWriteRunning>
  get copyWith =>
      _AddWriteRunningCopyWithImpl<AddWriteRunning, AddWriteRunning>(
        this as AddWriteRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddWriteRunningMapper.ensureInitialized().stringifyValue(
      this as AddWriteRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddWriteRunningMapper.ensureInitialized().equalsValue(
      this as AddWriteRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return AddWriteRunningMapper.ensureInitialized().hashValue(
      this as AddWriteRunning,
    );
  }
}

extension AddWriteRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddWriteRunning, $Out> {
  AddWriteRunningCopyWith<$R, AddWriteRunning, $Out> get $asAddWriteRunning =>
      $base.as((v, t, t2) => _AddWriteRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddWriteRunningCopyWith<$R, $In extends AddWriteRunning, $Out>
    implements AddWriteStateCopyWith<$R, $In, $Out> {
  @override
  $R call({AddStage? stage});
  AddWriteRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddWriteRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddWriteRunning, $Out>
    implements AddWriteRunningCopyWith<$R, AddWriteRunning, $Out> {
  _AddWriteRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddWriteRunning> $mapper =
      AddWriteRunningMapper.ensureInitialized();
  @override
  $R call({AddStage? stage}) =>
      $apply(FieldCopyWithData({if (stage != null) #stage: stage}));
  @override
  AddWriteRunning $make(CopyWithData data) =>
      AddWriteRunning(data.get(#stage, or: $value.stage));

  @override
  AddWriteRunningCopyWith<$R2, AddWriteRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddWriteRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddWriteDoneMapper extends SubClassMapperBase<AddWriteDone> {
  AddWriteDoneMapper._();

  static AddWriteDoneMapper? _instance;
  static AddWriteDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddWriteDoneMapper._());
      AddWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
      AddedFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddWriteDone';

  static AddedFood _$added(AddWriteDone v) => v.added;
  static const Field<AddWriteDone, AddedFood> _f$added = Field(
    'added',
    _$added,
  );

  @override
  final MappableFields<AddWriteDone> fields = const {#added: _f$added};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper =
      AddWriteStateMapper.ensureInitialized();

  static AddWriteDone _instantiate(DecodingData data) {
    return AddWriteDone(data.dec(_f$added));
  }

  @override
  final Function instantiate = _instantiate;

  static AddWriteDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddWriteDone>(map);
  }

  static AddWriteDone fromJson(String json) {
    return ensureInitialized().decodeJson<AddWriteDone>(json);
  }
}

mixin AddWriteDoneMappable {
  String toJson() {
    return AddWriteDoneMapper.ensureInitialized().encodeJson<AddWriteDone>(
      this as AddWriteDone,
    );
  }

  Map<String, dynamic> toMap() {
    return AddWriteDoneMapper.ensureInitialized().encodeMap<AddWriteDone>(
      this as AddWriteDone,
    );
  }

  AddWriteDoneCopyWith<AddWriteDone, AddWriteDone, AddWriteDone> get copyWith =>
      _AddWriteDoneCopyWithImpl<AddWriteDone, AddWriteDone>(
        this as AddWriteDone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddWriteDoneMapper.ensureInitialized().stringifyValue(
      this as AddWriteDone,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddWriteDoneMapper.ensureInitialized().equalsValue(
      this as AddWriteDone,
      other,
    );
  }

  @override
  int get hashCode {
    return AddWriteDoneMapper.ensureInitialized().hashValue(
      this as AddWriteDone,
    );
  }
}

extension AddWriteDoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddWriteDone, $Out> {
  AddWriteDoneCopyWith<$R, AddWriteDone, $Out> get $asAddWriteDone =>
      $base.as((v, t, t2) => _AddWriteDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddWriteDoneCopyWith<$R, $In extends AddWriteDone, $Out>
    implements AddWriteStateCopyWith<$R, $In, $Out> {
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added;
  @override
  $R call({AddedFood? added});
  AddWriteDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddWriteDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddWriteDone, $Out>
    implements AddWriteDoneCopyWith<$R, AddWriteDone, $Out> {
  _AddWriteDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddWriteDone> $mapper =
      AddWriteDoneMapper.ensureInitialized();
  @override
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added =>
      $value.added.copyWith.$chain((v) => call(added: v));
  @override
  $R call({AddedFood? added}) =>
      $apply(FieldCopyWithData({if (added != null) #added: added}));
  @override
  AddWriteDone $make(CopyWithData data) =>
      AddWriteDone(data.get(#added, or: $value.added));

  @override
  AddWriteDoneCopyWith<$R2, AddWriteDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddWriteDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddWriteFailedMapper extends SubClassMapperBase<AddWriteFailed> {
  AddWriteFailedMapper._();

  static AddWriteFailedMapper? _instance;
  static AddWriteFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddWriteFailedMapper._());
      AddWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddWriteFailed';

  static ReadProblem _$problem(AddWriteFailed v) => v.problem;
  static const Field<AddWriteFailed, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );
  static bool _$blockedInDev(AddWriteFailed v) => v.blockedInDev;
  static const Field<AddWriteFailed, bool> _f$blockedInDev = Field(
    'blockedInDev',
    _$blockedInDev,
    key: r'blocked_in_dev',
  );

  @override
  final MappableFields<AddWriteFailed> fields = const {
    #problem: _f$problem,
    #blockedInDev: _f$blockedInDev,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      AddWriteStateMapper.ensureInitialized();

  static AddWriteFailed _instantiate(DecodingData data) {
    return AddWriteFailed(
      data.dec(_f$problem),
      blockedInDev: data.dec(_f$blockedInDev),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddWriteFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddWriteFailed>(map);
  }

  static AddWriteFailed fromJson(String json) {
    return ensureInitialized().decodeJson<AddWriteFailed>(json);
  }
}

mixin AddWriteFailedMappable {
  String toJson() {
    return AddWriteFailedMapper.ensureInitialized().encodeJson<AddWriteFailed>(
      this as AddWriteFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return AddWriteFailedMapper.ensureInitialized().encodeMap<AddWriteFailed>(
      this as AddWriteFailed,
    );
  }

  AddWriteFailedCopyWith<AddWriteFailed, AddWriteFailed, AddWriteFailed>
  get copyWith => _AddWriteFailedCopyWithImpl<AddWriteFailed, AddWriteFailed>(
    this as AddWriteFailed,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return AddWriteFailedMapper.ensureInitialized().stringifyValue(
      this as AddWriteFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddWriteFailedMapper.ensureInitialized().equalsValue(
      this as AddWriteFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return AddWriteFailedMapper.ensureInitialized().hashValue(
      this as AddWriteFailed,
    );
  }
}

extension AddWriteFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddWriteFailed, $Out> {
  AddWriteFailedCopyWith<$R, AddWriteFailed, $Out> get $asAddWriteFailed =>
      $base.as((v, t, t2) => _AddWriteFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddWriteFailedCopyWith<$R, $In extends AddWriteFailed, $Out>
    implements AddWriteStateCopyWith<$R, $In, $Out> {
  @override
  $R call({ReadProblem? problem, bool? blockedInDev});
  AddWriteFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddWriteFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddWriteFailed, $Out>
    implements AddWriteFailedCopyWith<$R, AddWriteFailed, $Out> {
  _AddWriteFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddWriteFailed> $mapper =
      AddWriteFailedMapper.ensureInitialized();
  @override
  $R call({ReadProblem? problem, bool? blockedInDev}) => $apply(
    FieldCopyWithData({
      if (problem != null) #problem: problem,
      if (blockedInDev != null) #blockedInDev: blockedInDev,
    }),
  );
  @override
  AddWriteFailed $make(CopyWithData data) => AddWriteFailed(
    data.get(#problem, or: $value.problem),
    blockedInDev: data.get(#blockedInDev, or: $value.blockedInDev),
  );

  @override
  AddWriteFailedCopyWith<$R2, AddWriteFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddWriteFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddWriteEkkloFailedMapper
    extends SubClassMapperBase<AddWriteEkkloFailed> {
  AddWriteEkkloFailedMapper._();

  static AddWriteEkkloFailedMapper? _instance;
  static AddWriteEkkloFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddWriteEkkloFailedMapper._());
      AddWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
      AddedFoodMapper.ensureInitialized();
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddWriteEkkloFailed';

  static AddedFood _$added(AddWriteEkkloFailed v) => v.added;
  static const Field<AddWriteEkkloFailed, AddedFood> _f$added = Field(
    'added',
    _$added,
  );
  static ReadProblem _$problem(AddWriteEkkloFailed v) => v.problem;
  static const Field<AddWriteEkkloFailed, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );
  static bool _$undoing(AddWriteEkkloFailed v) => v.undoing;
  static const Field<AddWriteEkkloFailed, bool> _f$undoing = Field(
    'undoing',
    _$undoing,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<AddWriteEkkloFailed> fields = const {
    #added: _f$added,
    #problem: _f$problem,
    #undoing: _f$undoing,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'ekklo_failed';
  @override
  late final ClassMapperBase superMapper =
      AddWriteStateMapper.ensureInitialized();

  static AddWriteEkkloFailed _instantiate(DecodingData data) {
    return AddWriteEkkloFailed(
      data.dec(_f$added),
      data.dec(_f$problem),
      undoing: data.dec(_f$undoing),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddWriteEkkloFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddWriteEkkloFailed>(map);
  }

  static AddWriteEkkloFailed fromJson(String json) {
    return ensureInitialized().decodeJson<AddWriteEkkloFailed>(json);
  }
}

mixin AddWriteEkkloFailedMappable {
  String toJson() {
    return AddWriteEkkloFailedMapper.ensureInitialized()
        .encodeJson<AddWriteEkkloFailed>(this as AddWriteEkkloFailed);
  }

  Map<String, dynamic> toMap() {
    return AddWriteEkkloFailedMapper.ensureInitialized()
        .encodeMap<AddWriteEkkloFailed>(this as AddWriteEkkloFailed);
  }

  AddWriteEkkloFailedCopyWith<
    AddWriteEkkloFailed,
    AddWriteEkkloFailed,
    AddWriteEkkloFailed
  >
  get copyWith =>
      _AddWriteEkkloFailedCopyWithImpl<
        AddWriteEkkloFailed,
        AddWriteEkkloFailed
      >(this as AddWriteEkkloFailed, $identity, $identity);
  @override
  String toString() {
    return AddWriteEkkloFailedMapper.ensureInitialized().stringifyValue(
      this as AddWriteEkkloFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddWriteEkkloFailedMapper.ensureInitialized().equalsValue(
      this as AddWriteEkkloFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return AddWriteEkkloFailedMapper.ensureInitialized().hashValue(
      this as AddWriteEkkloFailed,
    );
  }
}

extension AddWriteEkkloFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddWriteEkkloFailed, $Out> {
  AddWriteEkkloFailedCopyWith<$R, AddWriteEkkloFailed, $Out>
  get $asAddWriteEkkloFailed => $base.as(
    (v, t, t2) => _AddWriteEkkloFailedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AddWriteEkkloFailedCopyWith<
  $R,
  $In extends AddWriteEkkloFailed,
  $Out
>
    implements AddWriteStateCopyWith<$R, $In, $Out> {
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added;
  @override
  $R call({AddedFood? added, ReadProblem? problem, bool? undoing});
  AddWriteEkkloFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddWriteEkkloFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddWriteEkkloFailed, $Out>
    implements AddWriteEkkloFailedCopyWith<$R, AddWriteEkkloFailed, $Out> {
  _AddWriteEkkloFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddWriteEkkloFailed> $mapper =
      AddWriteEkkloFailedMapper.ensureInitialized();
  @override
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added =>
      $value.added.copyWith.$chain((v) => call(added: v));
  @override
  $R call({AddedFood? added, ReadProblem? problem, bool? undoing}) => $apply(
    FieldCopyWithData({
      if (added != null) #added: added,
      if (problem != null) #problem: problem,
      if (undoing != null) #undoing: undoing,
    }),
  );
  @override
  AddWriteEkkloFailed $make(CopyWithData data) => AddWriteEkkloFailed(
    data.get(#added, or: $value.added),
    data.get(#problem, or: $value.problem),
    undoing: data.get(#undoing, or: $value.undoing),
  );

  @override
  AddWriteEkkloFailedCopyWith<$R2, AddWriteEkkloFailed, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AddWriteEkkloFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

