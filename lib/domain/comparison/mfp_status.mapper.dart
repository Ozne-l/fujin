// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mfp_status.dart';

class MfpStatusMapper extends ClassMapperBase<MfpStatus> {
  MfpStatusMapper._();

  static MfpStatusMapper? _instance;
  static MfpStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpStatusMapper._());
      MfpPendingMapper.ensureInitialized();
      MfpFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpStatus';

  @override
  final MappableFields<MfpStatus> fields = const {};
  @override
  final bool ignoreNull = true;

  static MfpStatus _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'MfpStatus',
      'mfp',
      '${data.value['mfp']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpStatus>(map);
  }

  static MfpStatus fromJson(String json) {
    return ensureInitialized().decodeJson<MfpStatus>(json);
  }
}

mixin MfpStatusMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MfpStatusCopyWith<MfpStatus, MfpStatus, MfpStatus> get copyWith;
}

abstract class MfpStatusCopyWith<$R, $In extends MfpStatus, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MfpStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MfpPendingMapper extends SubClassMapperBase<MfpPending> {
  MfpPendingMapper._();

  static MfpPendingMapper? _instance;
  static MfpPendingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpPendingMapper._());
      MfpStatusMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MfpPending';

  @override
  final MappableFields<MfpPending> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'mfp';
  @override
  final dynamic discriminatorValue = 'pending';
  @override
  late final ClassMapperBase superMapper = MfpStatusMapper.ensureInitialized();

  static MfpPending _instantiate(DecodingData data) {
    return MfpPending();
  }

  @override
  final Function instantiate = _instantiate;

  static MfpPending fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpPending>(map);
  }

  static MfpPending fromJson(String json) {
    return ensureInitialized().decodeJson<MfpPending>(json);
  }
}

mixin MfpPendingMappable {
  String toJson() {
    return MfpPendingMapper.ensureInitialized().encodeJson<MfpPending>(
      this as MfpPending,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpPendingMapper.ensureInitialized().encodeMap<MfpPending>(
      this as MfpPending,
    );
  }

  MfpPendingCopyWith<MfpPending, MfpPending, MfpPending> get copyWith =>
      _MfpPendingCopyWithImpl<MfpPending, MfpPending>(
        this as MfpPending,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpPendingMapper.ensureInitialized().stringifyValue(
      this as MfpPending,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpPendingMapper.ensureInitialized().equalsValue(
      this as MfpPending,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpPendingMapper.ensureInitialized().hashValue(this as MfpPending);
  }
}

extension MfpPendingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpPending, $Out> {
  MfpPendingCopyWith<$R, MfpPending, $Out> get $asMfpPending =>
      $base.as((v, t, t2) => _MfpPendingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpPendingCopyWith<$R, $In extends MfpPending, $Out>
    implements MfpStatusCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MfpPendingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpPendingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpPending, $Out>
    implements MfpPendingCopyWith<$R, MfpPending, $Out> {
  _MfpPendingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpPending> $mapper =
      MfpPendingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MfpPending $make(CopyWithData data) => MfpPending();

  @override
  MfpPendingCopyWith<$R2, MfpPending, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpPendingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpFailedMapper extends SubClassMapperBase<MfpFailed> {
  MfpFailedMapper._();

  static MfpFailedMapper? _instance;
  static MfpFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpFailedMapper._());
      MfpStatusMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MfpFailed';

  @override
  final MappableFields<MfpFailed> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'mfp';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper = MfpStatusMapper.ensureInitialized();

  static MfpFailed _instantiate(DecodingData data) {
    return MfpFailed();
  }

  @override
  final Function instantiate = _instantiate;

  static MfpFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpFailed>(map);
  }

  static MfpFailed fromJson(String json) {
    return ensureInitialized().decodeJson<MfpFailed>(json);
  }
}

mixin MfpFailedMappable {
  String toJson() {
    return MfpFailedMapper.ensureInitialized().encodeJson<MfpFailed>(
      this as MfpFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpFailedMapper.ensureInitialized().encodeMap<MfpFailed>(
      this as MfpFailed,
    );
  }

  MfpFailedCopyWith<MfpFailed, MfpFailed, MfpFailed> get copyWith =>
      _MfpFailedCopyWithImpl<MfpFailed, MfpFailed>(
        this as MfpFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpFailedMapper.ensureInitialized().stringifyValue(
      this as MfpFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpFailedMapper.ensureInitialized().equalsValue(
      this as MfpFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpFailedMapper.ensureInitialized().hashValue(this as MfpFailed);
  }
}

extension MfpFailedValueCopy<$R, $Out> on ObjectCopyWith<$R, MfpFailed, $Out> {
  MfpFailedCopyWith<$R, MfpFailed, $Out> get $asMfpFailed =>
      $base.as((v, t, t2) => _MfpFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpFailedCopyWith<$R, $In extends MfpFailed, $Out>
    implements MfpStatusCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MfpFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpFailed, $Out>
    implements MfpFailedCopyWith<$R, MfpFailed, $Out> {
  _MfpFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpFailed> $mapper =
      MfpFailedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MfpFailed $make(CopyWithData data) => MfpFailed();

  @override
  MfpFailedCopyWith<$R2, MfpFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

