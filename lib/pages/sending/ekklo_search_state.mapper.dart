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
      EkkloCandidateMapper.ensureInitialized();
      SendFailureMapper.ensureInitialized();
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
  static List<EkkloCandidate>? _$results(EkkloSearchState v) => v.results;
  static const Field<EkkloSearchState, List<EkkloCandidate>> _f$results = Field(
    'results',
    _$results,
    opt: true,
  );
  static SendFailure? _$failure(EkkloSearchState v) => v.failure;
  static const Field<EkkloSearchState, SendFailure> _f$failure = Field(
    'failure',
    _$failure,
    opt: true,
  );

  @override
  final MappableFields<EkkloSearchState> fields = const {
    #query: _f$query,
    #results: _f$results,
    #failure: _f$failure,
  };
  @override
  final bool ignoreNull = true;

  static EkkloSearchState _instantiate(DecodingData data) {
    return EkkloSearchState(
      query: data.dec(_f$query),
      results: data.dec(_f$results),
      failure: data.dec(_f$failure),
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
  String toJson() {
    return EkkloSearchStateMapper.ensureInitialized()
        .encodeJson<EkkloSearchState>(this as EkkloSearchState);
  }

  Map<String, dynamic> toMap() {
    return EkkloSearchStateMapper.ensureInitialized()
        .encodeMap<EkkloSearchState>(this as EkkloSearchState);
  }

  EkkloSearchStateCopyWith<EkkloSearchState, EkkloSearchState, EkkloSearchState>
  get copyWith =>
      _EkkloSearchStateCopyWithImpl<EkkloSearchState, EkkloSearchState>(
        this as EkkloSearchState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloSearchStateMapper.ensureInitialized().stringifyValue(
      this as EkkloSearchState,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloSearchStateMapper.ensureInitialized().equalsValue(
      this as EkkloSearchState,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloSearchStateMapper.ensureInitialized().hashValue(
      this as EkkloSearchState,
    );
  }
}

extension EkkloSearchStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloSearchState, $Out> {
  EkkloSearchStateCopyWith<$R, EkkloSearchState, $Out>
  get $asEkkloSearchState =>
      $base.as((v, t, t2) => _EkkloSearchStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloSearchStateCopyWith<$R, $In extends EkkloSearchState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    EkkloCandidate,
    EkkloCandidateCopyWith<$R, EkkloCandidate, EkkloCandidate>
  >?
  get results;
  $R call({String? query, List<EkkloCandidate>? results, SendFailure? failure});
  EkkloSearchStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloSearchStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloSearchState, $Out>
    implements EkkloSearchStateCopyWith<$R, EkkloSearchState, $Out> {
  _EkkloSearchStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloSearchState> $mapper =
      EkkloSearchStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    EkkloCandidate,
    EkkloCandidateCopyWith<$R, EkkloCandidate, EkkloCandidate>
  >?
  get results => $value.results != null
      ? ListCopyWith(
          $value.results!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(results: v),
        )
      : null;
  @override
  $R call({String? query, Object? results = $none, Object? failure = $none}) =>
      $apply(
        FieldCopyWithData({
          if (query != null) #query: query,
          if (results != $none) #results: results,
          if (failure != $none) #failure: failure,
        }),
      );
  @override
  EkkloSearchState $make(CopyWithData data) => EkkloSearchState(
    query: data.get(#query, or: $value.query),
    results: data.get(#results, or: $value.results),
    failure: data.get(#failure, or: $value.failure),
  );

  @override
  EkkloSearchStateCopyWith<$R2, EkkloSearchState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloSearchStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

