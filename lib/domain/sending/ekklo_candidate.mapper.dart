// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ekklo_candidate.dart';

class EkkloCandidateMapper extends ClassMapperBase<EkkloCandidate> {
  EkkloCandidateMapper._();

  static EkkloCandidateMapper? _instance;
  static EkkloCandidateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloCandidateMapper._());
      EkkloFoodMapper.ensureInitialized();
      NutrientDeltasMapper.ensureInitialized();
      NameMatchMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloCandidate';

  static EkkloFood _$food(EkkloCandidate v) => v.food;
  static const Field<EkkloCandidate, EkkloFood> _f$food = Field('food', _$food);
  static double _$grams(EkkloCandidate v) => v.grams;
  static const Field<EkkloCandidate, double> _f$grams = Field('grams', _$grams);
  static bool _$gramsInferred(EkkloCandidate v) => v.gramsInferred;
  static const Field<EkkloCandidate, bool> _f$gramsInferred = Field(
    'gramsInferred',
    _$gramsInferred,
    key: r'grams_inferred',
  );
  static NutrientDeltas _$deltas(EkkloCandidate v) => v.deltas;
  static const Field<EkkloCandidate, NutrientDeltas> _f$deltas = Field(
    'deltas',
    _$deltas,
  );
  static NameMatch _$nameMatch(EkkloCandidate v) => v.nameMatch;
  static const Field<EkkloCandidate, NameMatch> _f$nameMatch = Field(
    'nameMatch',
    _$nameMatch,
    key: r'name_match',
  );

  @override
  final MappableFields<EkkloCandidate> fields = const {
    #food: _f$food,
    #grams: _f$grams,
    #gramsInferred: _f$gramsInferred,
    #deltas: _f$deltas,
    #nameMatch: _f$nameMatch,
  };
  @override
  final bool ignoreNull = true;

  static EkkloCandidate _instantiate(DecodingData data) {
    return EkkloCandidate(
      food: data.dec(_f$food),
      grams: data.dec(_f$grams),
      gramsInferred: data.dec(_f$gramsInferred),
      deltas: data.dec(_f$deltas),
      nameMatch: data.dec(_f$nameMatch),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloCandidate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloCandidate>(map);
  }

  static EkkloCandidate fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloCandidate>(json);
  }
}

mixin EkkloCandidateMappable {
  String toJson() {
    return EkkloCandidateMapper.ensureInitialized().encodeJson<EkkloCandidate>(
      this as EkkloCandidate,
    );
  }

  Map<String, dynamic> toMap() {
    return EkkloCandidateMapper.ensureInitialized().encodeMap<EkkloCandidate>(
      this as EkkloCandidate,
    );
  }

  EkkloCandidateCopyWith<EkkloCandidate, EkkloCandidate, EkkloCandidate>
  get copyWith => _EkkloCandidateCopyWithImpl<EkkloCandidate, EkkloCandidate>(
    this as EkkloCandidate,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return EkkloCandidateMapper.ensureInitialized().stringifyValue(
      this as EkkloCandidate,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloCandidateMapper.ensureInitialized().equalsValue(
      this as EkkloCandidate,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloCandidateMapper.ensureInitialized().hashValue(
      this as EkkloCandidate,
    );
  }
}

extension EkkloCandidateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloCandidate, $Out> {
  EkkloCandidateCopyWith<$R, EkkloCandidate, $Out> get $asEkkloCandidate =>
      $base.as((v, t, t2) => _EkkloCandidateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloCandidateCopyWith<$R, $In extends EkkloCandidate, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EkkloFoodCopyWith<$R, EkkloFood, EkkloFood> get food;
  NutrientDeltasCopyWith<$R, NutrientDeltas, NutrientDeltas> get deltas;
  $R call({
    EkkloFood? food,
    double? grams,
    bool? gramsInferred,
    NutrientDeltas? deltas,
    NameMatch? nameMatch,
  });
  EkkloCandidateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloCandidateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloCandidate, $Out>
    implements EkkloCandidateCopyWith<$R, EkkloCandidate, $Out> {
  _EkkloCandidateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloCandidate> $mapper =
      EkkloCandidateMapper.ensureInitialized();
  @override
  EkkloFoodCopyWith<$R, EkkloFood, EkkloFood> get food =>
      $value.food.copyWith.$chain((v) => call(food: v));
  @override
  NutrientDeltasCopyWith<$R, NutrientDeltas, NutrientDeltas> get deltas =>
      $value.deltas.copyWith.$chain((v) => call(deltas: v));
  @override
  $R call({
    EkkloFood? food,
    double? grams,
    bool? gramsInferred,
    NutrientDeltas? deltas,
    NameMatch? nameMatch,
  }) => $apply(
    FieldCopyWithData({
      if (food != null) #food: food,
      if (grams != null) #grams: grams,
      if (gramsInferred != null) #gramsInferred: gramsInferred,
      if (deltas != null) #deltas: deltas,
      if (nameMatch != null) #nameMatch: nameMatch,
    }),
  );
  @override
  EkkloCandidate $make(CopyWithData data) => EkkloCandidate(
    food: data.get(#food, or: $value.food),
    grams: data.get(#grams, or: $value.grams),
    gramsInferred: data.get(#gramsInferred, or: $value.gramsInferred),
    deltas: data.get(#deltas, or: $value.deltas),
    nameMatch: data.get(#nameMatch, or: $value.nameMatch),
  );

  @override
  EkkloCandidateCopyWith<$R2, EkkloCandidate, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloCandidateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

