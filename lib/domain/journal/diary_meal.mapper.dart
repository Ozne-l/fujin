// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'diary_meal.dart';

class DiaryMealMapper extends ClassMapperBase<DiaryMeal> {
  DiaryMealMapper._();

  static DiaryMealMapper? _instance;
  static DiaryMealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DiaryMealMapper._());
      MfpFoodEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DiaryMeal';

  static String _$name(DiaryMeal v) => v.name;
  static const Field<DiaryMeal, String> _f$name = Field('name', _$name);
  static List<MfpFoodEntry> _$entries(DiaryMeal v) => v.entries;
  static const Field<DiaryMeal, List<MfpFoodEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<DiaryMeal> fields = const {
    #name: _f$name,
    #entries: _f$entries,
  };
  @override
  final bool ignoreNull = true;

  static DiaryMeal _instantiate(DecodingData data) {
    return DiaryMeal(name: data.dec(_f$name), entries: data.dec(_f$entries));
  }

  @override
  final Function instantiate = _instantiate;

  static DiaryMeal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DiaryMeal>(map);
  }

  static DiaryMeal fromJson(String json) {
    return ensureInitialized().decodeJson<DiaryMeal>(json);
  }
}

mixin DiaryMealMappable {
  String toJson() {
    return DiaryMealMapper.ensureInitialized().encodeJson<DiaryMeal>(
      this as DiaryMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return DiaryMealMapper.ensureInitialized().encodeMap<DiaryMeal>(
      this as DiaryMeal,
    );
  }

  DiaryMealCopyWith<DiaryMeal, DiaryMeal, DiaryMeal> get copyWith =>
      _DiaryMealCopyWithImpl<DiaryMeal, DiaryMeal>(
        this as DiaryMeal,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DiaryMealMapper.ensureInitialized().stringifyValue(
      this as DiaryMeal,
    );
  }

  @override
  bool operator ==(Object other) {
    return DiaryMealMapper.ensureInitialized().equalsValue(
      this as DiaryMeal,
      other,
    );
  }

  @override
  int get hashCode {
    return DiaryMealMapper.ensureInitialized().hashValue(this as DiaryMeal);
  }
}

extension DiaryMealValueCopy<$R, $Out> on ObjectCopyWith<$R, DiaryMeal, $Out> {
  DiaryMealCopyWith<$R, DiaryMeal, $Out> get $asDiaryMeal =>
      $base.as((v, t, t2) => _DiaryMealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DiaryMealCopyWith<$R, $In extends DiaryMeal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MfpFoodEntry,
    MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry>
  >
  get entries;
  $R call({String? name, List<MfpFoodEntry>? entries});
  DiaryMealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DiaryMealCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DiaryMeal, $Out>
    implements DiaryMealCopyWith<$R, DiaryMeal, $Out> {
  _DiaryMealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DiaryMeal> $mapper =
      DiaryMealMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MfpFoodEntry,
    MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry>
  >
  get entries => ListCopyWith(
    $value.entries,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(entries: v),
  );
  @override
  $R call({String? name, List<MfpFoodEntry>? entries}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (entries != null) #entries: entries,
    }),
  );
  @override
  DiaryMeal $make(CopyWithData data) => DiaryMeal(
    name: data.get(#name, or: $value.name),
    entries: data.get(#entries, or: $value.entries),
  );

  @override
  DiaryMealCopyWith<$R2, DiaryMeal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DiaryMealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

