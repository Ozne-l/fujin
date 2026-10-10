// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'backup.dart';

class BackupMapper extends ClassMapperBase<Backup> {
  BackupMapper._();

  static BackupMapper? _instance;
  static BackupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupMapper._());
      MatchedFoodMapper.ensureInitialized();
      OwnCopyMapper.ensureInitialized();
      RememberedUnitMapper.ensureInitialized();
      MealMappingMapper.ensureInitialized();
      SentLinkMapper.ensureInitialized();
      GoalsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Backup';

  static DateTime _$exportedAt(Backup v) => v.exportedAt;
  static const Field<Backup, DateTime> _f$exportedAt = Field(
    'exportedAt',
    _$exportedAt,
    key: r'exported_at',
  );
  static List<MatchedFood> _$matches(Backup v) => v.matches;
  static const Field<Backup, List<MatchedFood>> _f$matches = Field(
    'matches',
    _$matches,
  );
  static List<OwnCopy> _$ownCopies(Backup v) => v.ownCopies;
  static const Field<Backup, List<OwnCopy>> _f$ownCopies = Field(
    'ownCopies',
    _$ownCopies,
    key: r'own_copies',
  );
  static List<RememberedUnit> _$units(Backup v) => v.units;
  static const Field<Backup, List<RememberedUnit>> _f$units = Field(
    'units',
    _$units,
  );
  static List<MealMapping> _$meals(Backup v) => v.meals;
  static const Field<Backup, List<MealMapping>> _f$meals = Field(
    'meals',
    _$meals,
  );
  static List<SentLink> _$links(Backup v) => v.links;
  static const Field<Backup, List<SentLink>> _f$links = Field('links', _$links);
  static Goals? _$goals(Backup v) => v.goals;
  static const Field<Backup, Goals> _f$goals = Field(
    'goals',
    _$goals,
    opt: true,
  );
  static String _$format(Backup v) => v.format;
  static const Field<Backup, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );
  static int _$version(Backup v) => v.version;
  static const Field<Backup, int> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: Backup.currentVersion,
  );

  @override
  final MappableFields<Backup> fields = const {
    #exportedAt: _f$exportedAt,
    #matches: _f$matches,
    #ownCopies: _f$ownCopies,
    #units: _f$units,
    #meals: _f$meals,
    #links: _f$links,
    #goals: _f$goals,
    #format: _f$format,
    #version: _f$version,
  };
  @override
  final bool ignoreNull = true;

  static Backup _instantiate(DecodingData data) {
    return Backup(
      exportedAt: data.dec(_f$exportedAt),
      matches: data.dec(_f$matches),
      ownCopies: data.dec(_f$ownCopies),
      units: data.dec(_f$units),
      meals: data.dec(_f$meals),
      links: data.dec(_f$links),
      goals: data.dec(_f$goals),
      format: data.dec(_f$format),
      version: data.dec(_f$version),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Backup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Backup>(map);
  }

  static Backup fromJson(String json) {
    return ensureInitialized().decodeJson<Backup>(json);
  }
}

mixin BackupMappable {
  String toJson() {
    return BackupMapper.ensureInitialized().encodeJson<Backup>(this as Backup);
  }

  Map<String, dynamic> toMap() {
    return BackupMapper.ensureInitialized().encodeMap<Backup>(this as Backup);
  }

  BackupCopyWith<Backup, Backup, Backup> get copyWith =>
      _BackupCopyWithImpl<Backup, Backup>(this as Backup, $identity, $identity);
  @override
  String toString() {
    return BackupMapper.ensureInitialized().stringifyValue(this as Backup);
  }

  @override
  bool operator ==(Object other) {
    return BackupMapper.ensureInitialized().equalsValue(this as Backup, other);
  }

  @override
  int get hashCode {
    return BackupMapper.ensureInitialized().hashValue(this as Backup);
  }
}

extension BackupValueCopy<$R, $Out> on ObjectCopyWith<$R, Backup, $Out> {
  BackupCopyWith<$R, Backup, $Out> get $asBackup =>
      $base.as((v, t, t2) => _BackupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupCopyWith<$R, $In extends Backup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MatchedFood,
    MatchedFoodCopyWith<$R, MatchedFood, MatchedFood>
  >
  get matches;
  ListCopyWith<$R, OwnCopy, OwnCopyCopyWith<$R, OwnCopy, OwnCopy>>
  get ownCopies;
  ListCopyWith<
    $R,
    RememberedUnit,
    RememberedUnitCopyWith<$R, RememberedUnit, RememberedUnit>
  >
  get units;
  ListCopyWith<
    $R,
    MealMapping,
    MealMappingCopyWith<$R, MealMapping, MealMapping>
  >
  get meals;
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links;
  GoalsCopyWith<$R, Goals, Goals>? get goals;
  $R call({
    DateTime? exportedAt,
    List<MatchedFood>? matches,
    List<OwnCopy>? ownCopies,
    List<RememberedUnit>? units,
    List<MealMapping>? meals,
    List<SentLink>? links,
    Goals? goals,
    String? format,
    int? version,
  });
  BackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Backup, $Out>
    implements BackupCopyWith<$R, Backup, $Out> {
  _BackupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Backup> $mapper = BackupMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MatchedFood,
    MatchedFoodCopyWith<$R, MatchedFood, MatchedFood>
  >
  get matches => ListCopyWith(
    $value.matches,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(matches: v),
  );
  @override
  ListCopyWith<$R, OwnCopy, OwnCopyCopyWith<$R, OwnCopy, OwnCopy>>
  get ownCopies => ListCopyWith(
    $value.ownCopies,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ownCopies: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedUnit,
    RememberedUnitCopyWith<$R, RememberedUnit, RememberedUnit>
  >
  get units => ListCopyWith(
    $value.units,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(units: v),
  );
  @override
  ListCopyWith<
    $R,
    MealMapping,
    MealMappingCopyWith<$R, MealMapping, MealMapping>
  >
  get meals => ListCopyWith(
    $value.meals,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(meals: v),
  );
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links => ListCopyWith(
    $value.links,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(links: v),
  );
  @override
  GoalsCopyWith<$R, Goals, Goals>? get goals =>
      $value.goals?.copyWith.$chain((v) => call(goals: v));
  @override
  $R call({
    DateTime? exportedAt,
    List<MatchedFood>? matches,
    List<OwnCopy>? ownCopies,
    List<RememberedUnit>? units,
    List<MealMapping>? meals,
    List<SentLink>? links,
    Object? goals = $none,
    String? format,
    int? version,
  }) => $apply(
    FieldCopyWithData({
      if (exportedAt != null) #exportedAt: exportedAt,
      if (matches != null) #matches: matches,
      if (ownCopies != null) #ownCopies: ownCopies,
      if (units != null) #units: units,
      if (meals != null) #meals: meals,
      if (links != null) #links: links,
      if (goals != $none) #goals: goals,
      if (format != null) #format: format,
      if (version != null) #version: version,
    }),
  );
  @override
  Backup $make(CopyWithData data) => Backup(
    exportedAt: data.get(#exportedAt, or: $value.exportedAt),
    matches: data.get(#matches, or: $value.matches),
    ownCopies: data.get(#ownCopies, or: $value.ownCopies),
    units: data.get(#units, or: $value.units),
    meals: data.get(#meals, or: $value.meals),
    links: data.get(#links, or: $value.links),
    goals: data.get(#goals, or: $value.goals),
    format: data.get(#format, or: $value.format),
    version: data.get(#version, or: $value.version),
  );

  @override
  BackupCopyWith<$R2, Backup, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BackupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

