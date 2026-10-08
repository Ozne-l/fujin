// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_plan.dart';

class SendPlanMapper extends ClassMapperBase<SendPlan> {
  SendPlanMapper._();

  static SendPlanMapper? _instance;
  static SendPlanMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendPlanMapper._());
      PlannedEntryMapper.ensureInitialized();
      MfpFoodEntryMapper.ensureInitialized();
      ComparedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendPlan';

  static DateTime _$date(SendPlan v) => v.date;
  static const Field<SendPlan, DateTime> _f$date = Field('date', _$date);
  static List<PlannedEntry> _$entries(SendPlan v) => v.entries;
  static const Field<SendPlan, List<PlannedEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );
  static List<MfpFoodEntry> _$pending(SendPlan v) => v.pending;
  static const Field<SendPlan, List<MfpFoodEntry>> _f$pending = Field(
    'pending',
    _$pending,
    opt: true,
    def: const [],
  );
  static List<ComparedEntry> _$inEkklo(SendPlan v) => v.inEkklo;
  static const Field<SendPlan, List<ComparedEntry>> _f$inEkklo = Field(
    'inEkklo',
    _$inEkklo,
    key: r'in_ekklo',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<SendPlan> fields = const {
    #date: _f$date,
    #entries: _f$entries,
    #pending: _f$pending,
    #inEkklo: _f$inEkklo,
  };
  @override
  final bool ignoreNull = true;

  static SendPlan _instantiate(DecodingData data) {
    return SendPlan(
      date: data.dec(_f$date),
      entries: data.dec(_f$entries),
      pending: data.dec(_f$pending),
      inEkklo: data.dec(_f$inEkklo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendPlan fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendPlan>(map);
  }

  static SendPlan fromJson(String json) {
    return ensureInitialized().decodeJson<SendPlan>(json);
  }
}

mixin SendPlanMappable {
  String toJson() {
    return SendPlanMapper.ensureInitialized().encodeJson<SendPlan>(
      this as SendPlan,
    );
  }

  Map<String, dynamic> toMap() {
    return SendPlanMapper.ensureInitialized().encodeMap<SendPlan>(
      this as SendPlan,
    );
  }

  SendPlanCopyWith<SendPlan, SendPlan, SendPlan> get copyWith =>
      _SendPlanCopyWithImpl<SendPlan, SendPlan>(
        this as SendPlan,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendPlanMapper.ensureInitialized().stringifyValue(this as SendPlan);
  }

  @override
  bool operator ==(Object other) {
    return SendPlanMapper.ensureInitialized().equalsValue(
      this as SendPlan,
      other,
    );
  }

  @override
  int get hashCode {
    return SendPlanMapper.ensureInitialized().hashValue(this as SendPlan);
  }
}

extension SendPlanValueCopy<$R, $Out> on ObjectCopyWith<$R, SendPlan, $Out> {
  SendPlanCopyWith<$R, SendPlan, $Out> get $asSendPlan =>
      $base.as((v, t, t2) => _SendPlanCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendPlanCopyWith<$R, $In extends SendPlan, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PlannedEntry,
    PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry>
  >
  get entries;
  ListCopyWith<
    $R,
    MfpFoodEntry,
    MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry>
  >
  get pending;
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get inEkklo;
  $R call({
    DateTime? date,
    List<PlannedEntry>? entries,
    List<MfpFoodEntry>? pending,
    List<ComparedEntry>? inEkklo,
  });
  SendPlanCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendPlanCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendPlan, $Out>
    implements SendPlanCopyWith<$R, SendPlan, $Out> {
  _SendPlanCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendPlan> $mapper =
      SendPlanMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PlannedEntry,
    PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry>
  >
  get entries => ListCopyWith(
    $value.entries,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(entries: v),
  );
  @override
  ListCopyWith<
    $R,
    MfpFoodEntry,
    MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry>
  >
  get pending => ListCopyWith(
    $value.pending,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(pending: v),
  );
  @override
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get inEkklo => ListCopyWith(
    $value.inEkklo,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(inEkklo: v),
  );
  @override
  $R call({
    DateTime? date,
    List<PlannedEntry>? entries,
    List<MfpFoodEntry>? pending,
    List<ComparedEntry>? inEkklo,
  }) => $apply(
    FieldCopyWithData({
      if (date != null) #date: date,
      if (entries != null) #entries: entries,
      if (pending != null) #pending: pending,
      if (inEkklo != null) #inEkklo: inEkklo,
    }),
  );
  @override
  SendPlan $make(CopyWithData data) => SendPlan(
    date: data.get(#date, or: $value.date),
    entries: data.get(#entries, or: $value.entries),
    pending: data.get(#pending, or: $value.pending),
    inEkklo: data.get(#inEkklo, or: $value.inEkklo),
  );

  @override
  SendPlanCopyWith<$R2, SendPlan, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendPlanCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

