// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ekklo_search_state.dart';

class EkkloSearchStateMapper extends ClassMapperBase<EkkloSearchState> {
  EkkloSearchStateMapper._();

  static EkkloSearchStateMapper? _instance;
  static EkkloSearchStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSearchStateMapper._());
      EkkloSearchRunningMapper.ensureInitialized();
      EkkloSearchDoneMapper.ensureInitialized();
      EkkloSearchFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSearchState';

  static String _$query(EkkloSearchState v) => v.query;
  static const Field<EkkloSearchState, String> _f$query = Field(
    'query',
    _$query,
  );

  @override
  final MappableFields<EkkloSearchState> fields = const {#query: _f$query};
  @override
  final bool ignoreNull = true;

  static EkkloSearchState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'EkkloSearchState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSearchState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSearchState>(map);
  }

  static EkkloSearchState fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSearchState>(json);
  }
}

mixin EkkloSearchStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  EkkloSearchStateCopyWith<EkkloSearchState, EkkloSearchState, EkkloSearchState>
  get copyWith;
}

abstract class EkkloSearchStateCopyWith<$R, $In extends EkkloSearchState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? query});
  EkkloSearchStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class EkkloSearchRunningMapper extends SubClassMapperBase<EkkloSearchRunning> {
  EkkloSearchRunningMapper._();

  static EkkloSearchRunningMapper? _instance;
  static EkkloSearchRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSearchRunningMapper._());
      EkkloSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSearchRunning';

  static String _$query(EkkloSearchRunning v) => v.query;
  static const Field<EkkloSearchRunning, String> _f$query = Field(
    'query',
    _$query,
  );

  @override
  final MappableFields<EkkloSearchRunning> fields = const {#query: _f$query};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      EkkloSearchStateMapper.ensureInitialized();

  static EkkloSearchRunning _instantiate(DecodingData data) {
    return EkkloSearchRunning(data.dec(_f$query));
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSearchRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSearchRunning>(map);
  }

  static EkkloSearchRunning fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSearchRunning>(json);
  }
}

mixin EkkloSearchRunningMappable {
  String toJson() {
    return EkkloSearchRunningMapper.ensureInitialized()
        .encodeJson<EkkloSearchRunning>(this as EkkloSearchRunning);
  }

  Map<String, dynamic> toMap() {
    return EkkloSearchRunningMapper.ensureInitialized()
        .encodeMap<EkkloSearchRunning>(this as EkkloSearchRunning);
  }

  EkkloSearchRunningCopyWith<
    EkkloSearchRunning,
    EkkloSearchRunning,
    EkkloSearchRunning
  >
  get copyWith =>
      _EkkloSearchRunningCopyWithImpl<EkkloSearchRunning, EkkloSearchRunning>(
        this as EkkloSearchRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSearchRunningMapper.ensureInitialized().stringifyValue(
      this as EkkloSearchRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSearchRunningMapper.ensureInitialized().equalsValue(
      this as EkkloSearchRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSearchRunningMapper.ensureInitialized().hashValue(
      this as EkkloSearchRunning,
    );
  }
}

extension EkkloSearchRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSearchRunning, $Out> {
  EkkloSearchRunningCopyWith<$R, EkkloSearchRunning, $Out>
  get $asEkkloSearchRunning => $base.as(
    (v, t, t2) => _EkkloSearchRunningCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EkkloSearchRunningCopyWith<
  $R,
  $In extends EkkloSearchRunning,
  $Out
>
    implements EkkloSearchStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? query});
  EkkloSearchRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSearchRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSearchRunning, $Out>
    implements EkkloSearchRunningCopyWith<$R, EkkloSearchRunning, $Out> {
  _EkkloSearchRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSearchRunning> $mapper =
      EkkloSearchRunningMapper.ensureInitialized();
  @override
  $R call({String? query}) =>
      $apply(FieldCopyWithData({if (query != null) #query: query}));
  @override
  EkkloSearchRunning $make(CopyWithData data) =>
      EkkloSearchRunning(data.get(#query, or: $value.query));

  @override
  EkkloSearchRunningCopyWith<$R2, EkkloSearchRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSearchRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloSearchDoneMapper extends SubClassMapperBase<EkkloSearchDone> {
  EkkloSearchDoneMapper._();

  static EkkloSearchDoneMapper? _instance;
  static EkkloSearchDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSearchDoneMapper._());
      EkkloSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      EkkloCandidateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSearchDone';

  static String _$query(EkkloSearchDone v) => v.query;
  static const Field<EkkloSearchDone, String> _f$query = Field(
    'query',
    _$query,
  );
  static List<EkkloCandidate> _$results(EkkloSearchDone v) => v.results;
  static const Field<EkkloSearchDone, List<EkkloCandidate>> _f$results = Field(
    'results',
    _$results,
  );

  @override
  final MappableFields<EkkloSearchDone> fields = const {
    #query: _f$query,
    #results: _f$results,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper =
      EkkloSearchStateMapper.ensureInitialized();

  static EkkloSearchDone _instantiate(DecodingData data) {
    return EkkloSearchDone(data.dec(_f$query), data.dec(_f$results));
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSearchDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSearchDone>(map);
  }

  static EkkloSearchDone fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSearchDone>(json);
  }
}

mixin EkkloSearchDoneMappable {
  String toJson() {
    return EkkloSearchDoneMapper.ensureInitialized()
        .encodeJson<EkkloSearchDone>(this as EkkloSearchDone);
  }

  Map<String, dynamic> toMap() {
    return EkkloSearchDoneMapper.ensureInitialized().encodeMap<EkkloSearchDone>(
      this as EkkloSearchDone,
    );
  }

  EkkloSearchDoneCopyWith<EkkloSearchDone, EkkloSearchDone, EkkloSearchDone>
  get copyWith =>
      _EkkloSearchDoneCopyWithImpl<EkkloSearchDone, EkkloSearchDone>(
        this as EkkloSearchDone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSearchDoneMapper.ensureInitialized().stringifyValue(
      this as EkkloSearchDone,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSearchDoneMapper.ensureInitialized().equalsValue(
      this as EkkloSearchDone,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSearchDoneMapper.ensureInitialized().hashValue(
      this as EkkloSearchDone,
    );
  }
}

extension EkkloSearchDoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSearchDone, $Out> {
  EkkloSearchDoneCopyWith<$R, EkkloSearchDone, $Out> get $asEkkloSearchDone =>
      $base.as((v, t, t2) => _EkkloSearchDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloSearchDoneCopyWith<$R, $In extends EkkloSearchDone, $Out>
    implements EkkloSearchStateCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    EkkloCandidate,
    EkkloCandidateCopyWith<$R, EkkloCandidate, EkkloCandidate>
  >
  get results;
  @override
  $R call({String? query, List<EkkloCandidate>? results});
  EkkloSearchDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSearchDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSearchDone, $Out>
    implements EkkloSearchDoneCopyWith<$R, EkkloSearchDone, $Out> {
  _EkkloSearchDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSearchDone> $mapper =
      EkkloSearchDoneMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    EkkloCandidate,
    EkkloCandidateCopyWith<$R, EkkloCandidate, EkkloCandidate>
  >
  get results => ListCopyWith(
    $value.results,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(results: v),
  );
  @override
  $R call({String? query, List<EkkloCandidate>? results}) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (results != null) #results: results,
    }),
  );
  @override
  EkkloSearchDone $make(CopyWithData data) => EkkloSearchDone(
    data.get(#query, or: $value.query),
    data.get(#results, or: $value.results),
  );

  @override
  EkkloSearchDoneCopyWith<$R2, EkkloSearchDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSearchDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloSearchFailedMapper extends SubClassMapperBase<EkkloSearchFailed> {
  EkkloSearchFailedMapper._();

  static EkkloSearchFailedMapper? _instance;
  static EkkloSearchFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloSearchFailedMapper._());
      EkkloSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      SendFailureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloSearchFailed';

  static String _$query(EkkloSearchFailed v) => v.query;
  static const Field<EkkloSearchFailed, String> _f$query = Field(
    'query',
    _$query,
  );
  static SendFailure _$failure(EkkloSearchFailed v) => v.failure;
  static const Field<EkkloSearchFailed, SendFailure> _f$failure = Field(
    'failure',
    _$failure,
  );

  @override
  final MappableFields<EkkloSearchFailed> fields = const {
    #query: _f$query,
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
      EkkloSearchStateMapper.ensureInitialized();

  static EkkloSearchFailed _instantiate(DecodingData data) {
    return EkkloSearchFailed(data.dec(_f$query), data.dec(_f$failure));
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloSearchFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloSearchFailed>(map);
  }

  static EkkloSearchFailed fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloSearchFailed>(json);
  }
}

mixin EkkloSearchFailedMappable {
  String toJson() {
    return EkkloSearchFailedMapper.ensureInitialized()
        .encodeJson<EkkloSearchFailed>(this as EkkloSearchFailed);
  }

  Map<String, dynamic> toMap() {
    return EkkloSearchFailedMapper.ensureInitialized()
        .encodeMap<EkkloSearchFailed>(this as EkkloSearchFailed);
  }

  EkkloSearchFailedCopyWith<
    EkkloSearchFailed,
    EkkloSearchFailed,
    EkkloSearchFailed
  >
  get copyWith =>
      _EkkloSearchFailedCopyWithImpl<EkkloSearchFailed, EkkloSearchFailed>(
        this as EkkloSearchFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSearchFailedMapper.ensureInitialized().stringifyValue(
      this as EkkloSearchFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSearchFailedMapper.ensureInitialized().equalsValue(
      this as EkkloSearchFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSearchFailedMapper.ensureInitialized().hashValue(
      this as EkkloSearchFailed,
    );
  }
}

extension EkkloSearchFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSearchFailed, $Out> {
  EkkloSearchFailedCopyWith<$R, EkkloSearchFailed, $Out>
  get $asEkkloSearchFailed => $base.as(
    (v, t, t2) => _EkkloSearchFailedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EkkloSearchFailedCopyWith<
  $R,
  $In extends EkkloSearchFailed,
  $Out
>
    implements EkkloSearchStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? query, SendFailure? failure});
  EkkloSearchFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSearchFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSearchFailed, $Out>
    implements EkkloSearchFailedCopyWith<$R, EkkloSearchFailed, $Out> {
  _EkkloSearchFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSearchFailed> $mapper =
      EkkloSearchFailedMapper.ensureInitialized();
  @override
  $R call({String? query, SendFailure? failure}) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (failure != null) #failure: failure,
    }),
  );
  @override
  EkkloSearchFailed $make(CopyWithData data) => EkkloSearchFailed(
    data.get(#query, or: $value.query),
    data.get(#failure, or: $value.failure),
  );

  @override
  EkkloSearchFailedCopyWith<$R2, EkkloSearchFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSearchFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

