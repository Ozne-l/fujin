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
      ComparedEntryMapper.ensureInitialized();
      SentLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DayComparison';

  static List<ComparedEntry> _$entries(DayComparison v) => v.entries;
  static const Field<DayComparison, List<ComparedEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );
  static List<SentLink> _$linksToAdopt(DayComparison v) => v.linksToAdopt;
  static const Field<DayComparison, List<SentLink>> _f$linksToAdopt = Field(
    'linksToAdopt',
    _$linksToAdopt,
    key: r'links_to_adopt',
    opt: true,
    def: const [],
  );
  static List<SentLink> _$linksToDrop(DayComparison v) => v.linksToDrop;
  static const Field<DayComparison, List<SentLink>> _f$linksToDrop = Field(
    'linksToDrop',
    _$linksToDrop,
    key: r'links_to_drop',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<DayComparison> fields = const {
    #entries: _f$entries,
    #linksToAdopt: _f$linksToAdopt,
    #linksToDrop: _f$linksToDrop,
  };
  @override
  final bool ignoreNull = true;

  static DayComparison _instantiate(DecodingData data) {
    return DayComparison(
      entries: data.dec(_f$entries),
      linksToAdopt: data.dec(_f$linksToAdopt),
      linksToDrop: data.dec(_f$linksToDrop),
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
  ListCopyWith<
    $R,
    ComparedEntry,
    ComparedEntryCopyWith<$R, ComparedEntry, ComparedEntry>
  >
  get entries;
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get linksToAdopt;
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get linksToDrop;
  $R call({
    List<ComparedEntry>? entries,
    List<SentLink>? linksToAdopt,
    List<SentLink>? linksToDrop,
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
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get linksToAdopt => ListCopyWith(
    $value.linksToAdopt,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(linksToAdopt: v),
  );
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get linksToDrop => ListCopyWith(
    $value.linksToDrop,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(linksToDrop: v),
  );
  @override
  $R call({
    List<ComparedEntry>? entries,
    List<SentLink>? linksToAdopt,
    List<SentLink>? linksToDrop,
  }) => $apply(
    FieldCopyWithData({
      if (entries != null) #entries: entries,
      if (linksToAdopt != null) #linksToAdopt: linksToAdopt,
      if (linksToDrop != null) #linksToDrop: linksToDrop,
    }),
  );
  @override
  DayComparison $make(CopyWithData data) => DayComparison(
    entries: data.get(#entries, or: $value.entries),
    linksToAdopt: data.get(#linksToAdopt, or: $value.linksToAdopt),
    linksToDrop: data.get(#linksToDrop, or: $value.linksToDrop),
  );

  @override
  DayComparisonCopyWith<$R2, DayComparison, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DayComparisonCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

