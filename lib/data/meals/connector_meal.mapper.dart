// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'connector_meal.dart';

class ConnectorMealMapper extends ClassMapperBase<ConnectorMeal> {
  ConnectorMealMapper._();

  static ConnectorMealMapper? _instance;
  static ConnectorMealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConnectorMealMapper._());
      ConnectorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConnectorMeal';

  static String _$id(ConnectorMeal v) => v.id;
  static const Field<ConnectorMeal, String> _f$id = Field('id', _$id);
  static String _$mealId(ConnectorMeal v) => v.mealId;
  static const Field<ConnectorMeal, String> _f$mealId = Field(
    'mealId',
    _$mealId,
    key: r'meal_id',
  );
  static Connector _$connector(ConnectorMeal v) => v.connector;
  static const Field<ConnectorMeal, Connector> _f$connector = Field(
    'connector',
    _$connector,
  );
  static String _$name(ConnectorMeal v) => v.name;
  static const Field<ConnectorMeal, String> _f$name = Field('name', _$name);
  static DateTime _$updatedAt(ConnectorMeal v) => v.updatedAt;
  static const Field<ConnectorMeal, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static DateTime? _$deletedAt(ConnectorMeal v) => v.deletedAt;
  static const Field<ConnectorMeal, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<ConnectorMeal> fields = const {
    #id: _f$id,
    #mealId: _f$mealId,
    #connector: _f$connector,
    #name: _f$name,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  static ConnectorMeal _instantiate(DecodingData data) {
    return ConnectorMeal(
      id: data.dec(_f$id),
      mealId: data.dec(_f$mealId),
      connector: data.dec(_f$connector),
      name: data.dec(_f$name),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConnectorMeal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConnectorMeal>(map);
  }

  static ConnectorMeal fromJson(String json) {
    return ensureInitialized().decodeJson<ConnectorMeal>(json);
  }
}

mixin ConnectorMealMappable {
  String toJson() {
    return ConnectorMealMapper.ensureInitialized().encodeJson<ConnectorMeal>(
      this as ConnectorMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return ConnectorMealMapper.ensureInitialized().encodeMap<ConnectorMeal>(
      this as ConnectorMeal,
    );
  }

  ConnectorMealCopyWith<ConnectorMeal, ConnectorMeal, ConnectorMeal>
  get copyWith => _ConnectorMealCopyWithImpl<ConnectorMeal, ConnectorMeal>(
    this as ConnectorMeal,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ConnectorMealMapper.ensureInitialized().stringifyValue(
      this as ConnectorMeal,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConnectorMealMapper.ensureInitialized().equalsValue(
      this as ConnectorMeal,
      other,
    );
  }

  @override
  int get hashCode {
    return ConnectorMealMapper.ensureInitialized().hashValue(
      this as ConnectorMeal,
    );
  }
}

extension ConnectorMealValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConnectorMeal, $Out> {
  ConnectorMealCopyWith<$R, ConnectorMeal, $Out> get $asConnectorMeal =>
      $base.as((v, t, t2) => _ConnectorMealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConnectorMealCopyWith<$R, $In extends ConnectorMeal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? mealId,
    Connector? connector,
    String? name,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  ConnectorMealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ConnectorMealCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConnectorMeal, $Out>
    implements ConnectorMealCopyWith<$R, ConnectorMeal, $Out> {
  _ConnectorMealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConnectorMeal> $mapper =
      ConnectorMealMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? mealId,
    Connector? connector,
    String? name,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (mealId != null) #mealId: mealId,
      if (connector != null) #connector: connector,
      if (name != null) #name: name,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  ConnectorMeal $make(CopyWithData data) => ConnectorMeal(
    id: data.get(#id, or: $value.id),
    mealId: data.get(#mealId, or: $value.mealId),
    connector: data.get(#connector, or: $value.connector),
    name: data.get(#name, or: $value.name),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  ConnectorMealCopyWith<$R2, ConnectorMeal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConnectorMealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

