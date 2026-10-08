// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mfp_sign_in_state.dart';

class MfpSignInStateMapper extends ClassMapperBase<MfpSignInState> {
  MfpSignInStateMapper._();

  static MfpSignInStateMapper? _instance;
  static MfpSignInStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpSignInStateMapper._());
      MfpSignInIdleMapper.ensureInitialized();
      MfpSignInRunningMapper.ensureInitialized();
      MfpSignInDoneMapper.ensureInitialized();
      MfpSignInFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpSignInState';

  @override
  final MappableFields<MfpSignInState> fields = const {};
  @override
  final bool ignoreNull = true;

  static MfpSignInState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'MfpSignInState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpSignInState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpSignInState>(map);
  }

  static MfpSignInState fromJson(String json) {
    return ensureInitialized().decodeJson<MfpSignInState>(json);
  }
}

mixin MfpSignInStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MfpSignInStateCopyWith<MfpSignInState, MfpSignInState, MfpSignInState>
  get copyWith;
}

abstract class MfpSignInStateCopyWith<$R, $In extends MfpSignInState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MfpSignInStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class MfpSignInIdleMapper extends SubClassMapperBase<MfpSignInIdle> {
  MfpSignInIdleMapper._();

  static MfpSignInIdleMapper? _instance;
  static MfpSignInIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpSignInIdleMapper._());
      MfpSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MfpSignInIdle';

  @override
  final MappableFields<MfpSignInIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      MfpSignInStateMapper.ensureInitialized();

  static MfpSignInIdle _instantiate(DecodingData data) {
    return MfpSignInIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static MfpSignInIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpSignInIdle>(map);
  }

  static MfpSignInIdle fromJson(String json) {
    return ensureInitialized().decodeJson<MfpSignInIdle>(json);
  }
}

mixin MfpSignInIdleMappable {
  String toJson() {
    return MfpSignInIdleMapper.ensureInitialized().encodeJson<MfpSignInIdle>(
      this as MfpSignInIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpSignInIdleMapper.ensureInitialized().encodeMap<MfpSignInIdle>(
      this as MfpSignInIdle,
    );
  }

  MfpSignInIdleCopyWith<MfpSignInIdle, MfpSignInIdle, MfpSignInIdle>
  get copyWith => _MfpSignInIdleCopyWithImpl<MfpSignInIdle, MfpSignInIdle>(
    this as MfpSignInIdle,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MfpSignInIdleMapper.ensureInitialized().stringifyValue(
      this as MfpSignInIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpSignInIdleMapper.ensureInitialized().equalsValue(
      this as MfpSignInIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpSignInIdleMapper.ensureInitialized().hashValue(
      this as MfpSignInIdle,
    );
  }
}

extension MfpSignInIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpSignInIdle, $Out> {
  MfpSignInIdleCopyWith<$R, MfpSignInIdle, $Out> get $asMfpSignInIdle =>
      $base.as((v, t, t2) => _MfpSignInIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpSignInIdleCopyWith<$R, $In extends MfpSignInIdle, $Out>
    implements MfpSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MfpSignInIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpSignInIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpSignInIdle, $Out>
    implements MfpSignInIdleCopyWith<$R, MfpSignInIdle, $Out> {
  _MfpSignInIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpSignInIdle> $mapper =
      MfpSignInIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MfpSignInIdle $make(CopyWithData data) => MfpSignInIdle();

  @override
  MfpSignInIdleCopyWith<$R2, MfpSignInIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpSignInIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpSignInRunningMapper extends SubClassMapperBase<MfpSignInRunning> {
  MfpSignInRunningMapper._();

  static MfpSignInRunningMapper? _instance;
  static MfpSignInRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpSignInRunningMapper._());
      MfpSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MfpSignInRunning';

  @override
  final MappableFields<MfpSignInRunning> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      MfpSignInStateMapper.ensureInitialized();

  static MfpSignInRunning _instantiate(DecodingData data) {
    return MfpSignInRunning();
  }

  @override
  final Function instantiate = _instantiate;

  static MfpSignInRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpSignInRunning>(map);
  }

  static MfpSignInRunning fromJson(String json) {
    return ensureInitialized().decodeJson<MfpSignInRunning>(json);
  }
}

mixin MfpSignInRunningMappable {
  String toJson() {
    return MfpSignInRunningMapper.ensureInitialized()
        .encodeJson<MfpSignInRunning>(this as MfpSignInRunning);
  }

  Map<String, dynamic> toMap() {
    return MfpSignInRunningMapper.ensureInitialized()
        .encodeMap<MfpSignInRunning>(this as MfpSignInRunning);
  }

  MfpSignInRunningCopyWith<MfpSignInRunning, MfpSignInRunning, MfpSignInRunning>
  get copyWith =>
      _MfpSignInRunningCopyWithImpl<MfpSignInRunning, MfpSignInRunning>(
        this as MfpSignInRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpSignInRunningMapper.ensureInitialized().stringifyValue(
      this as MfpSignInRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpSignInRunningMapper.ensureInitialized().equalsValue(
      this as MfpSignInRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpSignInRunningMapper.ensureInitialized().hashValue(
      this as MfpSignInRunning,
    );
  }
}

extension MfpSignInRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpSignInRunning, $Out> {
  MfpSignInRunningCopyWith<$R, MfpSignInRunning, $Out>
  get $asMfpSignInRunning =>
      $base.as((v, t, t2) => _MfpSignInRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpSignInRunningCopyWith<$R, $In extends MfpSignInRunning, $Out>
    implements MfpSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MfpSignInRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MfpSignInRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpSignInRunning, $Out>
    implements MfpSignInRunningCopyWith<$R, MfpSignInRunning, $Out> {
  _MfpSignInRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpSignInRunning> $mapper =
      MfpSignInRunningMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MfpSignInRunning $make(CopyWithData data) => MfpSignInRunning();

  @override
  MfpSignInRunningCopyWith<$R2, MfpSignInRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpSignInRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpSignInDoneMapper extends SubClassMapperBase<MfpSignInDone> {
  MfpSignInDoneMapper._();

  static MfpSignInDoneMapper? _instance;
  static MfpSignInDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpSignInDoneMapper._());
      MfpSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MfpSignInDone';

  @override
  final MappableFields<MfpSignInDone> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper =
      MfpSignInStateMapper.ensureInitialized();

  static MfpSignInDone _instantiate(DecodingData data) {
    return MfpSignInDone();
  }

  @override
  final Function instantiate = _instantiate;

  static MfpSignInDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpSignInDone>(map);
  }

  static MfpSignInDone fromJson(String json) {
    return ensureInitialized().decodeJson<MfpSignInDone>(json);
  }
}

mixin MfpSignInDoneMappable {
  String toJson() {
    return MfpSignInDoneMapper.ensureInitialized().encodeJson<MfpSignInDone>(
      this as MfpSignInDone,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpSignInDoneMapper.ensureInitialized().encodeMap<MfpSignInDone>(
      this as MfpSignInDone,
    );
  }

  MfpSignInDoneCopyWith<MfpSignInDone, MfpSignInDone, MfpSignInDone>
  get copyWith => _MfpSignInDoneCopyWithImpl<MfpSignInDone, MfpSignInDone>(
    this as MfpSignInDone,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MfpSignInDoneMapper.ensureInitialized().stringifyValue(
      this as MfpSignInDone,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpSignInDoneMapper.ensureInitialized().equalsValue(
      this as MfpSignInDone,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpSignInDoneMapper.ensureInitialized().hashValue(
      this as MfpSignInDone,
    );
  }
}

extension MfpSignInDoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpSignInDone, $Out> {
  MfpSignInDoneCopyWith<$R, MfpSignInDone, $Out> get $asMfpSignInDone =>
      $base.as((v, t, t2) => _MfpSignInDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpSignInDoneCopyWith<$R, $In extends MfpSignInDone, $Out>
    implements MfpSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MfpSignInDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpSignInDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpSignInDone, $Out>
    implements MfpSignInDoneCopyWith<$R, MfpSignInDone, $Out> {
  _MfpSignInDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpSignInDone> $mapper =
      MfpSignInDoneMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MfpSignInDone $make(CopyWithData data) => MfpSignInDone();

  @override
  MfpSignInDoneCopyWith<$R2, MfpSignInDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpSignInDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpSignInFailedMapper extends SubClassMapperBase<MfpSignInFailed> {
  MfpSignInFailedMapper._();

  static MfpSignInFailedMapper? _instance;
  static MfpSignInFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpSignInFailedMapper._());
      MfpSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
      SignInFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpSignInFailed';

  static SignInFailure _$failure(MfpSignInFailed v) => v.failure;
  static const Field<MfpSignInFailed, SignInFailure> _f$failure = Field(
    'failure',
    _$failure,
  );

  @override
  final MappableFields<MfpSignInFailed> fields = const {#failure: _f$failure};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      MfpSignInStateMapper.ensureInitialized();

  static MfpSignInFailed _instantiate(DecodingData data) {
    return MfpSignInFailed(data.dec(_f$failure));
  }

  @override
  final Function instantiate = _instantiate;

  static MfpSignInFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpSignInFailed>(map);
  }

  static MfpSignInFailed fromJson(String json) {
    return ensureInitialized().decodeJson<MfpSignInFailed>(json);
  }
}

mixin MfpSignInFailedMappable {
  String toJson() {
    return MfpSignInFailedMapper.ensureInitialized()
        .encodeJson<MfpSignInFailed>(this as MfpSignInFailed);
  }

  Map<String, dynamic> toMap() {
    return MfpSignInFailedMapper.ensureInitialized().encodeMap<MfpSignInFailed>(
      this as MfpSignInFailed,
    );
  }

  MfpSignInFailedCopyWith<MfpSignInFailed, MfpSignInFailed, MfpSignInFailed>
  get copyWith =>
      _MfpSignInFailedCopyWithImpl<MfpSignInFailed, MfpSignInFailed>(
        this as MfpSignInFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpSignInFailedMapper.ensureInitialized().stringifyValue(
      this as MfpSignInFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpSignInFailedMapper.ensureInitialized().equalsValue(
      this as MfpSignInFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpSignInFailedMapper.ensureInitialized().hashValue(
      this as MfpSignInFailed,
    );
  }
}

extension MfpSignInFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpSignInFailed, $Out> {
  MfpSignInFailedCopyWith<$R, MfpSignInFailed, $Out> get $asMfpSignInFailed =>
      $base.as((v, t, t2) => _MfpSignInFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpSignInFailedCopyWith<$R, $In extends MfpSignInFailed, $Out>
    implements MfpSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call({SignInFailure? failure});
  MfpSignInFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MfpSignInFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpSignInFailed, $Out>
    implements MfpSignInFailedCopyWith<$R, MfpSignInFailed, $Out> {
  _MfpSignInFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpSignInFailed> $mapper =
      MfpSignInFailedMapper.ensureInitialized();
  @override
  $R call({SignInFailure? failure}) =>
      $apply(FieldCopyWithData({if (failure != null) #failure: failure}));
  @override
  MfpSignInFailed $make(CopyWithData data) =>
      MfpSignInFailed(data.get(#failure, or: $value.failure));

  @override
  MfpSignInFailedCopyWith<$R2, MfpSignInFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpSignInFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

