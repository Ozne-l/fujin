// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'connected_accounts.dart';

class ConnectedAccountsMapper extends ClassMapperBase<ConnectedAccounts> {
  ConnectedAccountsMapper._();

  static ConnectedAccountsMapper? _instance;
  static ConnectedAccountsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConnectedAccountsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ConnectedAccounts';

  static bool _$mfp(ConnectedAccounts v) => v.mfp;
  static const Field<ConnectedAccounts, bool> _f$mfp = Field('mfp', _$mfp);
  static bool _$ekklo(ConnectedAccounts v) => v.ekklo;
  static const Field<ConnectedAccounts, bool> _f$ekklo = Field(
    'ekklo',
    _$ekklo,
  );

  @override
  final MappableFields<ConnectedAccounts> fields = const {
    #mfp: _f$mfp,
    #ekklo: _f$ekklo,
  };
  @override
  final bool ignoreNull = true;

  static ConnectedAccounts _instantiate(DecodingData data) {
    return ConnectedAccounts(mfp: data.dec(_f$mfp), ekklo: data.dec(_f$ekklo));
  }

  @override
  final Function instantiate = _instantiate;

  static ConnectedAccounts fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConnectedAccounts>(map);
  }

  static ConnectedAccounts fromJson(String json) {
    return ensureInitialized().decodeJson<ConnectedAccounts>(json);
  }
}

mixin ConnectedAccountsMappable {
  String toJson() {
    return ConnectedAccountsMapper.ensureInitialized()
        .encodeJson<ConnectedAccounts>(this as ConnectedAccounts);
  }

  Map<String, dynamic> toMap() {
    return ConnectedAccountsMapper.ensureInitialized()
        .encodeMap<ConnectedAccounts>(this as ConnectedAccounts);
  }

  ConnectedAccountsCopyWith<
    ConnectedAccounts,
    ConnectedAccounts,
    ConnectedAccounts
  >
  get copyWith =>
      _ConnectedAccountsCopyWithImpl<ConnectedAccounts, ConnectedAccounts>(
        this as ConnectedAccounts,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ConnectedAccountsMapper.ensureInitialized().stringifyValue(
      this as ConnectedAccounts,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConnectedAccountsMapper.ensureInitialized().equalsValue(
      this as ConnectedAccounts,
      other,
    );
  }

  @override
  int get hashCode {
    return ConnectedAccountsMapper.ensureInitialized().hashValue(
      this as ConnectedAccounts,
    );
  }
}

extension ConnectedAccountsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConnectedAccounts, $Out> {
  ConnectedAccountsCopyWith<$R, ConnectedAccounts, $Out>
  get $asConnectedAccounts => $base.as(
    (v, t, t2) => _ConnectedAccountsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConnectedAccountsCopyWith<
  $R,
  $In extends ConnectedAccounts,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? mfp, bool? ekklo});
  ConnectedAccountsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConnectedAccountsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConnectedAccounts, $Out>
    implements ConnectedAccountsCopyWith<$R, ConnectedAccounts, $Out> {
  _ConnectedAccountsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConnectedAccounts> $mapper =
      ConnectedAccountsMapper.ensureInitialized();
  @override
  $R call({bool? mfp, bool? ekklo}) => $apply(
    FieldCopyWithData({
      if (mfp != null) #mfp: mfp,
      if (ekklo != null) #ekklo: ekklo,
    }),
  );
  @override
  ConnectedAccounts $make(CopyWithData data) => ConnectedAccounts(
    mfp: data.get(#mfp, or: $value.mfp),
    ekklo: data.get(#ekklo, or: $value.ekklo),
  );

  @override
  ConnectedAccountsCopyWith<$R2, ConnectedAccounts, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConnectedAccountsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

