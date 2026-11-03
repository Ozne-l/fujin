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
      BackupV4Mapper.ensureInitialized();
      BackupV3Mapper.ensureInitialized();
      BackupV2Mapper.ensureInitialized();
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
  static List<SentLink> _$links(Backup v) => v.links;
  static const Field<Backup, List<SentLink>> _f$links = Field('links', _$links);
  static int _$version(Backup v) => v.version;
  static const Field<Backup, int> _f$version = Field('version', _$version);
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

  @override
  final MappableFields<Backup> fields = const {
    #exportedAt: _f$exportedAt,
    #links: _f$links,
    #version: _f$version,
    #goals: _f$goals,
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
  GoalsCopyWith<$R, Goals, Goals>? get goals;
  $R call({
    DateTime? exportedAt,
    List<SentLink>? links,
    int? version,
    Goals? goals,
    String? format,
  });
  BackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class BackupV4Mapper extends SubClassMapperBase<BackupV4> {
  BackupV4Mapper._();

  static BackupV4Mapper? _instance;
  static BackupV4Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupV4Mapper._());
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
      GoalsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupV4';

  static DateTime _$exportedAt(BackupV4 v) => v.exportedAt;
  static const Field<BackupV4, DateTime> _f$exportedAt = Field(
    'exportedAt',
    _$exportedAt,
    key: r'exported_at',
  );
  static List<SentLink> _$links(BackupV4 v) => v.links;
  static const Field<BackupV4, List<SentLink>> _f$links = Field(
    'links',
    _$links,
  );
  static List<Food> _$foods(BackupV4 v) => v.foods;
  static const Field<BackupV4, List<Food>> _f$foods = Field('foods', _$foods);
  static List<FoodServing> _$foodServings(BackupV4 v) => v.foodServings;
  static const Field<BackupV4, List<FoodServing>> _f$foodServings = Field(
    'foodServings',
    _$foodServings,
    key: r'food_servings',
  );
  static List<FoodUnit> _$foodUnits(BackupV4 v) => v.foodUnits;
  static const Field<BackupV4, List<FoodUnit>> _f$foodUnits = Field(
    'foodUnits',
    _$foodUnits,
    key: r'food_units',
  );
  static List<FoodReference> _$foodReferences(BackupV4 v) => v.foodReferences;
  static const Field<BackupV4, List<FoodReference>> _f$foodReferences = Field(
    'foodReferences',
    _$foodReferences,
    key: r'food_references',
  );
  static List<FoodBarcode> _$barcodeLinks(BackupV4 v) => v.barcodeLinks;
  static const Field<BackupV4, List<FoodBarcode>> _f$barcodeLinks = Field(
    'barcodeLinks',
    _$barcodeLinks,
    key: r'barcode_links',
  );
  static List<Meal> _$meals(BackupV4 v) => v.meals;
  static const Field<BackupV4, List<Meal>> _f$meals = Field('meals', _$meals);
  static List<ConnectorMeal> _$mealMappings(BackupV4 v) => v.mealMappings;
  static const Field<BackupV4, List<ConnectorMeal>> _f$mealMappings = Field(
    'mealMappings',
    _$mealMappings,
    key: r'meal_mappings',
  );
  static List<Entry> _$entries(BackupV4 v) => v.entries;
  static const Field<BackupV4, List<Entry>> _f$entries = Field(
    'entries',
    _$entries,
  );
  static List<MfpLink> _$mfpLinks(BackupV4 v) => v.mfpLinks;
  static const Field<BackupV4, List<MfpLink>> _f$mfpLinks = Field(
    'mfpLinks',
    _$mfpLinks,
    key: r'mfp_links',
  );
  static List<EkkloLink> _$ekkloLinks(BackupV4 v) => v.ekkloLinks;
  static const Field<BackupV4, List<EkkloLink>> _f$ekkloLinks = Field(
    'ekkloLinks',
    _$ekkloLinks,
    key: r'ekklo_links',
  );
  static Goals? _$goals(BackupV4 v) => v.goals;
  static const Field<BackupV4, Goals> _f$goals = Field(
    'goals',
    _$goals,
    opt: true,
  );
  static String _$format(BackupV4 v) => v.format;
  static const Field<BackupV4, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: Backup.formatName,
  );
  static int _$version(BackupV4 v) => v.version;
  static const Field<BackupV4, int> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: BackupV4.currentVersion,
  );

  @override
  final MappableFields<BackupV4> fields = const {
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
    #goals: _f$goals,
    #format: _f$format,
    #version: _f$version,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'version';
  @override
  final dynamic discriminatorValue = BackupV4.currentVersion;
  @override
  late final ClassMapperBase superMapper = BackupMapper.ensureInitialized();

  static BackupV4 _instantiate(DecodingData data) {
    return BackupV4(
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
      goals: data.dec(_f$goals),
      format: data.dec(_f$format),
      version: data.dec(_f$version),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupV4 fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupV4>(map);
  }

  static BackupV4 fromJson(String json) {
    return ensureInitialized().decodeJson<BackupV4>(json);
  }
}

mixin BackupV4Mappable {
  String toJson() {
    return BackupV4Mapper.ensureInitialized().encodeJson<BackupV4>(
      this as BackupV4,
    );
  }

  Map<String, dynamic> toMap() {
    return BackupV4Mapper.ensureInitialized().encodeMap<BackupV4>(
      this as BackupV4,
    );
  }

  BackupV4CopyWith<BackupV4, BackupV4, BackupV4> get copyWith =>
      _BackupV4CopyWithImpl<BackupV4, BackupV4>(
        this as BackupV4,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BackupV4Mapper.ensureInitialized().stringifyValue(this as BackupV4);
  }

  @override
  bool operator ==(Object other) {
    return BackupV4Mapper.ensureInitialized().equalsValue(
      this as BackupV4,
      other,
    );
  }

  @override
  int get hashCode {
    return BackupV4Mapper.ensureInitialized().hashValue(this as BackupV4);
  }
}

extension BackupV4ValueCopy<$R, $Out> on ObjectCopyWith<$R, BackupV4, $Out> {
  BackupV4CopyWith<$R, BackupV4, $Out> get $asBackupV4 =>
      $base.as((v, t, t2) => _BackupV4CopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BackupV4CopyWith<$R, $In extends BackupV4, $Out>
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
  GoalsCopyWith<$R, Goals, Goals>? get goals;
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
    Goals? goals,
    String? format,
    int? version,
  });
  BackupV4CopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BackupV4CopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BackupV4, $Out>
    implements BackupV4CopyWith<$R, BackupV4, $Out> {
  _BackupV4CopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BackupV4> $mapper =
      BackupV4Mapper.ensureInitialized();
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
  GoalsCopyWith<$R, Goals, Goals>? get goals =>
      $value.goals?.copyWith.$chain((v) => call(goals: v));
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
    Object? goals = $none,
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
      if (goals != $none) #goals: goals,
      if (format != null) #format: format,
      if (version != null) #version: version,
    }),
  );
  @override
  BackupV4 $make(CopyWithData data) => BackupV4(
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
    goals: data.get(#goals, or: $value.goals),
    format: data.get(#format, or: $value.format),
    version: data.get(#version, or: $value.version),
  );

  @override
  BackupV4CopyWith<$R2, BackupV4, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupV4CopyWithImpl<$R2, $Out2>($value, $cast, t);
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
      GoalsMapper.ensureInitialized();
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
  static Goals? _$goals(BackupV3 v) => v.goals;
  static const Field<BackupV3, Goals> _f$goals = Field(
    'goals',
    _$goals,
    opt: true,
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
    #goals: _f$goals,
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
      goals: data.dec(_f$goals),
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
  GoalsCopyWith<$R, Goals, Goals>? get goals;
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
    Goals? goals,
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
  GoalsCopyWith<$R, Goals, Goals>? get goals =>
      $value.goals?.copyWith.$chain((v) => call(goals: v));
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
    Object? goals = $none,
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
      if (goals != $none) #goals: goals,
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
    goals: data.get(#goals, or: $value.goals),
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
      GoalsMapper.ensureInitialized();
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
  static Goals? _$goals(BackupV2 v) => v.goals;
  static const Field<BackupV2, Goals> _f$goals = Field(
    'goals',
    _$goals,
    opt: true,
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
    #goals: _f$goals,
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
      goals: data.dec(_f$goals),
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
  GoalsCopyWith<$R, Goals, Goals>? get goals;
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
    Goals? goals,
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
  GoalsCopyWith<$R, Goals, Goals>? get goals =>
      $value.goals?.copyWith.$chain((v) => call(goals: v));
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
    Object? goals = $none,
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
      if (goals != $none) #goals: goals,
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
    goals: data.get(#goals, or: $value.goals),
    format: data.get(#format, or: $value.format),
  );

  @override
  BackupV2CopyWith<$R2, BackupV2, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BackupV2CopyWithImpl<$R2, $Out2>($value, $cast, t);
}

