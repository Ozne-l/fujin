// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'replacement.dart';

class ReplacementMapper extends ClassMapperBase<Replacement> {
  ReplacementMapper._();

  static ReplacementMapper? _instance;
  static ReplacementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReplacementMapper._());
      ReplacedEditMapper.ensureInitialized();
      ReplacedDeletionMapper.ensureInitialized();
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Replacement';

  static LoggedEntry _$logged(Replacement v) => v.logged;
  static const Field<Replacement, LoggedEntry> _f$logged = Field(
    'logged',
    _$logged,
  );

  @override
  final MappableFields<Replacement> fields = const {#logged: _f$logged};
  @override
  final bool ignoreNull = true;

  static Replacement _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'Replacement',
      'replaced',
      '${data.value['replaced']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Replacement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Replacement>(map);
  }

  static Replacement fromJson(String json) {
    return ensureInitialized().decodeJson<Replacement>(json);
  }
}

mixin ReplacementMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ReplacementCopyWith<Replacement, Replacement, Replacement> get copyWith;
}

abstract class ReplacementCopyWith<$R, $In extends Replacement, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  $R call({LoggedEntry? logged});
  ReplacementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ReplacedEditMapper extends SubClassMapperBase<ReplacedEdit> {
  ReplacedEditMapper._();

  static ReplacedEditMapper? _instance;
  static ReplacedEditMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReplacedEditMapper._());
      ReplacementMapper.ensureInitialized().addSubMapper(_instance!);
      LoggedEntryMapper.ensureInitialized();
      MfpLinkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReplacedEdit';

  static LoggedEntry _$logged(ReplacedEdit v) => v.logged;
  static const Field<ReplacedEdit, LoggedEntry> _f$logged = Field(
    'logged',
    _$logged,
  );
  static MfpLink _$before(ReplacedEdit v) => v.before;
  static const Field<ReplacedEdit, MfpLink> _f$before = Field(
    'before',
    _$before,
  );

  @override
  final MappableFields<ReplacedEdit> fields = const {
    #logged: _f$logged,
    #before: _f$before,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'replaced';
  @override
  final dynamic discriminatorValue = 'edit';
  @override
  late final ClassMapperBase superMapper =
      ReplacementMapper.ensureInitialized();

  static ReplacedEdit _instantiate(DecodingData data) {
    return ReplacedEdit(data.dec(_f$logged), before: data.dec(_f$before));
  }

  @override
  final Function instantiate = _instantiate;

  static ReplacedEdit fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReplacedEdit>(map);
  }

  static ReplacedEdit fromJson(String json) {
    return ensureInitialized().decodeJson<ReplacedEdit>(json);
  }
}

mixin ReplacedEditMappable {
  String toJson() {
    return ReplacedEditMapper.ensureInitialized().encodeJson<ReplacedEdit>(
      this as ReplacedEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return ReplacedEditMapper.ensureInitialized().encodeMap<ReplacedEdit>(
      this as ReplacedEdit,
    );
  }

  ReplacedEditCopyWith<ReplacedEdit, ReplacedEdit, ReplacedEdit> get copyWith =>
      _ReplacedEditCopyWithImpl<ReplacedEdit, ReplacedEdit>(
        this as ReplacedEdit,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReplacedEditMapper.ensureInitialized().stringifyValue(
      this as ReplacedEdit,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReplacedEditMapper.ensureInitialized().equalsValue(
      this as ReplacedEdit,
      other,
    );
  }

  @override
  int get hashCode {
    return ReplacedEditMapper.ensureInitialized().hashValue(
      this as ReplacedEdit,
    );
  }
}

extension ReplacedEditValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReplacedEdit, $Out> {
  ReplacedEditCopyWith<$R, ReplacedEdit, $Out> get $asReplacedEdit =>
      $base.as((v, t, t2) => _ReplacedEditCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReplacedEditCopyWith<$R, $In extends ReplacedEdit, $Out>
    implements ReplacementCopyWith<$R, $In, $Out> {
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  MfpLinkCopyWith<$R, MfpLink, MfpLink> get before;
  @override
  $R call({LoggedEntry? logged, MfpLink? before});
  ReplacedEditCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReplacedEditCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReplacedEdit, $Out>
    implements ReplacedEditCopyWith<$R, ReplacedEdit, $Out> {
  _ReplacedEditCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReplacedEdit> $mapper =
      ReplacedEditMapper.ensureInitialized();
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged =>
      $value.logged.copyWith.$chain((v) => call(logged: v));
  @override
  MfpLinkCopyWith<$R, MfpLink, MfpLink> get before =>
      $value.before.copyWith.$chain((v) => call(before: v));
  @override
  $R call({LoggedEntry? logged, MfpLink? before}) => $apply(
    FieldCopyWithData({
      if (logged != null) #logged: logged,
      if (before != null) #before: before,
    }),
  );
  @override
  ReplacedEdit $make(CopyWithData data) => ReplacedEdit(
    data.get(#logged, or: $value.logged),
    before: data.get(#before, or: $value.before),
  );

  @override
  ReplacedEditCopyWith<$R2, ReplacedEdit, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReplacedEditCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ReplacedDeletionMapper extends SubClassMapperBase<ReplacedDeletion> {
  ReplacedDeletionMapper._();

  static ReplacedDeletionMapper? _instance;
  static ReplacedDeletionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReplacedDeletionMapper._());
      ReplacementMapper.ensureInitialized().addSubMapper(_instance!);
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReplacedDeletion';

  static LoggedEntry _$logged(ReplacedDeletion v) => v.logged;
  static const Field<ReplacedDeletion, LoggedEntry> _f$logged = Field(
    'logged',
    _$logged,
  );

  @override
  final MappableFields<ReplacedDeletion> fields = const {#logged: _f$logged};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'replaced';
  @override
  final dynamic discriminatorValue = 'deletion';
  @override
  late final ClassMapperBase superMapper =
      ReplacementMapper.ensureInitialized();

  static ReplacedDeletion _instantiate(DecodingData data) {
    return ReplacedDeletion(data.dec(_f$logged));
  }

  @override
  final Function instantiate = _instantiate;

  static ReplacedDeletion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReplacedDeletion>(map);
  }

  static ReplacedDeletion fromJson(String json) {
    return ensureInitialized().decodeJson<ReplacedDeletion>(json);
  }
}

mixin ReplacedDeletionMappable {
  String toJson() {
    return ReplacedDeletionMapper.ensureInitialized()
        .encodeJson<ReplacedDeletion>(this as ReplacedDeletion);
  }

  Map<String, dynamic> toMap() {
    return ReplacedDeletionMapper.ensureInitialized()
        .encodeMap<ReplacedDeletion>(this as ReplacedDeletion);
  }

  ReplacedDeletionCopyWith<ReplacedDeletion, ReplacedDeletion, ReplacedDeletion>
  get copyWith =>
      _ReplacedDeletionCopyWithImpl<ReplacedDeletion, ReplacedDeletion>(
        this as ReplacedDeletion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReplacedDeletionMapper.ensureInitialized().stringifyValue(
      this as ReplacedDeletion,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReplacedDeletionMapper.ensureInitialized().equalsValue(
      this as ReplacedDeletion,
      other,
    );
  }

  @override
  int get hashCode {
    return ReplacedDeletionMapper.ensureInitialized().hashValue(
      this as ReplacedDeletion,
    );
  }
}

extension ReplacedDeletionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReplacedDeletion, $Out> {
  ReplacedDeletionCopyWith<$R, ReplacedDeletion, $Out>
  get $asReplacedDeletion =>
      $base.as((v, t, t2) => _ReplacedDeletionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReplacedDeletionCopyWith<$R, $In extends ReplacedDeletion, $Out>
    implements ReplacementCopyWith<$R, $In, $Out> {
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged;
  @override
  $R call({LoggedEntry? logged});
  ReplacedDeletionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ReplacedDeletionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReplacedDeletion, $Out>
    implements ReplacedDeletionCopyWith<$R, ReplacedDeletion, $Out> {
  _ReplacedDeletionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReplacedDeletion> $mapper =
      ReplacedDeletionMapper.ensureInitialized();
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get logged =>
      $value.logged.copyWith.$chain((v) => call(logged: v));
  @override
  $R call({LoggedEntry? logged}) =>
      $apply(FieldCopyWithData({if (logged != null) #logged: logged}));
  @override
  ReplacedDeletion $make(CopyWithData data) =>
      ReplacedDeletion(data.get(#logged, or: $value.logged));

  @override
  ReplacedDeletionCopyWith<$R2, ReplacedDeletion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReplacedDeletionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

