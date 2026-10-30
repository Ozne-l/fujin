// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mfp_write.dart';

class MfpWriteMapper extends ClassMapperBase<MfpWrite> {
  MfpWriteMapper._();

  static MfpWriteMapper? _instance;
  static MfpWriteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpWriteMapper._());
      MfpAddMapper.ensureInitialized();
      MfpEditMapper.ensureInitialized();
      MfpDeletionMapper.ensureInitialized();
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpWrite';

  static LoggedEntry _$logged(MfpWrite v) => v.logged;
  static const Field<MfpWrite, LoggedEntry> _f$logged = Field(
    'logged',
    _$logged,
  );

  @override
  final MappableFields<MfpWrite> fields = const {#logged: _f$logged};
  @override
  final bool ignoreNull = true;

  static MfpWrite _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'MfpWrite',
      'write',
      '${data.value['write']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MfpWrite fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpWrite>(map);
  }

  static MfpWrite fromJson(String json) {
    return ensureInitialized().decodeJson<MfpWrite>(json);
  }
}

mixin MfpWriteMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MfpWriteCopyWith<MfpWrite, MfpWrite, MfpWrite> get copyWith;
}

abstract class MfpWriteCopyWith<$R, $In extends MfpWrite, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  $R call({LoggedEntry? logged});
  MfpWriteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MfpAddMapper extends SubClassMapperBase<MfpAdd> {
  MfpAddMapper._();

  static MfpAddMapper? _instance;
  static MfpAddMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpAddMapper._());
      MfpWriteMapper.ensureInitialized().addSubMapper(_instance!);
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpAdd';

  static LoggedEntry _$logged(MfpAdd v) => v.logged;
  static const Field<MfpAdd, LoggedEntry> _f$logged = Field('logged', _$logged);

  @override
  final MappableFields<MfpAdd> fields = const {#logged: _f$logged};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'write';
  @override
  final dynamic discriminatorValue = 'add';
  @override
  late final ClassMapperBase superMapper = MfpWriteMapper.ensureInitialized();

  static MfpAdd _instantiate(DecodingData data) {
    return MfpAdd(data.dec(_f$logged));
  }

  @override
  final Function instantiate = _instantiate;

  static MfpAdd fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpAdd>(map);
  }

  static MfpAdd fromJson(String json) {
    return ensureInitialized().decodeJson<MfpAdd>(json);
  }
}

mixin MfpAddMappable {
  String toJson() {
    return MfpAddMapper.ensureInitialized().encodeJson<MfpAdd>(this as MfpAdd);
  }

  Map<String, dynamic> toMap() {
    return MfpAddMapper.ensureInitialized().encodeMap<MfpAdd>(this as MfpAdd);
  }

  MfpAddCopyWith<MfpAdd, MfpAdd, MfpAdd> get copyWith =>
      _MfpAddCopyWithImpl<MfpAdd, MfpAdd>(this as MfpAdd, $identity, $identity);
  @override
  String toString() {
    return MfpAddMapper.ensureInitialized().stringifyValue(this as MfpAdd);
  }

  @override
  bool operator ==(Object other) {
    return MfpAddMapper.ensureInitialized().equalsValue(this as MfpAdd, other);
  }

  @override
  int get hashCode {
    return MfpAddMapper.ensureInitialized().hashValue(this as MfpAdd);
  }
}

extension MfpAddValueCopy<$R, $Out> on ObjectCopyWith<$R, MfpAdd, $Out> {
  MfpAddCopyWith<$R, MfpAdd, $Out> get $asMfpAdd =>
      $base.as((v, t, t2) => _MfpAddCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpAddCopyWith<$R, $In extends MfpAdd, $Out>
    implements MfpWriteCopyWith<$R, $In, $Out> {
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  @override
  $R call({LoggedEntry? logged});
  MfpAddCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpAddCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, MfpAdd, $Out>
    implements MfpAddCopyWith<$R, MfpAdd, $Out> {
  _MfpAddCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpAdd> $mapper = MfpAddMapper.ensureInitialized();
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged =>
      $value.logged.copyWith.$chain((v) => call(logged: v));
  @override
  $R call({LoggedEntry? logged}) =>
      $apply(FieldCopyWithData({if (logged != null) #logged: logged}));
  @override
  MfpAdd $make(CopyWithData data) =>
      MfpAdd(data.get(#logged, or: $value.logged));

  @override
  MfpAddCopyWith<$R2, MfpAdd, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MfpAddCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpEditMapper extends SubClassMapperBase<MfpEdit> {
  MfpEditMapper._();

  static MfpEditMapper? _instance;
  static MfpEditMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpEditMapper._());
      MfpWriteMapper.ensureInitialized().addSubMapper(_instance!);
      LoggedEntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpEdit';

  static LoggedEntry _$logged(MfpEdit v) => v.logged;
  static const Field<MfpEdit, LoggedEntry> _f$logged = Field(
    'logged',
    _$logged,
  );
  static MfpLink _$link(MfpEdit v) => v.link;
  static const Field<MfpEdit, MfpLink> _f$link = Field('link', _$link);

  @override
  final MappableFields<MfpEdit> fields = const {
    #logged: _f$logged,
    #link: _f$link,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'write';
  @override
  final dynamic discriminatorValue = 'edit';
  @override
  late final ClassMapperBase superMapper = MfpWriteMapper.ensureInitialized();

  static MfpEdit _instantiate(DecodingData data) {
    return MfpEdit(data.dec(_f$logged), data.dec(_f$link));
  }

  @override
  final Function instantiate = _instantiate;

  static MfpEdit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpEdit>(map);
  }

  static MfpEdit fromJson(String json) {
    return ensureInitialized().decodeJson<MfpEdit>(json);
  }
}

mixin MfpEditMappable {
  String toJson() {
    return MfpEditMapper.ensureInitialized().encodeJson<MfpEdit>(
      this as MfpEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpEditMapper.ensureInitialized().encodeMap<MfpEdit>(
      this as MfpEdit,
    );
  }

  MfpEditCopyWith<MfpEdit, MfpEdit, MfpEdit> get copyWith =>
      _MfpEditCopyWithImpl<MfpEdit, MfpEdit>(
        this as MfpEdit,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpEditMapper.ensureInitialized().stringifyValue(this as MfpEdit);
  }

  @override
  bool operator ==(Object other) {
    return MfpEditMapper.ensureInitialized().equalsValue(
      this as MfpEdit,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpEditMapper.ensureInitialized().hashValue(this as MfpEdit);
  }
}

extension MfpEditValueCopy<$R, $Out> on ObjectCopyWith<$R, MfpEdit, $Out> {
  MfpEditCopyWith<$R, MfpEdit, $Out> get $asMfpEdit =>
      $base.as((v, t, t2) => _MfpEditCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpEditCopyWith<$R, $In extends MfpEdit, $Out>
    implements MfpWriteCopyWith<$R, $In, $Out> {
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  MfpLinkCopyWith<$R, MfpLink, MfpLink> get link;
  @override
  $R call({LoggedEntry? logged, MfpLink? link});
  MfpEditCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpEditCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpEdit, $Out>
    implements MfpEditCopyWith<$R, MfpEdit, $Out> {
  _MfpEditCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpEdit> $mapper =
      MfpEditMapper.ensureInitialized();
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged =>
      $value.logged.copyWith.$chain((v) => call(logged: v));
  @override
  MfpLinkCopyWith<$R, MfpLink, MfpLink> get link =>
      $value.link.copyWith.$chain((v) => call(link: v));
  @override
  $R call({LoggedEntry? logged, MfpLink? link}) => $apply(
    FieldCopyWithData({
      if (logged != null) #logged: logged,
      if (link != null) #link: link,
    }),
  );
  @override
  MfpEdit $make(CopyWithData data) => MfpEdit(
    data.get(#logged, or: $value.logged),
    data.get(#link, or: $value.link),
  );

  @override
  MfpEditCopyWith<$R2, MfpEdit, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MfpEditCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MfpDeletionMapper extends SubClassMapperBase<MfpDeletion> {
  MfpDeletionMapper._();

  static MfpDeletionMapper? _instance;
  static MfpDeletionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MfpDeletionMapper._());
      MfpWriteMapper.ensureInitialized().addSubMapper(_instance!);
      LoggedEntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MfpDeletion';

  static LoggedEntry _$logged(MfpDeletion v) => v.logged;
  static const Field<MfpDeletion, LoggedEntry> _f$logged = Field(
    'logged',
    _$logged,
  );
  static MfpLink _$link(MfpDeletion v) => v.link;
  static const Field<MfpDeletion, MfpLink> _f$link = Field('link', _$link);

  @override
  final MappableFields<MfpDeletion> fields = const {
    #logged: _f$logged,
    #link: _f$link,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'write';
  @override
  final dynamic discriminatorValue = 'deletion';
  @override
  late final ClassMapperBase superMapper = MfpWriteMapper.ensureInitialized();

  static MfpDeletion _instantiate(DecodingData data) {
    return MfpDeletion(data.dec(_f$logged), data.dec(_f$link));
  }

  @override
  final Function instantiate = _instantiate;

  static MfpDeletion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MfpDeletion>(map);
  }

  static MfpDeletion fromJson(String json) {
    return ensureInitialized().decodeJson<MfpDeletion>(json);
  }
}

mixin MfpDeletionMappable {
  String toJson() {
    return MfpDeletionMapper.ensureInitialized().encodeJson<MfpDeletion>(
      this as MfpDeletion,
    );
  }

  Map<String, dynamic> toMap() {
    return MfpDeletionMapper.ensureInitialized().encodeMap<MfpDeletion>(
      this as MfpDeletion,
    );
  }

  MfpDeletionCopyWith<MfpDeletion, MfpDeletion, MfpDeletion> get copyWith =>
      _MfpDeletionCopyWithImpl<MfpDeletion, MfpDeletion>(
        this as MfpDeletion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MfpDeletionMapper.ensureInitialized().stringifyValue(
      this as MfpDeletion,
    );
  }

  @override
  bool operator ==(Object other) {
    return MfpDeletionMapper.ensureInitialized().equalsValue(
      this as MfpDeletion,
      other,
    );
  }

  @override
  int get hashCode {
    return MfpDeletionMapper.ensureInitialized().hashValue(this as MfpDeletion);
  }
}

extension MfpDeletionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MfpDeletion, $Out> {
  MfpDeletionCopyWith<$R, MfpDeletion, $Out> get $asMfpDeletion =>
      $base.as((v, t, t2) => _MfpDeletionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MfpDeletionCopyWith<$R, $In extends MfpDeletion, $Out>
    implements MfpWriteCopyWith<$R, $In, $Out> {
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  MfpLinkCopyWith<$R, MfpLink, MfpLink> get link;
  @override
  $R call({LoggedEntry? logged, MfpLink? link});
  MfpDeletionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MfpDeletionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MfpDeletion, $Out>
    implements MfpDeletionCopyWith<$R, MfpDeletion, $Out> {
  _MfpDeletionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MfpDeletion> $mapper =
      MfpDeletionMapper.ensureInitialized();
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged =>
      $value.logged.copyWith.$chain((v) => call(logged: v));
  @override
  MfpLinkCopyWith<$R, MfpLink, MfpLink> get link =>
      $value.link.copyWith.$chain((v) => call(link: v));
  @override
  $R call({LoggedEntry? logged, MfpLink? link}) => $apply(
    FieldCopyWithData({
      if (logged != null) #logged: logged,
      if (link != null) #link: link,
    }),
  );
  @override
  MfpDeletion $make(CopyWithData data) => MfpDeletion(
    data.get(#logged, or: $value.logged),
    data.get(#link, or: $value.link),
  );

  @override
  MfpDeletionCopyWith<$R2, MfpDeletion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MfpDeletionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

