// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'connector_roles.dart';

class ConnectorRolesMapper extends ClassMapperBase<ConnectorRoles> {
  ConnectorRolesMapper._();

  static ConnectorRolesMapper? _instance;
  static ConnectorRolesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConnectorRolesMapper._());
      RoleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConnectorRoles';

  static Role _$mfp(ConnectorRoles v) => v.mfp;
  static const Field<ConnectorRoles, Role> _f$mfp = Field('mfp', _$mfp);
  static Role _$ekklo(ConnectorRoles v) => v.ekklo;
  static const Field<ConnectorRoles, Role> _f$ekklo = Field('ekklo', _$ekklo);

  @override
  final MappableFields<ConnectorRoles> fields = const {
    #mfp: _f$mfp,
    #ekklo: _f$ekklo,
  };
  @override
  final bool ignoreNull = true;

  static ConnectorRoles _instantiate(DecodingData data) {
    return ConnectorRoles(mfp: data.dec(_f$mfp), ekklo: data.dec(_f$ekklo));
  }

  @override
  final Function instantiate = _instantiate;

  static ConnectorRoles fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConnectorRoles>(map);
  }

  static ConnectorRoles fromJson(String json) {
    return ensureInitialized().decodeJson<ConnectorRoles>(json);
  }
}

mixin ConnectorRolesMappable {
  String toJson() {
    return ConnectorRolesMapper.ensureInitialized().encodeJson<ConnectorRoles>(
      this as ConnectorRoles,
    );
  }

  Map<String, dynamic> toMap() {
    return ConnectorRolesMapper.ensureInitialized().encodeMap<ConnectorRoles>(
      this as ConnectorRoles,
    );
  }

  ConnectorRolesCopyWith<ConnectorRoles, ConnectorRoles, ConnectorRoles>
  get copyWith => _ConnectorRolesCopyWithImpl<ConnectorRoles, ConnectorRoles>(
    this as ConnectorRoles,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ConnectorRolesMapper.ensureInitialized().stringifyValue(
      this as ConnectorRoles,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConnectorRolesMapper.ensureInitialized().equalsValue(
      this as ConnectorRoles,
      other,
    );
  }

  @override
  int get hashCode {
    return ConnectorRolesMapper.ensureInitialized().hashValue(
      this as ConnectorRoles,
    );
  }
}

extension ConnectorRolesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConnectorRoles, $Out> {
  ConnectorRolesCopyWith<$R, ConnectorRoles, $Out> get $asConnectorRoles =>
      $base.as((v, t, t2) => _ConnectorRolesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConnectorRolesCopyWith<$R, $In extends ConnectorRoles, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Role? mfp, Role? ekklo});
  ConnectorRolesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConnectorRolesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConnectorRoles, $Out>
    implements ConnectorRolesCopyWith<$R, ConnectorRoles, $Out> {
  _ConnectorRolesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConnectorRoles> $mapper =
      ConnectorRolesMapper.ensureInitialized();
  @override
  $R call({Role? mfp, Role? ekklo}) => $apply(
    FieldCopyWithData({
      if (mfp != null) #mfp: mfp,
      if (ekklo != null) #ekklo: ekklo,
    }),
  );
  @override
  ConnectorRoles $make(CopyWithData data) => ConnectorRoles(
    mfp: data.get(#mfp, or: $value.mfp),
    ekklo: data.get(#ekklo, or: $value.ekklo),
  );

  @override
  ConnectorRolesCopyWith<$R2, ConnectorRoles, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConnectorRolesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

