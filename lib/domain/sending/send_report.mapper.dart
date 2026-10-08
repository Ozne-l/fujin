// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_report.dart';

class SendReportMapper extends ClassMapperBase<SendReport> {
  SendReportMapper._();

  static SendReportMapper? _instance;
  static SendReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendReportMapper._());
      RetainedWeightMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendReport';

  static DateTime _$date(SendReport v) => v.date;
  static const Field<SendReport, DateTime> _f$date = Field('date', _$date);
  static DateTime _$sentAt(SendReport v) => v.sentAt;
  static const Field<SendReport, DateTime> _f$sentAt = Field(
    'sentAt',
    _$sentAt,
    key: r'sent_at',
  );
  static int _$sent(SendReport v) => v.sent;
  static const Field<SendReport, int> _f$sent = Field(
    'sent',
    _$sent,
    opt: true,
    def: 0,
  );
  static int _$reused(SendReport v) => v.reused;
  static const Field<SendReport, int> _f$reused = Field(
    'reused',
    _$reused,
    opt: true,
    def: 0,
  );
  static int _$updated(SendReport v) => v.updated;
  static const Field<SendReport, int> _f$updated = Field(
    'updated',
    _$updated,
    opt: true,
    def: 0,
  );
  static List<String> _$newAssociations(SendReport v) => v.newAssociations;
  static const Field<SendReport, List<String>> _f$newAssociations = Field(
    'newAssociations',
    _$newAssociations,
    key: r'new_associations',
    opt: true,
    def: const [],
  );
  static List<RetainedWeight> _$weights(SendReport v) => v.weights;
  static const Field<SendReport, List<RetainedWeight>> _f$weights = Field(
    'weights',
    _$weights,
    opt: true,
    def: const [],
  );
  static List<String> _$ownCopies(SendReport v) => v.ownCopies;
  static const Field<SendReport, List<String>> _f$ownCopies = Field(
    'ownCopies',
    _$ownCopies,
    key: r'own_copies',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<SendReport> fields = const {
    #date: _f$date,
    #sentAt: _f$sentAt,
    #sent: _f$sent,
    #reused: _f$reused,
    #updated: _f$updated,
    #newAssociations: _f$newAssociations,
    #weights: _f$weights,
    #ownCopies: _f$ownCopies,
  };
  @override
  final bool ignoreNull = true;

  static SendReport _instantiate(DecodingData data) {
    return SendReport(
      date: data.dec(_f$date),
      sentAt: data.dec(_f$sentAt),
      sent: data.dec(_f$sent),
      reused: data.dec(_f$reused),
      updated: data.dec(_f$updated),
      newAssociations: data.dec(_f$newAssociations),
      weights: data.dec(_f$weights),
      ownCopies: data.dec(_f$ownCopies),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendReport>(map);
  }

  static SendReport fromJson(String json) {
    return ensureInitialized().decodeJson<SendReport>(json);
  }
}

mixin SendReportMappable {
  String toJson() {
    return SendReportMapper.ensureInitialized().encodeJson<SendReport>(
      this as SendReport,
    );
  }

  Map<String, dynamic> toMap() {
    return SendReportMapper.ensureInitialized().encodeMap<SendReport>(
      this as SendReport,
    );
  }

  SendReportCopyWith<SendReport, SendReport, SendReport> get copyWith =>
      _SendReportCopyWithImpl<SendReport, SendReport>(
        this as SendReport,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendReportMapper.ensureInitialized().stringifyValue(
      this as SendReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendReportMapper.ensureInitialized().equalsValue(
      this as SendReport,
      other,
    );
  }

  @override
  int get hashCode {
    return SendReportMapper.ensureInitialized().hashValue(this as SendReport);
  }
}

extension SendReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendReport, $Out> {
  SendReportCopyWith<$R, SendReport, $Out> get $asSendReport =>
      $base.as((v, t, t2) => _SendReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendReportCopyWith<$R, $In extends SendReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get newAssociations;
  ListCopyWith<
    $R,
    RetainedWeight,
    RetainedWeightCopyWith<$R, RetainedWeight, RetainedWeight>
  >
  get weights;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get ownCopies;
  $R call({
    DateTime? date,
    DateTime? sentAt,
    int? sent,
    int? reused,
    int? updated,
    List<String>? newAssociations,
    List<RetainedWeight>? weights,
    List<String>? ownCopies,
  });
  SendReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendReport, $Out>
    implements SendReportCopyWith<$R, SendReport, $Out> {
  _SendReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendReport> $mapper =
      SendReportMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get newAssociations => ListCopyWith(
    $value.newAssociations,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(newAssociations: v),
  );
  @override
  ListCopyWith<
    $R,
    RetainedWeight,
    RetainedWeightCopyWith<$R, RetainedWeight, RetainedWeight>
  >
  get weights => ListCopyWith(
    $value.weights,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(weights: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get ownCopies =>
      ListCopyWith(
        $value.ownCopies,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(ownCopies: v),
      );
  @override
  $R call({
    DateTime? date,
    DateTime? sentAt,
    int? sent,
    int? reused,
    int? updated,
    List<String>? newAssociations,
    List<RetainedWeight>? weights,
    List<String>? ownCopies,
  }) => $apply(
    FieldCopyWithData({
      if (date != null) #date: date,
      if (sentAt != null) #sentAt: sentAt,
      if (sent != null) #sent: sent,
      if (reused != null) #reused: reused,
      if (updated != null) #updated: updated,
      if (newAssociations != null) #newAssociations: newAssociations,
      if (weights != null) #weights: weights,
      if (ownCopies != null) #ownCopies: ownCopies,
    }),
  );
  @override
  SendReport $make(CopyWithData data) => SendReport(
    date: data.get(#date, or: $value.date),
    sentAt: data.get(#sentAt, or: $value.sentAt),
    sent: data.get(#sent, or: $value.sent),
    reused: data.get(#reused, or: $value.reused),
    updated: data.get(#updated, or: $value.updated),
    newAssociations: data.get(#newAssociations, or: $value.newAssociations),
    weights: data.get(#weights, or: $value.weights),
    ownCopies: data.get(#ownCopies, or: $value.ownCopies),
  );

  @override
  SendReportCopyWith<$R2, SendReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

