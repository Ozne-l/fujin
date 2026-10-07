// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'journal_day.dart';

class JournalDayMapper extends ClassMapperBase<JournalDay> {
  JournalDayMapper._();

  static JournalDayMapper? _instance;
  static JournalDayMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JournalDayMapper._());
      MfpDiaryDayMapper.ensureInitialized();
      DayComparisonMapper.ensureInitialized();
      EkkloDailyMealMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'JournalDay';

  static MfpDiaryDay _$diary(JournalDay v) => v.diary;
  static const Field<JournalDay, MfpDiaryDay> _f$diary = Field(
    'diary',
    _$diary,
  );
  static DayComparison _$comparison(JournalDay v) => v.comparison;
  static const Field<JournalDay, DayComparison> _f$comparison = Field(
    'comparison',
    _$comparison,
  );
  static List<String> _$mealNames(JournalDay v) => v.mealNames;
  static const Field<JournalDay, List<String>> _f$mealNames = Field(
    'mealNames',
    _$mealNames,
    key: r'meal_names',
    opt: true,
    def: const [],
  );
  static List<EkkloDailyMeal> _$ekkloMeals(JournalDay v) => v.ekkloMeals;
  static const Field<JournalDay, List<EkkloDailyMeal>> _f$ekkloMeals = Field(
    'ekkloMeals',
    _$ekkloMeals,
    key: r'ekklo_meals',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<JournalDay> fields = const {
    #diary: _f$diary,
    #comparison: _f$comparison,
    #mealNames: _f$mealNames,
    #ekkloMeals: _f$ekkloMeals,
  };
  @override
  final bool ignoreNull = true;

  static JournalDay _instantiate(DecodingData data) {
    return JournalDay(
      diary: data.dec(_f$diary),
      comparison: data.dec(_f$comparison),
      mealNames: data.dec(_f$mealNames),
      ekkloMeals: data.dec(_f$ekkloMeals),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JournalDay fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JournalDay>(map);
  }

  static JournalDay fromJson(String json) {
    return ensureInitialized().decodeJson<JournalDay>(json);
  }
}

mixin JournalDayMappable {
  String toJson() {
    return JournalDayMapper.ensureInitialized().encodeJson<JournalDay>(
      this as JournalDay,
    );
  }

  Map<String, dynamic> toMap() {
    return JournalDayMapper.ensureInitialized().encodeMap<JournalDay>(
      this as JournalDay,
    );
  }

  JournalDayCopyWith<JournalDay, JournalDay, JournalDay> get copyWith =>
      _JournalDayCopyWithImpl<JournalDay, JournalDay>(
        this as JournalDay,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return JournalDayMapper.ensureInitialized().stringifyValue(
      this as JournalDay,
    );
  }

  @override
  bool operator ==(Object other) {
    return JournalDayMapper.ensureInitialized().equalsValue(
      this as JournalDay,
      other,
    );
  }

  @override
  int get hashCode {
    return JournalDayMapper.ensureInitialized().hashValue(this as JournalDay);
  }
}

extension JournalDayValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JournalDay, $Out> {
  JournalDayCopyWith<$R, JournalDay, $Out> get $asJournalDay =>
      $base.as((v, t, t2) => _JournalDayCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class JournalDayCopyWith<$R, $In extends JournalDay, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MfpDiaryDayCopyWith<$R, MfpDiaryDay, MfpDiaryDay> get diary;
  DayComparisonCopyWith<$R, DayComparison, DayComparison> get comparison;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get mealNames;
  ListCopyWith<
    $R,
    EkkloDailyMeal,
    EkkloDailyMealCopyWith<$R, EkkloDailyMeal, EkkloDailyMeal>
  >
  get ekkloMeals;
  $R call({
    MfpDiaryDay? diary,
    DayComparison? comparison,
    List<String>? mealNames,
    List<EkkloDailyMeal>? ekkloMeals,
  });
  JournalDayCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _JournalDayCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JournalDay, $Out>
    implements JournalDayCopyWith<$R, JournalDay, $Out> {
  _JournalDayCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<JournalDay> $mapper =
      JournalDayMapper.ensureInitialized();
  @override
  MfpDiaryDayCopyWith<$R, MfpDiaryDay, MfpDiaryDay> get diary =>
      $value.diary.copyWith.$chain((v) => call(diary: v));
  @override
  DayComparisonCopyWith<$R, DayComparison, DayComparison> get comparison =>
      $value.comparison.copyWith.$chain((v) => call(comparison: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get mealNames =>
      ListCopyWith(
        $value.mealNames,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(mealNames: v),
      );
  @override
  ListCopyWith<
    $R,
    EkkloDailyMeal,
    EkkloDailyMealCopyWith<$R, EkkloDailyMeal, EkkloDailyMeal>
  >
  get ekkloMeals => ListCopyWith(
    $value.ekkloMeals,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ekkloMeals: v),
  );
  @override
  $R call({
    MfpDiaryDay? diary,
    DayComparison? comparison,
    List<String>? mealNames,
    List<EkkloDailyMeal>? ekkloMeals,
  }) => $apply(
    FieldCopyWithData({
      if (diary != null) #diary: diary,
      if (comparison != null) #comparison: comparison,
      if (mealNames != null) #mealNames: mealNames,
      if (ekkloMeals != null) #ekkloMeals: ekkloMeals,
    }),
  );
  @override
  JournalDay $make(CopyWithData data) => JournalDay(
    diary: data.get(#diary, or: $value.diary),
    comparison: data.get(#comparison, or: $value.comparison),
    mealNames: data.get(#mealNames, or: $value.mealNames),
    ekkloMeals: data.get(#ekkloMeals, or: $value.ekkloMeals),
  );

  @override
  JournalDayCopyWith<$R2, JournalDay, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _JournalDayCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

