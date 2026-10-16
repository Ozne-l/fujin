// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'add_search_state.dart';

class AddSearchStateMapper extends ClassMapperBase<AddSearchState> {
  AddSearchStateMapper._();

  static AddSearchStateMapper? _instance;
  static AddSearchStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddSearchStateMapper._());
      AddSearchIdleMapper.ensureInitialized();
      AddSearchRunningMapper.ensureInitialized();
      AddSearchResultsMapper.ensureInitialized();
      AddBarcodeMissingMapper.ensureInitialized();
      AddSearchFailedMapper.ensureInitialized();
      RecentFoodMapper.ensureInitialized();
      RememberedFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddSearchState';

  static String _$query(AddSearchState v) => v.query;
  static const Field<AddSearchState, String> _f$query = Field('query', _$query);
  static bool _$verifiedOnly(AddSearchState v) => v.verifiedOnly;
  static const Field<AddSearchState, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    key: r'verified_only',
  );
  static List<RecentFood> _$recents(AddSearchState v) => v.recents;
  static const Field<AddSearchState, List<RecentFood>> _f$recents = Field(
    'recents',
    _$recents,
  );
  static List<RememberedFood> _$remembered(AddSearchState v) => v.remembered;
  static const Field<AddSearchState, List<RememberedFood>> _f$remembered =
      Field('remembered', _$remembered);

  @override
  final MappableFields<AddSearchState> fields = const {
    #query: _f$query,
    #verifiedOnly: _f$verifiedOnly,
    #recents: _f$recents,
    #remembered: _f$remembered,
  };
  @override
  final bool ignoreNull = true;

  static AddSearchState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'AddSearchState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddSearchState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddSearchState>(map);
  }

  static AddSearchState fromJson(String json) {
    return ensureInitialized().decodeJson<AddSearchState>(json);
  }
}

mixin AddSearchStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  AddSearchStateCopyWith<AddSearchState, AddSearchState, AddSearchState>
  get copyWith;
}

abstract class AddSearchStateCopyWith<$R, $In extends AddSearchState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents;
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered;
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
  });
  AddSearchStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class AddSearchIdleMapper extends SubClassMapperBase<AddSearchIdle> {
  AddSearchIdleMapper._();

  static AddSearchIdleMapper? _instance;
  static AddSearchIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddSearchIdleMapper._());
      AddSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      RecentFoodMapper.ensureInitialized();
      RememberedFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddSearchIdle';

  static String _$query(AddSearchIdle v) => v.query;
  static const Field<AddSearchIdle, String> _f$query = Field('query', _$query);
  static bool _$verifiedOnly(AddSearchIdle v) => v.verifiedOnly;
  static const Field<AddSearchIdle, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    key: r'verified_only',
  );
  static List<RecentFood> _$recents(AddSearchIdle v) => v.recents;
  static const Field<AddSearchIdle, List<RecentFood>> _f$recents = Field(
    'recents',
    _$recents,
  );
  static List<RememberedFood> _$remembered(AddSearchIdle v) => v.remembered;
  static const Field<AddSearchIdle, List<RememberedFood>> _f$remembered = Field(
    'remembered',
    _$remembered,
  );

  @override
  final MappableFields<AddSearchIdle> fields = const {
    #query: _f$query,
    #verifiedOnly: _f$verifiedOnly,
    #recents: _f$recents,
    #remembered: _f$remembered,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      AddSearchStateMapper.ensureInitialized();

  static AddSearchIdle _instantiate(DecodingData data) {
    return AddSearchIdle(
      query: data.dec(_f$query),
      verifiedOnly: data.dec(_f$verifiedOnly),
      recents: data.dec(_f$recents),
      remembered: data.dec(_f$remembered),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddSearchIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddSearchIdle>(map);
  }

  static AddSearchIdle fromJson(String json) {
    return ensureInitialized().decodeJson<AddSearchIdle>(json);
  }
}

mixin AddSearchIdleMappable {
  String toJson() {
    return AddSearchIdleMapper.ensureInitialized().encodeJson<AddSearchIdle>(
      this as AddSearchIdle,
    );
  }

  Map<String, dynamic> toMap() {
    return AddSearchIdleMapper.ensureInitialized().encodeMap<AddSearchIdle>(
      this as AddSearchIdle,
    );
  }

  AddSearchIdleCopyWith<AddSearchIdle, AddSearchIdle, AddSearchIdle>
  get copyWith => _AddSearchIdleCopyWithImpl<AddSearchIdle, AddSearchIdle>(
    this as AddSearchIdle,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return AddSearchIdleMapper.ensureInitialized().stringifyValue(
      this as AddSearchIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddSearchIdleMapper.ensureInitialized().equalsValue(
      this as AddSearchIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return AddSearchIdleMapper.ensureInitialized().hashValue(
      this as AddSearchIdle,
    );
  }
}

extension AddSearchIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddSearchIdle, $Out> {
  AddSearchIdleCopyWith<$R, AddSearchIdle, $Out> get $asAddSearchIdle =>
      $base.as((v, t, t2) => _AddSearchIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddSearchIdleCopyWith<$R, $In extends AddSearchIdle, $Out>
    implements AddSearchStateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents;
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered;
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
  });
  AddSearchIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddSearchIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddSearchIdle, $Out>
    implements AddSearchIdleCopyWith<$R, AddSearchIdle, $Out> {
  _AddSearchIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddSearchIdle> $mapper =
      AddSearchIdleMapper.ensureInitialized();
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents => ListCopyWith(
    $value.recents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(recents: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered => ListCopyWith(
    $value.remembered,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(remembered: v),
  );
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
  }) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (verifiedOnly != null) #verifiedOnly: verifiedOnly,
      if (recents != null) #recents: recents,
      if (remembered != null) #remembered: remembered,
    }),
  );
  @override
  AddSearchIdle $make(CopyWithData data) => AddSearchIdle(
    query: data.get(#query, or: $value.query),
    verifiedOnly: data.get(#verifiedOnly, or: $value.verifiedOnly),
    recents: data.get(#recents, or: $value.recents),
    remembered: data.get(#remembered, or: $value.remembered),
  );

  @override
  AddSearchIdleCopyWith<$R2, AddSearchIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddSearchIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddSearchRunningMapper extends SubClassMapperBase<AddSearchRunning> {
  AddSearchRunningMapper._();

  static AddSearchRunningMapper? _instance;
  static AddSearchRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddSearchRunningMapper._());
      AddSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      RecentFoodMapper.ensureInitialized();
      RememberedFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddSearchRunning';

  static String _$query(AddSearchRunning v) => v.query;
  static const Field<AddSearchRunning, String> _f$query = Field(
    'query',
    _$query,
  );
  static bool _$verifiedOnly(AddSearchRunning v) => v.verifiedOnly;
  static const Field<AddSearchRunning, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    key: r'verified_only',
  );
  static List<RecentFood> _$recents(AddSearchRunning v) => v.recents;
  static const Field<AddSearchRunning, List<RecentFood>> _f$recents = Field(
    'recents',
    _$recents,
  );
  static List<RememberedFood> _$remembered(AddSearchRunning v) => v.remembered;
  static const Field<AddSearchRunning, List<RememberedFood>> _f$remembered =
      Field('remembered', _$remembered);

  @override
  final MappableFields<AddSearchRunning> fields = const {
    #query: _f$query,
    #verifiedOnly: _f$verifiedOnly,
    #recents: _f$recents,
    #remembered: _f$remembered,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      AddSearchStateMapper.ensureInitialized();

  static AddSearchRunning _instantiate(DecodingData data) {
    return AddSearchRunning(
      query: data.dec(_f$query),
      verifiedOnly: data.dec(_f$verifiedOnly),
      recents: data.dec(_f$recents),
      remembered: data.dec(_f$remembered),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddSearchRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddSearchRunning>(map);
  }

  static AddSearchRunning fromJson(String json) {
    return ensureInitialized().decodeJson<AddSearchRunning>(json);
  }
}

mixin AddSearchRunningMappable {
  String toJson() {
    return AddSearchRunningMapper.ensureInitialized()
        .encodeJson<AddSearchRunning>(this as AddSearchRunning);
  }

  Map<String, dynamic> toMap() {
    return AddSearchRunningMapper.ensureInitialized()
        .encodeMap<AddSearchRunning>(this as AddSearchRunning);
  }

  AddSearchRunningCopyWith<AddSearchRunning, AddSearchRunning, AddSearchRunning>
  get copyWith =>
      _AddSearchRunningCopyWithImpl<AddSearchRunning, AddSearchRunning>(
        this as AddSearchRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddSearchRunningMapper.ensureInitialized().stringifyValue(
      this as AddSearchRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddSearchRunningMapper.ensureInitialized().equalsValue(
      this as AddSearchRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return AddSearchRunningMapper.ensureInitialized().hashValue(
      this as AddSearchRunning,
    );
  }
}

extension AddSearchRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddSearchRunning, $Out> {
  AddSearchRunningCopyWith<$R, AddSearchRunning, $Out>
  get $asAddSearchRunning =>
      $base.as((v, t, t2) => _AddSearchRunningCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddSearchRunningCopyWith<$R, $In extends AddSearchRunning, $Out>
    implements AddSearchStateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents;
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered;
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
  });
  AddSearchRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddSearchRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddSearchRunning, $Out>
    implements AddSearchRunningCopyWith<$R, AddSearchRunning, $Out> {
  _AddSearchRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddSearchRunning> $mapper =
      AddSearchRunningMapper.ensureInitialized();
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents => ListCopyWith(
    $value.recents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(recents: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered => ListCopyWith(
    $value.remembered,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(remembered: v),
  );
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
  }) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (verifiedOnly != null) #verifiedOnly: verifiedOnly,
      if (recents != null) #recents: recents,
      if (remembered != null) #remembered: remembered,
    }),
  );
  @override
  AddSearchRunning $make(CopyWithData data) => AddSearchRunning(
    query: data.get(#query, or: $value.query),
    verifiedOnly: data.get(#verifiedOnly, or: $value.verifiedOnly),
    recents: data.get(#recents, or: $value.recents),
    remembered: data.get(#remembered, or: $value.remembered),
  );

  @override
  AddSearchRunningCopyWith<$R2, AddSearchRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddSearchRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddSearchResultsMapper extends SubClassMapperBase<AddSearchResults> {
  AddSearchResultsMapper._();

  static AddSearchResultsMapper? _instance;
  static AddSearchResultsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddSearchResultsMapper._());
      AddSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      RecentFoodMapper.ensureInitialized();
      RememberedFoodMapper.ensureInitialized();
      MfpFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddSearchResults';

  static String _$query(AddSearchResults v) => v.query;
  static const Field<AddSearchResults, String> _f$query = Field(
    'query',
    _$query,
  );
  static bool _$verifiedOnly(AddSearchResults v) => v.verifiedOnly;
  static const Field<AddSearchResults, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    key: r'verified_only',
  );
  static List<RecentFood> _$recents(AddSearchResults v) => v.recents;
  static const Field<AddSearchResults, List<RecentFood>> _f$recents = Field(
    'recents',
    _$recents,
  );
  static List<RememberedFood> _$remembered(AddSearchResults v) => v.remembered;
  static const Field<AddSearchResults, List<RememberedFood>> _f$remembered =
      Field('remembered', _$remembered);
  static List<MfpFood> _$foods(AddSearchResults v) => v.foods;
  static const Field<AddSearchResults, List<MfpFood>> _f$foods = Field(
    'foods',
    _$foods,
  );

  @override
  final MappableFields<AddSearchResults> fields = const {
    #query: _f$query,
    #verifiedOnly: _f$verifiedOnly,
    #recents: _f$recents,
    #remembered: _f$remembered,
    #foods: _f$foods,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'results';
  @override
  late final ClassMapperBase superMapper =
      AddSearchStateMapper.ensureInitialized();

  static AddSearchResults _instantiate(DecodingData data) {
    return AddSearchResults(
      query: data.dec(_f$query),
      verifiedOnly: data.dec(_f$verifiedOnly),
      recents: data.dec(_f$recents),
      remembered: data.dec(_f$remembered),
      foods: data.dec(_f$foods),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddSearchResults fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddSearchResults>(map);
  }

  static AddSearchResults fromJson(String json) {
    return ensureInitialized().decodeJson<AddSearchResults>(json);
  }
}

mixin AddSearchResultsMappable {
  String toJson() {
    return AddSearchResultsMapper.ensureInitialized()
        .encodeJson<AddSearchResults>(this as AddSearchResults);
  }

  Map<String, dynamic> toMap() {
    return AddSearchResultsMapper.ensureInitialized()
        .encodeMap<AddSearchResults>(this as AddSearchResults);
  }

  AddSearchResultsCopyWith<AddSearchResults, AddSearchResults, AddSearchResults>
  get copyWith =>
      _AddSearchResultsCopyWithImpl<AddSearchResults, AddSearchResults>(
        this as AddSearchResults,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddSearchResultsMapper.ensureInitialized().stringifyValue(
      this as AddSearchResults,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddSearchResultsMapper.ensureInitialized().equalsValue(
      this as AddSearchResults,
      other,
    );
  }

  @override
  int get hashCode {
    return AddSearchResultsMapper.ensureInitialized().hashValue(
      this as AddSearchResults,
    );
  }
}

extension AddSearchResultsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddSearchResults, $Out> {
  AddSearchResultsCopyWith<$R, AddSearchResults, $Out>
  get $asAddSearchResults =>
      $base.as((v, t, t2) => _AddSearchResultsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddSearchResultsCopyWith<$R, $In extends AddSearchResults, $Out>
    implements AddSearchStateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents;
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered;
  ListCopyWith<$R, MfpFood, MfpFoodCopyWith<$R, MfpFood, MfpFood>> get foods;
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
    List<MfpFood>? foods,
  });
  AddSearchResultsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddSearchResultsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddSearchResults, $Out>
    implements AddSearchResultsCopyWith<$R, AddSearchResults, $Out> {
  _AddSearchResultsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddSearchResults> $mapper =
      AddSearchResultsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents => ListCopyWith(
    $value.recents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(recents: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered => ListCopyWith(
    $value.remembered,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(remembered: v),
  );
  @override
  ListCopyWith<$R, MfpFood, MfpFoodCopyWith<$R, MfpFood, MfpFood>> get foods =>
      ListCopyWith(
        $value.foods,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(foods: v),
      );
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
    List<MfpFood>? foods,
  }) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (verifiedOnly != null) #verifiedOnly: verifiedOnly,
      if (recents != null) #recents: recents,
      if (remembered != null) #remembered: remembered,
      if (foods != null) #foods: foods,
    }),
  );
  @override
  AddSearchResults $make(CopyWithData data) => AddSearchResults(
    query: data.get(#query, or: $value.query),
    verifiedOnly: data.get(#verifiedOnly, or: $value.verifiedOnly),
    recents: data.get(#recents, or: $value.recents),
    remembered: data.get(#remembered, or: $value.remembered),
    foods: data.get(#foods, or: $value.foods),
  );

  @override
  AddSearchResultsCopyWith<$R2, AddSearchResults, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddSearchResultsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddBarcodeMissingMapper extends SubClassMapperBase<AddBarcodeMissing> {
  AddBarcodeMissingMapper._();

  static AddBarcodeMissingMapper? _instance;
  static AddBarcodeMissingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddBarcodeMissingMapper._());
      AddSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      RecentFoodMapper.ensureInitialized();
      RememberedFoodMapper.ensureInitialized();
      MfpBarcodeResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddBarcodeMissing';

  static String _$query(AddBarcodeMissing v) => v.query;
  static const Field<AddBarcodeMissing, String> _f$query = Field(
    'query',
    _$query,
  );
  static bool _$verifiedOnly(AddBarcodeMissing v) => v.verifiedOnly;
  static const Field<AddBarcodeMissing, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    key: r'verified_only',
  );
  static List<RecentFood> _$recents(AddBarcodeMissing v) => v.recents;
  static const Field<AddBarcodeMissing, List<RecentFood>> _f$recents = Field(
    'recents',
    _$recents,
  );
  static List<RememberedFood> _$remembered(AddBarcodeMissing v) => v.remembered;
  static const Field<AddBarcodeMissing, List<RememberedFood>> _f$remembered =
      Field('remembered', _$remembered);
  static MfpBarcodeResult _$result(AddBarcodeMissing v) => v.result;
  static const Field<AddBarcodeMissing, MfpBarcodeResult> _f$result = Field(
    'result',
    _$result,
  );

  @override
  final MappableFields<AddBarcodeMissing> fields = const {
    #query: _f$query,
    #verifiedOnly: _f$verifiedOnly,
    #recents: _f$recents,
    #remembered: _f$remembered,
    #result: _f$result,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'barcode_missing';
  @override
  late final ClassMapperBase superMapper =
      AddSearchStateMapper.ensureInitialized();

  static AddBarcodeMissing _instantiate(DecodingData data) {
    return AddBarcodeMissing(
      query: data.dec(_f$query),
      verifiedOnly: data.dec(_f$verifiedOnly),
      recents: data.dec(_f$recents),
      remembered: data.dec(_f$remembered),
      result: data.dec(_f$result),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddBarcodeMissing fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddBarcodeMissing>(map);
  }

  static AddBarcodeMissing fromJson(String json) {
    return ensureInitialized().decodeJson<AddBarcodeMissing>(json);
  }
}

mixin AddBarcodeMissingMappable {
  String toJson() {
    return AddBarcodeMissingMapper.ensureInitialized()
        .encodeJson<AddBarcodeMissing>(this as AddBarcodeMissing);
  }

  Map<String, dynamic> toMap() {
    return AddBarcodeMissingMapper.ensureInitialized()
        .encodeMap<AddBarcodeMissing>(this as AddBarcodeMissing);
  }

  AddBarcodeMissingCopyWith<
    AddBarcodeMissing,
    AddBarcodeMissing,
    AddBarcodeMissing
  >
  get copyWith =>
      _AddBarcodeMissingCopyWithImpl<AddBarcodeMissing, AddBarcodeMissing>(
        this as AddBarcodeMissing,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddBarcodeMissingMapper.ensureInitialized().stringifyValue(
      this as AddBarcodeMissing,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddBarcodeMissingMapper.ensureInitialized().equalsValue(
      this as AddBarcodeMissing,
      other,
    );
  }

  @override
  int get hashCode {
    return AddBarcodeMissingMapper.ensureInitialized().hashValue(
      this as AddBarcodeMissing,
    );
  }
}

extension AddBarcodeMissingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddBarcodeMissing, $Out> {
  AddBarcodeMissingCopyWith<$R, AddBarcodeMissing, $Out>
  get $asAddBarcodeMissing => $base.as(
    (v, t, t2) => _AddBarcodeMissingCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AddBarcodeMissingCopyWith<
  $R,
  $In extends AddBarcodeMissing,
  $Out
>
    implements AddSearchStateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents;
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered;
  MfpBarcodeResultCopyWith<$R, MfpBarcodeResult, MfpBarcodeResult> get result;
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
    MfpBarcodeResult? result,
  });
  AddBarcodeMissingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddBarcodeMissingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddBarcodeMissing, $Out>
    implements AddBarcodeMissingCopyWith<$R, AddBarcodeMissing, $Out> {
  _AddBarcodeMissingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddBarcodeMissing> $mapper =
      AddBarcodeMissingMapper.ensureInitialized();
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents => ListCopyWith(
    $value.recents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(recents: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered => ListCopyWith(
    $value.remembered,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(remembered: v),
  );
  @override
  MfpBarcodeResultCopyWith<$R, MfpBarcodeResult, MfpBarcodeResult> get result =>
      $value.result.copyWith.$chain((v) => call(result: v));
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
    MfpBarcodeResult? result,
  }) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (verifiedOnly != null) #verifiedOnly: verifiedOnly,
      if (recents != null) #recents: recents,
      if (remembered != null) #remembered: remembered,
      if (result != null) #result: result,
    }),
  );
  @override
  AddBarcodeMissing $make(CopyWithData data) => AddBarcodeMissing(
    query: data.get(#query, or: $value.query),
    verifiedOnly: data.get(#verifiedOnly, or: $value.verifiedOnly),
    recents: data.get(#recents, or: $value.recents),
    remembered: data.get(#remembered, or: $value.remembered),
    result: data.get(#result, or: $value.result),
  );

  @override
  AddBarcodeMissingCopyWith<$R2, AddBarcodeMissing, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddBarcodeMissingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddSearchFailedMapper extends SubClassMapperBase<AddSearchFailed> {
  AddSearchFailedMapper._();

  static AddSearchFailedMapper? _instance;
  static AddSearchFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddSearchFailedMapper._());
      AddSearchStateMapper.ensureInitialized().addSubMapper(_instance!);
      RecentFoodMapper.ensureInitialized();
      RememberedFoodMapper.ensureInitialized();
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddSearchFailed';

  static String _$query(AddSearchFailed v) => v.query;
  static const Field<AddSearchFailed, String> _f$query = Field(
    'query',
    _$query,
  );
  static bool _$verifiedOnly(AddSearchFailed v) => v.verifiedOnly;
  static const Field<AddSearchFailed, bool> _f$verifiedOnly = Field(
    'verifiedOnly',
    _$verifiedOnly,
    key: r'verified_only',
  );
  static List<RecentFood> _$recents(AddSearchFailed v) => v.recents;
  static const Field<AddSearchFailed, List<RecentFood>> _f$recents = Field(
    'recents',
    _$recents,
  );
  static List<RememberedFood> _$remembered(AddSearchFailed v) => v.remembered;
  static const Field<AddSearchFailed, List<RememberedFood>> _f$remembered =
      Field('remembered', _$remembered);
  static ReadProblem _$problem(AddSearchFailed v) => v.problem;
  static const Field<AddSearchFailed, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );
  static int? _$statusCode(AddSearchFailed v) => v.statusCode;
  static const Field<AddSearchFailed, int> _f$statusCode = Field(
    'statusCode',
    _$statusCode,
    key: r'status_code',
    opt: true,
  );

  @override
  final MappableFields<AddSearchFailed> fields = const {
    #query: _f$query,
    #verifiedOnly: _f$verifiedOnly,
    #recents: _f$recents,
    #remembered: _f$remembered,
    #problem: _f$problem,
    #statusCode: _f$statusCode,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      AddSearchStateMapper.ensureInitialized();

  static AddSearchFailed _instantiate(DecodingData data) {
    return AddSearchFailed(
      query: data.dec(_f$query),
      verifiedOnly: data.dec(_f$verifiedOnly),
      recents: data.dec(_f$recents),
      remembered: data.dec(_f$remembered),
      problem: data.dec(_f$problem),
      statusCode: data.dec(_f$statusCode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddSearchFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddSearchFailed>(map);
  }

  static AddSearchFailed fromJson(String json) {
    return ensureInitialized().decodeJson<AddSearchFailed>(json);
  }
}

mixin AddSearchFailedMappable {
  String toJson() {
    return AddSearchFailedMapper.ensureInitialized()
        .encodeJson<AddSearchFailed>(this as AddSearchFailed);
  }

  Map<String, dynamic> toMap() {
    return AddSearchFailedMapper.ensureInitialized().encodeMap<AddSearchFailed>(
      this as AddSearchFailed,
    );
  }

  AddSearchFailedCopyWith<AddSearchFailed, AddSearchFailed, AddSearchFailed>
  get copyWith =>
      _AddSearchFailedCopyWithImpl<AddSearchFailed, AddSearchFailed>(
        this as AddSearchFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddSearchFailedMapper.ensureInitialized().stringifyValue(
      this as AddSearchFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddSearchFailedMapper.ensureInitialized().equalsValue(
      this as AddSearchFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return AddSearchFailedMapper.ensureInitialized().hashValue(
      this as AddSearchFailed,
    );
  }
}

extension AddSearchFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddSearchFailed, $Out> {
  AddSearchFailedCopyWith<$R, AddSearchFailed, $Out> get $asAddSearchFailed =>
      $base.as((v, t, t2) => _AddSearchFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddSearchFailedCopyWith<$R, $In extends AddSearchFailed, $Out>
    implements AddSearchStateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents;
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered;
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
    ReadProblem? problem,
    int? statusCode,
  });
  AddSearchFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddSearchFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddSearchFailed, $Out>
    implements AddSearchFailedCopyWith<$R, AddSearchFailed, $Out> {
  _AddSearchFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddSearchFailed> $mapper =
      AddSearchFailedMapper.ensureInitialized();
  @override
  ListCopyWith<$R, RecentFood, RecentFoodCopyWith<$R, RecentFood, RecentFood>>
  get recents => ListCopyWith(
    $value.recents,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(recents: v),
  );
  @override
  ListCopyWith<
    $R,
    RememberedFood,
    RememberedFoodCopyWith<$R, RememberedFood, RememberedFood>
  >
  get remembered => ListCopyWith(
    $value.remembered,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(remembered: v),
  );
  @override
  $R call({
    String? query,
    bool? verifiedOnly,
    List<RecentFood>? recents,
    List<RememberedFood>? remembered,
    ReadProblem? problem,
    Object? statusCode = $none,
  }) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (verifiedOnly != null) #verifiedOnly: verifiedOnly,
      if (recents != null) #recents: recents,
      if (remembered != null) #remembered: remembered,
      if (problem != null) #problem: problem,
      if (statusCode != $none) #statusCode: statusCode,
    }),
  );
  @override
  AddSearchFailed $make(CopyWithData data) => AddSearchFailed(
    query: data.get(#query, or: $value.query),
    verifiedOnly: data.get(#verifiedOnly, or: $value.verifiedOnly),
    recents: data.get(#recents, or: $value.recents),
    remembered: data.get(#remembered, or: $value.remembered),
    problem: data.get(#problem, or: $value.problem),
    statusCode: data.get(#statusCode, or: $value.statusCode),
  );

  @override
  AddSearchFailedCopyWith<$R2, AddSearchFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddSearchFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

