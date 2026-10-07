// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'compared_entry.dart';

class ComparedEntryMapper extends ClassMapperBase<ComparedEntry> {
  ComparedEntryMapper._();

  static ComparedEntryMapper? _instance;
  static ComparedEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ComparedEntryMapper._());
      MfpFoodEntryMapper.ensureInitialized();
      EntryStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ComparedEntry';

  static MfpFoodEntry _$entry(ComparedEntry v) => v.entry;
  static const Field<ComparedEntry, MfpFoodEntry> _f$entry = Field(
    'entry',
    _$entry,
  );
  static EntryStatus _$status(ComparedEntry v) => v.status;
  static const Field<ComparedEntry, EntryStatus> _f$status = Field(
    'status',
    _$status,
  );

  @override
  final MappableFields<ComparedEntry> fields = const {
    #entry: _f$entry,
    #status: _f$status,
  };
  @override
  final bool ignoreNull = true;

  static ComparedEntry _instantiate(DecodingData data) {
    return ComparedEntry(data.dec(_f$entry), data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static ComparedEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ComparedEntry>(map);
  }

  static ComparedEntry fromJson(String json) {
    return ensureInitialized().decodeJson<ComparedEntry>(json);
  }
}

mixin ComparedEntryMappable {
  String toJson() {
    return ComparedEntryMapper.ensureInitialized().encodeJson<ComparedEntry>(
      this as ComparedEntry,
    );
  }

  Map<String, dynamic> toMap() {
    return ComparedEntryMapper.ensureInitialized().encodeMap<ComparedEntry>(
      this as ComparedEntry,
    );
  }

  ComparedEntryCopyWith<ComparedEntry, ComparedEntry, ComparedEntry>
  get copyWith => _ComparedEntryCopyWithImpl<ComparedEntry, ComparedEntry>(
    this as ComparedEntry,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ComparedEntryMapper.ensureInitialized().stringifyValue(
      this as ComparedEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    return ComparedEntryMapper.ensureInitialized().equalsValue(
      this as ComparedEntry,
      other,
    );
  }

  @override
  int get hashCode {
    return ComparedEntryMapper.ensureInitialized().hashValue(
      this as ComparedEntry,
    );
  }
}

extension ComparedEntryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ComparedEntry, $Out> {
  ComparedEntryCopyWith<$R, ComparedEntry, $Out> get $asComparedEntry =>
      $base.as((v, t, t2) => _ComparedEntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ComparedEntryCopyWith<$R, $In extends ComparedEntry, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get entry;
  EntryStatusCopyWith<$R, EntryStatus, EntryStatus> get status;
  $R call({MfpFoodEntry? entry, EntryStatus? status});
  ComparedEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ComparedEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ComparedEntry, $Out>
    implements ComparedEntryCopyWith<$R, ComparedEntry, $Out> {
  _ComparedEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ComparedEntry> $mapper =
      ComparedEntryMapper.ensureInitialized();
  @override
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get entry =>
      $value.entry.copyWith.$chain((v) => call(entry: v));
  @override
  EntryStatusCopyWith<$R, EntryStatus, EntryStatus> get status =>
      $value.status.copyWith.$chain((v) => call(status: v));
  @override
  $R call({MfpFoodEntry? entry, EntryStatus? status}) => $apply(
    FieldCopyWithData({
      if (entry != null) #entry: entry,
      if (status != null) #status: status,
    }),
  );
  @override
  ComparedEntry $make(CopyWithData data) => ComparedEntry(
    data.get(#entry, or: $value.entry),
    data.get(#status, or: $value.status),
  );

  @override
  ComparedEntryCopyWith<$R2, ComparedEntry, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ComparedEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

