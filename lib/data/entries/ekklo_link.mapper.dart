// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ekklo_link.dart';

class EkkloLinkMapper extends ClassMapperBase<EkkloLink> {
  EkkloLinkMapper._();

  static EkkloLinkMapper? _instance;
  static EkkloLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EkkloLinkMapper._());
      LinkedItemMapper.ensureInitialized();
      UnattendedExpectationMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EkkloLink';

  static String _$id(EkkloLink v) => v.id;
  static const Field<EkkloLink, String> _f$id = Field('id', _$id);
  static String _$entryId(EkkloLink v) => v.entryId;
  static const Field<EkkloLink, String> _f$entryId = Field(
    'entryId',
    _$entryId,
    key: r'entry_id',
  );
  static DateTime _$updatedAt(EkkloLink v) => v.updatedAt;
  static const Field<EkkloLink, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static LinkedItem? _$item(EkkloLink v) => v.item;
  static const Field<EkkloLink, LinkedItem> _f$item = Field(
    'item',
    _$item,
    opt: true,
  );
  static UnattendedExpectation? _$unattended(EkkloLink v) => v.unattended;
  static const Field<EkkloLink, UnattendedExpectation> _f$unattended = Field(
    'unattended',
    _$unattended,
    opt: true,
  );
  static DateTime? _$deletedAt(EkkloLink v) => v.deletedAt;
  static const Field<EkkloLink, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
    opt: true,
  );

  @override
  final MappableFields<EkkloLink> fields = const {
    #id: _f$id,
    #entryId: _f$entryId,
    #updatedAt: _f$updatedAt,
    #item: _f$item,
    #unattended: _f$unattended,
    #deletedAt: _f$deletedAt,
  };
  @override
  final bool ignoreNull = true;

  @override
  final MappingHook hook = const EkkloLinkHook();
  static EkkloLink _instantiate(DecodingData data) {
    return EkkloLink(
      id: data.dec(_f$id),
      entryId: data.dec(_f$entryId),
      updatedAt: data.dec(_f$updatedAt),
      item: data.dec(_f$item),
      unattended: data.dec(_f$unattended),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EkkloLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EkkloLink>(map);
  }

  static EkkloLink fromJson(String json) {
    return ensureInitialized().decodeJson<EkkloLink>(json);
  }
}

mixin EkkloLinkMappable {
  String toJson() {
    return EkkloLinkMapper.ensureInitialized().encodeJson<EkkloLink>(
      this as EkkloLink,
    );
  }

  Map<String, dynamic> toMap() {
    return EkkloLinkMapper.ensureInitialized().encodeMap<EkkloLink>(
      this as EkkloLink,
    );
  }

  EkkloLinkCopyWith<EkkloLink, EkkloLink, EkkloLink> get copyWith =>
      _EkkloLinkCopyWithImpl<EkkloLink, EkkloLink>(
        this as EkkloLink,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EkkloLinkMapper.ensureInitialized().stringifyValue(
      this as EkkloLink,
    );
  }

  @override
  bool operator ==(Object other) {
    return EkkloLinkMapper.ensureInitialized().equalsValue(
      this as EkkloLink,
      other,
    );
  }

  @override
  int get hashCode {
    return EkkloLinkMapper.ensureInitialized().hashValue(this as EkkloLink);
  }
}

extension EkkloLinkValueCopy<$R, $Out> on ObjectCopyWith<$R, EkkloLink, $Out> {
  EkkloLinkCopyWith<$R, EkkloLink, $Out> get $asEkkloLink =>
      $base.as((v, t, t2) => _EkkloLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EkkloLinkCopyWith<$R, $In extends EkkloLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  LinkedItemCopyWith<$R, LinkedItem, LinkedItem>? get item;
  UnattendedExpectationCopyWith<
    $R,
    UnattendedExpectation,
    UnattendedExpectation
  >?
  get unattended;
  $R call({
    String? id,
    String? entryId,
    DateTime? updatedAt,
    LinkedItem? item,
    UnattendedExpectation? unattended,
    DateTime? deletedAt,
  });
  EkkloLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EkkloLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EkkloLink, $Out>
    implements EkkloLinkCopyWith<$R, EkkloLink, $Out> {
  _EkkloLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EkkloLink> $mapper =
      EkkloLinkMapper.ensureInitialized();
  @override
  LinkedItemCopyWith<$R, LinkedItem, LinkedItem>? get item =>
      $value.item?.copyWith.$chain((v) => call(item: v));
  @override
  UnattendedExpectationCopyWith<
    $R,
    UnattendedExpectation,
    UnattendedExpectation
  >?
  get unattended =>
      $value.unattended?.copyWith.$chain((v) => call(unattended: v));
  @override
  $R call({
    String? id,
    String? entryId,
    DateTime? updatedAt,
    Object? item = $none,
    Object? unattended = $none,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (entryId != null) #entryId: entryId,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (item != $none) #item: item,
      if (unattended != $none) #unattended: unattended,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  EkkloLink $make(CopyWithData data) => EkkloLink(
    id: data.get(#id, or: $value.id),
    entryId: data.get(#entryId, or: $value.entryId),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    item: data.get(#item, or: $value.item),
    unattended: data.get(#unattended, or: $value.unattended),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  EkkloLinkCopyWith<$R2, EkkloLink, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EkkloLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

