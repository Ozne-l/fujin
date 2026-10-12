// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'add_draft.dart';

class AddDraftMapper extends ClassMapperBase<AddDraft> {
  AddDraftMapper._();

  static AddDraftMapper? _instance;
  static AddDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddDraftMapper._());
      MfpFoodMapper.ensureInitialized();
      MfpServingSizeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddDraft';

  static MfpFood _$food(AddDraft v) => v.food;
  static const Field<AddDraft, MfpFood> _f$food = Field('food', _$food);
  static MfpServingSize _$servingSize(AddDraft v) => v.servingSize;
  static const Field<AddDraft, MfpServingSize> _f$servingSize = Field(
    'servingSize',
    _$servingSize,
    key: r'serving_size',
  );
  static double _$servings(AddDraft v) => v.servings;
  static const Field<AddDraft, double> _f$servings = Field(
    'servings',
    _$servings,
  );
  static String _$mfpMealName(AddDraft v) => v.mfpMealName;
  static const Field<AddDraft, String> _f$mfpMealName = Field(
    'mfpMealName',
    _$mfpMealName,
    key: r'mfp_meal_name',
  );
  static DateTime _$date(AddDraft v) => v.date;
  static const Field<AddDraft, DateTime> _f$date = Field('date', _$date);

  @override
  final MappableFields<AddDraft> fields = const {
    #food: _f$food,
    #servingSize: _f$servingSize,
    #servings: _f$servings,
    #mfpMealName: _f$mfpMealName,
    #date: _f$date,
  };
  @override
  final bool ignoreNull = true;

  static AddDraft _instantiate(DecodingData data) {
    return AddDraft(
      food: data.dec(_f$food),
      servingSize: data.dec(_f$servingSize),
      servings: data.dec(_f$servings),
      mfpMealName: data.dec(_f$mfpMealName),
      date: data.dec(_f$date),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddDraft>(map);
  }

  static AddDraft fromJson(String json) {
    return ensureInitialized().decodeJson<AddDraft>(json);
  }
}

mixin AddDraftMappable {
  String toJson() {
    return AddDraftMapper.ensureInitialized().encodeJson<AddDraft>(
      this as AddDraft,
    );
  }

  Map<String, dynamic> toMap() {
    return AddDraftMapper.ensureInitialized().encodeMap<AddDraft>(
      this as AddDraft,
    );
  }

  AddDraftCopyWith<AddDraft, AddDraft, AddDraft> get copyWith =>
      _AddDraftCopyWithImpl<AddDraft, AddDraft>(
        this as AddDraft,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddDraftMapper.ensureInitialized().stringifyValue(this as AddDraft);
  }

  @override
  bool operator ==(Object other) {
    return AddDraftMapper.ensureInitialized().equalsValue(
      this as AddDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return AddDraftMapper.ensureInitialized().hashValue(this as AddDraft);
  }
}

extension AddDraftValueCopy<$R, $Out> on ObjectCopyWith<$R, AddDraft, $Out> {
  AddDraftCopyWith<$R, AddDraft, $Out> get $asAddDraft =>
      $base.as((v, t, t2) => _AddDraftCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddDraftCopyWith<$R, $In extends AddDraft, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MfpFoodCopyWith<$R, MfpFood, MfpFood> get food;
  MfpServingSizeCopyWith<$R, MfpServingSize, MfpServingSize> get servingSize;
  $R call({
    MfpFood? food,
    MfpServingSize? servingSize,
    double? servings,
    String? mfpMealName,
    DateTime? date,
  });
  AddDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddDraft, $Out>
    implements AddDraftCopyWith<$R, AddDraft, $Out> {
  _AddDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddDraft> $mapper =
      AddDraftMapper.ensureInitialized();
  @override
  MfpFoodCopyWith<$R, MfpFood, MfpFood> get food =>
      $value.food.copyWith.$chain((v) => call(food: v));
  @override
  MfpServingSizeCopyWith<$R, MfpServingSize, MfpServingSize> get servingSize =>
      $value.servingSize.copyWith.$chain((v) => call(servingSize: v));
  @override
  $R call({
    MfpFood? food,
    MfpServingSize? servingSize,
    double? servings,
    String? mfpMealName,
    DateTime? date,
  }) => $apply(
    FieldCopyWithData({
      if (food != null) #food: food,
      if (servingSize != null) #servingSize: servingSize,
      if (servings != null) #servings: servings,
      if (mfpMealName != null) #mfpMealName: mfpMealName,
      if (date != null) #date: date,
    }),
  );
  @override
  AddDraft $make(CopyWithData data) => AddDraft(
    food: data.get(#food, or: $value.food),
    servingSize: data.get(#servingSize, or: $value.servingSize),
    servings: data.get(#servings, or: $value.servings),
    mfpMealName: data.get(#mfpMealName, or: $value.mfpMealName),
    date: data.get(#date, or: $value.date),
  );

  @override
  AddDraftCopyWith<$R2, AddDraft, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

