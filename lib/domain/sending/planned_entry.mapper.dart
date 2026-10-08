// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'planned_entry.dart';

class PlannedEntryMapper extends ClassMapperBase<PlannedEntry> {
  PlannedEntryMapper._();

  static PlannedEntryMapper? _instance;
  static PlannedEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlannedEntryMapper._());
      MfpFoodEntryMapper.ensureInitialized();
      SendChoiceMapper.ensureInitialized();
      EkkloCandidateMapper.ensureInitialized();
      SentLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PlannedEntry';

  static MfpFoodEntry _$entry(PlannedEntry v) => v.entry;
  static const Field<PlannedEntry, MfpFoodEntry> _f$entry = Field(
    'entry',
    _$entry,
  );
  static String _$entryId(PlannedEntry v) => v.entryId;
  static const Field<PlannedEntry, String> _f$entryId = Field(
    'entryId',
    _$entryId,
    key: r'entry_id',
  );
  static String _$ekkloMealName(PlannedEntry v) => v.ekkloMealName;
  static const Field<PlannedEntry, String> _f$ekkloMealName = Field(
    'ekkloMealName',
    _$ekkloMealName,
    key: r'ekklo_meal_name',
  );
  static SendChoice _$choice(PlannedEntry v) => v.choice;
  static const Field<PlannedEntry, SendChoice> _f$choice = Field(
    'choice',
    _$choice,
  );
  static bool _$reviewed(PlannedEntry v) => v.reviewed;
  static const Field<PlannedEntry, bool> _f$reviewed = Field(
    'reviewed',
    _$reviewed,
  );
  static bool _$confirmed(PlannedEntry v) => v.confirmed;
  static const Field<PlannedEntry, bool> _f$confirmed = Field(
    'confirmed',
    _$confirmed,
    opt: true,
    def: false,
  );
  static List<EkkloCandidate> _$candidates(PlannedEntry v) => v.candidates;
  static const Field<PlannedEntry, List<EkkloCandidate>> _f$candidates = Field(
    'candidates',
    _$candidates,
    opt: true,
    def: const [],
  );
  static String? _$rememberedEkkloFoodId(PlannedEntry v) =>
      v.rememberedEkkloFoodId;
  static const Field<PlannedEntry, String> _f$rememberedEkkloFoodId = Field(
    'rememberedEkkloFoodId',
    _$rememberedEkkloFoodId,
    key: r'remembered_ekklo_food_id',
    opt: true,
  );
  static double? _$rememberedGramsPerUnit(PlannedEntry v) =>
      v.rememberedGramsPerUnit;
  static const Field<PlannedEntry, double> _f$rememberedGramsPerUnit = Field(
    'rememberedGramsPerUnit',
    _$rememberedGramsPerUnit,
    key: r'remembered_grams_per_unit',
    opt: true,
  );
  static SentLink? _$replacing(PlannedEntry v) => v.replacing;
  static const Field<PlannedEntry, SentLink> _f$replacing = Field(
    'replacing',
    _$replacing,
    opt: true,
  );

  @override
  final MappableFields<PlannedEntry> fields = const {
    #entry: _f$entry,
    #entryId: _f$entryId,
    #ekkloMealName: _f$ekkloMealName,
    #choice: _f$choice,
    #reviewed: _f$reviewed,
    #confirmed: _f$confirmed,
    #candidates: _f$candidates,
    #rememberedEkkloFoodId: _f$rememberedEkkloFoodId,
    #rememberedGramsPerUnit: _f$rememberedGramsPerUnit,
    #replacing: _f$replacing,
  };
  @override
  final bool ignoreNull = true;

  static PlannedEntry _instantiate(DecodingData data) {
    return PlannedEntry(
      entry: data.dec(_f$entry),
      entryId: data.dec(_f$entryId),
      ekkloMealName: data.dec(_f$ekkloMealName),
      choice: data.dec(_f$choice),
      reviewed: data.dec(_f$reviewed),
      confirmed: data.dec(_f$confirmed),
      candidates: data.dec(_f$candidates),
      rememberedEkkloFoodId: data.dec(_f$rememberedEkkloFoodId),
      rememberedGramsPerUnit: data.dec(_f$rememberedGramsPerUnit),
      replacing: data.dec(_f$replacing),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PlannedEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PlannedEntry>(map);
  }

  static PlannedEntry fromJson(String json) {
    return ensureInitialized().decodeJson<PlannedEntry>(json);
  }
}

mixin PlannedEntryMappable {
  String toJson() {
    return PlannedEntryMapper.ensureInitialized().encodeJson<PlannedEntry>(
      this as PlannedEntry,
    );
  }

  Map<String, dynamic> toMap() {
    return PlannedEntryMapper.ensureInitialized().encodeMap<PlannedEntry>(
      this as PlannedEntry,
    );
  }

  PlannedEntryCopyWith<PlannedEntry, PlannedEntry, PlannedEntry> get copyWith =>
      _PlannedEntryCopyWithImpl<PlannedEntry, PlannedEntry>(
        this as PlannedEntry,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PlannedEntryMapper.ensureInitialized().stringifyValue(
      this as PlannedEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    return PlannedEntryMapper.ensureInitialized().equalsValue(
      this as PlannedEntry,
      other,
    );
  }

  @override
  int get hashCode {
    return PlannedEntryMapper.ensureInitialized().hashValue(
      this as PlannedEntry,
    );
  }
}

extension PlannedEntryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PlannedEntry, $Out> {
  PlannedEntryCopyWith<$R, PlannedEntry, $Out> get $asPlannedEntry =>
      $base.as((v, t, t2) => _PlannedEntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PlannedEntryCopyWith<$R, $In extends PlannedEntry, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get entry;
  SendChoiceCopyWith<$R, SendChoice, SendChoice> get choice;
  ListCopyWith<
    $R,
    EkkloCandidate,
    EkkloCandidateCopyWith<$R, EkkloCandidate, EkkloCandidate>
  >
  get candidates;
  SentLinkCopyWith<$R, SentLink, SentLink>? get replacing;
  $R call({
    MfpFoodEntry? entry,
    String? entryId,
    String? ekkloMealName,
    SendChoice? choice,
    bool? reviewed,
    bool? confirmed,
    List<EkkloCandidate>? candidates,
    String? rememberedEkkloFoodId,
    double? rememberedGramsPerUnit,
    SentLink? replacing,
  });
  PlannedEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PlannedEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PlannedEntry, $Out>
    implements PlannedEntryCopyWith<$R, PlannedEntry, $Out> {
  _PlannedEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PlannedEntry> $mapper =
      PlannedEntryMapper.ensureInitialized();
  @override
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get entry =>
      $value.entry.copyWith.$chain((v) => call(entry: v));
  @override
  SendChoiceCopyWith<$R, SendChoice, SendChoice> get choice =>
      $value.choice.copyWith.$chain((v) => call(choice: v));
  @override
  ListCopyWith<
    $R,
    EkkloCandidate,
    EkkloCandidateCopyWith<$R, EkkloCandidate, EkkloCandidate>
  >
  get candidates => ListCopyWith(
    $value.candidates,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(candidates: v),
  );
  @override
  SentLinkCopyWith<$R, SentLink, SentLink>? get replacing =>
      $value.replacing?.copyWith.$chain((v) => call(replacing: v));
  @override
  $R call({
    MfpFoodEntry? entry,
    String? entryId,
    String? ekkloMealName,
    SendChoice? choice,
    bool? reviewed,
    bool? confirmed,
    List<EkkloCandidate>? candidates,
    Object? rememberedEkkloFoodId = $none,
    Object? rememberedGramsPerUnit = $none,
    Object? replacing = $none,
  }) => $apply(
    FieldCopyWithData({
      if (entry != null) #entry: entry,
      if (entryId != null) #entryId: entryId,
      if (ekkloMealName != null) #ekkloMealName: ekkloMealName,
      if (choice != null) #choice: choice,
      if (reviewed != null) #reviewed: reviewed,
      if (confirmed != null) #confirmed: confirmed,
      if (candidates != null) #candidates: candidates,
      if (rememberedEkkloFoodId != $none)
        #rememberedEkkloFoodId: rememberedEkkloFoodId,
      if (rememberedGramsPerUnit != $none)
        #rememberedGramsPerUnit: rememberedGramsPerUnit,
      if (replacing != $none) #replacing: replacing,
    }),
  );
  @override
  PlannedEntry $make(CopyWithData data) => PlannedEntry(
    entry: data.get(#entry, or: $value.entry),
    entryId: data.get(#entryId, or: $value.entryId),
    ekkloMealName: data.get(#ekkloMealName, or: $value.ekkloMealName),
    choice: data.get(#choice, or: $value.choice),
    reviewed: data.get(#reviewed, or: $value.reviewed),
    confirmed: data.get(#confirmed, or: $value.confirmed),
    candidates: data.get(#candidates, or: $value.candidates),
    rememberedEkkloFoodId: data.get(
      #rememberedEkkloFoodId,
      or: $value.rememberedEkkloFoodId,
    ),
    rememberedGramsPerUnit: data.get(
      #rememberedGramsPerUnit,
      or: $value.rememberedGramsPerUnit,
    ),
    replacing: data.get(#replacing, or: $value.replacing),
  );

  @override
  PlannedEntryCopyWith<$R2, PlannedEntry, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PlannedEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

