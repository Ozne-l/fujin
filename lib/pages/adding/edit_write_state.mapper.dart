// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'edit_write_state.dart';

class EditWriteStateMapper extends ClassMapperBase<EditWriteState> {
  EditWriteStateMapper._();

  static EditWriteStateMapper? _instance;
  static EditWriteStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditWriteStateMapper._());
      EditWriteIdleMapper.ensureInitialized();
      EditWriteRunningMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EditWriteState';

  @override
  final MappableFields<EditWriteState> fields = const {};
  @override
  final bool ignoreNull = true;

  static EditWriteState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'EditWriteState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditWriteState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditWriteState>(map);
  }

  static EditWriteState fromJson(String json) {
    return ensureInitialized().decodeJson<EditWriteState>(json);
  }
}

mixin EditWriteStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  EditWriteStateCopyWith<EditWriteState, EditWriteState, EditWriteState>
  get copyWith;
}

abstract class EditWriteStateCopyWith<$R, $In extends EditWriteState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  EditWriteStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class EditWriteIdleMapper extends SubClassMapperBase<EditWriteIdle> {
  EditWriteIdleMapper._();

  static EditWriteIdleMapper? _instance;
  static EditWriteIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditWriteIdleMapper._());
      EditWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EditWriteIdle';

  @override
  final MappableFields<EditWriteIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      EditWriteStateMapper.ensureInitialized();

  static EditWriteIdle _instantiate(DecodingData data) {
    return EditWriteIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static EditWriteIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditWriteIdle>(map);
  }

  static EditWriteIdle fromJson(String json) {
    return ensureInitialized().decodeJson<EditWriteIdle>(json);
  }
}

mixin EditWriteIdleMappable {
  String toJson() {
    return EditWriteIdleMapper.ensureInitialized().encodeJson<EditWriteIdle>(
      this as EditWriteIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return EditWriteIdleMapper.ensureInitialized().encodeMap<EditWriteIdle>(
      this as EditWriteIdle,
    );
  }

  EditWriteIdleCopyWith<EditWriteIdle, EditWriteIdle, EditWriteIdle>
  get copyWith => _EditWriteIdleCopyWithImpl<EditWriteIdle, EditWriteIdle>(
    this as EditWriteIdle,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return EditWriteIdleMapper.ensureInitialized().stringifyValue(
      this as EditWriteIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditWriteIdleMapper.ensureInitialized().equalsValue(
      this as EditWriteIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return EditWriteIdleMapper.ensureInitialized().hashValue(
      this as EditWriteIdle,
    );
  }
}

extension EditWriteIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditWriteIdle, $Out> {
  EditWriteIdleCopyWith<$R, EditWriteIdle, $Out> get $asEditWriteIdle =>
      $base.as((v, t, t2) => _EditWriteIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditWriteIdleCopyWith<$R, $In extends EditWriteIdle, $Out>
    implements EditWriteStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  EditWriteIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EditWriteIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditWriteIdle, $Out>
    implements EditWriteIdleCopyWith<$R, EditWriteIdle, $Out> {
  _EditWriteIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditWriteIdle> $mapper =
      EditWriteIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  EditWriteIdle $make(CopyWithData data) => EditWriteIdle();

  @override
  EditWriteIdleCopyWith<$R2, EditWriteIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditWriteIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EditWriteRunningMapper extends SubClassMapperBase<EditWriteRunning> {
  EditWriteRunningMapper._();

  static EditWriteRunningMapper? _instance;
  static EditWriteRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditWriteRunningMapper._());
      EditWriteStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EditWriteRunning';

  @override
  final MappableFields<EditWriteRunning> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      EditWriteStateMapper.ensureInitialized();

  static EditWriteRunning _instantiate(DecodingData data) {
    return EditWriteRunning();
  }

  @override
  final Function instantiate = _instantiate;

  static EditWriteRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditWriteRunning>(map);
  }

  static EditWriteRunning fromJson(String json) {
    return ensureInitialized().decodeJson<EditWriteRunning>(json);
  }
}

mixin EditWriteRunningMappable {
  String toJson() {
    return EditWriteRunningMapper.ensureInitialized()
        .encodeJson<EditWriteRunning>(this as EditWriteRunning);
  }

  Map<String, dynamic> toMap() {
    return EditWriteRunningMapper.ensureInitialized()
        .encodeMap<EditWriteRunning>(this as EditWriteRunning);
  }

  EditWriteRunningCopyWith<EditWriteRunning, EditWriteRunning, EditWriteRunning>
  get copyWith =>
      _EditWriteRunningCopyWithImpl<EditWriteRunning, EditWriteRunning>(
        this as EditWriteRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EditWriteRunningMapper.ensureInitialized().stringifyValue(
      this as EditWriteRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditWriteRunningMapper.ensureInitialized().equalsValue(
      this as EditWriteRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return EditWriteRunningMapper.ensureInitialized().hashValue(
      this as EditWriteRunning,
    );
  }
}

extension EditWriteRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditWriteRunning, $Out> {
  EditWriteRunningCopyWith<$R, EditWriteRunning, $Out>
  get $asEditWriteRunning =>
      $base.as((v, t, t2) => _EditWriteRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditWriteRunningCopyWith<$R, $In extends EditWriteRunning, $Out>
    implements EditWriteStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  EditWriteRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EditWriteRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditWriteRunning, $Out>
    implements EditWriteRunningCopyWith<$R, EditWriteRunning, $Out> {
  _EditWriteRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditWriteRunning> $mapper =
      EditWriteRunningMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  EditWriteRunning $make(CopyWithData data) => EditWriteRunning();

  @override
  EditWriteRunningCopyWith<$R2, EditWriteRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditWriteRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

