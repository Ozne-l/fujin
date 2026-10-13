// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'scanner_exit.dart';

class ScannerExitMapper extends ClassMapperBase<ScannerExit> {
  ScannerExitMapper._();

  static ScannerExitMapper? _instance;
  static ScannerExitMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerExitMapper._());
      ScannerAddedMapper.ensureInitialized();
      ScannerSearchMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerExit';

  @override
  final MappableFields<ScannerExit> fields = const {};
  @override
  final bool ignoreNull = true;

  static ScannerExit _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'ScannerExit',
      'exit',
      '${data.value['exit']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerExit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerExit>(map);
  }

  static ScannerExit fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerExit>(json);
  }
}

mixin ScannerExitMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ScannerExitCopyWith<ScannerExit, ScannerExit, ScannerExit> get copyWith;
}

abstract class ScannerExitCopyWith<$R, $In extends ScannerExit, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ScannerExitCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ScannerAddedMapper extends SubClassMapperBase<ScannerAdded> {
  ScannerAddedMapper._();

  static ScannerAddedMapper? _instance;
  static ScannerAddedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerAddedMapper._());
      ScannerExitMapper.ensureInitialized().addSubMapper(_instance!);
      AddedFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerAdded';

  static AddedFood _$added(ScannerAdded v) => v.added;
  static const Field<ScannerAdded, AddedFood> _f$added = Field(
    'added',
    _$added,
  );

  @override
  final MappableFields<ScannerAdded> fields = const {#added: _f$added};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'exit';
  @override
  final dynamic discriminatorValue = 'added';
  @override
  late final ClassMapperBase superMapper =
      ScannerExitMapper.ensureInitialized();

  static ScannerAdded _instantiate(DecodingData data) {
    return ScannerAdded(data.dec(_f$added));
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerAdded fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerAdded>(map);
  }

  static ScannerAdded fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerAdded>(json);
  }
}

mixin ScannerAddedMappable {
  String toJson() {
    return ScannerAddedMapper.ensureInitialized().encodeJson<ScannerAdded>(
      this as ScannerAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerAddedMapper.ensureInitialized().encodeMap<ScannerAdded>(
      this as ScannerAdded,
    );
  }

  ScannerAddedCopyWith<ScannerAdded, ScannerAdded, ScannerAdded> get copyWith =>
      _ScannerAddedCopyWithImpl<ScannerAdded, ScannerAdded>(
        this as ScannerAdded,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ScannerAddedMapper.ensureInitialized().stringifyValue(
      this as ScannerAdded,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerAddedMapper.ensureInitialized().equalsValue(
      this as ScannerAdded,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerAddedMapper.ensureInitialized().hashValue(
      this as ScannerAdded,
    );
  }
}

extension ScannerAddedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerAdded, $Out> {
  ScannerAddedCopyWith<$R, ScannerAdded, $Out> get $asScannerAdded =>
      $base.as((v, t, t2) => _ScannerAddedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerAddedCopyWith<$R, $In extends ScannerAdded, $Out>
    implements ScannerExitCopyWith<$R, $In, $Out> {
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added;
  @override
  $R call({AddedFood? added});
  ScannerAddedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScannerAddedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerAdded, $Out>
    implements ScannerAddedCopyWith<$R, ScannerAdded, $Out> {
  _ScannerAddedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerAdded> $mapper =
      ScannerAddedMapper.ensureInitialized();
  @override
  AddedFoodCopyWith<$R, AddedFood, AddedFood> get added =>
      $value.added.copyWith.$chain((v) => call(added: v));
  @override
  $R call({AddedFood? added}) =>
      $apply(FieldCopyWithData({if (added != null) #added: added}));
  @override
  ScannerAdded $make(CopyWithData data) =>
      ScannerAdded(data.get(#added, or: $value.added));

  @override
  ScannerAddedCopyWith<$R2, ScannerAdded, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerAddedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerSearchMapper extends SubClassMapperBase<ScannerSearch> {
  ScannerSearchMapper._();

  static ScannerSearchMapper? _instance;
  static ScannerSearchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerSearchMapper._());
      ScannerExitMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerSearch';

  static String _$query(ScannerSearch v) => v.query;
  static const Field<ScannerSearch, String> _f$query = Field('query', _$query);
  static String? _$barcode(ScannerSearch v) => v.barcode;
  static const Field<ScannerSearch, String> _f$barcode = Field(
    'barcode',
    _$barcode,
    opt: true,
  );
  static bool _$unresolved(ScannerSearch v) => v.unresolved;
  static const Field<ScannerSearch, bool> _f$unresolved = Field(
    'unresolved',
    _$unresolved,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ScannerSearch> fields = const {
    #query: _f$query,
    #barcode: _f$barcode,
    #unresolved: _f$unresolved,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'exit';
  @override
  final dynamic discriminatorValue = 'search';
  @override
  late final ClassMapperBase superMapper =
      ScannerExitMapper.ensureInitialized();

  static ScannerSearch _instantiate(DecodingData data) {
    return ScannerSearch(
      query: data.dec(_f$query),
      barcode: data.dec(_f$barcode),
      unresolved: data.dec(_f$unresolved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerSearch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerSearch>(map);
  }

  static ScannerSearch fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerSearch>(json);
  }
}

mixin ScannerSearchMappable {
  String toJson() {
    return ScannerSearchMapper.ensureInitialized().encodeJson<ScannerSearch>(
      this as ScannerSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerSearchMapper.ensureInitialized().encodeMap<ScannerSearch>(
      this as ScannerSearch,
    );
  }

  ScannerSearchCopyWith<ScannerSearch, ScannerSearch, ScannerSearch>
  get copyWith => _ScannerSearchCopyWithImpl<ScannerSearch, ScannerSearch>(
    this as ScannerSearch,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerSearchMapper.ensureInitialized().stringifyValue(
      this as ScannerSearch,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerSearchMapper.ensureInitialized().equalsValue(
      this as ScannerSearch,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerSearchMapper.ensureInitialized().hashValue(
      this as ScannerSearch,
    );
  }
}

extension ScannerSearchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerSearch, $Out> {
  ScannerSearchCopyWith<$R, ScannerSearch, $Out> get $asScannerSearch =>
      $base.as((v, t, t2) => _ScannerSearchCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerSearchCopyWith<$R, $In extends ScannerSearch, $Out>
    implements ScannerExitCopyWith<$R, $In, $Out> {
  @override
  $R call({String? query, String? barcode, bool? unresolved});
  ScannerSearchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScannerSearchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerSearch, $Out>
    implements ScannerSearchCopyWith<$R, ScannerSearch, $Out> {
  _ScannerSearchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerSearch> $mapper =
      ScannerSearchMapper.ensureInitialized();
  @override
  $R call({String? query, Object? barcode = $none, bool? unresolved}) => $apply(
    FieldCopyWithData({
      if (query != null) #query: query,
      if (barcode != $none) #barcode: barcode,
      if (unresolved != null) #unresolved: unresolved,
    }),
  );
  @override
  ScannerSearch $make(CopyWithData data) => ScannerSearch(
    query: data.get(#query, or: $value.query),
    barcode: data.get(#barcode, or: $value.barcode),
    unresolved: data.get(#unresolved, or: $value.unresolved),
  );

  @override
  ScannerSearchCopyWith<$R2, ScannerSearch, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerSearchCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

