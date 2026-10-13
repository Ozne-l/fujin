// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'scanner_state.dart';

class ScannerStateMapper extends ClassMapperBase<ScannerState> {
  ScannerStateMapper._();

  static ScannerStateMapper? _instance;
  static ScannerStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerStateMapper._());
      ScannerAimingMapper.ensureInitialized();
      ScannerRefusedMapper.ensureInitialized();
      ScannerTypingMapper.ensureInitialized();
      ScannerLookingMapper.ensureInitialized();
      ScannerFoundMapper.ensureInitialized();
      ScannerUnknownMapper.ensureInitialized();
      ScannerUnresolvedMapper.ensureInitialized();
      ScannerFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerState';

  @override
  final MappableFields<ScannerState> fields = const {};
  @override
  final bool ignoreNull = true;

  static ScannerState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'ScannerState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerState>(map);
  }

  static ScannerState fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerState>(json);
  }
}

mixin ScannerStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ScannerStateCopyWith<ScannerState, ScannerState, ScannerState> get copyWith;
}

abstract class ScannerStateCopyWith<$R, $In extends ScannerState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ScannerStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ScannerAimingMapper extends SubClassMapperBase<ScannerAiming> {
  ScannerAimingMapper._();

  static ScannerAimingMapper? _instance;
  static ScannerAimingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerAimingMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerAiming';

  @override
  final MappableFields<ScannerAiming> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'aiming';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerAiming _instantiate(DecodingData data) {
    return ScannerAiming();
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerAiming fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerAiming>(map);
  }

  static ScannerAiming fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerAiming>(json);
  }
}

mixin ScannerAimingMappable {
  String toJson() {
    return ScannerAimingMapper.ensureInitialized().encodeJson<ScannerAiming>(
      this as ScannerAiming,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerAimingMapper.ensureInitialized().encodeMap<ScannerAiming>(
      this as ScannerAiming,
    );
  }

  ScannerAimingCopyWith<ScannerAiming, ScannerAiming, ScannerAiming>
  get copyWith => _ScannerAimingCopyWithImpl<ScannerAiming, ScannerAiming>(
    this as ScannerAiming,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerAimingMapper.ensureInitialized().stringifyValue(
      this as ScannerAiming,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerAimingMapper.ensureInitialized().equalsValue(
      this as ScannerAiming,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerAimingMapper.ensureInitialized().hashValue(
      this as ScannerAiming,
    );
  }
}

extension ScannerAimingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerAiming, $Out> {
  ScannerAimingCopyWith<$R, ScannerAiming, $Out> get $asScannerAiming =>
      $base.as((v, t, t2) => _ScannerAimingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerAimingCopyWith<$R, $In extends ScannerAiming, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ScannerAimingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScannerAimingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerAiming, $Out>
    implements ScannerAimingCopyWith<$R, ScannerAiming, $Out> {
  _ScannerAimingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerAiming> $mapper =
      ScannerAimingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ScannerAiming $make(CopyWithData data) => ScannerAiming();

  @override
  ScannerAimingCopyWith<$R2, ScannerAiming, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerAimingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerRefusedMapper extends SubClassMapperBase<ScannerRefused> {
  ScannerRefusedMapper._();

  static ScannerRefusedMapper? _instance;
  static ScannerRefusedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerRefusedMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerRefused';

  @override
  final MappableFields<ScannerRefused> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'refused';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerRefused _instantiate(DecodingData data) {
    return ScannerRefused();
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerRefused fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerRefused>(map);
  }

  static ScannerRefused fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerRefused>(json);
  }
}

mixin ScannerRefusedMappable {
  String toJson() {
    return ScannerRefusedMapper.ensureInitialized().encodeJson<ScannerRefused>(
      this as ScannerRefused,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerRefusedMapper.ensureInitialized().encodeMap<ScannerRefused>(
      this as ScannerRefused,
    );
  }

  ScannerRefusedCopyWith<ScannerRefused, ScannerRefused, ScannerRefused>
  get copyWith => _ScannerRefusedCopyWithImpl<ScannerRefused, ScannerRefused>(
    this as ScannerRefused,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerRefusedMapper.ensureInitialized().stringifyValue(
      this as ScannerRefused,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerRefusedMapper.ensureInitialized().equalsValue(
      this as ScannerRefused,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerRefusedMapper.ensureInitialized().hashValue(
      this as ScannerRefused,
    );
  }
}

extension ScannerRefusedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerRefused, $Out> {
  ScannerRefusedCopyWith<$R, ScannerRefused, $Out> get $asScannerRefused =>
      $base.as((v, t, t2) => _ScannerRefusedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerRefusedCopyWith<$R, $In extends ScannerRefused, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ScannerRefusedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ScannerRefusedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerRefused, $Out>
    implements ScannerRefusedCopyWith<$R, ScannerRefused, $Out> {
  _ScannerRefusedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerRefused> $mapper =
      ScannerRefusedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ScannerRefused $make(CopyWithData data) => ScannerRefused();

  @override
  ScannerRefusedCopyWith<$R2, ScannerRefused, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerRefusedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerTypingMapper extends SubClassMapperBase<ScannerTyping> {
  ScannerTypingMapper._();

  static ScannerTypingMapper? _instance;
  static ScannerTypingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerTypingMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerTyping';

  static String _$code(ScannerTyping v) => v.code;
  static const Field<ScannerTyping, String> _f$code = Field('code', _$code);

  @override
  final MappableFields<ScannerTyping> fields = const {#code: _f$code};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'typing';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerTyping _instantiate(DecodingData data) {
    return ScannerTyping(data.dec(_f$code));
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerTyping fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerTyping>(map);
  }

  static ScannerTyping fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerTyping>(json);
  }
}

mixin ScannerTypingMappable {
  String toJson() {
    return ScannerTypingMapper.ensureInitialized().encodeJson<ScannerTyping>(
      this as ScannerTyping,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerTypingMapper.ensureInitialized().encodeMap<ScannerTyping>(
      this as ScannerTyping,
    );
  }

  ScannerTypingCopyWith<ScannerTyping, ScannerTyping, ScannerTyping>
  get copyWith => _ScannerTypingCopyWithImpl<ScannerTyping, ScannerTyping>(
    this as ScannerTyping,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerTypingMapper.ensureInitialized().stringifyValue(
      this as ScannerTyping,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerTypingMapper.ensureInitialized().equalsValue(
      this as ScannerTyping,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerTypingMapper.ensureInitialized().hashValue(
      this as ScannerTyping,
    );
  }
}

extension ScannerTypingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerTyping, $Out> {
  ScannerTypingCopyWith<$R, ScannerTyping, $Out> get $asScannerTyping =>
      $base.as((v, t, t2) => _ScannerTypingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerTypingCopyWith<$R, $In extends ScannerTyping, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? code});
  ScannerTypingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScannerTypingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerTyping, $Out>
    implements ScannerTypingCopyWith<$R, ScannerTyping, $Out> {
  _ScannerTypingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerTyping> $mapper =
      ScannerTypingMapper.ensureInitialized();
  @override
  $R call({String? code}) =>
      $apply(FieldCopyWithData({if (code != null) #code: code}));
  @override
  ScannerTyping $make(CopyWithData data) =>
      ScannerTyping(data.get(#code, or: $value.code));

  @override
  ScannerTypingCopyWith<$R2, ScannerTyping, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerTypingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerLookingMapper extends SubClassMapperBase<ScannerLooking> {
  ScannerLookingMapper._();

  static ScannerLookingMapper? _instance;
  static ScannerLookingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerLookingMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerLooking';

  static String _$code(ScannerLooking v) => v.code;
  static const Field<ScannerLooking, String> _f$code = Field('code', _$code);

  @override
  final MappableFields<ScannerLooking> fields = const {#code: _f$code};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'looking';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerLooking _instantiate(DecodingData data) {
    return ScannerLooking(data.dec(_f$code));
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerLooking fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerLooking>(map);
  }

  static ScannerLooking fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerLooking>(json);
  }
}

mixin ScannerLookingMappable {
  String toJson() {
    return ScannerLookingMapper.ensureInitialized().encodeJson<ScannerLooking>(
      this as ScannerLooking,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerLookingMapper.ensureInitialized().encodeMap<ScannerLooking>(
      this as ScannerLooking,
    );
  }

  ScannerLookingCopyWith<ScannerLooking, ScannerLooking, ScannerLooking>
  get copyWith => _ScannerLookingCopyWithImpl<ScannerLooking, ScannerLooking>(
    this as ScannerLooking,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerLookingMapper.ensureInitialized().stringifyValue(
      this as ScannerLooking,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerLookingMapper.ensureInitialized().equalsValue(
      this as ScannerLooking,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerLookingMapper.ensureInitialized().hashValue(
      this as ScannerLooking,
    );
  }
}

extension ScannerLookingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerLooking, $Out> {
  ScannerLookingCopyWith<$R, ScannerLooking, $Out> get $asScannerLooking =>
      $base.as((v, t, t2) => _ScannerLookingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerLookingCopyWith<$R, $In extends ScannerLooking, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? code});
  ScannerLookingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ScannerLookingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerLooking, $Out>
    implements ScannerLookingCopyWith<$R, ScannerLooking, $Out> {
  _ScannerLookingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerLooking> $mapper =
      ScannerLookingMapper.ensureInitialized();
  @override
  $R call({String? code}) =>
      $apply(FieldCopyWithData({if (code != null) #code: code}));
  @override
  ScannerLooking $make(CopyWithData data) =>
      ScannerLooking(data.get(#code, or: $value.code));

  @override
  ScannerLookingCopyWith<$R2, ScannerLooking, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerLookingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerFoundMapper extends SubClassMapperBase<ScannerFound> {
  ScannerFoundMapper._();

  static ScannerFoundMapper? _instance;
  static ScannerFoundMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerFoundMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
      MfpFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerFound';

  static String _$code(ScannerFound v) => v.code;
  static const Field<ScannerFound, String> _f$code = Field('code', _$code);
  static MfpFood _$food(ScannerFound v) => v.food;
  static const Field<ScannerFound, MfpFood> _f$food = Field('food', _$food);
  static bool _$remembered(ScannerFound v) => v.remembered;
  static const Field<ScannerFound, bool> _f$remembered = Field(
    'remembered',
    _$remembered,
  );

  @override
  final MappableFields<ScannerFound> fields = const {
    #code: _f$code,
    #food: _f$food,
    #remembered: _f$remembered,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'found';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerFound _instantiate(DecodingData data) {
    return ScannerFound(
      data.dec(_f$code),
      data.dec(_f$food),
      remembered: data.dec(_f$remembered),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerFound fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerFound>(map);
  }

  static ScannerFound fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerFound>(json);
  }
}

mixin ScannerFoundMappable {
  String toJson() {
    return ScannerFoundMapper.ensureInitialized().encodeJson<ScannerFound>(
      this as ScannerFound,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerFoundMapper.ensureInitialized().encodeMap<ScannerFound>(
      this as ScannerFound,
    );
  }

  ScannerFoundCopyWith<ScannerFound, ScannerFound, ScannerFound> get copyWith =>
      _ScannerFoundCopyWithImpl<ScannerFound, ScannerFound>(
        this as ScannerFound,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ScannerFoundMapper.ensureInitialized().stringifyValue(
      this as ScannerFound,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerFoundMapper.ensureInitialized().equalsValue(
      this as ScannerFound,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerFoundMapper.ensureInitialized().hashValue(
      this as ScannerFound,
    );
  }
}

extension ScannerFoundValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerFound, $Out> {
  ScannerFoundCopyWith<$R, ScannerFound, $Out> get $asScannerFound =>
      $base.as((v, t, t2) => _ScannerFoundCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerFoundCopyWith<$R, $In extends ScannerFound, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  MfpFoodCopyWith<$R, MfpFood, MfpFood> get food;
  @override
  $R call({String? code, MfpFood? food, bool? remembered});
  ScannerFoundCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScannerFoundCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerFound, $Out>
    implements ScannerFoundCopyWith<$R, ScannerFound, $Out> {
  _ScannerFoundCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerFound> $mapper =
      ScannerFoundMapper.ensureInitialized();
  @override
  MfpFoodCopyWith<$R, MfpFood, MfpFood> get food =>
      $value.food.copyWith.$chain((v) => call(food: v));
  @override
  $R call({String? code, MfpFood? food, bool? remembered}) => $apply(
    FieldCopyWithData({
      if (code != null) #code: code,
      if (food != null) #food: food,
      if (remembered != null) #remembered: remembered,
    }),
  );
  @override
  ScannerFound $make(CopyWithData data) => ScannerFound(
    data.get(#code, or: $value.code),
    data.get(#food, or: $value.food),
    remembered: data.get(#remembered, or: $value.remembered),
  );

  @override
  ScannerFoundCopyWith<$R2, ScannerFound, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerFoundCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerUnknownMapper extends SubClassMapperBase<ScannerUnknown> {
  ScannerUnknownMapper._();

  static ScannerUnknownMapper? _instance;
  static ScannerUnknownMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerUnknownMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerUnknown';

  static String _$code(ScannerUnknown v) => v.code;
  static const Field<ScannerUnknown, String> _f$code = Field('code', _$code);

  @override
  final MappableFields<ScannerUnknown> fields = const {#code: _f$code};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'unknown';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerUnknown _instantiate(DecodingData data) {
    return ScannerUnknown(data.dec(_f$code));
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerUnknown fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerUnknown>(map);
  }

  static ScannerUnknown fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerUnknown>(json);
  }
}

mixin ScannerUnknownMappable {
  String toJson() {
    return ScannerUnknownMapper.ensureInitialized().encodeJson<ScannerUnknown>(
      this as ScannerUnknown,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerUnknownMapper.ensureInitialized().encodeMap<ScannerUnknown>(
      this as ScannerUnknown,
    );
  }

  ScannerUnknownCopyWith<ScannerUnknown, ScannerUnknown, ScannerUnknown>
  get copyWith => _ScannerUnknownCopyWithImpl<ScannerUnknown, ScannerUnknown>(
    this as ScannerUnknown,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerUnknownMapper.ensureInitialized().stringifyValue(
      this as ScannerUnknown,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerUnknownMapper.ensureInitialized().equalsValue(
      this as ScannerUnknown,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerUnknownMapper.ensureInitialized().hashValue(
      this as ScannerUnknown,
    );
  }
}

extension ScannerUnknownValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerUnknown, $Out> {
  ScannerUnknownCopyWith<$R, ScannerUnknown, $Out> get $asScannerUnknown =>
      $base.as((v, t, t2) => _ScannerUnknownCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerUnknownCopyWith<$R, $In extends ScannerUnknown, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? code});
  ScannerUnknownCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ScannerUnknownCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerUnknown, $Out>
    implements ScannerUnknownCopyWith<$R, ScannerUnknown, $Out> {
  _ScannerUnknownCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerUnknown> $mapper =
      ScannerUnknownMapper.ensureInitialized();
  @override
  $R call({String? code}) =>
      $apply(FieldCopyWithData({if (code != null) #code: code}));
  @override
  ScannerUnknown $make(CopyWithData data) =>
      ScannerUnknown(data.get(#code, or: $value.code));

  @override
  ScannerUnknownCopyWith<$R2, ScannerUnknown, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerUnknownCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerUnresolvedMapper extends SubClassMapperBase<ScannerUnresolved> {
  ScannerUnresolvedMapper._();

  static ScannerUnresolvedMapper? _instance;
  static ScannerUnresolvedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerUnresolvedMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerUnresolved';

  static String _$code(ScannerUnresolved v) => v.code;
  static const Field<ScannerUnresolved, String> _f$code = Field('code', _$code);
  static String _$description(ScannerUnresolved v) => v.description;
  static const Field<ScannerUnresolved, String> _f$description = Field(
    'description',
    _$description,
  );
  static String? _$brandName(ScannerUnresolved v) => v.brandName;
  static const Field<ScannerUnresolved, String> _f$brandName = Field(
    'brandName',
    _$brandName,
    key: r'brand_name',
  );

  @override
  final MappableFields<ScannerUnresolved> fields = const {
    #code: _f$code,
    #description: _f$description,
    #brandName: _f$brandName,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'unresolved';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerUnresolved _instantiate(DecodingData data) {
    return ScannerUnresolved(
      data.dec(_f$code),
      description: data.dec(_f$description),
      brandName: data.dec(_f$brandName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerUnresolved fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerUnresolved>(map);
  }

  static ScannerUnresolved fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerUnresolved>(json);
  }
}

mixin ScannerUnresolvedMappable {
  String toJson() {
    return ScannerUnresolvedMapper.ensureInitialized()
        .encodeJson<ScannerUnresolved>(this as ScannerUnresolved);
  }

  Map<String, dynamic> toMap() {
    return ScannerUnresolvedMapper.ensureInitialized()
        .encodeMap<ScannerUnresolved>(this as ScannerUnresolved);
  }

  ScannerUnresolvedCopyWith<
    ScannerUnresolved,
    ScannerUnresolved,
    ScannerUnresolved
  >
  get copyWith =>
      _ScannerUnresolvedCopyWithImpl<ScannerUnresolved, ScannerUnresolved>(
        this as ScannerUnresolved,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ScannerUnresolvedMapper.ensureInitialized().stringifyValue(
      this as ScannerUnresolved,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerUnresolvedMapper.ensureInitialized().equalsValue(
      this as ScannerUnresolved,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerUnresolvedMapper.ensureInitialized().hashValue(
      this as ScannerUnresolved,
    );
  }
}

extension ScannerUnresolvedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerUnresolved, $Out> {
  ScannerUnresolvedCopyWith<$R, ScannerUnresolved, $Out>
  get $asScannerUnresolved => $base.as(
    (v, t, t2) => _ScannerUnresolvedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ScannerUnresolvedCopyWith<
  $R,
  $In extends ScannerUnresolved,
  $Out
>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? code, String? description, String? brandName});
  ScannerUnresolvedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ScannerUnresolvedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerUnresolved, $Out>
    implements ScannerUnresolvedCopyWith<$R, ScannerUnresolved, $Out> {
  _ScannerUnresolvedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerUnresolved> $mapper =
      ScannerUnresolvedMapper.ensureInitialized();
  @override
  $R call({String? code, String? description, Object? brandName = $none}) =>
      $apply(
        FieldCopyWithData({
          if (code != null) #code: code,
          if (description != null) #description: description,
          if (brandName != $none) #brandName: brandName,
        }),
      );
  @override
  ScannerUnresolved $make(CopyWithData data) => ScannerUnresolved(
    data.get(#code, or: $value.code),
    description: data.get(#description, or: $value.description),
    brandName: data.get(#brandName, or: $value.brandName),
  );

  @override
  ScannerUnresolvedCopyWith<$R2, ScannerUnresolved, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerUnresolvedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ScannerFailedMapper extends SubClassMapperBase<ScannerFailed> {
  ScannerFailedMapper._();

  static ScannerFailedMapper? _instance;
  static ScannerFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScannerFailedMapper._());
      ScannerStateMapper.ensureInitialized().addSubMapper(_instance!);
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScannerFailed';

  static String _$code(ScannerFailed v) => v.code;
  static const Field<ScannerFailed, String> _f$code = Field('code', _$code);
  static ReadProblem _$problem(ScannerFailed v) => v.problem;
  static const Field<ScannerFailed, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );

  @override
  final MappableFields<ScannerFailed> fields = const {
    #code: _f$code,
    #problem: _f$problem,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      ScannerStateMapper.ensureInitialized();

  static ScannerFailed _instantiate(DecodingData data) {
    return ScannerFailed(data.dec(_f$code), data.dec(_f$problem));
  }

  @override
  final Function instantiate = _instantiate;

  static ScannerFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScannerFailed>(map);
  }

  static ScannerFailed fromJson(String json) {
    return ensureInitialized().decodeJson<ScannerFailed>(json);
  }
}

mixin ScannerFailedMappable {
  String toJson() {
    return ScannerFailedMapper.ensureInitialized().encodeJson<ScannerFailed>(
      this as ScannerFailed,
    );
  }

  Map<String, dynamic> toMap() {
    return ScannerFailedMapper.ensureInitialized().encodeMap<ScannerFailed>(
      this as ScannerFailed,
    );
  }

  ScannerFailedCopyWith<ScannerFailed, ScannerFailed, ScannerFailed>
  get copyWith => _ScannerFailedCopyWithImpl<ScannerFailed, ScannerFailed>(
    this as ScannerFailed,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScannerFailedMapper.ensureInitialized().stringifyValue(
      this as ScannerFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScannerFailedMapper.ensureInitialized().equalsValue(
      this as ScannerFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return ScannerFailedMapper.ensureInitialized().hashValue(
      this as ScannerFailed,
    );
  }
}

extension ScannerFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScannerFailed, $Out> {
  ScannerFailedCopyWith<$R, ScannerFailed, $Out> get $asScannerFailed =>
      $base.as((v, t, t2) => _ScannerFailedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ScannerFailedCopyWith<$R, $In extends ScannerFailed, $Out>
    implements ScannerStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? code, ReadProblem? problem});
  ScannerFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScannerFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScannerFailed, $Out>
    implements ScannerFailedCopyWith<$R, ScannerFailed, $Out> {
  _ScannerFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScannerFailed> $mapper =
      ScannerFailedMapper.ensureInitialized();
  @override
  $R call({String? code, ReadProblem? problem}) => $apply(
    FieldCopyWithData({
      if (code != null) #code: code,
      if (problem != null) #problem: problem,
    }),
  );
  @override
  ScannerFailed $make(CopyWithData data) => ScannerFailed(
    data.get(#code, or: $value.code),
    data.get(#problem, or: $value.problem),
  );

  @override
  ScannerFailedCopyWith<$R2, ScannerFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScannerFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

