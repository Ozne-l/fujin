// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'upload_phase.dart';

class UploadPhaseMapper extends ClassMapperBase<UploadPhase> {
  UploadPhaseMapper._();

  static UploadPhaseMapper? _instance;
  static UploadPhaseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadPhaseMapper._());
      UploadPreparingMapper.ensureInitialized();
      UploadSendingMapper.ensureInitialized();
      UploadNotSentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UploadPhase';

  @override
  final MappableFields<UploadPhase> fields = const {};
  @override
  final bool ignoreNull = true;

  static UploadPhase _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'UploadPhase',
      'phase',
      '${data.value['phase']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UploadPhase fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadPhase>(map);
  }

  static UploadPhase fromJson(String json) {
    return ensureInitialized().decodeJson<UploadPhase>(json);
  }
}

mixin UploadPhaseMappable {
  String toJson();
  Map<String, dynamic> toMap();
  UploadPhaseCopyWith<UploadPhase, UploadPhase, UploadPhase> get copyWith;
}

abstract class UploadPhaseCopyWith<$R, $In extends UploadPhase, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  UploadPhaseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class UploadPreparingMapper extends SubClassMapperBase<UploadPreparing> {
  UploadPreparingMapper._();

  static UploadPreparingMapper? _instance;
  static UploadPreparingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadPreparingMapper._());
      UploadPhaseMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UploadPreparing';

  static int _$videos(UploadPreparing v) => v.videos;
  static const Field<UploadPreparing, int> _f$videos = Field(
    'videos',
    _$videos,
  );
  static int _$percent(UploadPreparing v) => v.percent;
  static const Field<UploadPreparing, int> _f$percent = Field(
    'percent',
    _$percent,
  );

  @override
  final MappableFields<UploadPreparing> fields = const {
    #videos: _f$videos,
    #percent: _f$percent,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'phase';
  @override
  final dynamic discriminatorValue = 'preparing';
  @override
  late final ClassMapperBase superMapper =
      UploadPhaseMapper.ensureInitialized();

  static UploadPreparing _instantiate(DecodingData data) {
    return UploadPreparing(
      videos: data.dec(_f$videos),
      percent: data.dec(_f$percent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UploadPreparing fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadPreparing>(map);
  }

  static UploadPreparing fromJson(String json) {
    return ensureInitialized().decodeJson<UploadPreparing>(json);
  }
}

mixin UploadPreparingMappable {
  String toJson() {
    return UploadPreparingMapper.ensureInitialized()
        .encodeJson<UploadPreparing>(this as UploadPreparing);
  }

  Map<String, dynamic> toMap() {
    return UploadPreparingMapper.ensureInitialized().encodeMap<UploadPreparing>(
      this as UploadPreparing,
    );
  }

  UploadPreparingCopyWith<UploadPreparing, UploadPreparing, UploadPreparing>
  get copyWith =>
      _UploadPreparingCopyWithImpl<UploadPreparing, UploadPreparing>(
        this as UploadPreparing,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UploadPreparingMapper.ensureInitialized().stringifyValue(
      this as UploadPreparing,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadPreparingMapper.ensureInitialized().equalsValue(
      this as UploadPreparing,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadPreparingMapper.ensureInitialized().hashValue(
      this as UploadPreparing,
    );
  }
}

extension UploadPreparingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadPreparing, $Out> {
  UploadPreparingCopyWith<$R, UploadPreparing, $Out> get $asUploadPreparing =>
      $base.as((v, t, t2) => _UploadPreparingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadPreparingCopyWith<$R, $In extends UploadPreparing, $Out>
    implements UploadPhaseCopyWith<$R, $In, $Out> {
  @override
  $R call({int? videos, int? percent});
  UploadPreparingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UploadPreparingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadPreparing, $Out>
    implements UploadPreparingCopyWith<$R, UploadPreparing, $Out> {
  _UploadPreparingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadPreparing> $mapper =
      UploadPreparingMapper.ensureInitialized();
  @override
  $R call({int? videos, int? percent}) => $apply(
    FieldCopyWithData({
      if (videos != null) #videos: videos,
      if (percent != null) #percent: percent,
    }),
  );
  @override
  UploadPreparing $make(CopyWithData data) => UploadPreparing(
    videos: data.get(#videos, or: $value.videos),
    percent: data.get(#percent, or: $value.percent),
  );

  @override
  UploadPreparingCopyWith<$R2, UploadPreparing, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadPreparingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UploadSendingMapper extends SubClassMapperBase<UploadSending> {
  UploadSendingMapper._();

  static UploadSendingMapper? _instance;
  static UploadSendingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadSendingMapper._());
      UploadPhaseMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UploadSending';

  static int _$percent(UploadSending v) => v.percent;
  static const Field<UploadSending, int> _f$percent = Field(
    'percent',
    _$percent,
  );
  static bool _$waiting(UploadSending v) => v.waiting;
  static const Field<UploadSending, bool> _f$waiting = Field(
    'waiting',
    _$waiting,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<UploadSending> fields = const {
    #percent: _f$percent,
    #waiting: _f$waiting,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'phase';
  @override
  final dynamic discriminatorValue = 'sending';
  @override
  late final ClassMapperBase superMapper =
      UploadPhaseMapper.ensureInitialized();

  static UploadSending _instantiate(DecodingData data) {
    return UploadSending(
      percent: data.dec(_f$percent),
      waiting: data.dec(_f$waiting),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UploadSending fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadSending>(map);
  }

  static UploadSending fromJson(String json) {
    return ensureInitialized().decodeJson<UploadSending>(json);
  }
}

mixin UploadSendingMappable {
  String toJson() {
    return UploadSendingMapper.ensureInitialized().encodeJson<UploadSending>(
      this as UploadSending,
    );
  }

  Map<String, dynamic> toMap() {
    return UploadSendingMapper.ensureInitialized().encodeMap<UploadSending>(
      this as UploadSending,
    );
  }

  UploadSendingCopyWith<UploadSending, UploadSending, UploadSending>
  get copyWith => _UploadSendingCopyWithImpl<UploadSending, UploadSending>(
    this as UploadSending,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UploadSendingMapper.ensureInitialized().stringifyValue(
      this as UploadSending,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadSendingMapper.ensureInitialized().equalsValue(
      this as UploadSending,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadSendingMapper.ensureInitialized().hashValue(
      this as UploadSending,
    );
  }
}

extension UploadSendingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadSending, $Out> {
  UploadSendingCopyWith<$R, UploadSending, $Out> get $asUploadSending =>
      $base.as((v, t, t2) => _UploadSendingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadSendingCopyWith<$R, $In extends UploadSending, $Out>
    implements UploadPhaseCopyWith<$R, $In, $Out> {
  @override
  $R call({int? percent, bool? waiting});
  UploadSendingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UploadSendingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadSending, $Out>
    implements UploadSendingCopyWith<$R, UploadSending, $Out> {
  _UploadSendingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadSending> $mapper =
      UploadSendingMapper.ensureInitialized();
  @override
  $R call({int? percent, bool? waiting}) => $apply(
    FieldCopyWithData({
      if (percent != null) #percent: percent,
      if (waiting != null) #waiting: waiting,
    }),
  );
  @override
  UploadSending $make(CopyWithData data) => UploadSending(
    percent: data.get(#percent, or: $value.percent),
    waiting: data.get(#waiting, or: $value.waiting),
  );

  @override
  UploadSendingCopyWith<$R2, UploadSending, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadSendingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UploadNotSentMapper extends SubClassMapperBase<UploadNotSent> {
  UploadNotSentMapper._();

  static UploadNotSentMapper? _instance;
  static UploadNotSentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadNotSentMapper._());
      UploadPhaseMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'UploadNotSent';

  @override
  final MappableFields<UploadNotSent> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'phase';
  @override
  final dynamic discriminatorValue = 'not_sent';
  @override
  late final ClassMapperBase superMapper =
      UploadPhaseMapper.ensureInitialized();

  static UploadNotSent _instantiate(DecodingData data) {
    return UploadNotSent();
  }

  @override
  final Function instantiate = _instantiate;

  static UploadNotSent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadNotSent>(map);
  }

  static UploadNotSent fromJson(String json) {
    return ensureInitialized().decodeJson<UploadNotSent>(json);
  }
}

mixin UploadNotSentMappable {
  String toJson() {
    return UploadNotSentMapper.ensureInitialized().encodeJson<UploadNotSent>(
      this as UploadNotSent,
    );
  }

  Map<String, dynamic> toMap() {
    return UploadNotSentMapper.ensureInitialized().encodeMap<UploadNotSent>(
      this as UploadNotSent,
    );
  }

  UploadNotSentCopyWith<UploadNotSent, UploadNotSent, UploadNotSent>
  get copyWith => _UploadNotSentCopyWithImpl<UploadNotSent, UploadNotSent>(
    this as UploadNotSent,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UploadNotSentMapper.ensureInitialized().stringifyValue(
      this as UploadNotSent,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadNotSentMapper.ensureInitialized().equalsValue(
      this as UploadNotSent,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadNotSentMapper.ensureInitialized().hashValue(
      this as UploadNotSent,
    );
  }
}

extension UploadNotSentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadNotSent, $Out> {
  UploadNotSentCopyWith<$R, UploadNotSent, $Out> get $asUploadNotSent =>
      $base.as((v, t, t2) => _UploadNotSentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadNotSentCopyWith<$R, $In extends UploadNotSent, $Out>
    implements UploadPhaseCopyWith<$R, $In, $Out> {
  @override
  $R call();
  UploadNotSentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UploadNotSentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadNotSent, $Out>
    implements UploadNotSentCopyWith<$R, UploadNotSent, $Out> {
  _UploadNotSentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadNotSent> $mapper =
      UploadNotSentMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  UploadNotSent $make(CopyWithData data) => UploadNotSent();

  @override
  UploadNotSentCopyWith<$R2, UploadNotSent, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadNotSentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

