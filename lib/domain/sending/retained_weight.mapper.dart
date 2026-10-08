// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'retained_weight.dart';

class RetainedWeightMapper extends ClassMapperBase<RetainedWeight> {
  RetainedWeightMapper._();

  static RetainedWeightMapper? _instance;
  static RetainedWeightMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RetainedWeightMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RetainedWeight';

  static String _$unit(RetainedWeight v) => v.unit;
  static const Field<RetainedWeight, String> _f$unit = Field('unit', _$unit);
  static double _$grams(RetainedWeight v) => v.grams;
  static const Field<RetainedWeight, double> _f$grams = Field('grams', _$grams);

  @override
  final MappableFields<RetainedWeight> fields = const {
    #unit: _f$unit,
    #grams: _f$grams,
  };
  @override
  final bool ignoreNull = true;

  static RetainedWeight _instantiate(DecodingData data) {
    return RetainedWeight(unit: data.dec(_f$unit), grams: data.dec(_f$grams));
  }

  @override
  final Function instantiate = _instantiate;

  static RetainedWeight fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RetainedWeight>(map);
  }

  static RetainedWeight fromJson(String json) {
    return ensureInitialized().decodeJson<RetainedWeight>(json);
  }
}

mixin RetainedWeightMappable {
  String toJson() {
    return RetainedWeightMapper.ensureInitialized().encodeJson<RetainedWeight>(
      this as RetainedWeight,
    );
  }

  Map<String, dynamic> toMap() {
    return RetainedWeightMapper.ensureInitialized().encodeMap<RetainedWeight>(
      this as RetainedWeight,
    );
  }

  RetainedWeightCopyWith<RetainedWeight, RetainedWeight, RetainedWeight>
  get copyWith => _RetainedWeightCopyWithImpl<RetainedWeight, RetainedWeight>(
    this as RetainedWeight,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RetainedWeightMapper.ensureInitialized().stringifyValue(
      this as RetainedWeight,
    );
  }

  @override
  bool operator ==(Object other) {
    return RetainedWeightMapper.ensureInitialized().equalsValue(
      this as RetainedWeight,
      other,
    );
  }

  @override
  int get hashCode {
    return RetainedWeightMapper.ensureInitialized().hashValue(
      this as RetainedWeight,
    );
  }
}

extension RetainedWeightValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RetainedWeight, $Out> {
  RetainedWeightCopyWith<$R, RetainedWeight, $Out> get $asRetainedWeight =>
      $base.as((v, t, t2) => _RetainedWeightCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RetainedWeightCopyWith<$R, $In extends RetainedWeight, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? unit, double? grams});
  RetainedWeightCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RetainedWeightCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RetainedWeight, $Out>
    implements RetainedWeightCopyWith<$R, RetainedWeight, $Out> {
  _RetainedWeightCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RetainedWeight> $mapper =
      RetainedWeightMapper.ensureInitialized();
  @override
  $R call({String? unit, double? grams}) => $apply(
    FieldCopyWithData({
      if (unit != null) #unit: unit,
      if (grams != null) #grams: grams,
    }),
  );
  @override
  RetainedWeight $make(CopyWithData data) => RetainedWeight(
    unit: data.get(#unit, or: $value.unit),
    grams: data.get(#grams, or: $value.grams),
  );

  @override
  RetainedWeightCopyWith<$R2, RetainedWeight, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RetainedWeightCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

