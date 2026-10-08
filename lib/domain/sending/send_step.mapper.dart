// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_step.dart';

class SendStepMapper extends ClassMapperBase<SendStep> {
  SendStepMapper._();

  static SendStepMapper? _instance;
  static SendStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendStepMapper._());
      OwnCopyStepMapper.ensureInitialized();
      QuantityUpdateStepMapper.ensureInitialized();
      MealStepMapper.ensureInitialized();
      StepStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SendStep';

  static StepState _$state(SendStep v) => v.state;
  static const Field<SendStep, StepState> _f$state = Field(
    'state',
    _$state,
    opt: true,
    def: StepState.pending,
  );

  @override
  final MappableFields<SendStep> fields = const {#state: _f$state};
  @override
  final bool ignoreNull = true;

  static SendStep _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'SendStep',
      'step',
      '${data.value['step']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SendStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SendStep>(map);
  }

  static SendStep fromJson(String json) {
    return ensureInitialized().decodeJson<SendStep>(json);
  }
}

mixin SendStepMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SendStepCopyWith<SendStep, SendStep, SendStep> get copyWith;
}

abstract class SendStepCopyWith<$R, $In extends SendStep, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({StepState? state});
  SendStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class OwnCopyStepMapper extends SubClassMapperBase<OwnCopyStep> {
  OwnCopyStepMapper._();

  static OwnCopyStepMapper? _instance;
  static OwnCopyStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OwnCopyStepMapper._());
      SendStepMapper.ensureInitialized().addSubMapper(_instance!);
      StepStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OwnCopyStep';

  static String _$mfpFoodId(OwnCopyStep v) => v.mfpFoodId;
  static const Field<OwnCopyStep, String> _f$mfpFoodId = Field(
    'mfpFoodId',
    _$mfpFoodId,
    key: r'mfp_food_id',
  );
  static String _$name(OwnCopyStep v) => v.name;
  static const Field<OwnCopyStep, String> _f$name = Field('name', _$name);
  static StepState _$state(OwnCopyStep v) => v.state;
  static const Field<OwnCopyStep, StepState> _f$state = Field(
    'state',
    _$state,
    opt: true,
    def: StepState.pending,
  );

  @override
  final MappableFields<OwnCopyStep> fields = const {
    #mfpFoodId: _f$mfpFoodId,
    #name: _f$name,
    #state: _f$state,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'step';
  @override
  final dynamic discriminatorValue = 'own_copy';
  @override
  late final ClassMapperBase superMapper = SendStepMapper.ensureInitialized();

  static OwnCopyStep _instantiate(DecodingData data) {
    return OwnCopyStep(
      mfpFoodId: data.dec(_f$mfpFoodId),
      name: data.dec(_f$name),
      state: data.dec(_f$state),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OwnCopyStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OwnCopyStep>(map);
  }

  static OwnCopyStep fromJson(String json) {
    return ensureInitialized().decodeJson<OwnCopyStep>(json);
  }
}

mixin OwnCopyStepMappable {
  String toJson() {
    return OwnCopyStepMapper.ensureInitialized().encodeJson<OwnCopyStep>(
      this as OwnCopyStep,
    );
  }

  Map<String, dynamic> toMap() {
    return OwnCopyStepMapper.ensureInitialized().encodeMap<OwnCopyStep>(
      this as OwnCopyStep,
    );
  }

  OwnCopyStepCopyWith<OwnCopyStep, OwnCopyStep, OwnCopyStep> get copyWith =>
      _OwnCopyStepCopyWithImpl<OwnCopyStep, OwnCopyStep>(
        this as OwnCopyStep,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return OwnCopyStepMapper.ensureInitialized().stringifyValue(
      this as OwnCopyStep,
    );
  }

  @override
  bool operator ==(Object other) {
    return OwnCopyStepMapper.ensureInitialized().equalsValue(
      this as OwnCopyStep,
      other,
    );
  }

  @override
  int get hashCode {
    return OwnCopyStepMapper.ensureInitialized().hashValue(this as OwnCopyStep);
  }
}

extension OwnCopyStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OwnCopyStep, $Out> {
  OwnCopyStepCopyWith<$R, OwnCopyStep, $Out> get $asOwnCopyStep =>
      $base.as((v, t, t2) => _OwnCopyStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OwnCopyStepCopyWith<$R, $In extends OwnCopyStep, $Out>
    implements SendStepCopyWith<$R, $In, $Out> {
  @override
  $R call({String? mfpFoodId, String? name, StepState? state});
  OwnCopyStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OwnCopyStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OwnCopyStep, $Out>
    implements OwnCopyStepCopyWith<$R, OwnCopyStep, $Out> {
  _OwnCopyStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OwnCopyStep> $mapper =
      OwnCopyStepMapper.ensureInitialized();
  @override
  $R call({String? mfpFoodId, String? name, StepState? state}) => $apply(
    FieldCopyWithData({
      if (mfpFoodId != null) #mfpFoodId: mfpFoodId,
      if (name != null) #name: name,
      if (state != null) #state: state,
    }),
  );
  @override
  OwnCopyStep $make(CopyWithData data) => OwnCopyStep(
    mfpFoodId: data.get(#mfpFoodId, or: $value.mfpFoodId),
    name: data.get(#name, or: $value.name),
    state: data.get(#state, or: $value.state),
  );

  @override
  OwnCopyStepCopyWith<$R2, OwnCopyStep, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _OwnCopyStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class QuantityUpdateStepMapper extends SubClassMapperBase<QuantityUpdateStep> {
  QuantityUpdateStepMapper._();

  static QuantityUpdateStepMapper? _instance;
  static QuantityUpdateStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuantityUpdateStepMapper._());
      SendStepMapper.ensureInitialized().addSubMapper(_instance!);
      StepStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'QuantityUpdateStep';

  static String _$entryId(QuantityUpdateStep v) => v.entryId;
  static const Field<QuantityUpdateStep, String> _f$entryId = Field(
    'entryId',
    _$entryId,
    key: r'entry_id',
  );
  static String _$name(QuantityUpdateStep v) => v.name;
  static const Field<QuantityUpdateStep, String> _f$name = Field(
    'name',
    _$name,
  );
  static StepState _$state(QuantityUpdateStep v) => v.state;
  static const Field<QuantityUpdateStep, StepState> _f$state = Field(
    'state',
    _$state,
    opt: true,
    def: StepState.pending,
  );

  @override
  final MappableFields<QuantityUpdateStep> fields = const {
    #entryId: _f$entryId,
    #name: _f$name,
    #state: _f$state,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'step';
  @override
  final dynamic discriminatorValue = 'quantity_update';
  @override
  late final ClassMapperBase superMapper = SendStepMapper.ensureInitialized();

  static QuantityUpdateStep _instantiate(DecodingData data) {
    return QuantityUpdateStep(
      entryId: data.dec(_f$entryId),
      name: data.dec(_f$name),
      state: data.dec(_f$state),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuantityUpdateStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuantityUpdateStep>(map);
  }

  static QuantityUpdateStep fromJson(String json) {
    return ensureInitialized().decodeJson<QuantityUpdateStep>(json);
  }
}

mixin QuantityUpdateStepMappable {
  String toJson() {
    return QuantityUpdateStepMapper.ensureInitialized()
        .encodeJson<QuantityUpdateStep>(this as QuantityUpdateStep);
  }

  Map<String, dynamic> toMap() {
    return QuantityUpdateStepMapper.ensureInitialized()
        .encodeMap<QuantityUpdateStep>(this as QuantityUpdateStep);
  }

  QuantityUpdateStepCopyWith<
    QuantityUpdateStep,
    QuantityUpdateStep,
    QuantityUpdateStep
  >
  get copyWith =>
      _QuantityUpdateStepCopyWithImpl<QuantityUpdateStep, QuantityUpdateStep>(
        this as QuantityUpdateStep,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuantityUpdateStepMapper.ensureInitialized().stringifyValue(
      this as QuantityUpdateStep,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuantityUpdateStepMapper.ensureInitialized().equalsValue(
      this as QuantityUpdateStep,
      other,
    );
  }

  @override
  int get hashCode {
    return QuantityUpdateStepMapper.ensureInitialized().hashValue(
      this as QuantityUpdateStep,
    );
  }
}

extension QuantityUpdateStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuantityUpdateStep, $Out> {
  QuantityUpdateStepCopyWith<$R, QuantityUpdateStep, $Out>
  get $asQuantityUpdateStep => $base.as(
    (v, t, t2) => _QuantityUpdateStepCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class QuantityUpdateStepCopyWith<
  $R,
  $In extends QuantityUpdateStep,
  $Out
>
    implements SendStepCopyWith<$R, $In, $Out> {
  @override
  $R call({String? entryId, String? name, StepState? state});
  QuantityUpdateStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _QuantityUpdateStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuantityUpdateStep, $Out>
    implements QuantityUpdateStepCopyWith<$R, QuantityUpdateStep, $Out> {
  _QuantityUpdateStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuantityUpdateStep> $mapper =
      QuantityUpdateStepMapper.ensureInitialized();
  @override
  $R call({String? entryId, String? name, StepState? state}) => $apply(
    FieldCopyWithData({
      if (entryId != null) #entryId: entryId,
      if (name != null) #name: name,
      if (state != null) #state: state,
    }),
  );
  @override
  QuantityUpdateStep $make(CopyWithData data) => QuantityUpdateStep(
    entryId: data.get(#entryId, or: $value.entryId),
    name: data.get(#name, or: $value.name),
    state: data.get(#state, or: $value.state),
  );

  @override
  QuantityUpdateStepCopyWith<$R2, QuantityUpdateStep, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuantityUpdateStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MealStepMapper extends SubClassMapperBase<MealStep> {
  MealStepMapper._();

  static MealStepMapper? _instance;
  static MealStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealStepMapper._());
      SendStepMapper.ensureInitialized().addSubMapper(_instance!);
      StepStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MealStep';

  static String _$ekkloMealName(MealStep v) => v.ekkloMealName;
  static const Field<MealStep, String> _f$ekkloMealName = Field(
    'ekkloMealName',
    _$ekkloMealName,
    key: r'ekklo_meal_name',
  );
  static List<String> _$entryIds(MealStep v) => v.entryIds;
  static const Field<MealStep, List<String>> _f$entryIds = Field(
    'entryIds',
    _$entryIds,
    key: r'entry_ids',
  );
  static StepState _$state(MealStep v) => v.state;
  static const Field<MealStep, StepState> _f$state = Field(
    'state',
    _$state,
    opt: true,
    def: StepState.pending,
  );

  @override
  final MappableFields<MealStep> fields = const {
    #ekkloMealName: _f$ekkloMealName,
    #entryIds: _f$entryIds,
    #state: _f$state,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'step';
  @override
  final dynamic discriminatorValue = 'meal';
  @override
  late final ClassMapperBase superMapper = SendStepMapper.ensureInitialized();

  static MealStep _instantiate(DecodingData data) {
    return MealStep(
      ekkloMealName: data.dec(_f$ekkloMealName),
      entryIds: data.dec(_f$entryIds),
      state: data.dec(_f$state),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MealStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MealStep>(map);
  }

  static MealStep fromJson(String json) {
    return ensureInitialized().decodeJson<MealStep>(json);
  }
}

mixin MealStepMappable {
  String toJson() {
    return MealStepMapper.ensureInitialized().encodeJson<MealStep>(
      this as MealStep,
    );
  }

  Map<String, dynamic> toMap() {
    return MealStepMapper.ensureInitialized().encodeMap<MealStep>(
      this as MealStep,
    );
  }

  MealStepCopyWith<MealStep, MealStep, MealStep> get copyWith =>
      _MealStepCopyWithImpl<MealStep, MealStep>(
        this as MealStep,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MealStepMapper.ensureInitialized().stringifyValue(this as MealStep);
  }

  @override
  bool operator ==(Object other) {
    return MealStepMapper.ensureInitialized().equalsValue(
      this as MealStep,
      other,
    );
  }

  @override
  int get hashCode {
    return MealStepMapper.ensureInitialized().hashValue(this as MealStep);
  }
}

extension MealStepValueCopy<$R, $Out> on ObjectCopyWith<$R, MealStep, $Out> {
  MealStepCopyWith<$R, MealStep, $Out> get $asMealStep =>
      $base.as((v, t, t2) => _MealStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MealStepCopyWith<$R, $In extends MealStep, $Out>
    implements SendStepCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get entryIds;
  @override
  $R call({String? ekkloMealName, List<String>? entryIds, StepState? state});
  MealStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MealStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MealStep, $Out>
    implements MealStepCopyWith<$R, MealStep, $Out> {
  _MealStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MealStep> $mapper =
      MealStepMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get entryIds =>
      ListCopyWith(
        $value.entryIds,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(entryIds: v),
      );
  @override
  $R call({String? ekkloMealName, List<String>? entryIds, StepState? state}) =>
      $apply(
        FieldCopyWithData({
          if (ekkloMealName != null) #ekkloMealName: ekkloMealName,
          if (entryIds != null) #entryIds: entryIds,
          if (state != null) #state: state,
        }),
      );
  @override
  MealStep $make(CopyWithData data) => MealStep(
    ekkloMealName: data.get(#ekkloMealName, or: $value.ekkloMealName),
    entryIds: data.get(#entryIds, or: $value.entryIds),
    state: data.get(#state, or: $value.state),
  );

  @override
  MealStepCopyWith<$R2, MealStep, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MealStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

