// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'journal_read.dart';

class JournalReadMapper extends ClassMapperBase<JournalRead> {
  JournalReadMapper._();

  static JournalReadMapper? _instance;
  static JournalReadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = JournalReadMapper._());
      BothSidesMapper.ensureInitialized();
      MfpOnlyMapper.ensureInitialized();
      EkkloOnlyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'JournalRead';

  static DateTime _$readAt(JournalRead v) => v.readAt;
  static const Field<JournalRead, DateTime> _f$readAt = Field(
    'readAt',
    _$readAt,
    key: r'read_at',
  );

  @override
  final MappableFields<JournalRead> fields = const {#readAt: _f$readAt};
  @override
  final bool ignoreNull = true;

  static JournalRead _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'JournalRead',
      'sides',
      '${data.value['sides']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JournalRead fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JournalRead>(map);
  }

  static JournalRead fromJson(String json) {
    return ensureInitialized().decodeJson<JournalRead>(json);
  }
}

mixin JournalReadMappable {
  String toJson();
  Map<String, dynamic> toMap();
  JournalReadCopyWith<JournalRead, JournalRead, JournalRead> get copyWith;
}

abstract class JournalReadCopyWith<$R, $In extends JournalRead, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({DateTime? readAt});
  JournalReadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class BothSidesMapper extends SubClassMapperBase<BothSides> {
  BothSidesMapper._();

  static BothSidesMapper? _instance;
  static BothSidesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BothSidesMapper._());
      JournalReadMapper.ensureInitialized().addSubMapper(_instance!);
      JournalDayMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BothSides';

  static JournalDay _$day(BothSides v) => v.day;
  static const Field<BothSides, JournalDay> _f$day = Field('day', _$day);
  static DateTime _$readAt(BothSides v) => v.readAt;
  static const Field<BothSides, DateTime> _f$readAt = Field(
    'readAt',
    _$readAt,
    key: r'read_at',
  );

  @override
  final MappableFields<BothSides> fields = const {
    #day: _f$day,
    #readAt: _f$readAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'sides';
  @override
  final dynamic discriminatorValue = 'both';
  @override
  late final ClassMapperBase superMapper =
      JournalReadMapper.ensureInitialized();

  static BothSides _instantiate(DecodingData data) {
    return BothSides(day: data.dec(_f$day), readAt: data.dec(_f$readAt));
  }

  @override
  final Function instantiate = _instantiate;

  static BothSides fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BothSides>(map);
  }

  static BothSides fromJson(String json) {
    return ensureInitialized().decodeJson<BothSides>(json);
  }
}

mixin BothSidesMappable {
  String toJson() {
    return BothSidesMapper.ensureInitialized().encodeJson<BothSides>(
      this as BothSides,
    );
  }

  Map<String, dynamic> toMap() {
    return BothSidesMapper.ensureInitialized().encodeMap<BothSides>(
      this as BothSides,
    );
  }

  BothSidesCopyWith<BothSides, BothSides, BothSides> get copyWith =>
      _BothSidesCopyWithImpl<BothSides, BothSides>(
        this as BothSides,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BothSidesMapper.ensureInitialized().stringifyValue(
      this as BothSides,
    );
  }

  @override
  bool operator ==(Object other) {
    return BothSidesMapper.ensureInitialized().equalsValue(
      this as BothSides,
      other,
    );
  }

  @override
  int get hashCode {
    return BothSidesMapper.ensureInitialized().hashValue(this as BothSides);
  }
}

extension BothSidesValueCopy<$R, $Out> on ObjectCopyWith<$R, BothSides, $Out> {
  BothSidesCopyWith<$R, BothSides, $Out> get $asBothSides =>
      $base.as((v, t, t2) => _BothSidesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BothSidesCopyWith<$R, $In extends BothSides, $Out>
    implements JournalReadCopyWith<$R, $In, $Out> {
  JournalDayCopyWith<$R, JournalDay, JournalDay> get day;
  @override
  $R call({JournalDay? day, DateTime? readAt});
  BothSidesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BothSidesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BothSides, $Out>
    implements BothSidesCopyWith<$R, BothSides, $Out> {
  _BothSidesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BothSides> $mapper =
      BothSidesMapper.ensureInitialized();
  @override
  JournalDayCopyWith<$R, JournalDay, JournalDay> get day =>
      $value.day.copyWith.$chain((v) => call(day: v));
  @override
  $R call({JournalDay? day, DateTime? readAt}) => $apply(
    FieldCopyWithData({
      if (day != null) #day: day,
      if (readAt != null) #readAt: readAt,
    }),
  );
  @override
  BothSides $make(CopyWithData data) => BothSides(
    day: data.get(#day, or: $value.day),
    readAt: data.get(#readAt, or: $value.readAt),
  );

  @override
  BothSidesCopyWith<$R2, BothSides, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BothSidesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpOnlyMapper extends SubClassMapperBase<MfpOnly> {
  MfpOnlyMapper._();

  static MfpOnlyMapper? _instance;
  static MfpOnlyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpOnlyMapper._());
      JournalReadMapper.ensureInitialized().addSubMapper(_instance!);
      MfpDiaryDayMapper.ensureInitialized();
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpOnly';

  static MfpDiaryDay _$diary(MfpOnly v) => v.diary;
  static const Field<MfpOnly, MfpDiaryDay> _f$diary = Field('diary', _$diary);
  static ReadProblem _$ekkloProblem(MfpOnly v) => v.ekkloProblem;
  static const Field<MfpOnly, ReadProblem> _f$ekkloProblem = Field(
    'ekkloProblem',
    _$ekkloProblem,
    key: r'ekklo_problem',
  );
  static DateTime _$readAt(MfpOnly v) => v.readAt;
  static const Field<MfpOnly, DateTime> _f$readAt = Field(
    'readAt',
    _$readAt,
    key: r'read_at',
  );
  static List<String> _$mealNames(MfpOnly v) => v.mealNames;
  static const Field<MfpOnly, List<String>> _f$mealNames = Field(
    'mealNames',
    _$mealNames,
    key: r'meal_names',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<MfpOnly> fields = const {
    #diary: _f$diary,
    #ekkloProblem: _f$ekkloProblem,
    #readAt: _f$readAt,
    #mealNames: _f$mealNames,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'sides';
  @override
  final dynamic discriminatorValue = 'mfp_only';
  @override
  late final ClassMapperBase superMapper =
      JournalReadMapper.ensureInitialized();

  static MfpOnly _instantiate(DecodingData data) {
    return MfpOnly(
      diary: data.dec(_f$diary),
      ekkloProblem: data.dec(_f$ekkloProblem),
      readAt: data.dec(_f$readAt),
      mealNames: data.dec(_f$mealNames),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpOnly fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpOnly>(map);
  }

  static MfpOnly fromJson(String json) {
    return ensureInitialized().decodeJson<MfpOnly>(json);
  }
}

mixin MfpOnlyMappable {
  String toJson() {
    return MfpOnlyMapper.ensureInitialized().encodeJson<MfpOnly>(
      this as MfpOnly,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpOnlyMapper.ensureInitialized().encodeMap<MfpOnly>(
      this as MfpOnly,
    );
  }

  MfpOnlyCopyWith<MfpOnly, MfpOnly, MfpOnly> get copyWith =>
      _MfpOnlyCopyWithImpl<MfpOnly, MfpOnly>(
        this as MfpOnly,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpOnlyMapper.ensureInitialized().stringifyValue(this as MfpOnly);
  }

  @override
  bool operator ==(Object other) {
    return MfpOnlyMapper.ensureInitialized().equalsValue(
      this as MfpOnly,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpOnlyMapper.ensureInitialized().hashValue(this as MfpOnly);
  }
}

extension MfpOnlyValueCopy<$R, $Out> on ObjectCopyWith<$R, MfpOnly, $Out> {
  MfpOnlyCopyWith<$R, MfpOnly, $Out> get $asMfpOnly =>
      $base.as((v, t, t2) => _MfpOnlyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpOnlyCopyWith<$R, $In extends MfpOnly, $Out>
    implements JournalReadCopyWith<$R, $In, $Out> {
  MfpDiaryDayCopyWith<$R, MfpDiaryDay, MfpDiaryDay> get diary;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get mealNames;
  @override
  $R call({
    MfpDiaryDay? diary,
    ReadProblem? ekkloProblem,
    DateTime? readAt,
    List<String>? mealNames,
  });
  MfpOnlyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpOnlyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpOnly, $Out>
    implements MfpOnlyCopyWith<$R, MfpOnly, $Out> {
  _MfpOnlyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpOnly> $mapper =
      MfpOnlyMapper.ensureInitialized();
  @override
  MfpDiaryDayCopyWith<$R, MfpDiaryDay, MfpDiaryDay> get diary =>
      $value.diary.copyWith.$chain((v) => call(diary: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get mealNames =>
      ListCopyWith(
        $value.mealNames,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(mealNames: v),
      );
  @override
  $R call({
    MfpDiaryDay? diary,
    ReadProblem? ekkloProblem,
    DateTime? readAt,
    List<String>? mealNames,
  }) => $apply(
    FieldCopyWithData({
      if (diary != null) #diary: diary,
      if (ekkloProblem != null) #ekkloProblem: ekkloProblem,
      if (readAt != null) #readAt: readAt,
      if (mealNames != null) #mealNames: mealNames,
    }),
  );
  @override
  MfpOnly $make(CopyWithData data) => MfpOnly(
    diary: data.get(#diary, or: $value.diary),
    ekkloProblem: data.get(#ekkloProblem, or: $value.ekkloProblem),
    readAt: data.get(#readAt, or: $value.readAt),
    mealNames: data.get(#mealNames, or: $value.mealNames),
  );

  @override
  MfpOnlyCopyWith<$R2, MfpOnly, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MfpOnlyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EkkloOnlyMapper extends SubClassMapperBase<EkkloOnly> {
  EkkloOnlyMapper._();

  static EkkloOnlyMapper? _instance;
  static EkkloOnlyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloOnlyMapper._());
      JournalReadMapper.ensureInitialized().addSubMapper(_instance!);
      ReadProblemMapper.ensureInitialized();
      EkkloDailyMealMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloOnly';

  static ReadProblem _$mfpProblem(EkkloOnly v) => v.mfpProblem;
  static const Field<EkkloOnly, ReadProblem> _f$mfpProblem = Field(
    'mfpProblem',
    _$mfpProblem,
    key: r'mfp_problem',
  );
  static DateTime _$readAt(EkkloOnly v) => v.readAt;
  static const Field<EkkloOnly, DateTime> _f$readAt = Field(
    'readAt',
    _$readAt,
    key: r'read_at',
  );
  static List<EkkloDailyMeal> _$ekkloMeals(EkkloOnly v) => v.ekkloMeals;
  static const Field<EkkloOnly, List<EkkloDailyMeal>> _f$ekkloMeals = Field(
    'ekkloMeals',
    _$ekkloMeals,
    key: r'ekklo_meals',
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<EkkloOnly> fields = const {
    #mfpProblem: _f$mfpProblem,
    #readAt: _f$readAt,
    #ekkloMeals: _f$ekkloMeals,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'sides';
  @override
  final dynamic discriminatorValue = 'ekklo_only';
  @override
  late final ClassMapperBase superMapper =
      JournalReadMapper.ensureInitialized();

  static EkkloOnly _instantiate(DecodingData data) {
    return EkkloOnly(
      mfpProblem: data.dec(_f$mfpProblem),
      readAt: data.dec(_f$readAt),
      ekkloMeals: data.dec(_f$ekkloMeals),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloOnly fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloOnly>(map);
  }

  static EkkloOnly fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloOnly>(json);
  }
}

mixin EkkloOnlyMappable {
  String toJson() {
    return EkkloOnlyMapper.ensureInitialized().encodeJson<EkkloOnly>(
      this as EkkloOnly,
    );
  }

  Map<String, dynamic> toMap() {
    return EkkloOnlyMapper.ensureInitialized().encodeMap<EkkloOnly>(
      this as EkkloOnly,
    );
  }

  EkkloOnlyCopyWith<EkkloOnly, EkkloOnly, EkkloOnly> get copyWith =>
      _EkkloOnlyCopyWithImpl<EkkloOnly, EkkloOnly>(
        this as EkkloOnly,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloOnlyMapper.ensureInitialized().stringifyValue(
      this as EkkloOnly,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloOnlyMapper.ensureInitialized().equalsValue(
      this as EkkloOnly,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloOnlyMapper.ensureInitialized().hashValue(this as EkkloOnly);
  }
}

extension EkkloOnlyValueCopy<$R, $Out> on ObjectCopyWith<$R, EkkloOnly, $Out> {
  EkkloOnlyCopyWith<$R, EkkloOnly, $Out> get $asEkkloOnly =>
      $base.as((v, t, t2) => _EkkloOnlyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloOnlyCopyWith<$R, $In extends EkkloOnly, $Out>
    implements JournalReadCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    EkkloDailyMeal,
    EkkloDailyMealCopyWith<$R, EkkloDailyMeal, EkkloDailyMeal>
  >
  get ekkloMeals;
  @override
  $R call({
    ReadProblem? mfpProblem,
    DateTime? readAt,
    List<EkkloDailyMeal>? ekkloMeals,
  });
  EkkloOnlyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EkkloOnlyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloOnly, $Out>
    implements EkkloOnlyCopyWith<$R, EkkloOnly, $Out> {
  _EkkloOnlyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloOnly> $mapper =
      EkkloOnlyMapper.ensureInitialized();
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
    ReadProblem? mfpProblem,
    DateTime? readAt,
    List<EkkloDailyMeal>? ekkloMeals,
  }) => $apply(
    FieldCopyWithData({
      if (mfpProblem != null) #mfpProblem: mfpProblem,
      if (readAt != null) #readAt: readAt,
      if (ekkloMeals != null) #ekkloMeals: ekkloMeals,
    }),
  );
  @override
  EkkloOnly $make(CopyWithData data) => EkkloOnly(
    mfpProblem: data.get(#mfpProblem, or: $value.mfpProblem),
    readAt: data.get(#readAt, or: $value.readAt),
    ekkloMeals: data.get(#ekkloMeals, or: $value.ekkloMeals),
  );

  @override
  EkkloOnlyCopyWith<$R2, EkkloOnly, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloOnlyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

