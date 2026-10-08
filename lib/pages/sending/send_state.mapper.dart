// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_state.dart';

class SendStateMapper extends ClassMapperBase<SendState> {
  SendStateMapper._();

  static SendStateMapper? _instance;
  static SendStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendStateMapper._());
      SendIdleMapper.ensureInitialized();
      SendRunningMapper.ensureInitialized();
      SendDoneMapper.ensureInitialized();
      SendFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendState';

  @override
  final MappableFields<SendState> fields = const {};
  @override
  final bool ignoreNull = true;

  static SendState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'SendState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendState>(map);
  }

  static SendState fromJson(String json) {
    return ensureInitialized().decodeJson<SendState>(json);
  }
}

mixin SendStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SendStateCopyWith<SendState, SendState, SendState> get copyWith;
}

abstract class SendStateCopyWith<$R, $In extends SendState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SendStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class SendIdleMapper extends SubClassMapperBase<SendIdle> {
  SendIdleMapper._();

  static SendIdleMapper? _instance;
  static SendIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendIdleMapper._());
      SendStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SendIdle';

  @override
  final MappableFields<SendIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper = SendStateMapper.ensureInitialized();

  static SendIdle _instantiate(DecodingData data) {
    return SendIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static SendIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendIdle>(map);
  }

  static SendIdle fromJson(String json) {
    return ensureInitialized().decodeJson<SendIdle>(json);
  }
}

mixin SendIdleMappable {
  String toJson() {
    return SendIdleMapper.ensureInitialized().encodeJson<SendIdle>(
      this as SendIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return SendIdleMapper.ensureInitialized().encodeMap<SendIdle>(
      this as SendIdle,
    );
  }

  SendIdleCopyWith<SendIdle, SendIdle, SendIdle> get copyWith =>
      _SendIdleCopyWithImpl<SendIdle, SendIdle>(
        this as SendIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendIdleMapper.ensureInitialized().stringifyValue(this as SendIdle);
  }

  @override
  bool operator ==(Object other) {
    return SendIdleMapper.ensureInitialized().equalsValue(
      this as SendIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return SendIdleMapper.ensureInitialized().hashValue(this as SendIdle);
  }
}

extension SendIdleValueCopy<$R, $Out> on ObjectCopyWith<$R, SendIdle, $Out> {
  SendIdleCopyWith<$R, SendIdle, $Out> get $asSendIdle =>
      $base.as((v, t, t2) => _SendIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendIdleCopyWith<$R, $In extends SendIdle, $Out>
    implements SendStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  SendIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendIdle, $Out>
    implements SendIdleCopyWith<$R, SendIdle, $Out> {
  _SendIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendIdle> $mapper =
      SendIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SendIdle $make(CopyWithData data) => SendIdle();

  @override
  SendIdleCopyWith<$R2, SendIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SendRunningMapper extends SubClassMapperBase<SendRunning> {
  SendRunningMapper._();

  static SendRunningMapper? _instance;
  static SendRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendRunningMapper._());
      SendStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendProgressMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendRunning';

  static SendProgress _$progress(SendRunning v) => v.progress;
  static const Field<SendRunning, SendProgress> _f$progress = Field(
    'progress',
    _$progress,
  );

  @override
  final MappableFields<SendRunning> fields = const {#progress: _f$progress};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper = SendStateMapper.ensureInitialized();

  static SendRunning _instantiate(DecodingData data) {
    return SendRunning(data.dec(_f$progress));
  }

  @override
  final Function instantiate = _instantiate;

  static SendRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendRunning>(map);
  }

  static SendRunning fromJson(String json) {
    return ensureInitialized().decodeJson<SendRunning>(json);
  }
}

mixin SendRunningMappable {
  String toJson() {
    return SendRunningMapper.ensureInitialized().encodeJson<SendRunning>(
      this as SendRunning,
    );
  }

  Map<String, dynamic> toMap() {
    return SendRunningMapper.ensureInitialized().encodeMap<SendRunning>(
      this as SendRunning,
    );
  }

  SendRunningCopyWith<SendRunning, SendRunning, SendRunning> get copyWith =>
      _SendRunningCopyWithImpl<SendRunning, SendRunning>(
        this as SendRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendRunningMapper.ensureInitialized().stringifyValue(
      this as SendRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendRunningMapper.ensureInitialized().equalsValue(
      this as SendRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return SendRunningMapper.ensureInitialized().hashValue(this as SendRunning);
  }
}

extension SendRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendRunning, $Out> {
  SendRunningCopyWith<$R, SendRunning, $Out> get $asSendRunning =>
      $base.as((v, t, t2) => _SendRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendRunningCopyWith<$R, $In extends SendRunning, $Out>
    implements SendStateCopyWith<$R, $In, $Out> {
  SendProgressCopyWith<$R, SendProgress, SendProgress> get progress;
  @override
  $R call({SendProgress? progress});
  SendRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendRunning, $Out>
    implements SendRunningCopyWith<$R, SendRunning, $Out> {
  _SendRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendRunning> $mapper =
      SendRunningMapper.ensureInitialized();
  @override
  SendProgressCopyWith<$R, SendProgress, SendProgress> get progress =>
      $value.progress.copyWith.$chain((v) => call(progress: v));
  @override
  $R call({SendProgress? progress}) =>
      $apply(FieldCopyWithData({if (progress != null) #progress: progress}));
  @override
  SendRunning $make(CopyWithData data) =>
      SendRunning(data.get(#progress, or: $value.progress));

  @override
  SendRunningCopyWith<$R2, SendRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SendDoneMapper extends SubClassMapperBase<SendDone> {
  SendDoneMapper._();

  static SendDoneMapper? _instance;
  static SendDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendDoneMapper._());
      SendStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendReportMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendDone';

  static SendReport _$report(SendDone v) => v.report;
  static const Field<SendDone, SendReport> _f$report = Field(
    'report',
    _$report,
  );

  @override
  final MappableFields<SendDone> fields = const {#report: _f$report};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper = SendStateMapper.ensureInitialized();

  static SendDone _instantiate(DecodingData data) {
    return SendDone(data.dec(_f$report));
  }

  @override
  final Function instantiate = _instantiate;

  static SendDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendDone>(map);
  }

  static SendDone fromJson(String json) {
    return ensureInitialized().decodeJson<SendDone>(json);
  }
}

mixin SendDoneMappable {
  String toJson() {
    return SendDoneMapper.ensureInitialized().encodeJson<SendDone>(
      this as SendDone,
    );
  }

  Map<String, dynamic> toMap() {
    return SendDoneMapper.ensureInitialized().encodeMap<SendDone>(
      this as SendDone,
    );
  }

  SendDoneCopyWith<SendDone, SendDone, SendDone> get copyWith =>
      _SendDoneCopyWithImpl<SendDone, SendDone>(
        this as SendDone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendDoneMapper.ensureInitialized().stringifyValue(this as SendDone);
  }

  @override
  bool operator ==(Object other) {
    return SendDoneMapper.ensureInitialized().equalsValue(
      this as SendDone,
      other,
    );
  }

  @override
  int get hashCode {
    return SendDoneMapper.ensureInitialized().hashValue(this as SendDone);
  }
}

extension SendDoneValueCopy<$R, $Out> on ObjectCopyWith<$R, SendDone, $Out> {
  SendDoneCopyWith<$R, SendDone, $Out> get $asSendDone =>
      $base.as((v, t, t2) => _SendDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendDoneCopyWith<$R, $In extends SendDone, $Out>
    implements SendStateCopyWith<$R, $In, $Out> {
  SendReportCopyWith<$R, SendReport, SendReport> get report;
  @override
  $R call({SendReport? report});
  SendDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendDone, $Out>
    implements SendDoneCopyWith<$R, SendDone, $Out> {
  _SendDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendDone> $mapper =
      SendDoneMapper.ensureInitialized();
  @override
  SendReportCopyWith<$R, SendReport, SendReport> get report =>
      $value.report.copyWith.$chain((v) => call(report: v));
  @override
  $R call({SendReport? report}) =>
      $apply(FieldCopyWithData({if (report != null) #report: report}));
  @override
  SendDone $make(CopyWithData data) =>
      SendDone(data.get(#report, or: $value.report));

  @override
  SendDoneCopyWith<$R2, SendDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SendFailedMapper extends SubClassMapperBase<SendFailed> {
  SendFailedMapper._();

  static SendFailedMapper? _instance;
  static SendFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendFailedMapper._());
      SendStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendProgressMapper.ensureInitialized();
      SendFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendFailed';

  static SendProgress _$progress(SendFailed v) => v.progress;
  static const Field<SendFailed, SendProgress> _f$progress = Field(
    'progress',
    _$progress,
  );
  static SendFailure _$failure(SendFailed v) => v.failure;
  static const Field<SendFailed, SendFailure> _f$failure = Field(
    'failure',
    _$failure,
  );

  @override
  final MappableFields<SendFailed> fields = const {
    #progress: _f$progress,
    #failure: _f$failure,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper = SendStateMapper.ensureInitialized();

  static SendFailed _instantiate(DecodingData data) {
    return SendFailed(data.dec(_f$progress), data.dec(_f$failure));
  }

  @override
  final Function instantiate = _instantiate;

  static SendFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendFailed>(map);
  }

  static SendFailed fromJson(String json) {
    return ensureInitialized().decodeJson<SendFailed>(json);
  }
}

mixin SendFailedMappable {
  String toJson() {
    return SendFailedMapper.ensureInitialized().encodeJson<SendFailed>(
      this as SendFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return SendFailedMapper.ensureInitialized().encodeMap<SendFailed>(
      this as SendFailed,
    );
  }

  SendFailedCopyWith<SendFailed, SendFailed, SendFailed> get copyWith =>
      _SendFailedCopyWithImpl<SendFailed, SendFailed>(
        this as SendFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendFailedMapper.ensureInitialized().stringifyValue(
      this as SendFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendFailedMapper.ensureInitialized().equalsValue(
      this as SendFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return SendFailedMapper.ensureInitialized().hashValue(this as SendFailed);
  }
}

extension SendFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendFailed, $Out> {
  SendFailedCopyWith<$R, SendFailed, $Out> get $asSendFailed =>
      $base.as((v, t, t2) => _SendFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendFailedCopyWith<$R, $In extends SendFailed, $Out>
    implements SendStateCopyWith<$R, $In, $Out> {
  SendProgressCopyWith<$R, SendProgress, SendProgress> get progress;
  @override
  $R call({SendProgress? progress, SendFailure? failure});
  SendFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendFailed, $Out>
    implements SendFailedCopyWith<$R, SendFailed, $Out> {
  _SendFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendFailed> $mapper =
      SendFailedMapper.ensureInitialized();
  @override
  SendProgressCopyWith<$R, SendProgress, SendProgress> get progress =>
      $value.progress.copyWith.$chain((v) => call(progress: v));
  @override
  $R call({SendProgress? progress, SendFailure? failure}) => $apply(
    FieldCopyWithData({
      if (progress != null) #progress: progress,
      if (failure != null) #failure: failure,
    }),
  );
  @override
  SendFailed $make(CopyWithData data) => SendFailed(
    data.get(#progress, or: $value.progress),
    data.get(#failure, or: $value.failure),
  );

  @override
  SendFailedCopyWith<$R2, SendFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

