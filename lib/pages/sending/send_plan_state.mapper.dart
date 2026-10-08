// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_plan_state.dart';

class SendPlanStateMapper extends ClassMapperBase<SendPlanState> {
  SendPlanStateMapper._();

  static SendPlanStateMapper? _instance;
  static SendPlanStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendPlanStateMapper._());
      SendPlanSearchingMapper.ensureInitialized();
      SendPlanReadyMapper.ensureInitialized();
      SendPlanFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendPlanState';

  @override
  final MappableFields<SendPlanState> fields = const {};
  @override
  final bool ignoreNull = true;

  static SendPlanState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'SendPlanState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendPlanState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendPlanState>(map);
  }

  static SendPlanState fromJson(String json) {
    return ensureInitialized().decodeJson<SendPlanState>(json);
  }
}

mixin SendPlanStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SendPlanStateCopyWith<SendPlanState, SendPlanState, SendPlanState>
  get copyWith;
}

abstract class SendPlanStateCopyWith<$R, $In extends SendPlanState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SendPlanStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class SendPlanSearchingMapper extends SubClassMapperBase<SendPlanSearching> {
  SendPlanSearchingMapper._();

  static SendPlanSearchingMapper? _instance;
  static SendPlanSearchingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendPlanSearchingMapper._());
      SendPlanStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendPlanMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendPlanSearching';

  static SendPlan _$plan(SendPlanSearching v) => v.plan;
  static const Field<SendPlanSearching, SendPlan> _f$plan = Field(
    'plan',
    _$plan,
  );

  @override
  final MappableFields<SendPlanSearching> fields = const {#plan: _f$plan};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'searching';
  @override
  late final ClassMapperBase superMapper =
      SendPlanStateMapper.ensureInitialized();

  static SendPlanSearching _instantiate(DecodingData data) {
    return SendPlanSearching(data.dec(_f$plan));
  }

  @override
  final Function instantiate = _instantiate;

  static SendPlanSearching fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendPlanSearching>(map);
  }

  static SendPlanSearching fromJson(String json) {
    return ensureInitialized().decodeJson<SendPlanSearching>(json);
  }
}

mixin SendPlanSearchingMappable {
  String toJson() {
    return SendPlanSearchingMapper.ensureInitialized()
        .encodeJson<SendPlanSearching>(this as SendPlanSearching);
  }

  Map<String, dynamic> toMap() {
    return SendPlanSearchingMapper.ensureInitialized()
        .encodeMap<SendPlanSearching>(this as SendPlanSearching);
  }

  SendPlanSearchingCopyWith<
    SendPlanSearching,
    SendPlanSearching,
    SendPlanSearching
  >
  get copyWith =>
      _SendPlanSearchingCopyWithImpl<SendPlanSearching, SendPlanSearching>(
        this as SendPlanSearching,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendPlanSearchingMapper.ensureInitialized().stringifyValue(
      this as SendPlanSearching,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendPlanSearchingMapper.ensureInitialized().equalsValue(
      this as SendPlanSearching,
      other,
    );
  }

  @override
  int get hashCode {
    return SendPlanSearchingMapper.ensureInitialized().hashValue(
      this as SendPlanSearching,
    );
  }
}

extension SendPlanSearchingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendPlanSearching, $Out> {
  SendPlanSearchingCopyWith<$R, SendPlanSearching, $Out>
  get $asSendPlanSearching => $base.as(
    (v, t, t2) => _SendPlanSearchingCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SendPlanSearchingCopyWith<
  $R,
  $In extends SendPlanSearching,
  $Out
>
    implements SendPlanStateCopyWith<$R, $In, $Out> {
  SendPlanCopyWith<$R, SendPlan, SendPlan> get plan;
  @override
  $R call({SendPlan? plan});
  SendPlanSearchingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SendPlanSearchingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendPlanSearching, $Out>
    implements SendPlanSearchingCopyWith<$R, SendPlanSearching, $Out> {
  _SendPlanSearchingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendPlanSearching> $mapper =
      SendPlanSearchingMapper.ensureInitialized();
  @override
  SendPlanCopyWith<$R, SendPlan, SendPlan> get plan =>
      $value.plan.copyWith.$chain((v) => call(plan: v));
  @override
  $R call({SendPlan? plan}) =>
      $apply(FieldCopyWithData({if (plan != null) #plan: plan}));
  @override
  SendPlanSearching $make(CopyWithData data) =>
      SendPlanSearching(data.get(#plan, or: $value.plan));

  @override
  SendPlanSearchingCopyWith<$R2, SendPlanSearching, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendPlanSearchingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SendPlanReadyMapper extends SubClassMapperBase<SendPlanReady> {
  SendPlanReadyMapper._();

  static SendPlanReadyMapper? _instance;
  static SendPlanReadyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendPlanReadyMapper._());
      SendPlanStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendPlanMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendPlanReady';

  static SendPlan _$plan(SendPlanReady v) => v.plan;
  static const Field<SendPlanReady, SendPlan> _f$plan = Field('plan', _$plan);

  @override
  final MappableFields<SendPlanReady> fields = const {#plan: _f$plan};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'ready';
  @override
  late final ClassMapperBase superMapper =
      SendPlanStateMapper.ensureInitialized();

  static SendPlanReady _instantiate(DecodingData data) {
    return SendPlanReady(data.dec(_f$plan));
  }

  @override
  final Function instantiate = _instantiate;

  static SendPlanReady fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendPlanReady>(map);
  }

  static SendPlanReady fromJson(String json) {
    return ensureInitialized().decodeJson<SendPlanReady>(json);
  }
}

mixin SendPlanReadyMappable {
  String toJson() {
    return SendPlanReadyMapper.ensureInitialized().encodeJson<SendPlanReady>(
      this as SendPlanReady,
    );
  }

  Map<String, dynamic> toMap() {
    return SendPlanReadyMapper.ensureInitialized().encodeMap<SendPlanReady>(
      this as SendPlanReady,
    );
  }

  SendPlanReadyCopyWith<SendPlanReady, SendPlanReady, SendPlanReady>
  get copyWith => _SendPlanReadyCopyWithImpl<SendPlanReady, SendPlanReady>(
    this as SendPlanReady,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SendPlanReadyMapper.ensureInitialized().stringifyValue(
      this as SendPlanReady,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendPlanReadyMapper.ensureInitialized().equalsValue(
      this as SendPlanReady,
      other,
    );
  }

  @override
  int get hashCode {
    return SendPlanReadyMapper.ensureInitialized().hashValue(
      this as SendPlanReady,
    );
  }
}

extension SendPlanReadyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendPlanReady, $Out> {
  SendPlanReadyCopyWith<$R, SendPlanReady, $Out> get $asSendPlanReady =>
      $base.as((v, t, t2) => _SendPlanReadyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendPlanReadyCopyWith<$R, $In extends SendPlanReady, $Out>
    implements SendPlanStateCopyWith<$R, $In, $Out> {
  SendPlanCopyWith<$R, SendPlan, SendPlan> get plan;
  @override
  $R call({SendPlan? plan});
  SendPlanReadyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendPlanReadyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendPlanReady, $Out>
    implements SendPlanReadyCopyWith<$R, SendPlanReady, $Out> {
  _SendPlanReadyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendPlanReady> $mapper =
      SendPlanReadyMapper.ensureInitialized();
  @override
  SendPlanCopyWith<$R, SendPlan, SendPlan> get plan =>
      $value.plan.copyWith.$chain((v) => call(plan: v));
  @override
  $R call({SendPlan? plan}) =>
      $apply(FieldCopyWithData({if (plan != null) #plan: plan}));
  @override
  SendPlanReady $make(CopyWithData data) =>
      SendPlanReady(data.get(#plan, or: $value.plan));

  @override
  SendPlanReadyCopyWith<$R2, SendPlanReady, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendPlanReadyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SendPlanFailedMapper extends SubClassMapperBase<SendPlanFailed> {
  SendPlanFailedMapper._();

  static SendPlanFailedMapper? _instance;
  static SendPlanFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendPlanFailedMapper._());
      SendPlanStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendPlanMapper.ensureInitialized();
      SendFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendPlanFailed';

  static SendPlan _$plan(SendPlanFailed v) => v.plan;
  static const Field<SendPlanFailed, SendPlan> _f$plan = Field('plan', _$plan);
  static SendFailure _$failure(SendPlanFailed v) => v.failure;
  static const Field<SendPlanFailed, SendFailure> _f$failure = Field(
    'failure',
    _$failure,
  );

  @override
  final MappableFields<SendPlanFailed> fields = const {
    #plan: _f$plan,
    #failure: _f$failure,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      SendPlanStateMapper.ensureInitialized();

  static SendPlanFailed _instantiate(DecodingData data) {
    return SendPlanFailed(data.dec(_f$plan), data.dec(_f$failure));
  }

  @override
  final Function instantiate = _instantiate;

  static SendPlanFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendPlanFailed>(map);
  }

  static SendPlanFailed fromJson(String json) {
    return ensureInitialized().decodeJson<SendPlanFailed>(json);
  }
}

mixin SendPlanFailedMappable {
  String toJson() {
    return SendPlanFailedMapper.ensureInitialized().encodeJson<SendPlanFailed>(
      this as SendPlanFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return SendPlanFailedMapper.ensureInitialized().encodeMap<SendPlanFailed>(
      this as SendPlanFailed,
    );
  }

  SendPlanFailedCopyWith<SendPlanFailed, SendPlanFailed, SendPlanFailed>
  get copyWith => _SendPlanFailedCopyWithImpl<SendPlanFailed, SendPlanFailed>(
    this as SendPlanFailed,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SendPlanFailedMapper.ensureInitialized().stringifyValue(
      this as SendPlanFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendPlanFailedMapper.ensureInitialized().equalsValue(
      this as SendPlanFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return SendPlanFailedMapper.ensureInitialized().hashValue(
      this as SendPlanFailed,
    );
  }
}

extension SendPlanFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendPlanFailed, $Out> {
  SendPlanFailedCopyWith<$R, SendPlanFailed, $Out> get $asSendPlanFailed =>
      $base.as((v, t, t2) => _SendPlanFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendPlanFailedCopyWith<$R, $In extends SendPlanFailed, $Out>
    implements SendPlanStateCopyWith<$R, $In, $Out> {
  SendPlanCopyWith<$R, SendPlan, SendPlan> get plan;
  @override
  $R call({SendPlan? plan, SendFailure? failure});
  SendPlanFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SendPlanFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendPlanFailed, $Out>
    implements SendPlanFailedCopyWith<$R, SendPlanFailed, $Out> {
  _SendPlanFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendPlanFailed> $mapper =
      SendPlanFailedMapper.ensureInitialized();
  @override
  SendPlanCopyWith<$R, SendPlan, SendPlan> get plan =>
      $value.plan.copyWith.$chain((v) => call(plan: v));
  @override
  $R call({SendPlan? plan, SendFailure? failure}) => $apply(
    FieldCopyWithData({
      if (plan != null) #plan: plan,
      if (failure != null) #failure: failure,
    }),
  );
  @override
  SendPlanFailed $make(CopyWithData data) => SendPlanFailed(
    data.get(#plan, or: $value.plan),
    data.get(#failure, or: $value.failure),
  );

  @override
  SendPlanFailedCopyWith<$R2, SendPlanFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendPlanFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

