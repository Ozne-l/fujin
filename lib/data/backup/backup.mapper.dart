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
      BackupV6Mapper.ensureInitialized();
      BackupV5Mapper.ensureInitialized();
      BackupV3Mapper.ensureInitialized();
      BackupV2Mapper.ensureInitialized();
      SentLinkMapper.ensureInitialized();
      GoalPeriodMapper.ensureInitialized();
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
  static List<SentLink> _$links(Backup v) => v.links;
  static const Field<Backup, List<SentLink>> _f$links = Field('links', _$links);
  static int _$version(Backup v) => v.version;
  static const Field<Backup, int> _f$version = Field('version', _$version);
  static List<GoalPeriod> _$goalPeriods(Backup v) => v.goalPeriods;
  static const Field<Backup, List<GoalPeriod>> _f$goalPeriods = Field(
    'goalPeriods',
    _$goalPeriods,
    key: r'goal_periods',
    opt: true,
    def: const [],
  );
  static String _$format(Backup v) => v.format;
  static const Field<Backup, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );

  @override
  final MappableFields<Backup> fields = const {
    #exportedAt: _f$exportedAt,
    #links: _f$links,
    #version: _f$version,
    #goalPeriods: _f$goalPeriods,
    #format: _f$format,
  };
  @override
  final bool ignoreNull = true;

  static Backup _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'Backup',
      'version',
      '${data.value['version']}',
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
  String toJson();
  Map<String, dynamic> toMap();
  BackupCopyWith<Backup, Backup, Backup> get copyWith;
}

abstract class BackupCopyWith<$R, $In extends Backup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links;
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods;
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    int? version,
    List<GoalPeriod>? goalPeriods,
    String? format,
  });
  BackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class BackupV6Mapper extends SubClassMapperBase<BackupV6> {
  BackupV6Mapper._();

  static BackupV6Mapper? _instance;
  static BackupV6Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupV6Mapper._());
      BackupMapper.ensureInitialized().addSubMapper(_instance!);
      SentLinkMapper.ensureInitialized();
      FoodMapper.ensureInitialized();
      FoodServingMapper.ensureInitialized();
      FoodUnitMapper.ensureInitialized();
      FoodReferenceMapper.ensureInitialized();
      FoodBarcodeMapper.ensureInitialized();
      MealMapper.ensureInitialized();
      ConnectorMealMapper.ensureInitialized();
      EntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
      EkkloLinkMapper.ensureInitialized();
      WeighInMapper.ensureInitialized();
      EkkloWeighInLinkMapper.ensureInitialized();
      MfpWeighInLinkMapper.ensureInitialized();
      GoalPeriodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupV6';

  static DateTime _$exportedAt(BackupV6 v) => v.exportedAt;
  static const Field<BackupV6, DateTime> _f$exportedAt = Field(
    'exportedAt',
    _$exportedAt,
    key: r'exported_at',
  );
  static List<SentLink> _$links(BackupV6 v) => v.links;
  static const Field<BackupV6, List<SentLink>> _f$links = Field(
    'links',
    _$links,
  );
  static List<Food> _$foods(BackupV6 v) => v.foods;
  static const Field<BackupV6, List<Food>> _f$foods = Field('foods', _$foods);
  static List<FoodServing> _$foodServings(BackupV6 v) => v.foodServings;
  static const Field<BackupV6, List<FoodServing>> _f$foodServings = Field(
    'foodServings',
    _$foodServings,
    key: r'food_servings',
  );
  static List<FoodUnit> _$foodUnits(BackupV6 v) => v.foodUnits;
  static const Field<BackupV6, List<FoodUnit>> _f$foodUnits = Field(
    'foodUnits',
    _$foodUnits,
    key: r'food_units',
  );
  static List<FoodReference> _$foodReferences(BackupV6 v) => v.foodReferences;
  static const Field<BackupV6, List<FoodReference>> _f$foodReferences = Field(
    'foodReferences',
    _$foodReferences,
    key: r'food_references',
  );
  static List<FoodBarcode> _$barcodeLinks(BackupV6 v) => v.barcodeLinks;
  static const Field<BackupV6, List<FoodBarcode>> _f$barcodeLinks = Field(
    'barcodeLinks',
    _$barcodeLinks,
    key: r'barcode_links',
  );
  static List<Meal> _$meals(BackupV6 v) => v.meals;
  static const Field<BackupV6, List<Meal>> _f$meals = Field('meals', _$meals);
  static List<ConnectorMeal> _$mealMappings(BackupV6 v) => v.mealMappings;
  static const Field<BackupV6, List<ConnectorMeal>> _f$mealMappings = Field(
    'mealMappings',
    _$mealMappings,
    key: r'meal_mappings',
  );
  static List<Entry> _$entries(BackupV6 v) => v.entries;
  static const Field<BackupV6, List<Entry>> _f$entries = Field(
    'entries',
    _$entries,
  );
  static List<MfpLink> _$mfpLinks(BackupV6 v) => v.mfpLinks;
  static const Field<BackupV6, List<MfpLink>> _f$mfpLinks = Field(
    'mfpLinks',
    _$mfpLinks,
    key: r'mfp_links',
  );
  static List<EkkloLink> _$ekkloLinks(BackupV6 v) => v.ekkloLinks;
  static const Field<BackupV6, List<EkkloLink>> _f$ekkloLinks = Field(
    'ekkloLinks',
    _$ekkloLinks,
    key: r'ekklo_links',
  );
  static List<WeighIn> _$weighIns(BackupV6 v) => v.weighIns;
  static const Field<BackupV6, List<WeighIn>> _f$weighIns = Field(
    'weighIns',
    _$weighIns,
    key: r'weigh_ins',
  );
  static List<EkkloWeighInLink> _$ekkloWeighInLinks(BackupV6 v) =>
      v.ekkloWeighInLinks;
  static const Field<BackupV6, List<EkkloWeighInLink>> _f$ekkloWeighInLinks =
      Field(
        'ekkloWeighInLinks',
        _$ekkloWeighInLinks,
        key: r'ekklo_weigh_in_links',
      );
  static List<MfpWeighInLink> _$mfpWeighInLinks(BackupV6 v) =>
      v.mfpWeighInLinks;
  static const Field<BackupV6, List<MfpWeighInLink>> _f$mfpWeighInLinks = Field(
    'mfpWeighInLinks',
    _$mfpWeighInLinks,
    key: r'mfp_weigh_in_links',
  );
  static List<GoalPeriod> _$goalPeriods(BackupV6 v) => v.goalPeriods;
  static const Field<BackupV6, List<GoalPeriod>> _f$goalPeriods = Field(
    'goalPeriods',
    _$goalPeriods,
    key: r'goal_periods',
    opt: true,
    def: const [],
  );
  static String _$format(BackupV6 v) => v.format;
  static const Field<BackupV6, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );
  static int _$version(BackupV6 v) => v.version;
  static const Field<BackupV6, int> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: BackupV6.currentVersion,
  );

  @override
  final MappableFields<BackupV6> fields = const {
    #exportedAt: _f$exportedAt,
    #links: _f$links,
    #foods: _f$foods,
    #foodServings: _f$foodServings,
    #foodUnits: _f$foodUnits,
    #foodReferences: _f$foodReferences,
    #barcodeLinks: _f$barcodeLinks,
    #meals: _f$meals,
    #mealMappings: _f$mealMappings,
    #entries: _f$entries,
    #mfpLinks: _f$mfpLinks,
    #ekkloLinks: _f$ekkloLinks,
    #weighIns: _f$weighIns,
    #ekkloWeighInLinks: _f$ekkloWeighInLinks,
    #mfpWeighInLinks: _f$mfpWeighInLinks,
    #goalPeriods: _f$goalPeriods,
    #format: _f$format,
    #version: _f$version,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'version';
  @override
  final dynamic discriminatorValue = BackupV6.currentVersion;
  @override
  late final ClassMapperBase superMapper = BackupMapper.ensureInitialized();

  static BackupV6 _instantiate(DecodingData data) {
    return BackupV6(
      exportedAt: data.dec(_f$exportedAt),
      links: data.dec(_f$links),
      foods: data.dec(_f$foods),
      foodServings: data.dec(_f$foodServings),
      foodUnits: data.dec(_f$foodUnits),
      foodReferences: data.dec(_f$foodReferences),
      barcodeLinks: data.dec(_f$barcodeLinks),
      meals: data.dec(_f$meals),
      mealMappings: data.dec(_f$mealMappings),
      entries: data.dec(_f$entries),
      mfpLinks: data.dec(_f$mfpLinks),
      ekkloLinks: data.dec(_f$ekkloLinks),
      weighIns: data.dec(_f$weighIns),
      ekkloWeighInLinks: data.dec(_f$ekkloWeighInLinks),
      mfpWeighInLinks: data.dec(_f$mfpWeighInLinks),
      goalPeriods: data.dec(_f$goalPeriods),
      format: data.dec(_f$format),
      version: data.dec(_f$version),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupV6 fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupV6>(map);
  }

  static BackupV6 fromJson(String json) {
    return ensureInitialized().decodeJson<BackupV6>(json);
  }
}

mixin BackupV6Mappable {
  String toJson() {
    return BackupV6Mapper.ensureInitialized().encodeJson<BackupV6>(
      this as BackupV6,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupV6Mapper.ensureInitialized().encodeMap<BackupV6>(
      this as BackupV6,
    );
  }

  BackupV6CopyWith<BackupV6, BackupV6, BackupV6> get copyWith =>
      _BackupV6CopyWithImpl<BackupV6, BackupV6>(
        this as BackupV6,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupV6Mapper.ensureInitialized().stringifyValue(this as BackupV6);
  }

  @override
  bool operator ==(Object other) {
    return BackupV6Mapper.ensureInitialized().equalsValue(
      this as BackupV6,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupV6Mapper.ensureInitialized().hashValue(this as BackupV6);
  }
}

extension BackupV6ValueCopy<$R, $Out> on ObjectCopyWith<$R, BackupV6, $Out> {
  BackupV6CopyWith<$R, BackupV6, $Out> get $asBackupV6 =>
      $base.as((v, t, t2) => _BackupV6CopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupV6CopyWith<$R, $In extends BackupV6, $Out>
    implements BackupCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links;
  ListCopyWith<$R, Food, FoodCopyWith<$R, Food, Food>> get foods;
  ListCopyWith<
    $R,
    FoodServing,
    FoodServingCopyWith<$R, FoodServing, FoodServing>
  >
  get foodServings;
  ListCopyWith<$R, FoodUnit, FoodUnitCopyWith<$R, FoodUnit, FoodUnit>>
  get foodUnits;
  ListCopyWith<
    $R,
    FoodReference,
    FoodReferenceCopyWith<$R, FoodReference, FoodReference>
  >
  get foodReferences;
  ListCopyWith<
    $R,
    FoodBarcode,
    FoodBarcodeCopyWith<$R, FoodBarcode, FoodBarcode>
  >
  get barcodeLinks;
  ListCopyWith<$R, Meal, MealCopyWith<$R, Meal, Meal>> get meals;
  ListCopyWith<
    $R,
    ConnectorMeal,
    ConnectorMealCopyWith<$R, ConnectorMeal, ConnectorMeal>
  >
  get mealMappings;
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get entries;
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>> get mfpLinks;
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get ekkloLinks;
  ListCopyWith<$R, WeighIn, WeighInCopyWith<$R, WeighIn, WeighIn>> get weighIns;
  ListCopyWith<
    $R,
    EkkloWeighInLink,
    EkkloWeighInLinkCopyWith<$R, EkkloWeighInLink, EkkloWeighInLink>
  >
  get ekkloWeighInLinks;
  ListCopyWith<
    $R,
    MfpWeighInLink,
    MfpWeighInLinkCopyWith<$R, MfpWeighInLink, MfpWeighInLink>
  >
  get mfpWeighInLinks;
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods;
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    List<Food>? foods,
    List<FoodServing>? foodServings,
    List<FoodUnit>? foodUnits,
    List<FoodReference>? foodReferences,
    List<FoodBarcode>? barcodeLinks,
    List<Meal>? meals,
    List<ConnectorMeal>? mealMappings,
    List<Entry>? entries,
    List<MfpLink>? mfpLinks,
    List<EkkloLink>? ekkloLinks,
    List<WeighIn>? weighIns,
    List<EkkloWeighInLink>? ekkloWeighInLinks,
    List<MfpWeighInLink>? mfpWeighInLinks,
    List<GoalPeriod>? goalPeriods,
    String? format,
    int? version,
  });
  BackupV6CopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupV6CopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupV6, $Out>
    implements BackupV6CopyWith<$R, BackupV6, $Out> {
  _BackupV6CopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupV6> $mapper =
      BackupV6Mapper.ensureInitialized();
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links => ListCopyWith(
    $value.links,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(links: v),
  );
  @override
  ListCopyWith<$R, Food, FoodCopyWith<$R, Food, Food>> get foods =>
      ListCopyWith(
        $value.foods,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(foods: v),
      );
  @override
  ListCopyWith<
    $R,
    FoodServing,
    FoodServingCopyWith<$R, FoodServing, FoodServing>
  >
  get foodServings => ListCopyWith(
    $value.foodServings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodServings: v),
  );
  @override
  ListCopyWith<$R, FoodUnit, FoodUnitCopyWith<$R, FoodUnit, FoodUnit>>
  get foodUnits => ListCopyWith(
    $value.foodUnits,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodUnits: v),
  );
  @override
  ListCopyWith<
    $R,
    FoodReference,
    FoodReferenceCopyWith<$R, FoodReference, FoodReference>
  >
  get foodReferences => ListCopyWith(
    $value.foodReferences,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodReferences: v),
  );
  @override
  ListCopyWith<
    $R,
    FoodBarcode,
    FoodBarcodeCopyWith<$R, FoodBarcode, FoodBarcode>
  >
  get barcodeLinks => ListCopyWith(
    $value.barcodeLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(barcodeLinks: v),
  );
  @override
  ListCopyWith<$R, Meal, MealCopyWith<$R, Meal, Meal>> get meals =>
      ListCopyWith(
        $value.meals,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(meals: v),
      );
  @override
  ListCopyWith<
    $R,
    ConnectorMeal,
    ConnectorMealCopyWith<$R, ConnectorMeal, ConnectorMeal>
  >
  get mealMappings => ListCopyWith(
    $value.mealMappings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mealMappings: v),
  );
  @override
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get entries =>
      ListCopyWith(
        $value.entries,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(entries: v),
      );
  @override
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>>
  get mfpLinks => ListCopyWith(
    $value.mfpLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mfpLinks: v),
  );
  @override
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get ekkloLinks => ListCopyWith(
    $value.ekkloLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ekkloLinks: v),
  );
  @override
  ListCopyWith<$R, WeighIn, WeighInCopyWith<$R, WeighIn, WeighIn>>
  get weighIns => ListCopyWith(
    $value.weighIns,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(weighIns: v),
  );
  @override
  ListCopyWith<
    $R,
    EkkloWeighInLink,
    EkkloWeighInLinkCopyWith<$R, EkkloWeighInLink, EkkloWeighInLink>
  >
  get ekkloWeighInLinks => ListCopyWith(
    $value.ekkloWeighInLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ekkloWeighInLinks: v),
  );
  @override
  ListCopyWith<
    $R,
    MfpWeighInLink,
    MfpWeighInLinkCopyWith<$R, MfpWeighInLink, MfpWeighInLink>
  >
  get mfpWeighInLinks => ListCopyWith(
    $value.mfpWeighInLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mfpWeighInLinks: v),
  );
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods => ListCopyWith(
    $value.goalPeriods,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(goalPeriods: v),
  );
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    List<Food>? foods,
    List<FoodServing>? foodServings,
    List<FoodUnit>? foodUnits,
    List<FoodReference>? foodReferences,
    List<FoodBarcode>? barcodeLinks,
    List<Meal>? meals,
    List<ConnectorMeal>? mealMappings,
    List<Entry>? entries,
    List<MfpLink>? mfpLinks,
    List<EkkloLink>? ekkloLinks,
    List<WeighIn>? weighIns,
    List<EkkloWeighInLink>? ekkloWeighInLinks,
    List<MfpWeighInLink>? mfpWeighInLinks,
    List<GoalPeriod>? goalPeriods,
    String? format,
    int? version,
  }) => $apply(
    FieldCopyWithData({
      if (exportedAt != null) #exportedAt: exportedAt,
      if (links != null) #links: links,
      if (foods != null) #foods: foods,
      if (foodServings != null) #foodServings: foodServings,
      if (foodUnits != null) #foodUnits: foodUnits,
      if (foodReferences != null) #foodReferences: foodReferences,
      if (barcodeLinks != null) #barcodeLinks: barcodeLinks,
      if (meals != null) #meals: meals,
      if (mealMappings != null) #mealMappings: mealMappings,
      if (entries != null) #entries: entries,
      if (mfpLinks != null) #mfpLinks: mfpLinks,
      if (ekkloLinks != null) #ekkloLinks: ekkloLinks,
      if (weighIns != null) #weighIns: weighIns,
      if (ekkloWeighInLinks != null) #ekkloWeighInLinks: ekkloWeighInLinks,
      if (mfpWeighInLinks != null) #mfpWeighInLinks: mfpWeighInLinks,
      if (goalPeriods != null) #goalPeriods: goalPeriods,
      if (format != null) #format: format,
      if (version != null) #version: version,
    }),
  );
  @override
  BackupV6 $make(CopyWithData data) => BackupV6(
    exportedAt: data.get(#exportedAt, or: $value.exportedAt),
    links: data.get(#links, or: $value.links),
    foods: data.get(#foods, or: $value.foods),
    foodServings: data.get(#foodServings, or: $value.foodServings),
    foodUnits: data.get(#foodUnits, or: $value.foodUnits),
    foodReferences: data.get(#foodReferences, or: $value.foodReferences),
    barcodeLinks: data.get(#barcodeLinks, or: $value.barcodeLinks),
    meals: data.get(#meals, or: $value.meals),
    mealMappings: data.get(#mealMappings, or: $value.mealMappings),
    entries: data.get(#entries, or: $value.entries),
    mfpLinks: data.get(#mfpLinks, or: $value.mfpLinks),
    ekkloLinks: data.get(#ekkloLinks, or: $value.ekkloLinks),
    weighIns: data.get(#weighIns, or: $value.weighIns),
    ekkloWeighInLinks: data.get(
      #ekkloWeighInLinks,
      or: $value.ekkloWeighInLinks,
    ),
    mfpWeighInLinks: data.get(#mfpWeighInLinks, or: $value.mfpWeighInLinks),
    goalPeriods: data.get(#goalPeriods, or: $value.goalPeriods),
    format: data.get(#format, or: $value.format),
    version: data.get(#version, or: $value.version),
  );

  @override
  BackupV6CopyWith<$R2, BackupV6, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupV6CopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupV5Mapper extends SubClassMapperBase<BackupV5> {
  BackupV5Mapper._();

  static BackupV5Mapper? _instance;
  static BackupV5Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupV5Mapper._());
      BackupMapper.ensureInitialized().addSubMapper(_instance!);
      SentLinkMapper.ensureInitialized();
      FoodMapper.ensureInitialized();
      FoodServingMapper.ensureInitialized();
      FoodUnitMapper.ensureInitialized();
      FoodReferenceMapper.ensureInitialized();
      FoodBarcodeMapper.ensureInitialized();
      MealMapper.ensureInitialized();
      ConnectorMealMapper.ensureInitialized();
      EntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
      EkkloLinkMapper.ensureInitialized();
      GoalPeriodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupV5';

  static DateTime _$exportedAt(BackupV5 v) => v.exportedAt;
  static const Field<BackupV5, DateTime> _f$exportedAt = Field(
    'exportedAt',
    _$exportedAt,
    key: r'exported_at',
  );
  static List<SentLink> _$links(BackupV5 v) => v.links;
  static const Field<BackupV5, List<SentLink>> _f$links = Field(
    'links',
    _$links,
  );
  static List<Food> _$foods(BackupV5 v) => v.foods;
  static const Field<BackupV5, List<Food>> _f$foods = Field('foods', _$foods);
  static List<FoodServing> _$foodServings(BackupV5 v) => v.foodServings;
  static const Field<BackupV5, List<FoodServing>> _f$foodServings = Field(
    'foodServings',
    _$foodServings,
    key: r'food_servings',
  );
  static List<FoodUnit> _$foodUnits(BackupV5 v) => v.foodUnits;
  static const Field<BackupV5, List<FoodUnit>> _f$foodUnits = Field(
    'foodUnits',
    _$foodUnits,
    key: r'food_units',
  );
  static List<FoodReference> _$foodReferences(BackupV5 v) => v.foodReferences;
  static const Field<BackupV5, List<FoodReference>> _f$foodReferences = Field(
    'foodReferences',
    _$foodReferences,
    key: r'food_references',
  );
  static List<FoodBarcode> _$barcodeLinks(BackupV5 v) => v.barcodeLinks;
  static const Field<BackupV5, List<FoodBarcode>> _f$barcodeLinks = Field(
    'barcodeLinks',
    _$barcodeLinks,
    key: r'barcode_links',
  );
  static List<Meal> _$meals(BackupV5 v) => v.meals;
  static const Field<BackupV5, List<Meal>> _f$meals = Field('meals', _$meals);
  static List<ConnectorMeal> _$mealMappings(BackupV5 v) => v.mealMappings;
  static const Field<BackupV5, List<ConnectorMeal>> _f$mealMappings = Field(
    'mealMappings',
    _$mealMappings,
    key: r'meal_mappings',
  );
  static List<Entry> _$entries(BackupV5 v) => v.entries;
  static const Field<BackupV5, List<Entry>> _f$entries = Field(
    'entries',
    _$entries,
  );
  static List<MfpLink> _$mfpLinks(BackupV5 v) => v.mfpLinks;
  static const Field<BackupV5, List<MfpLink>> _f$mfpLinks = Field(
    'mfpLinks',
    _$mfpLinks,
    key: r'mfp_links',
  );
  static List<EkkloLink> _$ekkloLinks(BackupV5 v) => v.ekkloLinks;
  static const Field<BackupV5, List<EkkloLink>> _f$ekkloLinks = Field(
    'ekkloLinks',
    _$ekkloLinks,
    key: r'ekklo_links',
  );
  static List<GoalPeriod> _$goalPeriods(BackupV5 v) => v.goalPeriods;
  static const Field<BackupV5, List<GoalPeriod>> _f$goalPeriods = Field(
    'goalPeriods',
    _$goalPeriods,
    key: r'goal_periods',
    opt: true,
    def: const [],
  );
  static String _$format(BackupV5 v) => v.format;
  static const Field<BackupV5, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );
  static int _$version(BackupV5 v) => v.version;
  static const Field<BackupV5, int> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: BackupV5.goalPeriodsVersion,
  );

  @override
  final MappableFields<BackupV5> fields = const {
    #exportedAt: _f$exportedAt,
    #links: _f$links,
    #foods: _f$foods,
    #foodServings: _f$foodServings,
    #foodUnits: _f$foodUnits,
    #foodReferences: _f$foodReferences,
    #barcodeLinks: _f$barcodeLinks,
    #meals: _f$meals,
    #mealMappings: _f$mealMappings,
    #entries: _f$entries,
    #mfpLinks: _f$mfpLinks,
    #ekkloLinks: _f$ekkloLinks,
    #goalPeriods: _f$goalPeriods,
    #format: _f$format,
    #version: _f$version,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'version';
  @override
  final dynamic discriminatorValue = BackupV5.isEntriesFile;
  @override
  late final ClassMapperBase superMapper = BackupMapper.ensureInitialized();

  static BackupV5 _instantiate(DecodingData data) {
    return BackupV5(
      exportedAt: data.dec(_f$exportedAt),
      links: data.dec(_f$links),
      foods: data.dec(_f$foods),
      foodServings: data.dec(_f$foodServings),
      foodUnits: data.dec(_f$foodUnits),
      foodReferences: data.dec(_f$foodReferences),
      barcodeLinks: data.dec(_f$barcodeLinks),
      meals: data.dec(_f$meals),
      mealMappings: data.dec(_f$mealMappings),
      entries: data.dec(_f$entries),
      mfpLinks: data.dec(_f$mfpLinks),
      ekkloLinks: data.dec(_f$ekkloLinks),
      goalPeriods: data.dec(_f$goalPeriods),
      format: data.dec(_f$format),
      version: data.dec(_f$version),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupV5 fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupV5>(map);
  }

  static BackupV5 fromJson(String json) {
    return ensureInitialized().decodeJson<BackupV5>(json);
  }
}

mixin BackupV5Mappable {
  String toJson() {
    return BackupV5Mapper.ensureInitialized().encodeJson<BackupV5>(
      this as BackupV5,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupV5Mapper.ensureInitialized().encodeMap<BackupV5>(
      this as BackupV5,
    );
  }

  BackupV5CopyWith<BackupV5, BackupV5, BackupV5> get copyWith =>
      _BackupV5CopyWithImpl<BackupV5, BackupV5>(
        this as BackupV5,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupV5Mapper.ensureInitialized().stringifyValue(this as BackupV5);
  }

  @override
  bool operator ==(Object other) {
    return BackupV5Mapper.ensureInitialized().equalsValue(
      this as BackupV5,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupV5Mapper.ensureInitialized().hashValue(this as BackupV5);
  }
}

extension BackupV5ValueCopy<$R, $Out> on ObjectCopyWith<$R, BackupV5, $Out> {
  BackupV5CopyWith<$R, BackupV5, $Out> get $asBackupV5 =>
      $base.as((v, t, t2) => _BackupV5CopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupV5CopyWith<$R, $In extends BackupV5, $Out>
    implements BackupCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links;
  ListCopyWith<$R, Food, FoodCopyWith<$R, Food, Food>> get foods;
  ListCopyWith<
    $R,
    FoodServing,
    FoodServingCopyWith<$R, FoodServing, FoodServing>
  >
  get foodServings;
  ListCopyWith<$R, FoodUnit, FoodUnitCopyWith<$R, FoodUnit, FoodUnit>>
  get foodUnits;
  ListCopyWith<
    $R,
    FoodReference,
    FoodReferenceCopyWith<$R, FoodReference, FoodReference>
  >
  get foodReferences;
  ListCopyWith<
    $R,
    FoodBarcode,
    FoodBarcodeCopyWith<$R, FoodBarcode, FoodBarcode>
  >
  get barcodeLinks;
  ListCopyWith<$R, Meal, MealCopyWith<$R, Meal, Meal>> get meals;
  ListCopyWith<
    $R,
    ConnectorMeal,
    ConnectorMealCopyWith<$R, ConnectorMeal, ConnectorMeal>
  >
  get mealMappings;
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get entries;
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>> get mfpLinks;
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get ekkloLinks;
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods;
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    List<Food>? foods,
    List<FoodServing>? foodServings,
    List<FoodUnit>? foodUnits,
    List<FoodReference>? foodReferences,
    List<FoodBarcode>? barcodeLinks,
    List<Meal>? meals,
    List<ConnectorMeal>? mealMappings,
    List<Entry>? entries,
    List<MfpLink>? mfpLinks,
    List<EkkloLink>? ekkloLinks,
    List<GoalPeriod>? goalPeriods,
    String? format,
    int? version,
  });
  BackupV5CopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupV5CopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupV5, $Out>
    implements BackupV5CopyWith<$R, BackupV5, $Out> {
  _BackupV5CopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupV5> $mapper =
      BackupV5Mapper.ensureInitialized();
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links => ListCopyWith(
    $value.links,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(links: v),
  );
  @override
  ListCopyWith<$R, Food, FoodCopyWith<$R, Food, Food>> get foods =>
      ListCopyWith(
        $value.foods,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(foods: v),
      );
  @override
  ListCopyWith<
    $R,
    FoodServing,
    FoodServingCopyWith<$R, FoodServing, FoodServing>
  >
  get foodServings => ListCopyWith(
    $value.foodServings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodServings: v),
  );
  @override
  ListCopyWith<$R, FoodUnit, FoodUnitCopyWith<$R, FoodUnit, FoodUnit>>
  get foodUnits => ListCopyWith(
    $value.foodUnits,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodUnits: v),
  );
  @override
  ListCopyWith<
    $R,
    FoodReference,
    FoodReferenceCopyWith<$R, FoodReference, FoodReference>
  >
  get foodReferences => ListCopyWith(
    $value.foodReferences,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodReferences: v),
  );
  @override
  ListCopyWith<
    $R,
    FoodBarcode,
    FoodBarcodeCopyWith<$R, FoodBarcode, FoodBarcode>
  >
  get barcodeLinks => ListCopyWith(
    $value.barcodeLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(barcodeLinks: v),
  );
  @override
  ListCopyWith<$R, Meal, MealCopyWith<$R, Meal, Meal>> get meals =>
      ListCopyWith(
        $value.meals,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(meals: v),
      );
  @override
  ListCopyWith<
    $R,
    ConnectorMeal,
    ConnectorMealCopyWith<$R, ConnectorMeal, ConnectorMeal>
  >
  get mealMappings => ListCopyWith(
    $value.mealMappings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mealMappings: v),
  );
  @override
  ListCopyWith<$R, Entry, EntryCopyWith<$R, Entry, Entry>> get entries =>
      ListCopyWith(
        $value.entries,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(entries: v),
      );
  @override
  ListCopyWith<$R, MfpLink, MfpLinkCopyWith<$R, MfpLink, MfpLink>>
  get mfpLinks => ListCopyWith(
    $value.mfpLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mfpLinks: v),
  );
  @override
  ListCopyWith<$R, EkkloLink, EkkloLinkCopyWith<$R, EkkloLink, EkkloLink>>
  get ekkloLinks => ListCopyWith(
    $value.ekkloLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ekkloLinks: v),
  );
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods => ListCopyWith(
    $value.goalPeriods,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(goalPeriods: v),
  );
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    List<Food>? foods,
    List<FoodServing>? foodServings,
    List<FoodUnit>? foodUnits,
    List<FoodReference>? foodReferences,
    List<FoodBarcode>? barcodeLinks,
    List<Meal>? meals,
    List<ConnectorMeal>? mealMappings,
    List<Entry>? entries,
    List<MfpLink>? mfpLinks,
    List<EkkloLink>? ekkloLinks,
    List<GoalPeriod>? goalPeriods,
    String? format,
    int? version,
  }) => $apply(
    FieldCopyWithData({
      if (exportedAt != null) #exportedAt: exportedAt,
      if (links != null) #links: links,
      if (foods != null) #foods: foods,
      if (foodServings != null) #foodServings: foodServings,
      if (foodUnits != null) #foodUnits: foodUnits,
      if (foodReferences != null) #foodReferences: foodReferences,
      if (barcodeLinks != null) #barcodeLinks: barcodeLinks,
      if (meals != null) #meals: meals,
      if (mealMappings != null) #mealMappings: mealMappings,
      if (entries != null) #entries: entries,
      if (mfpLinks != null) #mfpLinks: mfpLinks,
      if (ekkloLinks != null) #ekkloLinks: ekkloLinks,
      if (goalPeriods != null) #goalPeriods: goalPeriods,
      if (format != null) #format: format,
      if (version != null) #version: version,
    }),
  );
  @override
  BackupV5 $make(CopyWithData data) => BackupV5(
    exportedAt: data.get(#exportedAt, or: $value.exportedAt),
    links: data.get(#links, or: $value.links),
    foods: data.get(#foods, or: $value.foods),
    foodServings: data.get(#foodServings, or: $value.foodServings),
    foodUnits: data.get(#foodUnits, or: $value.foodUnits),
    foodReferences: data.get(#foodReferences, or: $value.foodReferences),
    barcodeLinks: data.get(#barcodeLinks, or: $value.barcodeLinks),
    meals: data.get(#meals, or: $value.meals),
    mealMappings: data.get(#mealMappings, or: $value.mealMappings),
    entries: data.get(#entries, or: $value.entries),
    mfpLinks: data.get(#mfpLinks, or: $value.mfpLinks),
    ekkloLinks: data.get(#ekkloLinks, or: $value.ekkloLinks),
    goalPeriods: data.get(#goalPeriods, or: $value.goalPeriods),
    format: data.get(#format, or: $value.format),
    version: data.get(#version, or: $value.version),
  );

  @override
  BackupV5CopyWith<$R2, BackupV5, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupV5CopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupV3Mapper extends SubClassMapperBase<BackupV3> {
  BackupV3Mapper._();

  static BackupV3Mapper? _instance;
  static BackupV3Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupV3Mapper._());
      BackupMapper.ensureInitialized().addSubMapper(_instance!);
      SentLinkMapper.ensureInitialized();
      FoodMapper.ensureInitialized();
      FoodServingMapper.ensureInitialized();
      FoodUnitMapper.ensureInitialized();
      FoodReferenceMapper.ensureInitialized();
      FoodBarcodeMapper.ensureInitialized();
      MealMapper.ensureInitialized();
      ConnectorMealMapper.ensureInitialized();
      GoalPeriodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupV3';

  static DateTime _$exportedAt(BackupV3 v) => v.exportedAt;
  static const Field<BackupV3, DateTime> _f$exportedAt = Field(
    'exportedAt',
    _$exportedAt,
    key: r'exported_at',
  );
  static List<SentLink> _$links(BackupV3 v) => v.links;
  static const Field<BackupV3, List<SentLink>> _f$links = Field(
    'links',
    _$links,
  );
  static List<Food> _$foods(BackupV3 v) => v.foods;
  static const Field<BackupV3, List<Food>> _f$foods = Field('foods', _$foods);
  static List<FoodServing> _$foodServings(BackupV3 v) => v.foodServings;
  static const Field<BackupV3, List<FoodServing>> _f$foodServings = Field(
    'foodServings',
    _$foodServings,
    key: r'food_servings',
  );
  static List<FoodUnit> _$foodUnits(BackupV3 v) => v.foodUnits;
  static const Field<BackupV3, List<FoodUnit>> _f$foodUnits = Field(
    'foodUnits',
    _$foodUnits,
    key: r'food_units',
  );
  static List<FoodReference> _$foodReferences(BackupV3 v) => v.foodReferences;
  static const Field<BackupV3, List<FoodReference>> _f$foodReferences = Field(
    'foodReferences',
    _$foodReferences,
    key: r'food_references',
  );
  static List<FoodBarcode> _$barcodeLinks(BackupV3 v) => v.barcodeLinks;
  static const Field<BackupV3, List<FoodBarcode>> _f$barcodeLinks = Field(
    'barcodeLinks',
    _$barcodeLinks,
    key: r'barcode_links',
  );
  static List<Meal> _$meals(BackupV3 v) => v.meals;
  static const Field<BackupV3, List<Meal>> _f$meals = Field('meals', _$meals);
  static List<ConnectorMeal> _$mealMappings(BackupV3 v) => v.mealMappings;
  static const Field<BackupV3, List<ConnectorMeal>> _f$mealMappings = Field(
    'mealMappings',
    _$mealMappings,
    key: r'meal_mappings',
  );
  static List<GoalPeriod> _$goalPeriods(BackupV3 v) => v.goalPeriods;
  static const Field<BackupV3, List<GoalPeriod>> _f$goalPeriods = Field(
    'goalPeriods',
    _$goalPeriods,
    key: r'goal_periods',
    opt: true,
    def: const [],
  );
  static String _$format(BackupV3 v) => v.format;
  static const Field<BackupV3, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );
  static int _$version(BackupV3 v) => v.version;
  static const Field<BackupV3, int> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: BackupV3.foodsVersion,
  );

  @override
  final MappableFields<BackupV3> fields = const {
    #exportedAt: _f$exportedAt,
    #links: _f$links,
    #foods: _f$foods,
    #foodServings: _f$foodServings,
    #foodUnits: _f$foodUnits,
    #foodReferences: _f$foodReferences,
    #barcodeLinks: _f$barcodeLinks,
    #meals: _f$meals,
    #mealMappings: _f$mealMappings,
    #goalPeriods: _f$goalPeriods,
    #format: _f$format,
    #version: _f$version,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'version';
  @override
  final dynamic discriminatorValue = BackupV3.foodsVersion;
  @override
  late final ClassMapperBase superMapper = BackupMapper.ensureInitialized();

  static BackupV3 _instantiate(DecodingData data) {
    return BackupV3(
      exportedAt: data.dec(_f$exportedAt),
      links: data.dec(_f$links),
      foods: data.dec(_f$foods),
      foodServings: data.dec(_f$foodServings),
      foodUnits: data.dec(_f$foodUnits),
      foodReferences: data.dec(_f$foodReferences),
      barcodeLinks: data.dec(_f$barcodeLinks),
      meals: data.dec(_f$meals),
      mealMappings: data.dec(_f$mealMappings),
      goalPeriods: data.dec(_f$goalPeriods),
      format: data.dec(_f$format),
      version: data.dec(_f$version),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupV3 fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupV3>(map);
  }

  static BackupV3 fromJson(String json) {
    return ensureInitialized().decodeJson<BackupV3>(json);
  }
}

mixin BackupV3Mappable {
  String toJson() {
    return BackupV3Mapper.ensureInitialized().encodeJson<BackupV3>(
      this as BackupV3,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupV3Mapper.ensureInitialized().encodeMap<BackupV3>(
      this as BackupV3,
    );
  }

  BackupV3CopyWith<BackupV3, BackupV3, BackupV3> get copyWith =>
      _BackupV3CopyWithImpl<BackupV3, BackupV3>(
        this as BackupV3,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupV3Mapper.ensureInitialized().stringifyValue(this as BackupV3);
  }

  @override
  bool operator ==(Object other) {
    return BackupV3Mapper.ensureInitialized().equalsValue(
      this as BackupV3,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupV3Mapper.ensureInitialized().hashValue(this as BackupV3);
  }
}

extension BackupV3ValueCopy<$R, $Out> on ObjectCopyWith<$R, BackupV3, $Out> {
  BackupV3CopyWith<$R, BackupV3, $Out> get $asBackupV3 =>
      $base.as((v, t, t2) => _BackupV3CopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupV3CopyWith<$R, $In extends BackupV3, $Out>
    implements BackupCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links;
  ListCopyWith<$R, Food, FoodCopyWith<$R, Food, Food>> get foods;
  ListCopyWith<
    $R,
    FoodServing,
    FoodServingCopyWith<$R, FoodServing, FoodServing>
  >
  get foodServings;
  ListCopyWith<$R, FoodUnit, FoodUnitCopyWith<$R, FoodUnit, FoodUnit>>
  get foodUnits;
  ListCopyWith<
    $R,
    FoodReference,
    FoodReferenceCopyWith<$R, FoodReference, FoodReference>
  >
  get foodReferences;
  ListCopyWith<
    $R,
    FoodBarcode,
    FoodBarcodeCopyWith<$R, FoodBarcode, FoodBarcode>
  >
  get barcodeLinks;
  ListCopyWith<$R, Meal, MealCopyWith<$R, Meal, Meal>> get meals;
  ListCopyWith<
    $R,
    ConnectorMeal,
    ConnectorMealCopyWith<$R, ConnectorMeal, ConnectorMeal>
  >
  get mealMappings;
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods;
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    List<Food>? foods,
    List<FoodServing>? foodServings,
    List<FoodUnit>? foodUnits,
    List<FoodReference>? foodReferences,
    List<FoodBarcode>? barcodeLinks,
    List<Meal>? meals,
    List<ConnectorMeal>? mealMappings,
    List<GoalPeriod>? goalPeriods,
    String? format,
    int? version,
  });
  BackupV3CopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupV3CopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupV3, $Out>
    implements BackupV3CopyWith<$R, BackupV3, $Out> {
  _BackupV3CopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupV3> $mapper =
      BackupV3Mapper.ensureInitialized();
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links => ListCopyWith(
    $value.links,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(links: v),
  );
  @override
  ListCopyWith<$R, Food, FoodCopyWith<$R, Food, Food>> get foods =>
      ListCopyWith(
        $value.foods,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(foods: v),
      );
  @override
  ListCopyWith<
    $R,
    FoodServing,
    FoodServingCopyWith<$R, FoodServing, FoodServing>
  >
  get foodServings => ListCopyWith(
    $value.foodServings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodServings: v),
  );
  @override
  ListCopyWith<$R, FoodUnit, FoodUnitCopyWith<$R, FoodUnit, FoodUnit>>
  get foodUnits => ListCopyWith(
    $value.foodUnits,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodUnits: v),
  );
  @override
  ListCopyWith<
    $R,
    FoodReference,
    FoodReferenceCopyWith<$R, FoodReference, FoodReference>
  >
  get foodReferences => ListCopyWith(
    $value.foodReferences,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(foodReferences: v),
  );
  @override
  ListCopyWith<
    $R,
    FoodBarcode,
    FoodBarcodeCopyWith<$R, FoodBarcode, FoodBarcode>
  >
  get barcodeLinks => ListCopyWith(
    $value.barcodeLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(barcodeLinks: v),
  );
  @override
  ListCopyWith<$R, Meal, MealCopyWith<$R, Meal, Meal>> get meals =>
      ListCopyWith(
        $value.meals,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(meals: v),
      );
  @override
  ListCopyWith<
    $R,
    ConnectorMeal,
    ConnectorMealCopyWith<$R, ConnectorMeal, ConnectorMeal>
  >
  get mealMappings => ListCopyWith(
    $value.mealMappings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mealMappings: v),
  );
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods => ListCopyWith(
    $value.goalPeriods,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(goalPeriods: v),
  );
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    List<Food>? foods,
    List<FoodServing>? foodServings,
    List<FoodUnit>? foodUnits,
    List<FoodReference>? foodReferences,
    List<FoodBarcode>? barcodeLinks,
    List<Meal>? meals,
    List<ConnectorMeal>? mealMappings,
    List<GoalPeriod>? goalPeriods,
    String? format,
    int? version,
  }) => $apply(
    FieldCopyWithData({
      if (exportedAt != null) #exportedAt: exportedAt,
      if (links != null) #links: links,
      if (foods != null) #foods: foods,
      if (foodServings != null) #foodServings: foodServings,
      if (foodUnits != null) #foodUnits: foodUnits,
      if (foodReferences != null) #foodReferences: foodReferences,
      if (barcodeLinks != null) #barcodeLinks: barcodeLinks,
      if (meals != null) #meals: meals,
      if (mealMappings != null) #mealMappings: mealMappings,
      if (goalPeriods != null) #goalPeriods: goalPeriods,
      if (format != null) #format: format,
      if (version != null) #version: version,
    }),
  );
  @override
  BackupV3 $make(CopyWithData data) => BackupV3(
    exportedAt: data.get(#exportedAt, or: $value.exportedAt),
    links: data.get(#links, or: $value.links),
    foods: data.get(#foods, or: $value.foods),
    foodServings: data.get(#foodServings, or: $value.foodServings),
    foodUnits: data.get(#foodUnits, or: $value.foodUnits),
    foodReferences: data.get(#foodReferences, or: $value.foodReferences),
    barcodeLinks: data.get(#barcodeLinks, or: $value.barcodeLinks),
    meals: data.get(#meals, or: $value.meals),
    mealMappings: data.get(#mealMappings, or: $value.mealMappings),
    goalPeriods: data.get(#goalPeriods, or: $value.goalPeriods),
    format: data.get(#format, or: $value.format),
    version: data.get(#version, or: $value.version),
  );

  @override
  BackupV3CopyWith<$R2, BackupV3, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupV3CopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BackupV2Mapper extends SubClassMapperBase<BackupV2> {
  BackupV2Mapper._();

  static BackupV2Mapper? _instance;
  static BackupV2Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupV2Mapper._());
      BackupMapper.ensureInitialized().addSubMapper(_instance!);
      SentLinkMapper.ensureInitialized();
      MatchedFoodMapper.ensureInitialized();
      OwnCopyMapper.ensureInitialized();
      RememberedUnitMapper.ensureInitialized();
      MealMappingMapper.ensureInitialized();
      BarcodeLinkMapper.ensureInitialized();
      GoalPeriodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupV2';

  static DateTime _$exportedAt(BackupV2 v) => v.exportedAt;
  static const Field<BackupV2, DateTime> _f$exportedAt = Field(
    'exportedAt',
    _$exportedAt,
    key: r'exported_at',
  );
  static List<SentLink> _$links(BackupV2 v) => v.links;
  static const Field<BackupV2, List<SentLink>> _f$links = Field(
    'links',
    _$links,
  );
  static int _$version(BackupV2 v) => v.version;
  static const Field<BackupV2, int> _f$version = Field('version', _$version);
  static List<MatchedFood> _$matches(BackupV2 v) => v.matches;
  static const Field<BackupV2, List<MatchedFood>> _f$matches = Field(
    'matches',
    _$matches,
  );
  static List<OwnCopy> _$ownCopies(BackupV2 v) => v.ownCopies;
  static const Field<BackupV2, List<OwnCopy>> _f$ownCopies = Field(
    'ownCopies',
    _$ownCopies,
    key: r'own_copies',
  );
  static List<RememberedUnit> _$units(BackupV2 v) => v.units;
  static const Field<BackupV2, List<RememberedUnit>> _f$units = Field(
    'units',
    _$units,
  );
  static List<MealMapping> _$meals(BackupV2 v) => v.meals;
  static const Field<BackupV2, List<MealMapping>> _f$meals = Field(
    'meals',
    _$meals,
  );
  static List<BarcodeLink> _$barcodeLinks(BackupV2 v) => v.barcodeLinks;
  static const Field<BackupV2, List<BarcodeLink>> _f$barcodeLinks = Field(
    'barcodeLinks',
    _$barcodeLinks,
    key: r'barcode_links',
  );
  static List<GoalPeriod> _$goalPeriods(BackupV2 v) => v.goalPeriods;
  static const Field<BackupV2, List<GoalPeriod>> _f$goalPeriods = Field(
    'goalPeriods',
    _$goalPeriods,
    key: r'goal_periods',
    opt: true,
    def: const [],
  );
  static String _$format(BackupV2 v) => v.format;
  static const Field<BackupV2, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );

  @override
  final MappableFields<BackupV2> fields = const {
    #exportedAt: _f$exportedAt,
    #links: _f$links,
    #version: _f$version,
    #matches: _f$matches,
    #ownCopies: _f$ownCopies,
    #units: _f$units,
    #meals: _f$meals,
    #barcodeLinks: _f$barcodeLinks,
    #goalPeriods: _f$goalPeriods,
    #format: _f$format,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'version';
  @override
  final dynamic discriminatorValue = BackupV2.isMemoryFile;
  @override
  late final ClassMapperBase superMapper = BackupMapper.ensureInitialized();

  static BackupV2 _instantiate(DecodingData data) {
    return BackupV2(
      exportedAt: data.dec(_f$exportedAt),
      links: data.dec(_f$links),
      version: data.dec(_f$version),
      matches: data.dec(_f$matches),
      ownCopies: data.dec(_f$ownCopies),
      units: data.dec(_f$units),
      meals: data.dec(_f$meals),
      barcodeLinks: data.dec(_f$barcodeLinks),
      goalPeriods: data.dec(_f$goalPeriods),
      format: data.dec(_f$format),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupV2 fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupV2>(map);
  }

  static BackupV2 fromJson(String json) {
    return ensureInitialized().decodeJson<BackupV2>(json);
  }
}

mixin BackupV2Mappable {
  String toJson() {
    return BackupV2Mapper.ensureInitialized().encodeJson<BackupV2>(
      this as BackupV2,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupV2Mapper.ensureInitialized().encodeMap<BackupV2>(
      this as BackupV2,
    );
  }

  BackupV2CopyWith<BackupV2, BackupV2, BackupV2> get copyWith =>
      _BackupV2CopyWithImpl<BackupV2, BackupV2>(
        this as BackupV2,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupV2Mapper.ensureInitialized().stringifyValue(this as BackupV2);
  }

  @override
  bool operator ==(Object other) {
    return BackupV2Mapper.ensureInitialized().equalsValue(
      this as BackupV2,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupV2Mapper.ensureInitialized().hashValue(this as BackupV2);
  }
}

extension BackupV2ValueCopy<$R, $Out> on ObjectCopyWith<$R, BackupV2, $Out> {
  BackupV2CopyWith<$R, BackupV2, $Out> get $asBackupV2 =>
      $base.as((v, t, t2) => _BackupV2CopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupV2CopyWith<$R, $In extends BackupV2, $Out>
    implements BackupCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links;
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
  ListCopyWith<
    $R,
    BarcodeLink,
    BarcodeLinkCopyWith<$R, BarcodeLink, BarcodeLink>
  >
  get barcodeLinks;
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods;
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    int? version,
    List<MatchedFood>? matches,
    List<OwnCopy>? ownCopies,
    List<RememberedUnit>? units,
    List<MealMapping>? meals,
    List<BarcodeLink>? barcodeLinks,
    List<GoalPeriod>? goalPeriods,
    String? format,
  });
  BackupV2CopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupV2CopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupV2, $Out>
    implements BackupV2CopyWith<$R, BackupV2, $Out> {
  _BackupV2CopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupV2> $mapper =
      BackupV2Mapper.ensureInitialized();
  @override
  ListCopyWith<$R, SentLink, SentLinkCopyWith<$R, SentLink, SentLink>>
  get links => ListCopyWith(
    $value.links,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(links: v),
  );
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
  ListCopyWith<
    $R,
    BarcodeLink,
    BarcodeLinkCopyWith<$R, BarcodeLink, BarcodeLink>
  >
  get barcodeLinks => ListCopyWith(
    $value.barcodeLinks,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(barcodeLinks: v),
  );
  @override
  ListCopyWith<$R, GoalPeriod, GoalPeriodCopyWith<$R, GoalPeriod, GoalPeriod>>
  get goalPeriods => ListCopyWith(
    $value.goalPeriods,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(goalPeriods: v),
  );
  @override
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    int? version,
    List<MatchedFood>? matches,
    List<OwnCopy>? ownCopies,
    List<RememberedUnit>? units,
    List<MealMapping>? meals,
    List<BarcodeLink>? barcodeLinks,
    List<GoalPeriod>? goalPeriods,
    String? format,
  }) => $apply(
    FieldCopyWithData({
      if (exportedAt != null) #exportedAt: exportedAt,
      if (links != null) #links: links,
      if (version != null) #version: version,
      if (matches != null) #matches: matches,
      if (ownCopies != null) #ownCopies: ownCopies,
      if (units != null) #units: units,
      if (meals != null) #meals: meals,
      if (barcodeLinks != null) #barcodeLinks: barcodeLinks,
      if (goalPeriods != null) #goalPeriods: goalPeriods,
      if (format != null) #format: format,
    }),
  );
  @override
  BackupV2 $make(CopyWithData data) => BackupV2(
    exportedAt: data.get(#exportedAt, or: $value.exportedAt),
    links: data.get(#links, or: $value.links),
    version: data.get(#version, or: $value.version),
    matches: data.get(#matches, or: $value.matches),
    ownCopies: data.get(#ownCopies, or: $value.ownCopies),
    units: data.get(#units, or: $value.units),
    meals: data.get(#meals, or: $value.meals),
    barcodeLinks: data.get(#barcodeLinks, or: $value.barcodeLinks),
    goalPeriods: data.get(#goalPeriods, or: $value.goalPeriods),
    format: data.get(#format, or: $value.format),
  );

  @override
  BackupV2CopyWith<$R2, BackupV2, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupV2CopyWithImpl<$R2, $Out2>($value, $cast, t);
}

