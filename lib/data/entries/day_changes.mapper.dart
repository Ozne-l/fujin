// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'day_changes.dart';

class DayChangesMapper extends ClassMapperBase<DayChanges> {
  DayChangesMapper._();

  static DayChangesMapper? _instance;
  static DayChangesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DayChangesMapper._());
      CopiedFoodMapper.ensureInitialized();
      CopiedMealMapper.ensureInitialized();
      EntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
      EkkloLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DayChanges';

  static DateTime _$date(DayChanges v) => v.date;
  static const Field<DayChanges, DateTime> _f$date = Field(
    'date',
    _$date,
    hook: CalendarDateHook(),
  );
  static List<CopiedFood> _$foods(DayChanges v) => v.foods;
  static const Field<DayChanges, List<CopiedFood>> _f$foods = Field(
    'foods',
    _$foods,
    opt: true,
    def: const [],
  );
  static List<CopiedMeal> _$meals(DayChanges v) => v.meals;
  static const Field<DayChanges, List<CopiedMeal>> _f$meals = Field(
    'meals',
    _$meals,
    opt: true,
    def: const [],
  );
  static List<Entry> _$addedEntries(DayChanges v) => v.addedEntries;
  static const Field<DayChanges, List<Entry>> _f$addedEntries = Field(
    'addedEntries',
    _$addedEntries,
    key: r'added_entries',
    opt: true,
    def: const [],
  );
  static List<Entry> _$changedEntries(DayChanges v) => v.changedEntries;
  static const Field<DayChanges, List<Entry>> _f$changedEntries = Field(
    'changedEntries',
    _$changedEntries,
    key: r'changed_entries',
    opt: true,
    def: const [],
  );
  static List<String> _$deletedEntryIds(DayChanges v) => v.deletedEntryIds;
  static const Field<DayChanges, List<String>> _f$deletedEntryIds = Field(
    'deletedEntryIds',
    _$deletedEntryIds,
    key: r'deleted_entry_ids',
    opt: true,
    def: const [],
  );
  static List<MfpLink> _$addedMfpLinks(DayChanges v) => v.addedMfpLinks;
  static const Field<DayChanges, List<MfpLink>> _f$addedMfpLinks = Field(
    'addedMfpLinks',
    _$addedMfpLinks,
    key: r'added_mfp_links',
    opt: true,
    def: const [],
  );
  static List<MfpLink> _$changedMfpLinks(DayChanges v) => v.changedMfpLinks;
  static const Field<DayChanges, List<MfpLink>> _f$changedMfpLinks = Field(
    'changedMfpLinks',
    _$changedMfpLinks,
    key: r'changed_mfp_links',
    opt: true,
    def: const [],
  );
  static List<String> _$deletedMfpLinkIds(DayChanges v) => v.deletedMfpLinkIds;
  static const Field<DayChanges, List<String>> _f$deletedMfpLinkIds = Field(
    'deletedMfpLinkIds',
    _$deletedMfpLinkIds,
    key: r'deleted_mfp_link_ids',
    opt: true,
    def: const [],
  );
  static List<EkkloLink> _$addedEkkloLinks(DayChanges v) => v.addedEkkloLinks;
  static const Field<DayChanges, List<EkkloLink>> _f$addedEkkloLinks = Field(
    'addedEkkloLinks',
    _$addedEkkloLinks,
    key: r'added_ekklo_links',
    opt: true,
    def: const [],
  );
  static List<EkkloLink> _$changedEkkloLinks(DayChanges v) =>
      v.changedEkkloLinks;
  static const Field<DayChanges, List<EkkloLink>> _f$changedEkkloLinks = Field(
    'changedEkkloLinks',
    _$changedEkkloLinks,
    key: r'changed_ekklo_links',
    opt: true,
    def: const [],
  );
  static List<String> _$droppedEkkloLinkIds(DayChanges v) =>
      v.droppedEkkloLinkIds;
  static const Field<DayChanges, List<String>> _f$droppedEkkloLinkIds = Field(
    'droppedEkkloLinkIds',
    _$droppedEkkloLinkIds,
    key: r'dropped_ekklo_link_ids',
    opt: true,
    def: const [],
  );
  static bool _$forgetsWaiting(DayChanges v) => v.forgetsWaiting;
  static const Field<DayChanges, bool> _f$forgetsWaiting = Field(
    'forgetsWaiting',
    _$forgetsWaiting,
    key: r'forgets_waiting',
    opt: true,
    def: false,
  );

  @override
  final MappableFields<DayChanges> fields = const {
    #date: _f$date,
    #foods: _f$foods,
    #meals: _f$meals,
    #addedEntries: _f$addedEntries,
    #changedEntries: _f$changedEntries,
    #deletedEntryIds: _f$deletedEntryIds,
    #addedMfpLinks: _f$addedMfpLinks,
    #changedMfpLinks: _f$changedMfpLinks,
    #deletedMfpLinkIds: _f$deletedMfpLinkIds,
    #addedEkkloLinks: _f$addedEkkloLinks,
    #changedEkkloLinks: _f$changedEkkloLinks,
    #droppedEkkloLinkIds: _f$droppedEkkloLinkIds,
    #forgetsWaiting: _f$forgetsWaiting,
  };
  @override
  final bool ignoreNull = true;

  static DayChanges _instantiate(DecodingData data) {
    return DayChanges(
      date: data.dec(_f$date),
      foods: data.dec(_f$foods),
      meals: data.dec(_f$meals),
      addedEntries: data.dec(_f$addedEntries),
      changedEntries: data.dec(_f$changedEntries),
      deletedEntryIds: data.dec(_f$deletedEntryIds),
      addedMfpLinks: data.dec(_f$addedMfpLinks),
      changedMfpLinks: data.dec(_f$changedMfpLinks),
      deletedMfpLinkIds: data.dec(_f$deletedMfpLinkIds),
      addedEkkloLinks: data.dec(_f$addedEkkloLinks),
      changedEkkloLinks: data.dec(_f$changedEkkloLinks),
      droppedEkkloLinkIds: data.dec(_f$droppedEkkloLinkIds),
      forgetsWaiting: data.dec(_f$forgetsWaiting),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DayChanges fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DayChanges>(map);
  }

  static DayChanges fromJson(String json) {
    return ensureInitialized().decodeJson<DayChanges>(json);
  }
}

mixin DayChangesMappable {
  String toJson() {
    return DayChangesMapper.ensureInitialized().encodeJson<DayChanges>(
      this as DayChanges,
    );
  }

  Map<String, dynamic> toMap() {
    return DayChangesMapper.ensureInitialized().encodeMap<DayChanges>(
      this as DayChanges,
    );
  }

  DayChangesCopyWith<DayChanges, DayChanges, DayChanges> get copyWith =>
      _DayChangesCopyWithImpl<DayChanges, DayChanges>(
        this as DayChanges,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DayChangesMapper.ensureInitialized().stringifyValue(
      this as DayChanges,
    );
  }

  @override
  bool operator ==(Object other) {
    return DayChangesMapper.ensureInitialized().equalsValue(
      this as DayChanges,
      other,
    );
  }

  @override
  int get hashCode {
    return DayChangesMapper.ensureInitialized().hashValue(this as DayChanges);
  }
}

extension DayChangesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DayChanges, $Out> {
  DayChangesCopyWith<$R, DayChanges, $Out> get $asDayChanges =>
      $base.as((v, t, t2) => _DayChangesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DayChangesCopyWith<$R, $In extends DayChanges, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, CopiedFood, CopiedFoodCopyWith<$R, CopiedFood, CopiedFood>>
  get foods;
  ListCopyWith<$R, CopiedMeal, CopiedMealCopyWith<$R, CopiedMeal, CopiedMeal>>
  get meals;
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get addedEntries;
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get changedEntries;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get deletedEntryIds;
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>>
  get addedMfpLinks;
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>>
  get changedMfpLinks;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get deletedMfpLinkIds;
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get addedEkkloLinks;
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get changedEkkloLinks;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get droppedEkkloLinkIds;
  $R call({
    DateTime? date,
    List<CopiedFood>? foods,
    List<CopiedMeal>? meals,
    List<Entry>? addedEntries,
    List<Entry>? changedEntries,
    List<String>? deletedEntryIds,
    List<MfpLink>? addedMfpLinks,
    List<MfpLink>? changedMfpLinks,
    List<String>? deletedMfpLinkIds,
    List<EkkloLink>? addedEkkloLinks,
    List<EkkloLink>? changedEkkloLinks,
    List<String>? droppedEkkloLinkIds,
    bool? forgetsWaiting,
  });
  DayChangesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DayChangesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DayChanges, $Out>
    implements DayChangesCopyWith<$R, DayChanges, $Out> {
  _DayChangesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DayChanges> $mapper =
      DayChangesMapper.ensureInitialized();
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
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get addedEntries =>
      ListCopyWith(
        $value.addedEntries,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(addedEntries: v),
      );
  @override
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get changedEntries =>
      ListCopyWith(
        $value.changedEntries,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(changedEntries: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get deletedEntryIds => ListCopyWith(
    $value.deletedEntryIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(deletedEntryIds: v),
  );
  @override
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>>
  get addedMfpLinks => ListCopyWith(
    $value.addedMfpLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(addedMfpLinks: v),
  );
  @override
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>>
  get changedMfpLinks => ListCopyWith(
    $value.changedMfpLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(changedMfpLinks: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get deletedMfpLinkIds => ListCopyWith(
    $value.deletedMfpLinkIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(deletedMfpLinkIds: v),
  );
  @override
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get addedEkkloLinks => ListCopyWith(
    $value.addedEkkloLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(addedEkkloLinks: v),
  );
  @override
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get changedEkkloLinks => ListCopyWith(
    $value.changedEkkloLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(changedEkkloLinks: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get droppedEkkloLinkIds => ListCopyWith(
    $value.droppedEkkloLinkIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(droppedEkkloLinkIds: v),
  );
  @override
  $R call({
    DateTime? date,
    List<CopiedFood>? foods,
    List<CopiedMeal>? meals,
    List<Entry>? addedEntries,
    List<Entry>? changedEntries,
    List<String>? deletedEntryIds,
    List<MfpLink>? addedMfpLinks,
    List<MfpLink>? changedMfpLinks,
    List<String>? deletedMfpLinkIds,
    List<EkkloLink>? addedEkkloLinks,
    List<EkkloLink>? changedEkkloLinks,
    List<String>? droppedEkkloLinkIds,
    bool? forgetsWaiting,
  }) => $apply(
    FieldCopyWithData({
      if (date != null) #date: date,
      if (foods != null) #foods: foods,
      if (meals != null) #meals: meals,
      if (addedEntries != null) #addedEntries: addedEntries,
      if (changedEntries != null) #changedEntries: changedEntries,
      if (deletedEntryIds != null) #deletedEntryIds: deletedEntryIds,
      if (addedMfpLinks != null) #addedMfpLinks: addedMfpLinks,
      if (changedMfpLinks != null) #changedMfpLinks: changedMfpLinks,
      if (deletedMfpLinkIds != null) #deletedMfpLinkIds: deletedMfpLinkIds,
      if (addedEkkloLinks != null) #addedEkkloLinks: addedEkkloLinks,
      if (changedEkkloLinks != null) #changedEkkloLinks: changedEkkloLinks,
      if (droppedEkkloLinkIds != null)
        #droppedEkkloLinkIds: droppedEkkloLinkIds,
      if (forgetsWaiting != null) #forgetsWaiting: forgetsWaiting,
    }),
  );
  @override
  DayChanges $make(CopyWithData data) => DayChanges(
    date: data.get(#date, or: $value.date),
    foods: data.get(#foods, or: $value.foods),
    meals: data.get(#meals, or: $value.meals),
    addedEntries: data.get(#addedEntries, or: $value.addedEntries),
    changedEntries: data.get(#changedEntries, or: $value.changedEntries),
    deletedEntryIds: data.get(#deletedEntryIds, or: $value.deletedEntryIds),
    addedMfpLinks: data.get(#addedMfpLinks, or: $value.addedMfpLinks),
    changedMfpLinks: data.get(#changedMfpLinks, or: $value.changedMfpLinks),
    deletedMfpLinkIds: data.get(
      #deletedMfpLinkIds,
      or: $value.deletedMfpLinkIds,
    ),
    addedEkkloLinks: data.get(#addedEkkloLinks, or: $value.addedEkkloLinks),
    changedEkkloLinks: data.get(
      #changedEkkloLinks,
      or: $value.changedEkkloLinks,
    ),
    droppedEkkloLinkIds: data.get(
      #droppedEkkloLinkIds,
      or: $value.droppedEkkloLinkIds,
    ),
    forgetsWaiting: data.get(#forgetsWaiting, or: $value.forgetsWaiting),
  );

  @override
  DayChangesCopyWith<$R2, DayChanges, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DayChangesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

