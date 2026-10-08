// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_choice.dart';

class SendChoiceMapper extends ClassMapperBase<SendChoice> {
  SendChoiceMapper._();

  static SendChoiceMapper? _instance;
  static SendChoiceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendChoiceMapper._());
      SendToEkkloFoodMapper.ensureInitialized();
      SendAsOwnCopyMapper.ensureInitialized();
      SkipEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendChoice';

  @override
  final MappableFields<SendChoice> fields = const {};
  @override
  final bool ignoreNull = true;

  static SendChoice _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'SendChoice',
      'choice',
      '${data.value['choice']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendChoice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendChoice>(map);
  }

  static SendChoice fromJson(String json) {
    return ensureInitialized().decodeJson<SendChoice>(json);
  }
}

mixin SendChoiceMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SendChoiceCopyWith<SendChoice, SendChoice, SendChoice> get copyWith;
}

abstract class SendChoiceCopyWith<$R, $In extends SendChoice, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SendChoiceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class SendToEkkloFoodMapper extends SubClassMapperBase<SendToEkkloFood> {
  SendToEkkloFoodMapper._();

  static SendToEkkloFoodMapper? _instance;
  static SendToEkkloFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendToEkkloFoodMapper._());
      SendChoiceMapper.ensureInitialized().addSubMapper(_instance!);
      UnitWeightMapper.ensureInitialized();
      EkkloFoodMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendToEkkloFood';

  static String _$ekkloFoodId(SendToEkkloFood v) => v.ekkloFoodId;
  static const Field<SendToEkkloFood, String> _f$ekkloFoodId = Field(
    'ekkloFoodId',
    _$ekkloFoodId,
    key: r'ekklo_food_id',
  );
  static String _$ekkloFoodName(SendToEkkloFood v) => v.ekkloFoodName;
  static const Field<SendToEkkloFood, String> _f$ekkloFoodName = Field(
    'ekkloFoodName',
    _$ekkloFoodName,
    key: r'ekklo_food_name',
  );
  static double _$grams(SendToEkkloFood v) => v.grams;
  static const Field<SendToEkkloFood, double> _f$grams = Field(
    'grams',
    _$grams,
  );
  static bool _$remembered(SendToEkkloFood v) => v.remembered;
  static const Field<SendToEkkloFood, bool> _f$remembered = Field(
    'remembered',
    _$remembered,
  );
  static UnitWeight _$weight(SendToEkkloFood v) => v.weight;
  static const Field<SendToEkkloFood, UnitWeight> _f$weight = Field(
    'weight',
    _$weight,
    opt: true,
    def: UnitWeight.notNeeded,
  );
  static double? _$gramsPerUnit(SendToEkkloFood v) => v.gramsPerUnit;
  static const Field<SendToEkkloFood, double> _f$gramsPerUnit = Field(
    'gramsPerUnit',
    _$gramsPerUnit,
    key: r'grams_per_unit',
    opt: true,
  );
  static EkkloFood? _$food(SendToEkkloFood v) => v.food;
  static const Field<SendToEkkloFood, EkkloFood> _f$food = Field(
    'food',
    _$food,
    opt: true,
  );

  @override
  final MappableFields<SendToEkkloFood> fields = const {
    #ekkloFoodId: _f$ekkloFoodId,
    #ekkloFoodName: _f$ekkloFoodName,
    #grams: _f$grams,
    #remembered: _f$remembered,
    #weight: _f$weight,
    #gramsPerUnit: _f$gramsPerUnit,
    #food: _f$food,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'choice';
  @override
  final dynamic discriminatorValue = 'ekklo_food';
  @override
  late final ClassMapperBase superMapper = SendChoiceMapper.ensureInitialized();

  static SendToEkkloFood _instantiate(DecodingData data) {
    return SendToEkkloFood(
      ekkloFoodId: data.dec(_f$ekkloFoodId),
      ekkloFoodName: data.dec(_f$ekkloFoodName),
      grams: data.dec(_f$grams),
      remembered: data.dec(_f$remembered),
      weight: data.dec(_f$weight),
      gramsPerUnit: data.dec(_f$gramsPerUnit),
      food: data.dec(_f$food),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendToEkkloFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendToEkkloFood>(map);
  }

  static SendToEkkloFood fromJson(String json) {
    return ensureInitialized().decodeJson<SendToEkkloFood>(json);
  }
}

mixin SendToEkkloFoodMappable {
  String toJson() {
    return SendToEkkloFoodMapper.ensureInitialized()
        .encodeJson<SendToEkkloFood>(this as SendToEkkloFood);
  }

  Map<String, dynamic> toMap() {
    return SendToEkkloFoodMapper.ensureInitialized().encodeMap<SendToEkkloFood>(
      this as SendToEkkloFood,
    );
  }

  SendToEkkloFoodCopyWith<SendToEkkloFood, SendToEkkloFood, SendToEkkloFood>
  get copyWith =>
      _SendToEkkloFoodCopyWithImpl<SendToEkkloFood, SendToEkkloFood>(
        this as SendToEkkloFood,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SendToEkkloFoodMapper.ensureInitialized().stringifyValue(
      this as SendToEkkloFood,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendToEkkloFoodMapper.ensureInitialized().equalsValue(
      this as SendToEkkloFood,
      other,
    );
  }

  @override
  int get hashCode {
    return SendToEkkloFoodMapper.ensureInitialized().hashValue(
      this as SendToEkkloFood,
    );
  }
}

extension SendToEkkloFoodValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendToEkkloFood, $Out> {
  SendToEkkloFoodCopyWith<$R, SendToEkkloFood, $Out> get $asSendToEkkloFood =>
      $base.as((v, t, t2) => _SendToEkkloFoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendToEkkloFoodCopyWith<$R, $In extends SendToEkkloFood, $Out>
    implements SendChoiceCopyWith<$R, $In, $Out> {
  EkkloFoodCopyWith<$R, EkkloFood, EkkloFood>? get food;
  @override
  $R call({
    String? ekkloFoodId,
    String? ekkloFoodName,
    double? grams,
    bool? remembered,
    UnitWeight? weight,
    double? gramsPerUnit,
    EkkloFood? food,
  });
  SendToEkkloFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SendToEkkloFoodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendToEkkloFood, $Out>
    implements SendToEkkloFoodCopyWith<$R, SendToEkkloFood, $Out> {
  _SendToEkkloFoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendToEkkloFood> $mapper =
      SendToEkkloFoodMapper.ensureInitialized();
  @override
  EkkloFoodCopyWith<$R, EkkloFood, EkkloFood>? get food =>
      $value.food?.copyWith.$chain((v) => call(food: v));
  @override
  $R call({
    String? ekkloFoodId,
    String? ekkloFoodName,
    double? grams,
    bool? remembered,
    UnitWeight? weight,
    Object? gramsPerUnit = $none,
    Object? food = $none,
  }) => $apply(
    FieldCopyWithData({
      if (ekkloFoodId != null) #ekkloFoodId: ekkloFoodId,
      if (ekkloFoodName != null) #ekkloFoodName: ekkloFoodName,
      if (grams != null) #grams: grams,
      if (remembered != null) #remembered: remembered,
      if (weight != null) #weight: weight,
      if (gramsPerUnit != $none) #gramsPerUnit: gramsPerUnit,
      if (food != $none) #food: food,
    }),
  );
  @override
  SendToEkkloFood $make(CopyWithData data) => SendToEkkloFood(
    ekkloFoodId: data.get(#ekkloFoodId, or: $value.ekkloFoodId),
    ekkloFoodName: data.get(#ekkloFoodName, or: $value.ekkloFoodName),
    grams: data.get(#grams, or: $value.grams),
    remembered: data.get(#remembered, or: $value.remembered),
    weight: data.get(#weight, or: $value.weight),
    gramsPerUnit: data.get(#gramsPerUnit, or: $value.gramsPerUnit),
    food: data.get(#food, or: $value.food),
  );

  @override
  SendToEkkloFoodCopyWith<$R2, SendToEkkloFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendToEkkloFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SendAsOwnCopyMapper extends SubClassMapperBase<SendAsOwnCopy> {
  SendAsOwnCopyMapper._();

  static SendAsOwnCopyMapper? _instance;
  static SendAsOwnCopyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendAsOwnCopyMapper._());
      SendChoiceMapper.ensureInitialized().addSubMapper(_instance!);
      OwnCopyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendAsOwnCopy';

  static OwnCopy? _$reuse(SendAsOwnCopy v) => v.reuse;
  static const Field<SendAsOwnCopy, OwnCopy> _f$reuse = Field(
    'reuse',
    _$reuse,
    opt: true,
  );

  @override
  final MappableFields<SendAsOwnCopy> fields = const {#reuse: _f$reuse};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'choice';
  @override
  final dynamic discriminatorValue = 'own_copy';
  @override
  late final ClassMapperBase superMapper = SendChoiceMapper.ensureInitialized();

  static SendAsOwnCopy _instantiate(DecodingData data) {
    return SendAsOwnCopy(reuse: data.dec(_f$reuse));
  }

  @override
  final Function instantiate = _instantiate;

  static SendAsOwnCopy fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendAsOwnCopy>(map);
  }

  static SendAsOwnCopy fromJson(String json) {
    return ensureInitialized().decodeJson<SendAsOwnCopy>(json);
  }
}

mixin SendAsOwnCopyMappable {
  String toJson() {
    return SendAsOwnCopyMapper.ensureInitialized().encodeJson<SendAsOwnCopy>(
      this as SendAsOwnCopy,
    );
  }

  Map<String, dynamic> toMap() {
    return SendAsOwnCopyMapper.ensureInitialized().encodeMap<SendAsOwnCopy>(
      this as SendAsOwnCopy,
    );
  }

  SendAsOwnCopyCopyWith<SendAsOwnCopy, SendAsOwnCopy, SendAsOwnCopy>
  get copyWith => _SendAsOwnCopyCopyWithImpl<SendAsOwnCopy, SendAsOwnCopy>(
    this as SendAsOwnCopy,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SendAsOwnCopyMapper.ensureInitialized().stringifyValue(
      this as SendAsOwnCopy,
    );
  }

  @override
  bool operator ==(Object other) {
    return SendAsOwnCopyMapper.ensureInitialized().equalsValue(
      this as SendAsOwnCopy,
      other,
    );
  }

  @override
  int get hashCode {
    return SendAsOwnCopyMapper.ensureInitialized().hashValue(
      this as SendAsOwnCopy,
    );
  }
}

extension SendAsOwnCopyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SendAsOwnCopy, $Out> {
  SendAsOwnCopyCopyWith<$R, SendAsOwnCopy, $Out> get $asSendAsOwnCopy =>
      $base.as((v, t, t2) => _SendAsOwnCopyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SendAsOwnCopyCopyWith<$R, $In extends SendAsOwnCopy, $Out>
    implements SendChoiceCopyWith<$R, $In, $Out> {
  OwnCopyCopyWith<$R, OwnCopy, OwnCopy>? get reuse;
  @override
  $R call({OwnCopy? reuse});
  SendAsOwnCopyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SendAsOwnCopyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SendAsOwnCopy, $Out>
    implements SendAsOwnCopyCopyWith<$R, SendAsOwnCopy, $Out> {
  _SendAsOwnCopyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SendAsOwnCopy> $mapper =
      SendAsOwnCopyMapper.ensureInitialized();
  @override
  OwnCopyCopyWith<$R, OwnCopy, OwnCopy>? get reuse =>
      $value.reuse?.copyWith.$chain((v) => call(reuse: v));
  @override
  $R call({Object? reuse = $none}) =>
      $apply(FieldCopyWithData({if (reuse != $none) #reuse: reuse}));
  @override
  SendAsOwnCopy $make(CopyWithData data) =>
      SendAsOwnCopy(reuse: data.get(#reuse, or: $value.reuse));

  @override
  SendAsOwnCopyCopyWith<$R2, SendAsOwnCopy, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SendAsOwnCopyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SkipEntryMapper extends SubClassMapperBase<SkipEntry> {
  SkipEntryMapper._();

  static SkipEntryMapper? _instance;
  static SkipEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SkipEntryMapper._());
      SendChoiceMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SkipEntry';

  @override
  final MappableFields<SkipEntry> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'choice';
  @override
  final dynamic discriminatorValue = 'skip';
  @override
  late final ClassMapperBase superMapper = SendChoiceMapper.ensureInitialized();

  static SkipEntry _instantiate(DecodingData data) {
    return SkipEntry();
  }

  @override
  final Function instantiate = _instantiate;

  static SkipEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SkipEntry>(map);
  }

  static SkipEntry fromJson(String json) {
    return ensureInitialized().decodeJson<SkipEntry>(json);
  }
}

mixin SkipEntryMappable {
  String toJson() {
    return SkipEntryMapper.ensureInitialized().encodeJson<SkipEntry>(
      this as SkipEntry,
    );
  }

  Map<String, dynamic> toMap() {
    return SkipEntryMapper.ensureInitialized().encodeMap<SkipEntry>(
      this as SkipEntry,
    );
  }

  SkipEntryCopyWith<SkipEntry, SkipEntry, SkipEntry> get copyWith =>
      _SkipEntryCopyWithImpl<SkipEntry, SkipEntry>(
        this as SkipEntry,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SkipEntryMapper.ensureInitialized().stringifyValue(
      this as SkipEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    return SkipEntryMapper.ensureInitialized().equalsValue(
      this as SkipEntry,
      other,
    );
  }

  @override
  int get hashCode {
    return SkipEntryMapper.ensureInitialized().hashValue(this as SkipEntry);
  }
}

extension SkipEntryValueCopy<$R, $Out> on ObjectCopyWith<$R, SkipEntry, $Out> {
  SkipEntryCopyWith<$R, SkipEntry, $Out> get $asSkipEntry =>
      $base.as((v, t, t2) => _SkipEntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SkipEntryCopyWith<$R, $In extends SkipEntry, $Out>
    implements SendChoiceCopyWith<$R, $In, $Out> {
  @override
  $R call();
  SkipEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SkipEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SkipEntry, $Out>
    implements SkipEntryCopyWith<$R, SkipEntry, $Out> {
  _SkipEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SkipEntry> $mapper =
      SkipEntryMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SkipEntry $make(CopyWithData data) => SkipEntry();

  @override
  SkipEntryCopyWith<$R2, SkipEntry, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SkipEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

