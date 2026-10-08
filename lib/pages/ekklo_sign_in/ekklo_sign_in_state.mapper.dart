// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ekklo_sign_in_state.dart';

class EkkloSignInStateMapper extends ClassMapperBase<EkkloSignInState> {
  EkkloSignInStateMapper._();

  static EkkloSignInStateMapper? _instance;
  static EkkloSignInStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSignInStateMapper._());
      EkkloSignInIdleMapper.ensureInitialized();
      EkkloSignInRunningMapper.ensureInitialized();
      EkkloSignInDoneMapper.ensureInitialized();
      EkkloSignInFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSignInState';

  @override
  final MappableFields<EkkloSignInState> fields = const {};
  @override
  final bool ignoreNull = true;

  static EkkloSignInState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'EkkloSignInState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSignInState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSignInState>(map);
  }

  static EkkloSignInState fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSignInState>(json);
  }
}

mixin EkkloSignInStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  EkkloSignInStateCopyWith<EkkloSignInState, EkkloSignInState, EkkloSignInState>
  get copyWith;
}

abstract class EkkloSignInStateCopyWith<$R, $In extends EkkloSignInState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  EkkloSignInStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class EkkloSignInIdleMapper extends SubClassMapperBase<EkkloSignInIdle> {
  EkkloSignInIdleMapper._();

  static EkkloSignInIdleMapper? _instance;
  static EkkloSignInIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSignInIdleMapper._());
      EkkloSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSignInIdle';

  @override
  final MappableFields<EkkloSignInIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      EkkloSignInStateMapper.ensureInitialized();

  static EkkloSignInIdle _instantiate(DecodingData data) {
    return EkkloSignInIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSignInIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSignInIdle>(map);
  }

  static EkkloSignInIdle fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSignInIdle>(json);
  }
}

mixin EkkloSignInIdleMappable {
  String toJson() {
    return EkkloSignInIdleMapper.ensureInitialized()
        .encodeJson<EkkloSignInIdle>(this as EkkloSignInIdle);
  }

  Map<String, dynamic> toMap() {
    return EkkloSignInIdleMapper.ensureInitialized().encodeMap<EkkloSignInIdle>(
      this as EkkloSignInIdle,
    );
  }

  EkkloSignInIdleCopyWith<EkkloSignInIdle, EkkloSignInIdle, EkkloSignInIdle>
  get copyWith =>
      _EkkloSignInIdleCopyWithImpl<EkkloSignInIdle, EkkloSignInIdle>(
        this as EkkloSignInIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSignInIdleMapper.ensureInitialized().stringifyValue(
      this as EkkloSignInIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSignInIdleMapper.ensureInitialized().equalsValue(
      this as EkkloSignInIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSignInIdleMapper.ensureInitialized().hashValue(
      this as EkkloSignInIdle,
    );
  }
}

extension EkkloSignInIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSignInIdle, $Out> {
  EkkloSignInIdleCopyWith<$R, EkkloSignInIdle, $Out> get $asEkkloSignInIdle =>
      $base.as((v, t, t2) => _EkkloSignInIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloSignInIdleCopyWith<$R, $In extends EkkloSignInIdle, $Out>
    implements EkkloSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  EkkloSignInIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSignInIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSignInIdle, $Out>
    implements EkkloSignInIdleCopyWith<$R, EkkloSignInIdle, $Out> {
  _EkkloSignInIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSignInIdle> $mapper =
      EkkloSignInIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  EkkloSignInIdle $make(CopyWithData data) => EkkloSignInIdle();

  @override
  EkkloSignInIdleCopyWith<$R2, EkkloSignInIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSignInIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloSignInRunningMapper extends SubClassMapperBase<EkkloSignInRunning> {
  EkkloSignInRunningMapper._();

  static EkkloSignInRunningMapper? _instance;
  static EkkloSignInRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSignInRunningMapper._());
      EkkloSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSignInRunning';

  @override
  final MappableFields<EkkloSignInRunning> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      EkkloSignInStateMapper.ensureInitialized();

  static EkkloSignInRunning _instantiate(DecodingData data) {
    return EkkloSignInRunning();
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSignInRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSignInRunning>(map);
  }

  static EkkloSignInRunning fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSignInRunning>(json);
  }
}

mixin EkkloSignInRunningMappable {
  String toJson() {
    return EkkloSignInRunningMapper.ensureInitialized()
        .encodeJson<EkkloSignInRunning>(this as EkkloSignInRunning);
  }

  Map<String, dynamic> toMap() {
    return EkkloSignInRunningMapper.ensureInitialized()
        .encodeMap<EkkloSignInRunning>(this as EkkloSignInRunning);
  }

  EkkloSignInRunningCopyWith<
    EkkloSignInRunning,
    EkkloSignInRunning,
    EkkloSignInRunning
  >
  get copyWith =>
      _EkkloSignInRunningCopyWithImpl<EkkloSignInRunning, EkkloSignInRunning>(
        this as EkkloSignInRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSignInRunningMapper.ensureInitialized().stringifyValue(
      this as EkkloSignInRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSignInRunningMapper.ensureInitialized().equalsValue(
      this as EkkloSignInRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSignInRunningMapper.ensureInitialized().hashValue(
      this as EkkloSignInRunning,
    );
  }
}

extension EkkloSignInRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSignInRunning, $Out> {
  EkkloSignInRunningCopyWith<$R, EkkloSignInRunning, $Out>
  get $asEkkloSignInRunning => $base.as(
    (v, t, t2) => _EkkloSignInRunningCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EkkloSignInRunningCopyWith<
  $R,
  $In extends EkkloSignInRunning,
  $Out
>
    implements EkkloSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  EkkloSignInRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSignInRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSignInRunning, $Out>
    implements EkkloSignInRunningCopyWith<$R, EkkloSignInRunning, $Out> {
  _EkkloSignInRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSignInRunning> $mapper =
      EkkloSignInRunningMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  EkkloSignInRunning $make(CopyWithData data) => EkkloSignInRunning();

  @override
  EkkloSignInRunningCopyWith<$R2, EkkloSignInRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSignInRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloSignInDoneMapper extends SubClassMapperBase<EkkloSignInDone> {
  EkkloSignInDoneMapper._();

  static EkkloSignInDoneMapper? _instance;
  static EkkloSignInDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSignInDoneMapper._());
      EkkloSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSignInDone';

  @override
  final MappableFields<EkkloSignInDone> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper =
      EkkloSignInStateMapper.ensureInitialized();

  static EkkloSignInDone _instantiate(DecodingData data) {
    return EkkloSignInDone();
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSignInDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSignInDone>(map);
  }

  static EkkloSignInDone fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSignInDone>(json);
  }
}

mixin EkkloSignInDoneMappable {
  String toJson() {
    return EkkloSignInDoneMapper.ensureInitialized()
        .encodeJson<EkkloSignInDone>(this as EkkloSignInDone);
  }

  Map<String, dynamic> toMap() {
    return EkkloSignInDoneMapper.ensureInitialized().encodeMap<EkkloSignInDone>(
      this as EkkloSignInDone,
    );
  }

  EkkloSignInDoneCopyWith<EkkloSignInDone, EkkloSignInDone, EkkloSignInDone>
  get copyWith =>
      _EkkloSignInDoneCopyWithImpl<EkkloSignInDone, EkkloSignInDone>(
        this as EkkloSignInDone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSignInDoneMapper.ensureInitialized().stringifyValue(
      this as EkkloSignInDone,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSignInDoneMapper.ensureInitialized().equalsValue(
      this as EkkloSignInDone,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSignInDoneMapper.ensureInitialized().hashValue(
      this as EkkloSignInDone,
    );
  }
}

extension EkkloSignInDoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSignInDone, $Out> {
  EkkloSignInDoneCopyWith<$R, EkkloSignInDone, $Out> get $asEkkloSignInDone =>
      $base.as((v, t, t2) => _EkkloSignInDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloSignInDoneCopyWith<$R, $In extends EkkloSignInDone, $Out>
    implements EkkloSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  EkkloSignInDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSignInDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSignInDone, $Out>
    implements EkkloSignInDoneCopyWith<$R, EkkloSignInDone, $Out> {
  _EkkloSignInDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSignInDone> $mapper =
      EkkloSignInDoneMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  EkkloSignInDone $make(CopyWithData data) => EkkloSignInDone();

  @override
  EkkloSignInDoneCopyWith<$R2, EkkloSignInDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSignInDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloSignInFailedMapper extends SubClassMapperBase<EkkloSignInFailed> {
  EkkloSignInFailedMapper._();

  static EkkloSignInFailedMapper? _instance;
  static EkkloSignInFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSignInFailedMapper._());
      EkkloSignInStateMapper.ensureInitialized().addSubMapper(_instance!);
      SignInFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSignInFailed';

  static SignInFailure _$failure(EkkloSignInFailed v) => v.failure;
  static const Field<EkkloSignInFailed, SignInFailure> _f$failure = Field(
    'failure',
    _$failure,
  );
  static String? _$message(EkkloSignInFailed v) => v.message;
  static const Field<EkkloSignInFailed, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );

  @override
  final MappableFields<EkkloSignInFailed> fields = const {
    #failure: _f$failure,
    #message: _f$message,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      EkkloSignInStateMapper.ensureInitialized();

  static EkkloSignInFailed _instantiate(DecodingData data) {
    return EkkloSignInFailed(
      data.dec(_f$failure),
      message: data.dec(_f$message),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSignInFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSignInFailed>(map);
  }

  static EkkloSignInFailed fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSignInFailed>(json);
  }
}

mixin EkkloSignInFailedMappable {
  String toJson() {
    return EkkloSignInFailedMapper.ensureInitialized()
        .encodeJson<EkkloSignInFailed>(this as EkkloSignInFailed);
  }

  Map<String, dynamic> toMap() {
    return EkkloSignInFailedMapper.ensureInitialized()
        .encodeMap<EkkloSignInFailed>(this as EkkloSignInFailed);
  }

  EkkloSignInFailedCopyWith<
    EkkloSignInFailed,
    EkkloSignInFailed,
    EkkloSignInFailed
  >
  get copyWith =>
      _EkkloSignInFailedCopyWithImpl<EkkloSignInFailed, EkkloSignInFailed>(
        this as EkkloSignInFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSignInFailedMapper.ensureInitialized().stringifyValue(
      this as EkkloSignInFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSignInFailedMapper.ensureInitialized().equalsValue(
      this as EkkloSignInFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSignInFailedMapper.ensureInitialized().hashValue(
      this as EkkloSignInFailed,
    );
  }
}

extension EkkloSignInFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSignInFailed, $Out> {
  EkkloSignInFailedCopyWith<$R, EkkloSignInFailed, $Out>
  get $asEkkloSignInFailed => $base.as(
    (v, t, t2) => _EkkloSignInFailedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EkkloSignInFailedCopyWith<
  $R,
  $In extends EkkloSignInFailed,
  $Out
>
    implements EkkloSignInStateCopyWith<$R, $In, $Out> {
  @override
  $R call({SignInFailure? failure, String? message});
  EkkloSignInFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSignInFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSignInFailed, $Out>
    implements EkkloSignInFailedCopyWith<$R, EkkloSignInFailed, $Out> {
  _EkkloSignInFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSignInFailed> $mapper =
      EkkloSignInFailedMapper.ensureInitialized();
  @override
  $R call({SignInFailure? failure, Object? message = $none}) => $apply(
    FieldCopyWithData({
      if (failure != null) #failure: failure,
      if (message != $none) #message: message,
    }),
  );
  @override
  EkkloSignInFailed $make(CopyWithData data) => EkkloSignInFailed(
    data.get(#failure, or: $value.failure),
    message: data.get(#message, or: $value.message),
  );

  @override
  EkkloSignInFailedCopyWith<$R2, EkkloSignInFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSignInFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

