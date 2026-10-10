// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'backup_state.dart';

class BackupStateMapper extends ClassMapperBase<BackupState> {
  BackupStateMapper._();

  static BackupStateMapper? _instance;
  static BackupStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupStateMapper._());
      BackupIdleMapper.ensureInitialized();
      BackupRunningMapper.ensureInitialized();
      BackupOpenedMapper.ensureInitialized();
      BackupExportedMapper.ensureInitialized();
      BackupImportedMapper.ensureInitialized();
      BackupFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupState';

  @override
  final MappableFields<BackupState> fields = const {};
  @override
  final bool ignoreNull = true;

  static BackupState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'BackupState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupState>(map);
  }

  static BackupState fromJson(String json) {
    return ensureInitialized().decodeJson<BackupState>(json);
  }
}

mixin BackupStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  BackupStateCopyWith<BackupState, BackupState, BackupState> get copyWith;
}

abstract class BackupStateCopyWith<$R, $In extends BackupState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  BackupStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class BackupIdleMapper extends SubClassMapperBase<BackupIdle> {
  BackupIdleMapper._();

  static BackupIdleMapper? _instance;
  static BackupIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupIdleMapper._());
      BackupStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'BackupIdle';

  @override
  final MappableFields<BackupIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      BackupStateMapper.ensureInitialized();

  static BackupIdle _instantiate(DecodingData data) {
    return BackupIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static BackupIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupIdle>(map);
  }

  static BackupIdle fromJson(String json) {
    return ensureInitialized().decodeJson<BackupIdle>(json);
  }
}

mixin BackupIdleMappable {
  String toJson() {
    return BackupIdleMapper.ensureInitialized().encodeJson<BackupIdle>(
      this as BackupIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupIdleMapper.ensureInitialized().encodeMap<BackupIdle>(
      this as BackupIdle,
    );
  }

  BackupIdleCopyWith<BackupIdle, BackupIdle, BackupIdle> get copyWith =>
      _BackupIdleCopyWithImpl<BackupIdle, BackupIdle>(
        this as BackupIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupIdleMapper.ensureInitialized().stringifyValue(
      this as BackupIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return BackupIdleMapper.ensureInitialized().equalsValue(
      this as BackupIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupIdleMapper.ensureInitialized().hashValue(this as BackupIdle);
  }
}

extension BackupIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BackupIdle, $Out> {
  BackupIdleCopyWith<$R, BackupIdle, $Out> get $asBackupIdle =>
      $base.as((v, t, t2) => _BackupIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupIdleCopyWith<$R, $In extends BackupIdle, $Out>
    implements BackupStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  BackupIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupIdle, $Out>
    implements BackupIdleCopyWith<$R, BackupIdle, $Out> {
  _BackupIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupIdle> $mapper =
      BackupIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  BackupIdle $make(CopyWithData data) => BackupIdle();

  @override
  BackupIdleCopyWith<$R2, BackupIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupRunningMapper extends SubClassMapperBase<BackupRunning> {
  BackupRunningMapper._();

  static BackupRunningMapper? _instance;
  static BackupRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupRunningMapper._());
      BackupStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'BackupRunning';

  @override
  final MappableFields<BackupRunning> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      BackupStateMapper.ensureInitialized();

  static BackupRunning _instantiate(DecodingData data) {
    return BackupRunning();
  }

  @override
  final Function instantiate = _instantiate;

  static BackupRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupRunning>(map);
  }

  static BackupRunning fromJson(String json) {
    return ensureInitialized().decodeJson<BackupRunning>(json);
  }
}

mixin BackupRunningMappable {
  String toJson() {
    return BackupRunningMapper.ensureInitialized().encodeJson<BackupRunning>(
      this as BackupRunning,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupRunningMapper.ensureInitialized().encodeMap<BackupRunning>(
      this as BackupRunning,
    );
  }

  BackupRunningCopyWith<BackupRunning, BackupRunning, BackupRunning>
  get copyWith => _BackupRunningCopyWithImpl<BackupRunning, BackupRunning>(
    this as BackupRunning,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return BackupRunningMapper.ensureInitialized().stringifyValue(
      this as BackupRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return BackupRunningMapper.ensureInitialized().equalsValue(
      this as BackupRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupRunningMapper.ensureInitialized().hashValue(
      this as BackupRunning,
    );
  }
}

extension BackupRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BackupRunning, $Out> {
  BackupRunningCopyWith<$R, BackupRunning, $Out> get $asBackupRunning =>
      $base.as((v, t, t2) => _BackupRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupRunningCopyWith<$R, $In extends BackupRunning, $Out>
    implements BackupStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  BackupRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupRunning, $Out>
    implements BackupRunningCopyWith<$R, BackupRunning, $Out> {
  _BackupRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupRunning> $mapper =
      BackupRunningMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  BackupRunning $make(CopyWithData data) => BackupRunning();

  @override
  BackupRunningCopyWith<$R2, BackupRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupOpenedMapper extends SubClassMapperBase<BackupOpened> {
  BackupOpenedMapper._();

  static BackupOpenedMapper? _instance;
  static BackupOpenedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupOpenedMapper._());
      BackupStateMapper.ensureInitialized().addSubMapper(_instance!);
      BackupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupOpened';

  static Backup _$backup(BackupOpened v) => v.backup;
  static const Field<BackupOpened, Backup> _f$backup = Field(
    'backup',
    _$backup,
  );

  @override
  final MappableFields<BackupOpened> fields = const {#backup: _f$backup};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'opened';
  @override
  late final ClassMapperBase superMapper =
      BackupStateMapper.ensureInitialized();

  static BackupOpened _instantiate(DecodingData data) {
    return BackupOpened(data.dec(_f$backup));
  }

  @override
  final Function instantiate = _instantiate;

  static BackupOpened fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupOpened>(map);
  }

  static BackupOpened fromJson(String json) {
    return ensureInitialized().decodeJson<BackupOpened>(json);
  }
}

mixin BackupOpenedMappable {
  String toJson() {
    return BackupOpenedMapper.ensureInitialized().encodeJson<BackupOpened>(
      this as BackupOpened,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupOpenedMapper.ensureInitialized().encodeMap<BackupOpened>(
      this as BackupOpened,
    );
  }

  BackupOpenedCopyWith<BackupOpened, BackupOpened, BackupOpened> get copyWith =>
      _BackupOpenedCopyWithImpl<BackupOpened, BackupOpened>(
        this as BackupOpened,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupOpenedMapper.ensureInitialized().stringifyValue(
      this as BackupOpened,
    );
  }

  @override
  bool operator ==(Object other) {
    return BackupOpenedMapper.ensureInitialized().equalsValue(
      this as BackupOpened,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupOpenedMapper.ensureInitialized().hashValue(
      this as BackupOpened,
    );
  }
}

extension BackupOpenedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BackupOpened, $Out> {
  BackupOpenedCopyWith<$R, BackupOpened, $Out> get $asBackupOpened =>
      $base.as((v, t, t2) => _BackupOpenedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupOpenedCopyWith<$R, $In extends BackupOpened, $Out>
    implements BackupStateCopyWith<$R, $In, $Out> {
  BackupCopyWith<$R, Backup, Backup> get backup;
  @override
  $R call({Backup? backup});
  BackupOpenedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupOpenedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupOpened, $Out>
    implements BackupOpenedCopyWith<$R, BackupOpened, $Out> {
  _BackupOpenedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupOpened> $mapper =
      BackupOpenedMapper.ensureInitialized();
  @override
  BackupCopyWith<$R, Backup, Backup> get backup =>
      $value.backup.copyWith.$chain((v) => call(backup: v));
  @override
  $R call({Backup? backup}) =>
      $apply(FieldCopyWithData({if (backup != null) #backup: backup}));
  @override
  BackupOpened $make(CopyWithData data) =>
      BackupOpened(data.get(#backup, or: $value.backup));

  @override
  BackupOpenedCopyWith<$R2, BackupOpened, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupOpenedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupExportedMapper extends SubClassMapperBase<BackupExported> {
  BackupExportedMapper._();

  static BackupExportedMapper? _instance;
  static BackupExportedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupExportedMapper._());
      BackupStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'BackupExported';

  @override
  final MappableFields<BackupExported> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'exported';
  @override
  late final ClassMapperBase superMapper =
      BackupStateMapper.ensureInitialized();

  static BackupExported _instantiate(DecodingData data) {
    return BackupExported();
  }

  @override
  final Function instantiate = _instantiate;

  static BackupExported fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupExported>(map);
  }

  static BackupExported fromJson(String json) {
    return ensureInitialized().decodeJson<BackupExported>(json);
  }
}

mixin BackupExportedMappable {
  String toJson() {
    return BackupExportedMapper.ensureInitialized().encodeJson<BackupExported>(
      this as BackupExported,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupExportedMapper.ensureInitialized().encodeMap<BackupExported>(
      this as BackupExported,
    );
  }

  BackupExportedCopyWith<BackupExported, BackupExported, BackupExported>
  get copyWith => _BackupExportedCopyWithImpl<BackupExported, BackupExported>(
    this as BackupExported,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return BackupExportedMapper.ensureInitialized().stringifyValue(
      this as BackupExported,
    );
  }

  @override
  bool operator ==(Object other) {
    return BackupExportedMapper.ensureInitialized().equalsValue(
      this as BackupExported,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupExportedMapper.ensureInitialized().hashValue(
      this as BackupExported,
    );
  }
}

extension BackupExportedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BackupExported, $Out> {
  BackupExportedCopyWith<$R, BackupExported, $Out> get $asBackupExported =>
      $base.as((v, t, t2) => _BackupExportedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupExportedCopyWith<$R, $In extends BackupExported, $Out>
    implements BackupStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  BackupExportedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BackupExportedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupExported, $Out>
    implements BackupExportedCopyWith<$R, BackupExported, $Out> {
  _BackupExportedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupExported> $mapper =
      BackupExportedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  BackupExported $make(CopyWithData data) => BackupExported();

  @override
  BackupExportedCopyWith<$R2, BackupExported, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupExportedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupImportedMapper extends SubClassMapperBase<BackupImported> {
  BackupImportedMapper._();

  static BackupImportedMapper? _instance;
  static BackupImportedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupImportedMapper._());
      BackupStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'BackupImported';

  @override
  final MappableFields<BackupImported> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'imported';
  @override
  late final ClassMapperBase superMapper =
      BackupStateMapper.ensureInitialized();

  static BackupImported _instantiate(DecodingData data) {
    return BackupImported();
  }

  @override
  final Function instantiate = _instantiate;

  static BackupImported fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupImported>(map);
  }

  static BackupImported fromJson(String json) {
    return ensureInitialized().decodeJson<BackupImported>(json);
  }
}

mixin BackupImportedMappable {
  String toJson() {
    return BackupImportedMapper.ensureInitialized().encodeJson<BackupImported>(
      this as BackupImported,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupImportedMapper.ensureInitialized().encodeMap<BackupImported>(
      this as BackupImported,
    );
  }

  BackupImportedCopyWith<BackupImported, BackupImported, BackupImported>
  get copyWith => _BackupImportedCopyWithImpl<BackupImported, BackupImported>(
    this as BackupImported,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return BackupImportedMapper.ensureInitialized().stringifyValue(
      this as BackupImported,
    );
  }

  @override
  bool operator ==(Object other) {
    return BackupImportedMapper.ensureInitialized().equalsValue(
      this as BackupImported,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupImportedMapper.ensureInitialized().hashValue(
      this as BackupImported,
    );
  }
}

extension BackupImportedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BackupImported, $Out> {
  BackupImportedCopyWith<$R, BackupImported, $Out> get $asBackupImported =>
      $base.as((v, t, t2) => _BackupImportedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupImportedCopyWith<$R, $In extends BackupImported, $Out>
    implements BackupStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  BackupImportedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BackupImportedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupImported, $Out>
    implements BackupImportedCopyWith<$R, BackupImported, $Out> {
  _BackupImportedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupImported> $mapper =
      BackupImportedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  BackupImported $make(CopyWithData data) => BackupImported();

  @override
  BackupImportedCopyWith<$R2, BackupImported, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupImportedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupFailedMapper extends SubClassMapperBase<BackupFailed> {
  BackupFailedMapper._();

  static BackupFailedMapper? _instance;
  static BackupFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupFailedMapper._());
      BackupStateMapper.ensureInitialized().addSubMapper(_instance!);
      BackupFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupFailed';

  static BackupFailure _$failure(BackupFailed v) => v.failure;
  static const Field<BackupFailed, BackupFailure> _f$failure = Field(
    'failure',
    _$failure,
  );

  @override
  final MappableFields<BackupFailed> fields = const {#failure: _f$failure};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      BackupStateMapper.ensureInitialized();

  static BackupFailed _instantiate(DecodingData data) {
    return BackupFailed(data.dec(_f$failure));
  }

  @override
  final Function instantiate = _instantiate;

  static BackupFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupFailed>(map);
  }

  static BackupFailed fromJson(String json) {
    return ensureInitialized().decodeJson<BackupFailed>(json);
  }
}

mixin BackupFailedMappable {
  String toJson() {
    return BackupFailedMapper.ensureInitialized().encodeJson<BackupFailed>(
      this as BackupFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupFailedMapper.ensureInitialized().encodeMap<BackupFailed>(
      this as BackupFailed,
    );
  }

  BackupFailedCopyWith<BackupFailed, BackupFailed, BackupFailed> get copyWith =>
      _BackupFailedCopyWithImpl<BackupFailed, BackupFailed>(
        this as BackupFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupFailedMapper.ensureInitialized().stringifyValue(
      this as BackupFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return BackupFailedMapper.ensureInitialized().equalsValue(
      this as BackupFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupFailedMapper.ensureInitialized().hashValue(
      this as BackupFailed,
    );
  }
}

extension BackupFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BackupFailed, $Out> {
  BackupFailedCopyWith<$R, BackupFailed, $Out> get $asBackupFailed =>
      $base.as((v, t, t2) => _BackupFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupFailedCopyWith<$R, $In extends BackupFailed, $Out>
    implements BackupStateCopyWith<$R, $In, $Out> {
  @override
  $R call({BackupFailure? failure});
  BackupFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupFailed, $Out>
    implements BackupFailedCopyWith<$R, BackupFailed, $Out> {
  _BackupFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupFailed> $mapper =
      BackupFailedMapper.ensureInitialized();
  @override
  $R call({BackupFailure? failure}) =>
      $apply(FieldCopyWithData({if (failure != null) #failure: failure}));
  @override
  BackupFailed $make(CopyWithData data) =>
      BackupFailed(data.get(#failure, or: $value.failure));

  @override
  BackupFailedCopyWith<$R2, BackupFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

