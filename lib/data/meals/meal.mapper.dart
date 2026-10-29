// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'meal.dart';

class MealMapper extends ClassMapperBase<Meal> {
  MealMapper._();

  static MealMapper? _instance;
  static MealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Meal';

  static String _$id(Meal v) => v.id;
  static const Field<Meal, String> _f$id = Field('id', _$id);
  static String _$name(Meal v) => v.name;
  static const Field<Meal, String> _f$name = Field('name', _$name);
  static int _$position(Meal v) => v.position;
  static const Field<Meal, int> _f$position = Field('position', _$position);
  static DateTime _$updatedAt(Meal v) => v.updatedAt;
  static const Field<Meal, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(Meal v) => v.deletedAt;
  static const Field<Meal, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<Meal> fields = const {
    #id: _f$id,
    #name: _f$name,
    #position: _f$position,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static Meal _instantiate(DecodingData data) {
    return Meal(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      position: data.dec(_f$position),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Meal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Meal>(map);
  }

  static Meal fromJson(String json) {
    return ensureInitialized().decodeJson<Meal>(json);
  }
}

mixin MealMappable {
  String toJson() {
    return MealMapper.ensureInitialized().encodeJson<Meal>(this as Meal);
  }

  Map<String, dynamic> toMap() {
    return MealMapper.ensureInitialized().encodeMap<Meal>(this as Meal);
  }

  MealCopyWith<Meal, Meal, Meal> get copyWith =>
      _MealCopyWithImpl<Meal, Meal>(this as Meal, $identity, $identity);
  @override
  String toString() {
    return MealMapper.ensureInitialized().stringifyValue(this as Meal);
  }

  @override
  bool operator ==(Object other) {
    return MealMapper.ensureInitialized().equalsValue(this as Meal, other);
  }

  @override
  int get hashCode {
    return MealMapper.ensureInitialized().hashValue(this as Meal);
  }
}

extension MealValueCopy<$R, $Out> on ObjectCopyWith<$R, Meal, $Out> {
  MealCopyWith<$R, Meal, $Out> get $asMeal =>
      $base.as((v, t, t2) => _MealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MealCopyWith<$R, $In extends Meal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? name,
    int? position,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  MealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MealCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Meal, $Out>
    implements MealCopyWith<$R, Meal, $Out> {
  _MealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Meal> $mapper = MealMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    int? position,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (position != null) #position: position,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  Meal $make(CopyWithData data) => Meal(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    position: data.get(#position, or: $value.position),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  MealCopyWith<$R2, Meal, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

