// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'removed_entry.dart';

class RemovedEntryMapper extends ClassMapperBase<RemovedEntry> {
  RemovedEntryMapper._();

  static RemovedEntryMapper? _instance;
  static RemovedEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemovedEntryMapper._());
      LoggedEntryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RemovedEntry';

  static LoggedEntry _$entry(RemovedEntry v) => v.entry;
  static const Field<RemovedEntry, LoggedEntry> _f$entry = Field(
    'entry',
    _$entry,
  );
  static bool _$ekkloRemoved(RemovedEntry v) => v.ekkloRemoved;
  static const Field<RemovedEntry, bool> _f$ekkloRemoved = Field(
    'ekkloRemoved',
    _$ekkloRemoved,
    key: r'ekklo_removed',
  );

  @override
  final MappableFields<RemovedEntry> fields = const {
    #entry: _f$entry,
    #ekkloRemoved: _f$ekkloRemoved,
  };
  @override
  final bool ignoreNull = true;

  static RemovedEntry _instantiate(DecodingData data) {
    return RemovedEntry(
      data.dec(_f$entry),
      ekkloRemoved: data.dec(_f$ekkloRemoved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RemovedEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemovedEntry>(map);
  }

  static RemovedEntry fromJson(String json) {
    return ensureInitialized().decodeJson<RemovedEntry>(json);
  }
}

mixin RemovedEntryMappable {
  String toJson() {
    return RemovedEntryMapper.ensureInitialized().encodeJson<RemovedEntry>(
      this as RemovedEntry,
    );
  }

  Map<String, dynamic> toMap() {
    return RemovedEntryMapper.ensureInitialized().encodeMap<RemovedEntry>(
      this as RemovedEntry,
    );
  }

  RemovedEntryCopyWith<RemovedEntry, RemovedEntry, RemovedEntry> get copyWith =>
      _RemovedEntryCopyWithImpl<RemovedEntry, RemovedEntry>(
        this as RemovedEntry,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemovedEntryMapper.ensureInitialized().stringifyValue(
      this as RemovedEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemovedEntryMapper.ensureInitialized().equalsValue(
      this as RemovedEntry,
      other,
    );
  }

  @override
  int get hashCode {
    return RemovedEntryMapper.ensureInitialized().hashValue(
      this as RemovedEntry,
    );
  }
}

extension RemovedEntryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemovedEntry, $Out> {
  RemovedEntryCopyWith<$R, RemovedEntry, $Out> get $asRemovedEntry =>
      $base.as((v, t, t2) => _RemovedEntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RemovedEntryCopyWith<$R, $In extends RemovedEntry, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get entry;
  $R call({LoggedEntry? entry, bool? ekkloRemoved});
  RemovedEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RemovedEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemovedEntry, $Out>
    implements RemovedEntryCopyWith<$R, RemovedEntry, $Out> {
  _RemovedEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemovedEntry> $mapper =
      RemovedEntryMapper.ensureInitialized();
  @override
  LoggedEntryCopyWith<$R, LoggedEntry, LoggedEntry> get entry =>
      $value.entry.copyWith.$chain((v) => call(entry: v));
  @override
  $R call({LoggedEntry? entry, bool? ekkloRemoved}) => $apply(
    FieldCopyWithData({
      if (entry != null) #entry: entry,
      if (ekkloRemoved != null) #ekkloRemoved: ekkloRemoved,
    }),
  );
  @override
  RemovedEntry $make(CopyWithData data) => RemovedEntry(
    data.get(#entry, or: $value.entry),
    ekkloRemoved: data.get(#ekkloRemoved, or: $value.ekkloRemoved),
  );

  @override
  RemovedEntryCopyWith<$R2, RemovedEntry, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemovedEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

