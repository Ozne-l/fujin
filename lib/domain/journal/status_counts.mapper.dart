// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'status_counts.dart';

class StatusCountsMapper extends ClassMapperBase<StatusCounts> {
  StatusCountsMapper._();

  static StatusCountsMapper? _instance;
  static StatusCountsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StatusCountsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'StatusCounts';

  static int _$inEkklo(StatusCounts v) => v.inEkklo;
  static const Field<StatusCounts, int> _f$inEkklo = Field(
    'inEkklo',
    _$inEkklo,
    key: r'in_ekklo',
    opt: true,
    def: 0,
  );
  static int _$toSend(StatusCounts v) => v.toSend;
  static const Field<StatusCounts, int> _f$toSend = Field(
    'toSend',
    _$toSend,
    key: r'to_send',
    opt: true,
    def: 0,
  );
  static int _$toUpdate(StatusCounts v) => v.toUpdate;
  static const Field<StatusCounts, int> _f$toUpdate = Field(
    'toUpdate',
    _$toUpdate,
    key: r'to_update',
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<StatusCounts> fields = const {
    #inEkklo: _f$inEkklo,
    #toSend: _f$toSend,
    #toUpdate: _f$toUpdate,
  };
  @override
  final bool ignoreNull = true;

  static StatusCounts _instantiate(DecodingData data) {
    return StatusCounts(
      inEkklo: data.dec(_f$inEkklo),
      toSend: data.dec(_f$toSend),
      toUpdate: data.dec(_f$toUpdate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StatusCounts fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StatusCounts>(map);
  }

  static StatusCounts fromJson(String json) {
    return ensureInitialized().decodeJson<StatusCounts>(json);
  }
}

mixin StatusCountsMappable {
  String toJson() {
    return StatusCountsMapper.ensureInitialized().encodeJson<StatusCounts>(
      this as StatusCounts,
    );
  }

  Map<String, dynamic> toMap() {
    return StatusCountsMapper.ensureInitialized().encodeMap<StatusCounts>(
      this as StatusCounts,
    );
  }

  StatusCountsCopyWith<StatusCounts, StatusCounts, StatusCounts> get copyWith =>
      _StatusCountsCopyWithImpl<StatusCounts, StatusCounts>(
        this as StatusCounts,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StatusCountsMapper.ensureInitialized().stringifyValue(
      this as StatusCounts,
    );
  }

  @override
  bool operator ==(Object other) {
    return StatusCountsMapper.ensureInitialized().equalsValue(
      this as StatusCounts,
      other,
    );
  }

  @override
  int get hashCode {
    return StatusCountsMapper.ensureInitialized().hashValue(
      this as StatusCounts,
    );
  }
}

extension StatusCountsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StatusCounts, $Out> {
  StatusCountsCopyWith<$R, StatusCounts, $Out> get $asStatusCounts =>
      $base.as((v, t, t2) => _StatusCountsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StatusCountsCopyWith<$R, $In extends StatusCounts, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? inEkklo, int? toSend, int? toUpdate});
  StatusCountsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StatusCountsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StatusCounts, $Out>
    implements StatusCountsCopyWith<$R, StatusCounts, $Out> {
  _StatusCountsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StatusCounts> $mapper =
      StatusCountsMapper.ensureInitialized();
  @override
  $R call({int? inEkklo, int? toSend, int? toUpdate}) => $apply(
    FieldCopyWithData({
      if (inEkklo != null) #inEkklo: inEkklo,
      if (toSend != null) #toSend: toSend,
      if (toUpdate != null) #toUpdate: toUpdate,
    }),
  );
  @override
  StatusCounts $make(CopyWithData data) => StatusCounts(
    inEkklo: data.get(#inEkklo, or: $value.inEkklo),
    toSend: data.get(#toSend, or: $value.toSend),
    toUpdate: data.get(#toUpdate, or: $value.toUpdate),
  );

  @override
  StatusCountsCopyWith<$R2, StatusCounts, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StatusCountsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

