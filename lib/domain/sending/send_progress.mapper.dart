// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_progress.dart';

class SendProgressMapper extends ClassMapperBase<SendProgress> {
  SendProgressMapper._();

  static SendProgressMapper? _instance;
  static SendProgressMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendProgressMapper._());
      SendStepMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendProgress';

  static List<SendStep> _$steps(SendProgress v) => v.steps;
  static const Field<SendProgress, List<SendStep>> _f$steps = Field(
    'steps',
    _$steps,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<SendProgress> fields = const {#steps: _f$steps};
  @override
  final bool ignoreNull = true;

  static SendProgress _instantiate(DecodingData data) {
    return SendProgress(steps: data.dec(_f$steps));
  }

  @override
  final Function instantiate = _instantiate;

  static SendProgress fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendProgress>(map);
  }

  static SendProgress fromJson(String json) {
    return ensureInitialized().decodeJson<SendProgress>(json);
  }
}

mixin SendProgressMappable {
  String toJson() {
    return SendProgressMapper.ensureInitialized().encodeJson<SendProgress>(
      this as SendProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return SendProgressMapper.ensureInitialized().encodeMap<SendProgress>(
      this as SendProgress,
    );
  }

  SendProgressCopyWith<SendProgress, SendProgress, SendProgress> get copyWith =>
      _SendProgressCopyWithImpl<SendProgress, SendProgress>(
        this as SendProgress,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendProgressMapper.ensureInitialized().stringifyValue(
      this as SendProgress,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendProgressMapper.ensureInitialized().equalsValue(
      this as SendProgress,
      other,
    );
  }

  @override
  int get hashCode {
    return SendProgressMapper.ensureInitialized().hashValue(
      this as SendProgress,
    );
  }
}

extension SendProgressValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendProgress, $Out> {
  SendProgressCopyWith<$R, SendProgress, $Out> get $asSendProgress =>
      $base.as((v, t, t2) => _SendProgressCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendProgressCopyWith<$R, $In extends SendProgress, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, SendStep, SendStepCopyWith<$R, SendStep, SendStep>>
  get steps;
  $R call({List<SendStep>? steps});
  SendProgressCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendProgressCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendProgress, $Out>
    implements SendProgressCopyWith<$R, SendProgress, $Out> {
  _SendProgressCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendProgress> $mapper =
      SendProgressMapper.ensureInitialized();
  @override
  ListCopyWith<$R, SendStep, SendStepCopyWith<$R, SendStep, SendStep>>
  get steps => ListCopyWith(
    $value.steps,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(steps: v),
  );
  @override
  $R call({List<SendStep>? steps}) =>
      $apply(FieldCopyWithData({if (steps != null) #steps: steps}));
  @override
  SendProgress $make(CopyWithData data) =>
      SendProgress(steps: data.get(#steps, or: $value.steps));

  @override
  SendProgressCopyWith<$R2, SendProgress, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendProgressCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

