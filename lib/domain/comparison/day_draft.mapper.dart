// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'day_draft.dart';

class DayDraftMapper extends ClassMapperBase<DayDraft> {
  DayDraftMapper._();

  static DayDraftMapper? _instance;
  static DayDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DayDraftMapper._());
      StoredDayMapper.ensureInitialized();
      LoggedEntryMapper.ensureInitialized();
      CopiedFoodMapper.ensureInitialized();
      CopiedMealMapper.ensureInitialized();
      EkkloLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DayDraft';

  static DateTime _$date(DayDraft v) => v.date;
  static const Field<DayDraft, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static StoredDay _$stored(DayDraft v) => v.stored;
  static const Field<DayDraft, StoredDay> _f$stored = Field(
    'stored',
    _$stored,
    opt: true,
    def: const StoredDay(),
  );
  static List<LoggedEntry> _$entries(DayDraft v) => v.entries;
  static const Field<DayDraft, List<LoggedEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );
  static List<LoggedEntry> _$deleted(DayDraft v) => v.deleted;
  static const Field<DayDraft, List<LoggedEntry>> _f$deleted = Field(
    'deleted',
    _$deleted,
    opt: true,
    def: const [],
  );
  static List<LoggedEntry> _$owed(DayDraft v) => v.owed;
  static const Field<DayDraft, List<LoggedEntry>> _f$owed = Field(
    'owed',
    _$owed,
    opt: true,
    def: const [],
  );
  static List<LoggedEntry> _$unstored(DayDraft v) => v.unstored;
  static const Field<DayDraft, List<LoggedEntry>> _f$unstored = Field(
    'unstored',
    _$unstored,
    opt: true,
    def: const [],
  );
  static List<CopiedFood> _$foods(DayDraft v) => v.foods;
  static const Field<DayDraft, List<CopiedFood>> _f$foods = Field(
    'foods',
    _$foods,
    opt: true,
    def: const [],
  );
  static List<CopiedMeal> _$meals(DayDraft v) => v.meals;
  static const Field<DayDraft, List<CopiedMeal>> _f$meals = Field(
    'meals',
    _$meals,
    opt: true,
    def: const [],
  );
  static Map<String, String> _$plannedEntryIds(DayDraft v) => v.plannedEntryIds;
  static const Field<DayDraft, Map<String, String>> _f$plannedEntryIds = Field(
    'plannedEntryIds',
    _$plannedEntryIds,
    key: r'planned_entry_ids',
    opt: true,
    def: const {},
  );
  static List<EkkloLink> _$pendingLinks(DayDraft v) => v.pendingLinks;
  static const Field<DayDraft, List<EkkloLink>> _f$pendingLinks = Field(
    'pendingLinks',
    _$pendingLinks,
    key: r'pending_links',
    opt: true,
    def: const [],
  );
  static bool _$forgetsWaiting(DayDraft v) => v.forgetsWaiting;
  static const Field<DayDraft, bool> _f$forgetsWaiting = Field(
    'forgetsWaiting',
    _$forgetsWaiting,
    key: r'forgets_waiting',
    opt: true,
    def: false,
  );

  @override
  final MappableFields<DayDraft> fields = const {
    #date: _f$date,
    #stored: _f$stored,
    #entries: _f$entries,
    #deleted: _f$deleted,
    #owed: _f$owed,
    #unstored: _f$unstored,
    #foods: _f$foods,
    #meals: _f$meals,
    #plannedEntryIds: _f$plannedEntryIds,
    #pendingLinks: _f$pendingLinks,
    #forgetsWaiting: _f$forgetsWaiting,
  };
  @override
  final bool ignoreNull = true;

  static DayDraft _instantiate(DecodingData data) {
    return DayDraft(
      date: data.dec(_f$date),
      stored: data.dec(_f$stored),
      entries: data.dec(_f$entries),
      deleted: data.dec(_f$deleted),
      owed: data.dec(_f$owed),
      unstored: data.dec(_f$unstored),
      foods: data.dec(_f$foods),
      meals: data.dec(_f$meals),
      plannedEntryIds: data.dec(_f$plannedEntryIds),
      pendingLinks: data.dec(_f$pendingLinks),
      forgetsWaiting: data.dec(_f$forgetsWaiting),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DayDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DayDraft>(map);
  }

  static DayDraft fromJson(String json) {
    return ensureInitialized().decodeJson<DayDraft>(json);
  }
}

mixin DayDraftMappable {
  String toJson() {
    return DayDraftMapper.ensureInitialized().encodeJson<DayDraft>(
      this as DayDraft,
    );
  }

  Map<String, dynamic> toMap() {
    return DayDraftMapper.ensureInitialized().encodeMap<DayDraft>(
      this as DayDraft,
    );
  }

  DayDraftCopyWith<DayDraft, DayDraft, DayDraft> get copyWith =>
      _DayDraftCopyWithImpl<DayDraft, DayDraft>(
        this as DayDraft,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DayDraftMapper.ensureInitialized().stringifyValue(this as DayDraft);
  }

  @override
  bool operator ==(Object other) {
    return DayDraftMapper.ensureInitialized().equalsValue(
      this as DayDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return DayDraftMapper.ensureInitialized().hashValue(this as DayDraft);
  }
}

extension DayDraftValueCopy<$R, $Out> on ObjectCopyWith<$R, DayDraft, $Out> {
  DayDraftCopyWith<$R, DayDraft, $Out> get $asDayDraft =>
      $base.as((v, t, t2) => _DayDraftCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DayDraftCopyWith<$R, $In extends DayDraft, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  StoredDayCopyWith<$R, StoredDay, StoredDay> get stored;
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get entries;
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get deleted;
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get owed;
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get unstored;
  ListCopyWith<$R, CopiedFood, CopiedFoodCopyWith<$R, CopiedFood, CopiedFood>>
  get foods;
  ListCopyWith<$R, CopiedMeal, CopiedMealCopyWith<$R, CopiedMeal, CopiedMeal>>
  get meals;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get plannedEntryIds;
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get pendingLinks;
  $R call({
    DateTime? date,
    StoredDay? stored,
    List<LoggedEntry>? entries,
    List<LoggedEntry>? deleted,
    List<LoggedEntry>? owed,
    List<LoggedEntry>? unstored,
    List<CopiedFood>? foods,
    List<CopiedMeal>? meals,
    Map<String, String>? plannedEntryIds,
    List<EkkloLink>? pendingLinks,
    bool? forgetsWaiting,
  });
  DayDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DayDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DayDraft, $Out>
    implements DayDraftCopyWith<$R, DayDraft, $Out> {
  _DayDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DayDraft> $mapper =
      DayDraftMapper.ensureInitialized();
  @override
  StoredDayCopyWith<$R, StoredDay, StoredDay> get stored =>
      $value.stored.copyWith.$chain((v) => call(stored: v));
  @override
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
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
  get deleted => ListCopyWith(
    $value.deleted,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(deleted: v),
  );
  @override
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get owed => ListCopyWith(
    $value.owed,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(owed: v),
  );
  @override
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get unstored => ListCopyWith(
    $value.unstored,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(unstored: v),
  );
  @override
  ListCopyWith<$R, CopiedFood, CopiedFoodCopyWith<$R, CopiedFood, CopiedFood>>
  get foods => ListCopyWith(
    $value.foods,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foods: v),
  );
  @override
  ListCopyWith<$R, CopiedMeal, CopiedMealCopyWith<$R, CopiedMeal, CopiedMeal>>
  get meals => ListCopyWith(
    $value.meals,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(meals: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get plannedEntryIds => MapCopyWith(
    $value.plannedEntryIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(plannedEntryIds: v),
  );
  @override
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get pendingLinks => ListCopyWith(
    $value.pendingLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(pendingLinks: v),
  );
  @override
  $R call({
    DateTime? date,
    StoredDay? stored,
    List<LoggedEntry>? entries,
    List<LoggedEntry>? deleted,
    List<LoggedEntry>? owed,
    List<LoggedEntry>? unstored,
    List<CopiedFood>? foods,
    List<CopiedMeal>? meals,
    Map<String, String>? plannedEntryIds,
    List<EkkloLink>? pendingLinks,
    bool? forgetsWaiting,
  }) => $apply(
    FieldCopyWithData({
      if (date != null) #date: date,
      if (stored != null) #stored: stored,
      if (entries != null) #entries: entries,
      if (deleted != null) #deleted: deleted,
      if (owed != null) #owed: owed,
      if (unstored != null) #unstored: unstored,
      if (foods != null) #foods: foods,
      if (meals != null) #meals: meals,
      if (plannedEntryIds != null) #plannedEntryIds: plannedEntryIds,
      if (pendingLinks != null) #pendingLinks: pendingLinks,
      if (forgetsWaiting != null) #forgetsWaiting: forgetsWaiting,
    }),
  );
  @override
  DayDraft $make(CopyWithData data) => DayDraft(
    date: data.get(#date, or: $value.date),
    stored: data.get(#stored, or: $value.stored),
    entries: data.get(#entries, or: $value.entries),
    deleted: data.get(#deleted, or: $value.deleted),
    owed: data.get(#owed, or: $value.owed),
    unstored: data.get(#unstored, or: $value.unstored),
    foods: data.get(#foods, or: $value.foods),
    meals: data.get(#meals, or: $value.meals),
    plannedEntryIds: data.get(#plannedEntryIds, or: $value.plannedEntryIds),
    pendingLinks: data.get(#pendingLinks, or: $value.pendingLinks),
    forgetsWaiting: data.get(#forgetsWaiting, or: $value.forgetsWaiting),
  );

  @override
  DayDraftCopyWith<$R2, DayDraft, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DayDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

