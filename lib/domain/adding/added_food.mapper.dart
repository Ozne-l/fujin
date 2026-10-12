// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'added_food.dart';

class AddedFoodMapper extends ClassMapperBase<AddedFood> {
  AddedFoodMapper._();

  static AddedFoodMapper? _instance;
  static AddedFoodMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddedFoodMapper._());
      PlannedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddedFood';

  static PlannedEntry _$planned(AddedFood v) => v.planned;
  static const Field<AddedFood, PlannedEntry> _f$planned = Field(
    'planned',
    _$planned,
  );
  static bool _$ekkloWritten(AddedFood v) => v.ekkloWritten;
  static const Field<AddedFood, bool> _f$ekkloWritten = Field(
    'ekkloWritten',
    _$ekkloWritten,
    key: r'ekklo_written',
  );

  @override
  final MappableFields<AddedFood> fields = const {
    #planned: _f$planned,
    #ekkloWritten: _f$ekkloWritten,
  };
  @override
  final bool ignoreNull = true;

  static AddedFood _instantiate(DecodingData data) {
    return AddedFood(
      planned: data.dec(_f$planned),
      ekkloWritten: data.dec(_f$ekkloWritten),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddedFood fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddedFood>(map);
  }

  static AddedFood fromJson(String json) {
    return ensureInitialized().decodeJson<AddedFood>(json);
  }
}

mixin AddedFoodMappable {
  String toJson() {
    return AddedFoodMapper.ensureInitialized().encodeJson<AddedFood>(
      this as AddedFood,
    );
  }

  Map<String, dynamic> toMap() {
    return AddedFoodMapper.ensureInitialized().encodeMap<AddedFood>(
      this as AddedFood,
    );
  }

  AddedFoodCopyWith<AddedFood, AddedFood, AddedFood> get copyWith =>
      _AddedFoodCopyWithImpl<AddedFood, AddedFood>(
        this as AddedFood,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddedFoodMapper.ensureInitialized().stringifyValue(
      this as AddedFood,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddedFoodMapper.ensureInitialized().equalsValue(
      this as AddedFood,
      other,
    );
  }

  @override
  int get hashCode {
    return AddedFoodMapper.ensureInitialized().hashValue(this as AddedFood);
  }
}

extension AddedFoodValueCopy<$R, $Out> on ObjectCopyWith<$R, AddedFood, $Out> {
  AddedFoodCopyWith<$R, AddedFood, $Out> get $asAddedFood =>
      $base.as((v, t, t2) => _AddedFoodCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddedFoodCopyWith<$R, $In extends AddedFood, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry> get planned;
  $R call({PlannedEntry? planned, bool? ekkloWritten});
  AddedFoodCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddedFoodCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddedFood, $Out>
    implements AddedFoodCopyWith<$R, AddedFood, $Out> {
  _AddedFoodCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddedFood> $mapper =
      AddedFoodMapper.ensureInitialized();
  @override
  PlannedEntryCopyWith<$R, PlannedEntry, PlannedEntry> get planned =>
      $value.planned.copyWith.$chain((v) => call(planned: v));
  @override
  $R call({PlannedEntry? planned, bool? ekkloWritten}) => $apply(
    FieldCopyWithData({
      if (planned != null) #planned: planned,
      if (ekkloWritten != null) #ekkloWritten: ekkloWritten,
    }),
  );
  @override
  AddedFood $make(CopyWithData data) => AddedFood(
    planned: data.get(#planned, or: $value.planned),
    ekkloWritten: data.get(#ekkloWritten, or: $value.ekkloWritten),
  );

  @override
  AddedFoodCopyWith<$R2, AddedFood, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddedFoodCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

