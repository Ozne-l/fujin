// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'undo_add_state.dart';

class UndoAddStateMapper extends ClassMapperBase<UndoAddState> {
  UndoAddStateMapper._();

  static UndoAddStateMapper? _instance;
  static UndoAddStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UndoAddStateMapper._());
      UndoAddIdleMapper.ensureInitialized();
      UndoAddRunningMapper.ensureInitialized();
      UndoAddDoneMapper.ensureInitialized();
      UndoAddFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UndoAddState';

  @override
  final MappableFields<UndoAddState> fields = const {};
  @override
  final bool ignoreNull = true;

  static UndoAddState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'UndoAddState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UndoAddState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UndoAddState>(map);
  }

  static UndoAddState fromJson(String json) {
    return ensureInitialized().decodeJson<UndoAddState>(json);
  }
}

mixin UndoAddStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  UndoAddStateCopyWith<UndoAddState, UndoAddState, UndoAddState> get copyWith;
}

abstract class UndoAddStateCopyWith<$R, $In extends UndoAddState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  UndoAddStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class UndoAddIdleMapper extends SubClassMapperBase<UndoAddIdle> {
  UndoAddIdleMapper._();

  static UndoAddIdleMapper? _instance;
  static UndoAddIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UndoAddIdleMapper._());
      UndoAddStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UndoAddIdle';

  @override
  final MappableFields<UndoAddIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      UndoAddStateMapper.ensureInitialized();

  static UndoAddIdle _instantiate(DecodingData data) {
    return UndoAddIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static UndoAddIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UndoAddIdle>(map);
  }

  static UndoAddIdle fromJson(String json) {
    return ensureInitialized().decodeJson<UndoAddIdle>(json);
  }
}

mixin UndoAddIdleMappable {
  String toJson() {
    return UndoAddIdleMapper.ensureInitialized().encodeJson<UndoAddIdle>(
      this as UndoAddIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return UndoAddIdleMapper.ensureInitialized().encodeMap<UndoAddIdle>(
      this as UndoAddIdle,
    );
  }

  UndoAddIdleCopyWith<UndoAddIdle, UndoAddIdle, UndoAddIdle> get copyWith =>
      _UndoAddIdleCopyWithImpl<UndoAddIdle, UndoAddIdle>(
        this as UndoAddIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UndoAddIdleMapper.ensureInitialized().stringifyValue(
      this as UndoAddIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return UndoAddIdleMapper.ensureInitialized().equalsValue(
      this as UndoAddIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return UndoAddIdleMapper.ensureInitialized().hashValue(this as UndoAddIdle);
  }
}

extension UndoAddIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UndoAddIdle, $Out> {
  UndoAddIdleCopyWith<$R, UndoAddIdle, $Out> get $asUndoAddIdle =>
      $base.as((v, t, t2) => _UndoAddIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UndoAddIdleCopyWith<$R, $In extends UndoAddIdle, $Out>
    implements UndoAddStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  UndoAddIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UndoAddIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UndoAddIdle, $Out>
    implements UndoAddIdleCopyWith<$R, UndoAddIdle, $Out> {
  _UndoAddIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UndoAddIdle> $mapper =
      UndoAddIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  UndoAddIdle $make(CopyWithData data) => UndoAddIdle();

  @override
  UndoAddIdleCopyWith<$R2, UndoAddIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UndoAddIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UndoAddRunningMapper extends SubClassMapperBase<UndoAddRunning> {
  UndoAddRunningMapper._();

  static UndoAddRunningMapper? _instance;
  static UndoAddRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UndoAddRunningMapper._());
      UndoAddStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UndoAddRunning';

  @override
  final MappableFields<UndoAddRunning> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      UndoAddStateMapper.ensureInitialized();

  static UndoAddRunning _instantiate(DecodingData data) {
    return UndoAddRunning();
  }

  @override
  final Function instantiate = _instantiate;

  static UndoAddRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UndoAddRunning>(map);
  }

  static UndoAddRunning fromJson(String json) {
    return ensureInitialized().decodeJson<UndoAddRunning>(json);
  }
}

mixin UndoAddRunningMappable {
  String toJson() {
    return UndoAddRunningMapper.ensureInitialized().encodeJson<UndoAddRunning>(
      this as UndoAddRunning,
    );
  }

  Map<String, dynamic> toMap() {
    return UndoAddRunningMapper.ensureInitialized().encodeMap<UndoAddRunning>(
      this as UndoAddRunning,
    );
  }

  UndoAddRunningCopyWith<UndoAddRunning, UndoAddRunning, UndoAddRunning>
  get copyWith => _UndoAddRunningCopyWithImpl<UndoAddRunning, UndoAddRunning>(
    this as UndoAddRunning,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UndoAddRunningMapper.ensureInitialized().stringifyValue(
      this as UndoAddRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return UndoAddRunningMapper.ensureInitialized().equalsValue(
      this as UndoAddRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return UndoAddRunningMapper.ensureInitialized().hashValue(
      this as UndoAddRunning,
    );
  }
}

extension UndoAddRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UndoAddRunning, $Out> {
  UndoAddRunningCopyWith<$R, UndoAddRunning, $Out> get $asUndoAddRunning =>
      $base.as((v, t, t2) => _UndoAddRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UndoAddRunningCopyWith<$R, $In extends UndoAddRunning, $Out>
    implements UndoAddStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  UndoAddRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UndoAddRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UndoAddRunning, $Out>
    implements UndoAddRunningCopyWith<$R, UndoAddRunning, $Out> {
  _UndoAddRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UndoAddRunning> $mapper =
      UndoAddRunningMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  UndoAddRunning $make(CopyWithData data) => UndoAddRunning();

  @override
  UndoAddRunningCopyWith<$R2, UndoAddRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UndoAddRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UndoAddDoneMapper extends SubClassMapperBase<UndoAddDone> {
  UndoAddDoneMapper._();

  static UndoAddDoneMapper? _instance;
  static UndoAddDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UndoAddDoneMapper._());
      UndoAddStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UndoAddDone';

  @override
  final MappableFields<UndoAddDone> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper =
      UndoAddStateMapper.ensureInitialized();

  static UndoAddDone _instantiate(DecodingData data) {
    return UndoAddDone();
  }

  @override
  final Function instantiate = _instantiate;

  static UndoAddDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UndoAddDone>(map);
  }

  static UndoAddDone fromJson(String json) {
    return ensureInitialized().decodeJson<UndoAddDone>(json);
  }
}

mixin UndoAddDoneMappable {
  String toJson() {
    return UndoAddDoneMapper.ensureInitialized().encodeJson<UndoAddDone>(
      this as UndoAddDone,
    );
  }

  Map<String, dynamic> toMap() {
    return UndoAddDoneMapper.ensureInitialized().encodeMap<UndoAddDone>(
      this as UndoAddDone,
    );
  }

  UndoAddDoneCopyWith<UndoAddDone, UndoAddDone, UndoAddDone> get copyWith =>
      _UndoAddDoneCopyWithImpl<UndoAddDone, UndoAddDone>(
        this as UndoAddDone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UndoAddDoneMapper.ensureInitialized().stringifyValue(
      this as UndoAddDone,
    );
  }

  @override
  bool operator ==(Object other) {
    return UndoAddDoneMapper.ensureInitialized().equalsValue(
      this as UndoAddDone,
      other,
    );
  }

  @override
  int get hashCode {
    return UndoAddDoneMapper.ensureInitialized().hashValue(this as UndoAddDone);
  }
}

extension UndoAddDoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UndoAddDone, $Out> {
  UndoAddDoneCopyWith<$R, UndoAddDone, $Out> get $asUndoAddDone =>
      $base.as((v, t, t2) => _UndoAddDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UndoAddDoneCopyWith<$R, $In extends UndoAddDone, $Out>
    implements UndoAddStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  UndoAddDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UndoAddDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UndoAddDone, $Out>
    implements UndoAddDoneCopyWith<$R, UndoAddDone, $Out> {
  _UndoAddDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UndoAddDone> $mapper =
      UndoAddDoneMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  UndoAddDone $make(CopyWithData data) => UndoAddDone();

  @override
  UndoAddDoneCopyWith<$R2, UndoAddDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UndoAddDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UndoAddFailedMapper extends SubClassMapperBase<UndoAddFailed> {
  UndoAddFailedMapper._();

  static UndoAddFailedMapper? _instance;
  static UndoAddFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UndoAddFailedMapper._());
      UndoAddStateMapper.ensureInitialized().addSubMapper(_instance!);
      AddedFoodMapper.ensureInitialized();
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UndoAddFailed';

  static AddedFood _$added(UndoAddFailed v) => v.added;
  static const Field<UndoAddFailed, AddedFood> _f$added = Field(
    'added',
    _$added,
  );
  static ReadProblem _$problem(UndoAddFailed v) => v.problem;
  static const Field<UndoAddFailed, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );
  static bool _$removedFromEkklo(UndoAddFailed v) => v.removedFromEkklo;
  static const Field<UndoAddFailed, bool> _f$removedFromEkklo = Field(
    'removedFromEkklo',
    _$removedFromEkklo,
    key: r'removed_from_ekklo',
  );

  @override
  final MappableFields<UndoAddFailed> fields = const {
    #added: _f$added,
    #problem: _f$problem,
    #removedFromEkklo: _f$removedFromEkklo,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      UndoAddStateMapper.ensureInitialized();

  static UndoAddFailed _instantiate(DecodingData data) {
    return UndoAddFailed(
      data.dec(_f$added),
      data.dec(_f$problem),
      removedFromEkklo: data.dec(_f$removedFromEkklo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UndoAddFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UndoAddFailed>(map);
  }

  static UndoAddFailed fromJson(String json) {
    return ensureInitialized().decodeJson<UndoAddFailed>(json);
  }
}

mixin UndoAddFailedMappable {
  String toJson() {
    return UndoAddFailedMapper.ensureInitialized().encodeJson<UndoAddFailed>(
      this as UndoAddFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return UndoAddFailedMapper.ensureInitialized().encodeMap<UndoAddFailed>(
      this as UndoAddFailed,
    );
  }

  UndoAddFailedCopyWith<UndoAddFailed, UndoAddFailed, UndoAddFailed>
  get copyWith => _UndoAddFailedCopyWithImpl<UndoAddFailed, UndoAddFailed>(
    this as UndoAddFailed,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UndoAddFailedMapper.ensureInitialized().stringifyValue(
      this as UndoAddFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return UndoAddFailedMapper.ensureInitialized().equalsValue(
      this as UndoAddFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return UndoAddFailedMapper.ensureInitialized().hashValue(
      this as UndoAddFailed,
    );
  }
}

extension UndoAddFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UndoAddFailed, $Out> {
  UndoAddFailedCopyWith<$R, UndoAddFailed, $Out> get $asUndoAddFailed =>
      $base.as((v, t, t2) => _UndoAddFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UndoAddFailedCopyWith<$R, $In extends UndoAddFailed, $Out>
    implements UndoAddStateCopyWith<$R, $In, $Out> {
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added;
  @override
  $R call({AddedFood? added, ReadProblem? problem, bool? removedFromEkklo});
  UndoAddFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UndoAddFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UndoAddFailed, $Out>
    implements UndoAddFailedCopyWith<$R, UndoAddFailed, $Out> {
  _UndoAddFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UndoAddFailed> $mapper =
      UndoAddFailedMapper.ensureInitialized();
  @override
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added =>
      $value.added.copyWith.$chain((v) => call(added: v));
  @override
  $R call({AddedFood? added, ReadProblem? problem, bool? removedFromEkklo}) =>
      $apply(
        FieldCopyWithData({
          if (added != null) #added: added,
          if (problem != null) #problem: problem,
          if (removedFromEkklo != null) #removedFromEkklo: removedFromEkklo,
        }),
      );
  @override
  UndoAddFailed $make(CopyWithData data) => UndoAddFailed(
    data.get(#added, or: $value.added),
    data.get(#problem, or: $value.problem),
    removedFromEkklo: data.get(#removedFromEkklo, or: $value.removedFromEkklo),
  );

  @override
  UndoAddFailedCopyWith<$R2, UndoAddFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UndoAddFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

