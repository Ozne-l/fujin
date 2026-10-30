// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'stored_day.dart';

class StoredDayMapper extends ClassMapperBase<StoredDay> {
  StoredDayMapper._();

  static StoredDayMapper? _instance;
  static StoredDayMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StoredDayMapper._());
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StoredDay';

  static List<LoggedEntry> _$entries(StoredDay v) => v.entries;
  static const Field<StoredDay, List<LoggedEntry>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
    def: const [],
  );
  static List<LoggedEntry> _$deleted(StoredDay v) => v.deleted;
  static const Field<StoredDay, List<LoggedEntry>> _f$deleted = Field(
    'deleted',
    _$deleted,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<StoredDay> fields = const {
    #entries: _f$entries,
    #deleted: _f$deleted,
  };
  @override
  final bool ignoreNull = true;

  static StoredDay _instantiate(DecodingData data) {
    return StoredDay(
      entries: data.dec(_f$entries),
      deleted: data.dec(_f$deleted),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StoredDay fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StoredDay>(map);
  }

  static StoredDay fromJson(String json) {
    return ensureInitialized().decodeJson<StoredDay>(json);
  }
}

mixin StoredDayMappable {
  String toJson() {
    return StoredDayMapper.ensureInitialized().encodeJson<StoredDay>(
      this as StoredDay,
    );
  }

  Map<String, dynamic> toMap() {
    return StoredDayMapper.ensureInitialized().encodeMap<StoredDay>(
      this as StoredDay,
    );
  }

  StoredDayCopyWith<StoredDay, StoredDay, StoredDay> get copyWith =>
      _StoredDayCopyWithImpl<StoredDay, StoredDay>(
        this as StoredDay,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StoredDayMapper.ensureInitialized().stringifyValue(
      this as StoredDay,
    );
  }

  @override
  bool operator ==(Object other) {
    return StoredDayMapper.ensureInitialized().equalsValue(
      this as StoredDay,
      other,
    );
  }

  @override
  int get hashCode {
    return StoredDayMapper.ensureInitialized().hashValue(this as StoredDay);
  }
}

extension StoredDayValueCopy<$R, $Out> on ObjectCopyWith<$R, StoredDay, $Out> {
  StoredDayCopyWith<$R, StoredDay, $Out> get $asStoredDay =>
      $base.as((v, t, t2) => _StoredDayCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StoredDayCopyWith<$R, $In extends StoredDay, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get entries;
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get deleted;
  $R call({List<LoggedEntry>? entries, List<LoggedEntry>? deleted});
  StoredDayCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StoredDayCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StoredDay, $Out>
    implements StoredDayCopyWith<$R, StoredDay, $Out> {
  _StoredDayCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StoredDay> $mapper =
      StoredDayMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get entries => ListCopyWith(
    $value.entries,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(entries: v),
  );
  @override
  ListCopyWith<
    $R,
    LoggedEntry,
    LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry>
  >
  get deleted => ListCopyWith(
    $value.deleted,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(deleted: v),
  );
  @override
  $R call({List<LoggedEntry>? entries, List<LoggedEntry>? deleted}) => $apply(
    FieldCopyWithData({
      if (entries != null) #entries: entries,
      if (deleted != null) #deleted: deleted,
    }),
  );
  @override
  StoredDay $make(CopyWithData data) => StoredDay(
    entries: data.get(#entries, or: $value.entries),
    deleted: data.get(#deleted, or: $value.deleted),
  );

  @override
  StoredDayCopyWith<$R2, StoredDay, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StoredDayCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

