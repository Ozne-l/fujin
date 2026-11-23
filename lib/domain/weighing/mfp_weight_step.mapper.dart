// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mfp_weight_step.dart';

class MfpWeightStepMapper extends ClassMapperBase<MfpWeightStep> {
  MfpWeightStepMapper._();

  static MfpWeightStepMapper? _instance;
  static MfpWeightStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpWeightStepMapper._());
      PostWeightMapper.ensureInitialized();
      AdoptMeasurementMapper.ensureInitialized();
      RemoveMeasurementMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpWeightStep';

  @override
  final MappableFields<MfpWeightStep> fields = const {};
  @override
  final bool ignoreNull = true;

  static MfpWeightStep _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'MfpWeightStep',
      'step',
      '${data.value['step']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpWeightStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpWeightStep>(map);
  }

  static MfpWeightStep fromJson(String json) {
    return ensureInitialized().decodeJson<MfpWeightStep>(json);
  }
}

mixin MfpWeightStepMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MfpWeightStepCopyWith<MfpWeightStep, MfpWeightStep, MfpWeightStep>
  get copyWith;
}

abstract class MfpWeightStepCopyWith<$R, $In extends MfpWeightStep, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MfpWeightStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class PostWeightMapper extends SubClassMapperBase<PostWeight> {
  PostWeightMapper._();

  static PostWeightMapper? _instance;
  static PostWeightMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostWeightMapper._());
      MfpWeightStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'PostWeight';

  @override
  final MappableFields<PostWeight> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'step';
  @override
  final dynamic discriminatorValue = 'post';
  @override
  late final ClassMapperBase superMapper =
      MfpWeightStepMapper.ensureInitialized();

  static PostWeight _instantiate(DecodingData data) {
    return PostWeight();
  }

  @override
  final Function instantiate = _instantiate;

  static PostWeight fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PostWeight>(map);
  }

  static PostWeight fromJson(String json) {
    return ensureInitialized().decodeJson<PostWeight>(json);
  }
}

mixin PostWeightMappable {
  String toJson() {
    return PostWeightMapper.ensureInitialized().encodeJson<PostWeight>(
      this as PostWeight,
    );
  }

  Map<String, dynamic> toMap() {
    return PostWeightMapper.ensureInitialized().encodeMap<PostWeight>(
      this as PostWeight,
    );
  }

  PostWeightCopyWith<PostWeight, PostWeight, PostWeight> get copyWith =>
      _PostWeightCopyWithImpl<PostWeight, PostWeight>(
        this as PostWeight,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PostWeightMapper.ensureInitialized().stringifyValue(
      this as PostWeight,
    );
  }

  @override
  bool operator ==(Object other) {
    return PostWeightMapper.ensureInitialized().equalsValue(
      this as PostWeight,
      other,
    );
  }

  @override
  int get hashCode {
    return PostWeightMapper.ensureInitialized().hashValue(this as PostWeight);
  }
}

extension PostWeightValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PostWeight, $Out> {
  PostWeightCopyWith<$R, PostWeight, $Out> get $asPostWeight =>
      $base.as((v, t, t2) => _PostWeightCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PostWeightCopyWith<$R, $In extends PostWeight, $Out>
    implements MfpWeightStepCopyWith<$R, $In, $Out> {
  @override
  $R call();
  PostWeightCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PostWeightCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PostWeight, $Out>
    implements PostWeightCopyWith<$R, PostWeight, $Out> {
  _PostWeightCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PostWeight> $mapper =
      PostWeightMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  PostWeight $make(CopyWithData data) => PostWeight();

  @override
  PostWeightCopyWith<$R2, PostWeight, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PostWeightCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AdoptMeasurementMapper extends SubClassMapperBase<AdoptMeasurement> {
  AdoptMeasurementMapper._();

  static AdoptMeasurementMapper? _instance;
  static AdoptMeasurementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AdoptMeasurementMapper._());
      MfpWeightStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'AdoptMeasurement';

  static String _$measurementId(AdoptMeasurement v) => v.measurementId;
  static const Field<AdoptMeasurement, String> _f$measurementId = Field(
    'measurementId',
    _$measurementId,
    key: r'measurement_id',
  );

  @override
  final MappableFields<AdoptMeasurement> fields = const {
    #measurementId: _f$measurementId,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'step';
  @override
  final dynamic discriminatorValue = 'adopt';
  @override
  late final ClassMapperBase superMapper =
      MfpWeightStepMapper.ensureInitialized();

  static AdoptMeasurement _instantiate(DecodingData data) {
    return AdoptMeasurement(data.dec(_f$measurementId));
  }

  @override
  final Function instantiate = _instantiate;

  static AdoptMeasurement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AdoptMeasurement>(map);
  }

  static AdoptMeasurement fromJson(String json) {
    return ensureInitialized().decodeJson<AdoptMeasurement>(json);
  }
}

mixin AdoptMeasurementMappable {
  String toJson() {
    return AdoptMeasurementMapper.ensureInitialized()
        .encodeJson<AdoptMeasurement>(this as AdoptMeasurement);
  }

  Map<String, dynamic> toMap() {
    return AdoptMeasurementMapper.ensureInitialized()
        .encodeMap<AdoptMeasurement>(this as AdoptMeasurement);
  }

  AdoptMeasurementCopyWith<AdoptMeasurement, AdoptMeasurement, AdoptMeasurement>
  get copyWith =>
      _AdoptMeasurementCopyWithImpl<AdoptMeasurement, AdoptMeasurement>(
        this as AdoptMeasurement,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AdoptMeasurementMapper.ensureInitialized().stringifyValue(
      this as AdoptMeasurement,
    );
  }

  @override
  bool operator ==(Object other) {
    return AdoptMeasurementMapper.ensureInitialized().equalsValue(
      this as AdoptMeasurement,
      other,
    );
  }

  @override
  int get hashCode {
    return AdoptMeasurementMapper.ensureInitialized().hashValue(
      this as AdoptMeasurement,
    );
  }
}

extension AdoptMeasurementValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AdoptMeasurement, $Out> {
  AdoptMeasurementCopyWith<$R, AdoptMeasurement, $Out>
  get $asAdoptMeasurement =>
      $base.as((v, t, t2) => _AdoptMeasurementCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AdoptMeasurementCopyWith<$R, $In extends AdoptMeasurement, $Out>
    implements MfpWeightStepCopyWith<$R, $In, $Out> {
  @override
  $R call({String? measurementId});
  AdoptMeasurementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AdoptMeasurementCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AdoptMeasurement, $Out>
    implements AdoptMeasurementCopyWith<$R, AdoptMeasurement, $Out> {
  _AdoptMeasurementCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AdoptMeasurement> $mapper =
      AdoptMeasurementMapper.ensureInitialized();
  @override
  $R call({String? measurementId}) => $apply(
    FieldCopyWithData({
      if (measurementId != null) #measurementId: measurementId,
    }),
  );
  @override
  AdoptMeasurement $make(CopyWithData data) =>
      AdoptMeasurement(data.get(#measurementId, or: $value.measurementId));

  @override
  AdoptMeasurementCopyWith<$R2, AdoptMeasurement, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AdoptMeasurementCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RemoveMeasurementMapper extends SubClassMapperBase<RemoveMeasurement> {
  RemoveMeasurementMapper._();

  static RemoveMeasurementMapper? _instance;
  static RemoveMeasurementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveMeasurementMapper._());
      MfpWeightStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveMeasurement';

  static String _$measurementId(RemoveMeasurement v) => v.measurementId;
  static const Field<RemoveMeasurement, String> _f$measurementId = Field(
    'measurementId',
    _$measurementId,
    key: r'measurement_id',
  );

  @override
  final MappableFields<RemoveMeasurement> fields = const {
    #measurementId: _f$measurementId,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'step';
  @override
  final dynamic discriminatorValue = 'remove';
  @override
  late final ClassMapperBase superMapper =
      MfpWeightStepMapper.ensureInitialized();

  static RemoveMeasurement _instantiate(DecodingData data) {
    return RemoveMeasurement(data.dec(_f$measurementId));
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveMeasurement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveMeasurement>(map);
  }

  static RemoveMeasurement fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveMeasurement>(json);
  }
}

mixin RemoveMeasurementMappable {
  String toJson() {
    return RemoveMeasurementMapper.ensureInitialized()
        .encodeJson<RemoveMeasurement>(this as RemoveMeasurement);
  }

  Map<String, dynamic> toMap() {
    return RemoveMeasurementMapper.ensureInitialized()
        .encodeMap<RemoveMeasurement>(this as RemoveMeasurement);
  }

  RemoveMeasurementCopyWith<
    RemoveMeasurement,
    RemoveMeasurement,
    RemoveMeasurement
  >
  get copyWith =>
      _RemoveMeasurementCopyWithImpl<RemoveMeasurement, RemoveMeasurement>(
        this as RemoveMeasurement,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoveMeasurementMapper.ensureInitialized().stringifyValue(
      this as RemoveMeasurement,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoveMeasurementMapper.ensureInitialized().equalsValue(
      this as RemoveMeasurement,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoveMeasurementMapper.ensureInitialized().hashValue(
      this as RemoveMeasurement,
    );
  }
}

extension RemoveMeasurementValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoveMeasurement, $Out> {
  RemoveMeasurementCopyWith<$R, RemoveMeasurement, $Out>
  get $asRemoveMeasurement => $base.as(
    (v, t, t2) => _RemoveMeasurementCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RemoveMeasurementCopyWith<
  $R,
  $In extends RemoveMeasurement,
  $Out
>
    implements MfpWeightStepCopyWith<$R, $In, $Out> {
  @override
  $R call({String? measurementId});
  RemoveMeasurementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RemoveMeasurementCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoveMeasurement, $Out>
    implements RemoveMeasurementCopyWith<$R, RemoveMeasurement, $Out> {
  _RemoveMeasurementCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoveMeasurement> $mapper =
      RemoveMeasurementMapper.ensureInitialized();
  @override
  $R call({String? measurementId}) => $apply(
    FieldCopyWithData({
      if (measurementId != null) #measurementId: measurementId,
    }),
  );
  @override
  RemoveMeasurement $make(CopyWithData data) =>
      RemoveMeasurement(data.get(#measurementId, or: $value.measurementId));

  @override
  RemoveMeasurementCopyWith<$R2, RemoveMeasurement, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoveMeasurementCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

