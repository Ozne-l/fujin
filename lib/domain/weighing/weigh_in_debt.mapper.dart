// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'weigh_in_debt.dart';

class WeighInDebtMapper extends ClassMapperBase<WeighInDebt> {
  WeighInDebtMapper._();

  static WeighInDebtMapper? _instance;
  static WeighInDebtMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WeighInDebtMapper._());
      EkkloWeighInWriteMapper.ensureInitialized();
      MfpWeighInWriteMapper.ensureInitialized();
      MfpWeighInDeletionMapper.ensureInitialized();
      WeighInMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WeighInDebt';

  static WeighIn _$weighIn(WeighInDebt v) => v.weighIn;
  static const Field<WeighInDebt, WeighIn> _f$weighIn = Field(
    'weighIn',
    _$weighIn,
    key: r'weigh_in',
  );

  @override
  final MappableFields<WeighInDebt> fields = const {#weighIn: _f$weighIn};
  @override
  final bool ignoreNull = true;

  static WeighInDebt _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'WeighInDebt',
      'debt',
      '${data.value['debt']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WeighInDebt fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WeighInDebt>(map);
  }

  static WeighInDebt fromJson(String json) {
    return ensureInitialized().decodeJson<WeighInDebt>(json);
  }
}

mixin WeighInDebtMappable {
  String toJson();
  Map<String, dynamic> toMap();
  WeighInDebtCopyWith<WeighInDebt, WeighInDebt, WeighInDebt> get copyWith;
}

abstract class WeighInDebtCopyWith<$R, $In extends WeighInDebt, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn;
  $R call({WeighIn? weighIn});
  WeighInDebtCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class EkkloWeighInWriteMapper extends SubClassMapperBase<EkkloWeighInWrite> {
  EkkloWeighInWriteMapper._();

  static EkkloWeighInWriteMapper? _instance;
  static EkkloWeighInWriteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloWeighInWriteMapper._());
      WeighInDebtMapper.ensureInitialized().addSubMapper(_instance!);
      WeighInMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloWeighInWrite';

  static WeighIn _$weighIn(EkkloWeighInWrite v) => v.weighIn;
  static const Field<EkkloWeighInWrite, WeighIn> _f$weighIn = Field(
    'weighIn',
    _$weighIn,
    key: r'weigh_in',
  );

  @override
  final MappableFields<EkkloWeighInWrite> fields = const {#weighIn: _f$weighIn};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'debt';
  @override
  final dynamic discriminatorValue = 'ekklo_write';
  @override
  late final ClassMapperBase superMapper =
      WeighInDebtMapper.ensureInitialized();

  static EkkloWeighInWrite _instantiate(DecodingData data) {
    return EkkloWeighInWrite(data.dec(_f$weighIn));
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloWeighInWrite fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloWeighInWrite>(map);
  }

  static EkkloWeighInWrite fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloWeighInWrite>(json);
  }
}

mixin EkkloWeighInWriteMappable {
  String toJson() {
    return EkkloWeighInWriteMapper.ensureInitialized()
        .encodeJson<EkkloWeighInWrite>(this as EkkloWeighInWrite);
  }

  Map<String, dynamic> toMap() {
    return EkkloWeighInWriteMapper.ensureInitialized()
        .encodeMap<EkkloWeighInWrite>(this as EkkloWeighInWrite);
  }

  EkkloWeighInWriteCopyWith<
    EkkloWeighInWrite,
    EkkloWeighInWrite,
    EkkloWeighInWrite
  >
  get copyWith =>
      _EkkloWeighInWriteCopyWithImpl<EkkloWeighInWrite, EkkloWeighInWrite>(
        this as EkkloWeighInWrite,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloWeighInWriteMapper.ensureInitialized().stringifyValue(
      this as EkkloWeighInWrite,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloWeighInWriteMapper.ensureInitialized().equalsValue(
      this as EkkloWeighInWrite,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloWeighInWriteMapper.ensureInitialized().hashValue(
      this as EkkloWeighInWrite,
    );
  }
}

extension EkkloWeighInWriteValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EkkloWeighInWrite, $Out> {
  EkkloWeighInWriteCopyWith<$R, EkkloWeighInWrite, $Out>
  get $asEkkloWeighInWrite => $base.as(
    (v, t, t2) => _EkkloWeighInWriteCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EkkloWeighInWriteCopyWith<
  $R,
  $In extends EkkloWeighInWrite,
  $Out
>
    implements WeighInDebtCopyWith<$R, $In, $Out> {
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn;
  @override
  $R call({WeighIn? weighIn});
  EkkloWeighInWriteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EkkloWeighInWriteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloWeighInWrite, $Out>
    implements EkkloWeighInWriteCopyWith<$R, EkkloWeighInWrite, $Out> {
  _EkkloWeighInWriteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloWeighInWrite> $mapper =
      EkkloWeighInWriteMapper.ensureInitialized();
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn =>
      $value.weighIn.copyWith.$chain((v) => call(weighIn: v));
  @override
  $R call({WeighIn? weighIn}) =>
      $apply(FieldCopyWithData({if (weighIn != null) #weighIn: weighIn}));
  @override
  EkkloWeighInWrite $make(CopyWithData data) =>
      EkkloWeighInWrite(data.get(#weighIn, or: $value.weighIn));

  @override
  EkkloWeighInWriteCopyWith<$R2, EkkloWeighInWrite, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloWeighInWriteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpWeighInWriteMapper extends SubClassMapperBase<MfpWeighInWrite> {
  MfpWeighInWriteMapper._();

  static MfpWeighInWriteMapper? _instance;
  static MfpWeighInWriteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpWeighInWriteMapper._());
      WeighInDebtMapper.ensureInitialized().addSubMapper(_instance!);
      WeighInMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpWeighInWrite';

  static WeighIn _$weighIn(MfpWeighInWrite v) => v.weighIn;
  static const Field<MfpWeighInWrite, WeighIn> _f$weighIn = Field(
    'weighIn',
    _$weighIn,
    key: r'weigh_in',
  );

  @override
  final MappableFields<MfpWeighInWrite> fields = const {#weighIn: _f$weighIn};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'debt';
  @override
  final dynamic discriminatorValue = 'mfp_write';
  @override
  late final ClassMapperBase superMapper =
      WeighInDebtMapper.ensureInitialized();

  static MfpWeighInWrite _instantiate(DecodingData data) {
    return MfpWeighInWrite(data.dec(_f$weighIn));
  }

  @override
  final Function instantiate = _instantiate;

  static MfpWeighInWrite fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpWeighInWrite>(map);
  }

  static MfpWeighInWrite fromJson(String json) {
    return ensureInitialized().decodeJson<MfpWeighInWrite>(json);
  }
}

mixin MfpWeighInWriteMappable {
  String toJson() {
    return MfpWeighInWriteMapper.ensureInitialized()
        .encodeJson<MfpWeighInWrite>(this as MfpWeighInWrite);
  }

  Map<String, dynamic> toMap() {
    return MfpWeighInWriteMapper.ensureInitialized().encodeMap<MfpWeighInWrite>(
      this as MfpWeighInWrite,
    );
  }

  MfpWeighInWriteCopyWith<MfpWeighInWrite, MfpWeighInWrite, MfpWeighInWrite>
  get copyWith =>
      _MfpWeighInWriteCopyWithImpl<MfpWeighInWrite, MfpWeighInWrite>(
        this as MfpWeighInWrite,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpWeighInWriteMapper.ensureInitialized().stringifyValue(
      this as MfpWeighInWrite,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpWeighInWriteMapper.ensureInitialized().equalsValue(
      this as MfpWeighInWrite,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpWeighInWriteMapper.ensureInitialized().hashValue(
      this as MfpWeighInWrite,
    );
  }
}

extension MfpWeighInWriteValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpWeighInWrite, $Out> {
  MfpWeighInWriteCopyWith<$R, MfpWeighInWrite, $Out> get $asMfpWeighInWrite =>
      $base.as((v, t, t2) => _MfpWeighInWriteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpWeighInWriteCopyWith<$R, $In extends MfpWeighInWrite, $Out>
    implements WeighInDebtCopyWith<$R, $In, $Out> {
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn;
  @override
  $R call({WeighIn? weighIn});
  MfpWeighInWriteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MfpWeighInWriteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpWeighInWrite, $Out>
    implements MfpWeighInWriteCopyWith<$R, MfpWeighInWrite, $Out> {
  _MfpWeighInWriteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpWeighInWrite> $mapper =
      MfpWeighInWriteMapper.ensureInitialized();
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn =>
      $value.weighIn.copyWith.$chain((v) => call(weighIn: v));
  @override
  $R call({WeighIn? weighIn}) =>
      $apply(FieldCopyWithData({if (weighIn != null) #weighIn: weighIn}));
  @override
  MfpWeighInWrite $make(CopyWithData data) =>
      MfpWeighInWrite(data.get(#weighIn, or: $value.weighIn));

  @override
  MfpWeighInWriteCopyWith<$R2, MfpWeighInWrite, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpWeighInWriteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpWeighInDeletionMapper extends SubClassMapperBase<MfpWeighInDeletion> {
  MfpWeighInDeletionMapper._();

  static MfpWeighInDeletionMapper? _instance;
  static MfpWeighInDeletionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpWeighInDeletionMapper._());
      WeighInDebtMapper.ensureInitialized().addSubMapper(_instance!);
      WeighInMapper.ensureInitialized();
      MfpWeighInLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpWeighInDeletion';

  static WeighIn _$weighIn(MfpWeighInDeletion v) => v.weighIn;
  static const Field<MfpWeighInDeletion, WeighIn> _f$weighIn = Field(
    'weighIn',
    _$weighIn,
    key: r'weigh_in',
  );
  static MfpWeighInLink _$link(MfpWeighInDeletion v) => v.link;
  static const Field<MfpWeighInDeletion, MfpWeighInLink> _f$link = Field(
    'link',
    _$link,
  );

  @override
  final MappableFields<MfpWeighInDeletion> fields = const {
    #weighIn: _f$weighIn,
    #link: _f$link,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'debt';
  @override
  final dynamic discriminatorValue = 'mfp_deletion';
  @override
  late final ClassMapperBase superMapper =
      WeighInDebtMapper.ensureInitialized();

  static MfpWeighInDeletion _instantiate(DecodingData data) {
    return MfpWeighInDeletion(data.dec(_f$weighIn), data.dec(_f$link));
  }

  @override
  final Function instantiate = _instantiate;

  static MfpWeighInDeletion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpWeighInDeletion>(map);
  }

  static MfpWeighInDeletion fromJson(String json) {
    return ensureInitialized().decodeJson<MfpWeighInDeletion>(json);
  }
}

mixin MfpWeighInDeletionMappable {
  String toJson() {
    return MfpWeighInDeletionMapper.ensureInitialized()
        .encodeJson<MfpWeighInDeletion>(this as MfpWeighInDeletion);
  }

  Map<String, dynamic> toMap() {
    return MfpWeighInDeletionMapper.ensureInitialized()
        .encodeMap<MfpWeighInDeletion>(this as MfpWeighInDeletion);
  }

  MfpWeighInDeletionCopyWith<
    MfpWeighInDeletion,
    MfpWeighInDeletion,
    MfpWeighInDeletion
  >
  get copyWith =>
      _MfpWeighInDeletionCopyWithImpl<MfpWeighInDeletion, MfpWeighInDeletion>(
        this as MfpWeighInDeletion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpWeighInDeletionMapper.ensureInitialized().stringifyValue(
      this as MfpWeighInDeletion,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpWeighInDeletionMapper.ensureInitialized().equalsValue(
      this as MfpWeighInDeletion,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpWeighInDeletionMapper.ensureInitialized().hashValue(
      this as MfpWeighInDeletion,
    );
  }
}

extension MfpWeighInDeletionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpWeighInDeletion, $Out> {
  MfpWeighInDeletionCopyWith<$R, MfpWeighInDeletion, $Out>
  get $asMfpWeighInDeletion => $base.as(
    (v, t, t2) => _MfpWeighInDeletionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class MfpWeighInDeletionCopyWith<
  $R,
  $In extends MfpWeighInDeletion,
  $Out
>
    implements WeighInDebtCopyWith<$R, $In, $Out> {
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn;
  MfpWeighInLinkCopyWith<$R, MfpWeighInLink, MfpWeighInLink> get link;
  @override
  $R call({WeighIn? weighIn, MfpWeighInLink? link});
  MfpWeighInDeletionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MfpWeighInDeletionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpWeighInDeletion, $Out>
    implements MfpWeighInDeletionCopyWith<$R, MfpWeighInDeletion, $Out> {
  _MfpWeighInDeletionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpWeighInDeletion> $mapper =
      MfpWeighInDeletionMapper.ensureInitialized();
  @override
  WeighInCopyWith<$R, WeighIn, WeighIn> get weighIn =>
      $value.weighIn.copyWith.$chain((v) => call(weighIn: v));
  @override
  MfpWeighInLinkCopyWith<$R, MfpWeighInLink, MfpWeighInLink> get link =>
      $value.link.copyWith.$chain((v) => call(link: v));
  @override
  $R call({WeighIn? weighIn, MfpWeighInLink? link}) => $apply(
    FieldCopyWithData({
      if (weighIn != null) #weighIn: weighIn,
      if (link != null) #link: link,
    }),
  );
  @override
  MfpWeighInDeletion $make(CopyWithData data) => MfpWeighInDeletion(
    data.get(#weighIn, or: $value.weighIn),
    data.get(#link, or: $value.link),
  );

  @override
  MfpWeighInDeletionCopyWith<$R2, MfpWeighInDeletion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpWeighInDeletionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

