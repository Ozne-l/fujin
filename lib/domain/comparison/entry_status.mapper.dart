// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'entry_status.dart';

class EntryStatusMapper extends ClassMapperBase<EntryStatus> {
  EntryStatusMapper._();

  static EntryStatusMapper? _instance;
  static EntryStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EntryStatusMapper._());
      InEkkloMapper.ensureInitialized();
      ToSendMapper.ensureInitialized();
      ToUpdateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EntryStatus';

  @override
  final MappableFields<EntryStatus> fields = const {};
  @override
  final bool ignoreNull = true;

  static EntryStatus _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'EntryStatus',
      'status',
      '${data.value['status']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EntryStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EntryStatus>(map);
  }

  static EntryStatus fromJson(String json) {
    return ensureInitialized().decodeJson<EntryStatus>(json);
  }
}

mixin EntryStatusMappable {
  String toJson();
  Map<String, dynamic> toMap();
  EntryStatusCopyWith<EntryStatus, EntryStatus, EntryStatus> get copyWith;
}

abstract class EntryStatusCopyWith<$R, $In extends EntryStatus, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  EntryStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class InEkkloMapper extends SubClassMapperBase<InEkklo> {
  InEkkloMapper._();

  static InEkkloMapper? _instance;
  static InEkkloMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InEkkloMapper._());
      EntryStatusMapper.ensureInitialized().addSubMapper(_instance!);
      SentLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InEkklo';

  static SentLink _$link(InEkklo v) => v.link;
  static const Field<InEkklo, SentLink> _f$link = Field('link', _$link);

  @override
  final MappableFields<InEkklo> fields = const {#link: _f$link};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'in_ekklo';
  @override
  late final ClassMapperBase superMapper =
      EntryStatusMapper.ensureInitialized();

  static InEkklo _instantiate(DecodingData data) {
    return InEkklo(data.dec(_f$link));
  }

  @override
  final Function instantiate = _instantiate;

  static InEkklo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InEkklo>(map);
  }

  static InEkklo fromJson(String json) {
    return ensureInitialized().decodeJson<InEkklo>(json);
  }
}

mixin InEkkloMappable {
  String toJson() {
    return InEkkloMapper.ensureInitialized().encodeJson<InEkklo>(
      this as InEkklo,
    );
  }

  Map<String, dynamic> toMap() {
    return InEkkloMapper.ensureInitialized().encodeMap<InEkklo>(
      this as InEkklo,
    );
  }

  InEkkloCopyWith<InEkklo, InEkklo, InEkklo> get copyWith =>
      _InEkkloCopyWithImpl<InEkklo, InEkklo>(
        this as InEkklo,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return InEkkloMapper.ensureInitialized().stringifyValue(this as InEkklo);
  }

  @override
  bool operator ==(Object other) {
    return InEkkloMapper.ensureInitialized().equalsValue(
      this as InEkklo,
      other,
    );
  }

  @override
  int get hashCode {
    return InEkkloMapper.ensureInitialized().hashValue(this as InEkklo);
  }
}

extension InEkkloValueCopy<$R, $Out> on ObjectCopyWith<$R, InEkklo, $Out> {
  InEkkloCopyWith<$R, InEkklo, $Out> get $asInEkklo =>
      $base.as((v, t, t2) => _InEkkloCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InEkkloCopyWith<$R, $In extends InEkklo, $Out>
    implements EntryStatusCopyWith<$R, $In, $Out> {
  SentLinkCopyWith<$R, SentLink, SentLink> get link;
  @override
  $R call({SentLink? link});
  InEkkloCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InEkkloCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InEkklo, $Out>
    implements InEkkloCopyWith<$R, InEkklo, $Out> {
  _InEkkloCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InEkklo> $mapper =
      InEkkloMapper.ensureInitialized();
  @override
  SentLinkCopyWith<$R, SentLink, SentLink> get link =>
      $value.link.copyWith.$chain((v) => call(link: v));
  @override
  $R call({SentLink? link}) =>
      $apply(FieldCopyWithData({if (link != null) #link: link}));
  @override
  InEkklo $make(CopyWithData data) => InEkklo(data.get(#link, or: $value.link));

  @override
  InEkkloCopyWith<$R2, InEkklo, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InEkkloCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ToSendMapper extends SubClassMapperBase<ToSend> {
  ToSendMapper._();

  static ToSendMapper? _instance;
  static ToSendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ToSendMapper._());
      EntryStatusMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ToSend';

  @override
  final MappableFields<ToSend> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'to_send';
  @override
  late final ClassMapperBase superMapper =
      EntryStatusMapper.ensureInitialized();

  static ToSend _instantiate(DecodingData data) {
    return ToSend();
  }

  @override
  final Function instantiate = _instantiate;

  static ToSend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ToSend>(map);
  }

  static ToSend fromJson(String json) {
    return ensureInitialized().decodeJson<ToSend>(json);
  }
}

mixin ToSendMappable {
  String toJson() {
    return ToSendMapper.ensureInitialized().encodeJson<ToSend>(this as ToSend);
  }

  Map<String, dynamic> toMap() {
    return ToSendMapper.ensureInitialized().encodeMap<ToSend>(this as ToSend);
  }

  ToSendCopyWith<ToSend, ToSend, ToSend> get copyWith =>
      _ToSendCopyWithImpl<ToSend, ToSend>(this as ToSend, $identity, $identity);
  @override
  String toString() {
    return ToSendMapper.ensureInitialized().stringifyValue(this as ToSend);
  }

  @override
  bool operator ==(Object other) {
    return ToSendMapper.ensureInitialized().equalsValue(this as ToSend, other);
  }

  @override
  int get hashCode {
    return ToSendMapper.ensureInitialized().hashValue(this as ToSend);
  }
}

extension ToSendValueCopy<$R, $Out> on ObjectCopyWith<$R, ToSend, $Out> {
  ToSendCopyWith<$R, ToSend, $Out> get $asToSend =>
      $base.as((v, t, t2) => _ToSendCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ToSendCopyWith<$R, $In extends ToSend, $Out>
    implements EntryStatusCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ToSendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ToSendCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, ToSend, $Out>
    implements ToSendCopyWith<$R, ToSend, $Out> {
  _ToSendCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ToSend> $mapper = ToSendMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ToSend $make(CopyWithData data) => ToSend();

  @override
  ToSendCopyWith<$R2, ToSend, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ToSendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ToUpdateMapper extends SubClassMapperBase<ToUpdate> {
  ToUpdateMapper._();

  static ToUpdateMapper? _instance;
  static ToUpdateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ToUpdateMapper._());
      EntryStatusMapper.ensureInitialized().addSubMapper(_instance!);
      SentLinkMapper.ensureInitialized();
      UpdateKindMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ToUpdate';

  static SentLink _$link(ToUpdate v) => v.link;
  static const Field<ToUpdate, SentLink> _f$link = Field('link', _$link);
  static UpdateKind _$kind(ToUpdate v) => v.kind;
  static const Field<ToUpdate, UpdateKind> _f$kind = Field('kind', _$kind);

  @override
  final MappableFields<ToUpdate> fields = const {
    #link: _f$link,
    #kind: _f$kind,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'status';
  @override
  final dynamic discriminatorValue = 'to_update';
  @override
  late final ClassMapperBase superMapper =
      EntryStatusMapper.ensureInitialized();

  static ToUpdate _instantiate(DecodingData data) {
    return ToUpdate(data.dec(_f$link), data.dec(_f$kind));
  }

  @override
  final Function instantiate = _instantiate;

  static ToUpdate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ToUpdate>(map);
  }

  static ToUpdate fromJson(String json) {
    return ensureInitialized().decodeJson<ToUpdate>(json);
  }
}

mixin ToUpdateMappable {
  String toJson() {
    return ToUpdateMapper.ensureInitialized().encodeJson<ToUpdate>(
      this as ToUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return ToUpdateMapper.ensureInitialized().encodeMap<ToUpdate>(
      this as ToUpdate,
    );
  }

  ToUpdateCopyWith<ToUpdate, ToUpdate, ToUpdate> get copyWith =>
      _ToUpdateCopyWithImpl<ToUpdate, ToUpdate>(
        this as ToUpdate,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ToUpdateMapper.ensureInitialized().stringifyValue(this as ToUpdate);
  }

  @override
  bool operator ==(Object other) {
    return ToUpdateMapper.ensureInitialized().equalsValue(
      this as ToUpdate,
      other,
    );
  }

  @override
  int get hashCode {
    return ToUpdateMapper.ensureInitialized().hashValue(this as ToUpdate);
  }
}

extension ToUpdateValueCopy<$R, $Out> on ObjectCopyWith<$R, ToUpdate, $Out> {
  ToUpdateCopyWith<$R, ToUpdate, $Out> get $asToUpdate =>
      $base.as((v, t, t2) => _ToUpdateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ToUpdateCopyWith<$R, $In extends ToUpdate, $Out>
    implements EntryStatusCopyWith<$R, $In, $Out> {
  SentLinkCopyWith<$R, SentLink, SentLink> get link;
  @override
  $R call({SentLink? link, UpdateKind? kind});
  ToUpdateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ToUpdateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ToUpdate, $Out>
    implements ToUpdateCopyWith<$R, ToUpdate, $Out> {
  _ToUpdateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ToUpdate> $mapper =
      ToUpdateMapper.ensureInitialized();
  @override
  SentLinkCopyWith<$R, SentLink, SentLink> get link =>
      $value.link.copyWith.$chain((v) => call(link: v));
  @override
  $R call({SentLink? link, UpdateKind? kind}) => $apply(
    FieldCopyWithData({
      if (link != null) #link: link,
      if (kind != null) #kind: kind,
    }),
  );
  @override
  ToUpdate $make(CopyWithData data) => ToUpdate(
    data.get(#link, or: $value.link),
    data.get(#kind, or: $value.kind),
  );

  @override
  ToUpdateCopyWith<$R2, ToUpdate, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ToUpdateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

