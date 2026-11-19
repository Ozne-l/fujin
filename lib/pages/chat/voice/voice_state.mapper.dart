// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'voice_state.dart';

class VoiceStateMapper extends ClassMapperBase<VoiceState> {
  VoiceStateMapper._();

  static VoiceStateMapper? _instance;
  static VoiceStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceStateMapper._());
      VoiceIdleMapper.ensureInitialized();
      VoiceStartingMapper.ensureInitialized();
      VoiceRecordingMapper.ensureInitialized();
      VoiceKeptMapper.ensureInitialized();
      VoiceSendingMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceState';

  @override
  final MappableFields<VoiceState> fields = const {};
  @override
  final bool ignoreNull = true;

  static VoiceState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'VoiceState',
      'stage',
      '${data.value['stage']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceState>(map);
  }

  static VoiceState fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceState>(json);
  }
}

mixin VoiceStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  VoiceStateCopyWith<VoiceState, VoiceState, VoiceState> get copyWith;
}

abstract class VoiceStateCopyWith<$R, $In extends VoiceState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  VoiceStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class VoiceIdleMapper extends SubClassMapperBase<VoiceIdle> {
  VoiceIdleMapper._();

  static VoiceIdleMapper? _instance;
  static VoiceIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceIdleMapper._());
      VoiceStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceIdle';

  @override
  final MappableFields<VoiceIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'stage';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper = VoiceStateMapper.ensureInitialized();

  static VoiceIdle _instantiate(DecodingData data) {
    return VoiceIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceIdle>(map);
  }

  static VoiceIdle fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceIdle>(json);
  }
}

mixin VoiceIdleMappable {
  String toJson() {
    return VoiceIdleMapper.ensureInitialized().encodeJson<VoiceIdle>(
      this as VoiceIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceIdleMapper.ensureInitialized().encodeMap<VoiceIdle>(
      this as VoiceIdle,
    );
  }

  VoiceIdleCopyWith<VoiceIdle, VoiceIdle, VoiceIdle> get copyWith =>
      _VoiceIdleCopyWithImpl<VoiceIdle, VoiceIdle>(
        this as VoiceIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VoiceIdleMapper.ensureInitialized().stringifyValue(
      this as VoiceIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceIdleMapper.ensureInitialized().equalsValue(
      this as VoiceIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceIdleMapper.ensureInitialized().hashValue(this as VoiceIdle);
  }
}

extension VoiceIdleValueCopy<$R, $Out> on ObjectCopyWith<$R, VoiceIdle, $Out> {
  VoiceIdleCopyWith<$R, VoiceIdle, $Out> get $asVoiceIdle =>
      $base.as((v, t, t2) => _VoiceIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceIdleCopyWith<$R, $In extends VoiceIdle, $Out>
    implements VoiceStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  VoiceIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoiceIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceIdle, $Out>
    implements VoiceIdleCopyWith<$R, VoiceIdle, $Out> {
  _VoiceIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceIdle> $mapper =
      VoiceIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  VoiceIdle $make(CopyWithData data) => VoiceIdle();

  @override
  VoiceIdleCopyWith<$R2, VoiceIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VoiceStartingMapper extends SubClassMapperBase<VoiceStarting> {
  VoiceStartingMapper._();

  static VoiceStartingMapper? _instance;
  static VoiceStartingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceStartingMapper._());
      VoiceStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceStarting';

  @override
  final MappableFields<VoiceStarting> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'stage';
  @override
  final dynamic discriminatorValue = 'starting';
  @override
  late final ClassMapperBase superMapper = VoiceStateMapper.ensureInitialized();

  static VoiceStarting _instantiate(DecodingData data) {
    return VoiceStarting();
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceStarting fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceStarting>(map);
  }

  static VoiceStarting fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceStarting>(json);
  }
}

mixin VoiceStartingMappable {
  String toJson() {
    return VoiceStartingMapper.ensureInitialized().encodeJson<VoiceStarting>(
      this as VoiceStarting,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceStartingMapper.ensureInitialized().encodeMap<VoiceStarting>(
      this as VoiceStarting,
    );
  }

  VoiceStartingCopyWith<VoiceStarting, VoiceStarting, VoiceStarting>
  get copyWith => _VoiceStartingCopyWithImpl<VoiceStarting, VoiceStarting>(
    this as VoiceStarting,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return VoiceStartingMapper.ensureInitialized().stringifyValue(
      this as VoiceStarting,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceStartingMapper.ensureInitialized().equalsValue(
      this as VoiceStarting,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceStartingMapper.ensureInitialized().hashValue(
      this as VoiceStarting,
    );
  }
}

extension VoiceStartingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VoiceStarting, $Out> {
  VoiceStartingCopyWith<$R, VoiceStarting, $Out> get $asVoiceStarting =>
      $base.as((v, t, t2) => _VoiceStartingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceStartingCopyWith<$R, $In extends VoiceStarting, $Out>
    implements VoiceStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  VoiceStartingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoiceStartingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceStarting, $Out>
    implements VoiceStartingCopyWith<$R, VoiceStarting, $Out> {
  _VoiceStartingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceStarting> $mapper =
      VoiceStartingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  VoiceStarting $make(CopyWithData data) => VoiceStarting();

  @override
  VoiceStartingCopyWith<$R2, VoiceStarting, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceStartingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VoiceRecordingMapper extends SubClassMapperBase<VoiceRecording> {
  VoiceRecordingMapper._();

  static VoiceRecordingMapper? _instance;
  static VoiceRecordingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceRecordingMapper._());
      VoiceStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceRecording';

  static Duration _$elapsed(VoiceRecording v) => v.elapsed;
  static const Field<VoiceRecording, Duration> _f$elapsed = Field(
    'elapsed',
    _$elapsed,
    key: r'elapsed_ms',
    hook: MillisecondsHook(),
  );
  static List<double> _$levels(VoiceRecording v) => v.levels;
  static const Field<VoiceRecording, List<double>> _f$levels = Field(
    'levels',
    _$levels,
  );

  @override
  final MappableFields<VoiceRecording> fields = const {
    #elapsed: _f$elapsed,
    #levels: _f$levels,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'stage';
  @override
  final dynamic discriminatorValue = 'recording';
  @override
  late final ClassMapperBase superMapper = VoiceStateMapper.ensureInitialized();

  static VoiceRecording _instantiate(DecodingData data) {
    return VoiceRecording(
      elapsed: data.dec(_f$elapsed),
      levels: data.dec(_f$levels),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceRecording fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceRecording>(map);
  }

  static VoiceRecording fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceRecording>(json);
  }
}

mixin VoiceRecordingMappable {
  String toJson() {
    return VoiceRecordingMapper.ensureInitialized().encodeJson<VoiceRecording>(
      this as VoiceRecording,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceRecordingMapper.ensureInitialized().encodeMap<VoiceRecording>(
      this as VoiceRecording,
    );
  }

  VoiceRecordingCopyWith<VoiceRecording, VoiceRecording, VoiceRecording>
  get copyWith => _VoiceRecordingCopyWithImpl<VoiceRecording, VoiceRecording>(
    this as VoiceRecording,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return VoiceRecordingMapper.ensureInitialized().stringifyValue(
      this as VoiceRecording,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceRecordingMapper.ensureInitialized().equalsValue(
      this as VoiceRecording,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceRecordingMapper.ensureInitialized().hashValue(
      this as VoiceRecording,
    );
  }
}

extension VoiceRecordingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VoiceRecording, $Out> {
  VoiceRecordingCopyWith<$R, VoiceRecording, $Out> get $asVoiceRecording =>
      $base.as((v, t, t2) => _VoiceRecordingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceRecordingCopyWith<$R, $In extends VoiceRecording, $Out>
    implements VoiceStateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get levels;
  @override
  $R call({Duration? elapsed, List<double>? levels});
  VoiceRecordingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VoiceRecordingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceRecording, $Out>
    implements VoiceRecordingCopyWith<$R, VoiceRecording, $Out> {
  _VoiceRecordingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceRecording> $mapper =
      VoiceRecordingMapper.ensureInitialized();
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get levels =>
      ListCopyWith(
        $value.levels,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(levels: v),
      );
  @override
  $R call({Duration? elapsed, List<double>? levels}) => $apply(
    FieldCopyWithData({
      if (elapsed != null) #elapsed: elapsed,
      if (levels != null) #levels: levels,
    }),
  );
  @override
  VoiceRecording $make(CopyWithData data) => VoiceRecording(
    elapsed: data.get(#elapsed, or: $value.elapsed),
    levels: data.get(#levels, or: $value.levels),
  );

  @override
  VoiceRecordingCopyWith<$R2, VoiceRecording, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceRecordingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VoiceKeptMapper extends SubClassMapperBase<VoiceKept> {
  VoiceKeptMapper._();

  static VoiceKeptMapper? _instance;
  static VoiceKeptMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceKeptMapper._());
      VoiceStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceKept';

  static String _$path(VoiceKept v) => v.path;
  static const Field<VoiceKept, String> _f$path = Field('path', _$path);
  static Duration _$duration(VoiceKept v) => v.duration;
  static const Field<VoiceKept, Duration> _f$duration = Field(
    'duration',
    _$duration,
    key: r'duration_ms',
    hook: MillisecondsHook(),
  );
  static List<double> _$levels(VoiceKept v) => v.levels;
  static const Field<VoiceKept, List<double>> _f$levels = Field(
    'levels',
    _$levels,
  );
  static bool _$atLimit(VoiceKept v) => v.atLimit;
  static const Field<VoiceKept, bool> _f$atLimit = Field(
    'atLimit',
    _$atLimit,
    key: r'at_limit',
  );

  @override
  final MappableFields<VoiceKept> fields = const {
    #path: _f$path,
    #duration: _f$duration,
    #levels: _f$levels,
    #atLimit: _f$atLimit,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'stage';
  @override
  final dynamic discriminatorValue = 'kept';
  @override
  late final ClassMapperBase superMapper = VoiceStateMapper.ensureInitialized();

  static VoiceKept _instantiate(DecodingData data) {
    return VoiceKept(
      path: data.dec(_f$path),
      duration: data.dec(_f$duration),
      levels: data.dec(_f$levels),
      atLimit: data.dec(_f$atLimit),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceKept fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceKept>(map);
  }

  static VoiceKept fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceKept>(json);
  }
}

mixin VoiceKeptMappable {
  String toJson() {
    return VoiceKeptMapper.ensureInitialized().encodeJson<VoiceKept>(
      this as VoiceKept,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceKeptMapper.ensureInitialized().encodeMap<VoiceKept>(
      this as VoiceKept,
    );
  }

  VoiceKeptCopyWith<VoiceKept, VoiceKept, VoiceKept> get copyWith =>
      _VoiceKeptCopyWithImpl<VoiceKept, VoiceKept>(
        this as VoiceKept,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VoiceKeptMapper.ensureInitialized().stringifyValue(
      this as VoiceKept,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceKeptMapper.ensureInitialized().equalsValue(
      this as VoiceKept,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceKeptMapper.ensureInitialized().hashValue(this as VoiceKept);
  }
}

extension VoiceKeptValueCopy<$R, $Out> on ObjectCopyWith<$R, VoiceKept, $Out> {
  VoiceKeptCopyWith<$R, VoiceKept, $Out> get $asVoiceKept =>
      $base.as((v, t, t2) => _VoiceKeptCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceKeptCopyWith<$R, $In extends VoiceKept, $Out>
    implements VoiceStateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get levels;
  @override
  $R call({
    String? path,
    Duration? duration,
    List<double>? levels,
    bool? atLimit,
  });
  VoiceKeptCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoiceKeptCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceKept, $Out>
    implements VoiceKeptCopyWith<$R, VoiceKept, $Out> {
  _VoiceKeptCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceKept> $mapper =
      VoiceKeptMapper.ensureInitialized();
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get levels =>
      ListCopyWith(
        $value.levels,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(levels: v),
      );
  @override
  $R call({
    String? path,
    Duration? duration,
    List<double>? levels,
    bool? atLimit,
  }) => $apply(
    FieldCopyWithData({
      if (path != null) #path: path,
      if (duration != null) #duration: duration,
      if (levels != null) #levels: levels,
      if (atLimit != null) #atLimit: atLimit,
    }),
  );
  @override
  VoiceKept $make(CopyWithData data) => VoiceKept(
    path: data.get(#path, or: $value.path),
    duration: data.get(#duration, or: $value.duration),
    levels: data.get(#levels, or: $value.levels),
    atLimit: data.get(#atLimit, or: $value.atLimit),
  );

  @override
  VoiceKeptCopyWith<$R2, VoiceKept, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceKeptCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VoiceSendingMapper extends SubClassMapperBase<VoiceSending> {
  VoiceSendingMapper._();

  static VoiceSendingMapper? _instance;
  static VoiceSendingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoiceSendingMapper._());
      VoiceStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'VoiceSending';

  static Duration _$shown(VoiceSending v) => v.shown;
  static const Field<VoiceSending, Duration> _f$shown = Field(
    'shown',
    _$shown,
    key: r'shown_ms',
    hook: MillisecondsHook(),
  );
  static List<double> _$levels(VoiceSending v) => v.levels;
  static const Field<VoiceSending, List<double>> _f$levels = Field(
    'levels',
    _$levels,
  );

  @override
  final MappableFields<VoiceSending> fields = const {
    #shown: _f$shown,
    #levels: _f$levels,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'stage';
  @override
  final dynamic discriminatorValue = 'sending';
  @override
  late final ClassMapperBase superMapper = VoiceStateMapper.ensureInitialized();

  static VoiceSending _instantiate(DecodingData data) {
    return VoiceSending(shown: data.dec(_f$shown), levels: data.dec(_f$levels));
  }

  @override
  final Function instantiate = _instantiate;

  static VoiceSending fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VoiceSending>(map);
  }

  static VoiceSending fromJson(String json) {
    return ensureInitialized().decodeJson<VoiceSending>(json);
  }
}

mixin VoiceSendingMappable {
  String toJson() {
    return VoiceSendingMapper.ensureInitialized().encodeJson<VoiceSending>(
      this as VoiceSending,
    );
  }

  Map<String, dynamic> toMap() {
    return VoiceSendingMapper.ensureInitialized().encodeMap<VoiceSending>(
      this as VoiceSending,
    );
  }

  VoiceSendingCopyWith<VoiceSending, VoiceSending, VoiceSending> get copyWith =>
      _VoiceSendingCopyWithImpl<VoiceSending, VoiceSending>(
        this as VoiceSending,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VoiceSendingMapper.ensureInitialized().stringifyValue(
      this as VoiceSending,
    );
  }

  @override
  bool operator ==(Object other) {
    return VoiceSendingMapper.ensureInitialized().equalsValue(
      this as VoiceSending,
      other,
    );
  }

  @override
  int get hashCode {
    return VoiceSendingMapper.ensureInitialized().hashValue(
      this as VoiceSending,
    );
  }
}

extension VoiceSendingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VoiceSending, $Out> {
  VoiceSendingCopyWith<$R, VoiceSending, $Out> get $asVoiceSending =>
      $base.as((v, t, t2) => _VoiceSendingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoiceSendingCopyWith<$R, $In extends VoiceSending, $Out>
    implements VoiceStateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get levels;
  @override
  $R call({Duration? shown, List<double>? levels});
  VoiceSendingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoiceSendingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VoiceSending, $Out>
    implements VoiceSendingCopyWith<$R, VoiceSending, $Out> {
  _VoiceSendingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VoiceSending> $mapper =
      VoiceSendingMapper.ensureInitialized();
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get levels =>
      ListCopyWith(
        $value.levels,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(levels: v),
      );
  @override
  $R call({Duration? shown, List<double>? levels}) => $apply(
    FieldCopyWithData({
      if (shown != null) #shown: shown,
      if (levels != null) #levels: levels,
    }),
  );
  @override
  VoiceSending $make(CopyWithData data) => VoiceSending(
    shown: data.get(#shown, or: $value.shown),
    levels: data.get(#levels, or: $value.levels),
  );

  @override
  VoiceSendingCopyWith<$R2, VoiceSending, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VoiceSendingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

