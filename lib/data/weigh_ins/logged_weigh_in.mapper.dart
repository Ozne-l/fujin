// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'logged_weigh_in.dart';

class LoggedWeighInMapper extends ClassMapperBase<LoggedWeighIn> {
  LoggedWeighInMapper._();

  static LoggedWeighInMapper? _instance;
  static LoggedWeighInMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoggedWeighInMapper._());
      WeighInMapper.ensureInitialized();
      EkkloWeighInLinkMapper.ensureInitialized();
      MfpWeighInLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LoggedWeighIn';

  static WeighIn _$weighIn(LoggedWeighIn v) => v.weighIn;
  static const Field<LoggedWeighIn, WeighIn> _f$weighIn = Field(
    'weighIn',
    _$weighIn,
    key: r'weigh_in',
  );
  static EkkloWeighInLink? _$ekkloLink(LoggedWeighIn v) => v.ekkloLink;
  static const Field<LoggedWeighIn, EkkloWeighInLink> _f$ekkloLink = Field(
    'ekkloLink',
    _$ekkloLink,
    key: r'ekklo_link',
    opt: true,
  );
  static MfpWeighInLink? _$mfpLink(LoggedWeighIn v) => v.mfpLink;
  static const Field<LoggedWeighIn, MfpWeighInLink> _f$mfpLink = Field(
    'mfpLink',
    _$mfpLink,
    key: r'mfp_link',
    opt: true,
  );

  @override
  final MappableFields<LoggedWeighIn> fields = const {
    #weighIn: _f$weighIn,
    #ekkloLink: _f$ekkloLink,
    #mfpLink: _f$mfpLink,
  };
  @override
  final bool ignoreNull = true;

  static LoggedWeighIn _instantiate(DecodingData data) {
    return LoggedWeighIn(
      weighIn: data.dec(_f$weighIn),
      ekkloLink: data.dec(_f$ekkloLink),
      mfpLink: data.dec(_f$mfpLink),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoggedWeighIn fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoggedWeighIn>(map);
  }

  static LoggedWeighIn fromJson(String json) {
    return ensureInitialized().decodeJson<LoggedWeighIn>(json);
  }
}

mixin LoggedWeighInMappable {
  String toJson() {
    return LoggedWeighInMapper.ensureInitialized().encodeJson<LoggedWeighIn>(
      this as LoggedWeighIn,
    );
  }

  Map<String, dynamic> toMap() {
    return LoggedWeighInMapper.ensureInitialized().encodeMap<LoggedWeighIn>(
      this as LoggedWeighIn,
    );
  }

  LoggedWeighInCopyWith<LoggedWeighIn, LoggedWeighIn, LoggedWeighIn>
  get copyWith => _LoggedWeighInCopyWithImpl<LoggedWeighIn, LoggedWeighIn>(
    this as LoggedWeighIn,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return LoggedWeighInMapper.ensureInitialized().stringifyValue(
      this as LoggedWeighIn,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoggedWeighInMapper.ensureInitialized().equalsValue(
      this as LoggedWeighIn,
      other,
    );
  }

  @override
  int get hashCode {
    return LoggedWeighInMapper.ensureInitialized().hashValue(
      this as LoggedWeighIn,
    );
  }
}

extension LoggedWeighInValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoggedWeighIn, $Out> {
  LoggedWeighInCopyWith<$R, LoggedWeighIn, $Out> get $asLoggedWeighIn =>
      $base.as((v, t, t2) => _LoggedWeighInCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoggedWeighInCopyWith<$R, $In extends LoggedWeighIn, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn;
  EkkloWeighInLinkCopyWith<$R, EkkloWeighInLink, EkkloWeighInLink>?
  get ekkloLink;
  MfpWeighInLinkCopyWith<$R, MfpWeighInLink, MfpWeighInLink>? get mfpLink;
  $R call({
    WeighIn? weighIn,
    EkkloWeighInLink? ekkloLink,
    MfpWeighInLink? mfpLink,
  });
  LoggedWeighInCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoggedWeighInCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoggedWeighIn, $Out>
    implements LoggedWeighInCopyWith<$R, LoggedWeighIn, $Out> {
  _LoggedWeighInCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoggedWeighIn> $mapper =
      LoggedWeighInMapper.ensureInitialized();
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn =>
      $value.weighIn.copyWith.$chain((v) => call(weighIn: v));
  @override
  EkkloWeighInLinkCopyWith<$R, EkkloWeighInLink, EkkloWeighInLink>?
  get ekkloLink => $value.ekkloLink?.copyWith.$chain((v) => call(ekkloLink: v));
  @override
  MfpWeighInLinkCopyWith<$R, MfpWeighInLink, MfpWeighInLink>? get mfpLink =>
      $value.mfpLink?.copyWith.$chain((v) => call(mfpLink: v));
  @override
  $R call({
    WeighIn? weighIn,
    Object? ekkloLink = $none,
    Object? mfpLink = $none,
  }) => $apply(
    FieldCopyWithData({
      if (weighIn != null) #weighIn: weighIn,
      if (ekkloLink != $none) #ekkloLink: ekkloLink,
      if (mfpLink != $none) #mfpLink: mfpLink,
    }),
  );
  @override
  LoggedWeighIn $make(CopyWithData data) => LoggedWeighIn(
    weighIn: data.get(#weighIn, or: $value.weighIn),
    ekkloLink: data.get(#ekkloLink, or: $value.ekkloLink),
    mfpLink: data.get(#mfpLink, or: $value.mfpLink),
  );

  @override
  LoggedWeighInCopyWith<$R2, LoggedWeighIn, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoggedWeighInCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

