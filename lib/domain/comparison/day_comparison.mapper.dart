// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'day_comparison.dart';

class DayComparisonMapper extends ClassMapperBase<DayComparison> {
  DayComparisonMapper._();

  static DayComparisonMapper? _instance;
  static DayComparisonMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DayComparisonMapper._());
      DayChangesMapper.ensureInitialized();
      ComparedEntryMapper.ensureInitialized();
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DayComparison';

  static DayChanges _$changes(DayComparison v) => v.changes;
  static const Field<DayComparison, DayChanges> _f$changes = Field(
    'changes',
    _$changes,
  );
  static List<ComparedEntry> _$entries(DayComparison v) => v.entries;
  static const Field<DayComparison, List<ComparedEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );
  static List<LoggedEntry> _$leaving(DayComparison v) => v.leaving;
  static const Field<DayComparison, List<LoggedEntry>> _f$leaving = Field(
    'leaving',
    _$leaving,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<DayComparison> fields = const {
    #changes: _f$changes,
    #entries: _f$entries,
    #leaving: _f$leaving,
  };
  @override
  final bool ignoreNull = true;

  static DayComparison _instantiate(DecodingData data) {
    return DayComparison(
      changes: data.dec(_f$changes),
      entries: data.dec(_f$entries),
      leaving: data.dec(_f$leaving),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DayComparison fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DayComparison>(map);
  }

  static DayComparison fromJson(String json) {
    return ensureInitialized().decodeJson<DayComparison>(json);
  }
}

mixin DayComparisonMappable {
  String toJson() {
    return DayComparisonMapper.ensureInitialized().encodeJson<DayComparison>(
      this as DayComparison,
    );
  }

  Map<String, dynamic> toMap() {
    return DayComparisonMapper.ensureInitialized().encodeMap<DayComparison>(
      this as DayComparison,
    );
  }

  DayComparisonCopyWith<DayComparison, DayComparison, DayComparison>
  get copyWith => _DayComparisonCopyWithImpl<DayComparison, DayComparison>(
    this as DayComparison,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return DayComparisonMapper.ensureInitialized().stringifyValue(
      this as DayComparison,
    );
  }

  @override
  bool operator ==(Object other) {
    return DayComparisonMapper.ensureInitialized().equalsValue(
      this as DayComparison,
      other,
    );
  }

  @override
  int get hashCode {
    return DayComparisonMapper.ensureInitialized().hashValue(
      this as DayComparison,
    );
  }
}

extension DayComparisonValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DayComparison, $Out> {
  DayComparisonCopyWith<$R, DayComparison, $Out> get $asDayComparison =>
      $base.as((v, t, t2) => _DayComparisonCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DayComparisonCopyWith<$R, $In extends DayComparison, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  DayChangesCopyWith<$R, DayChanges, DayChanges> get changes;
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get entries;
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get leaving;
  $R call({
    DayChanges? changes,
    List<ComparedEntry>? entries,
    List<LoggedEntry>? leaving,
  });
  DayComparisonCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DayComparisonCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DayComparison, $Out>
    implements DayComparisonCopyWith<$R, DayComparison, $Out> {
  _DayComparisonCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DayComparison> $mapper =
      DayComparisonMapper.ensureInitialized();
  @override
  DayChangesCopyWith<$R, DayChanges, DayChanges> get changes =>
      $value.changes.copyWith.$chain((v) => call(changes: v));
  @override
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get entries => ListCopyWith(
    $value.entries,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(entries: v),
  );
  @override
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get leaving => ListCopyWith(
    $value.leaving,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(leaving: v),
  );
  @override
  $R call({
    DayChanges? changes,
    List<ComparedEntry>? entries,
    List<LoggedEntry>? leaving,
  }) => $apply(
    FieldCopyWithData({
      if (changes != null) #changes: changes,
      if (entries != null) #entries: entries,
      if (leaving != null) #leaving: leaving,
    }),
  );
  @override
  DayComparison $make(CopyWithData data) => DayComparison(
    changes: data.get(#changes, or: $value.changes),
    entries: data.get(#entries, or: $value.entries),
    leaving: data.get(#leaving, or: $value.leaving),
  );

  @override
  DayComparisonCopyWith<$R2, DayComparison, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DayComparisonCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

