// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'entry_removal.dart';

class EntryRemovalMapper extends ClassMapperBase<EntryRemoval> {
  EntryRemovalMapper._();

  static EntryRemovalMapper? _instance;
  static EntryRemovalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EntryRemovalMapper._());
      MfpFoodEntryMapper.ensureInitialized();
      RemovalReasonMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EntryRemoval';

  static String _$entryId(EntryRemoval v) => v.entryId;
  static const Field<EntryRemoval, String> _f$entryId = Field(
    'entryId',
    _$entryId,
    key: r'entry_id',
  );
  static MfpFoodEntry _$entry(EntryRemoval v) => v.entry;
  static const Field<EntryRemoval, MfpFoodEntry> _f$entry = Field(
    'entry',
    _$entry,
  );
  static RemovalReason _$reason(EntryRemoval v) => v.reason;
  static const Field<EntryRemoval, RemovalReason> _f$reason = Field(
    'reason',
    _$reason,
  );

  @override
  final MappableFields<EntryRemoval> fields = const {
    #entryId: _f$entryId,
    #entry: _f$entry,
    #reason: _f$reason,
  };
  @override
  final bool ignoreNull = true;

  static EntryRemoval _instantiate(DecodingData data) {
    return EntryRemoval(
      entryId: data.dec(_f$entryId),
      entry: data.dec(_f$entry),
      reason: data.dec(_f$reason),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EntryRemoval fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EntryRemoval>(map);
  }

  static EntryRemoval fromJson(String json) {
    return ensureInitialized().decodeJson<EntryRemoval>(json);
  }
}

mixin EntryRemovalMappable {
  String toJson() {
    return EntryRemovalMapper.ensureInitialized().encodeJson<EntryRemoval>(
      this as EntryRemoval,
    );
  }

  Map<String, dynamic> toMap() {
    return EntryRemovalMapper.ensureInitialized().encodeMap<EntryRemoval>(
      this as EntryRemoval,
    );
  }

  EntryRemovalCopyWith<EntryRemoval, EntryRemoval, EntryRemoval> get copyWith =>
      _EntryRemovalCopyWithImpl<EntryRemoval, EntryRemoval>(
        this as EntryRemoval,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EntryRemovalMapper.ensureInitialized().stringifyValue(
      this as EntryRemoval,
    );
  }

  @override
  bool operator ==(Object other) {
    return EntryRemovalMapper.ensureInitialized().equalsValue(
      this as EntryRemoval,
      other,
    );
  }

  @override
  int get hashCode {
    return EntryRemovalMapper.ensureInitialized().hashValue(
      this as EntryRemoval,
    );
  }
}

extension EntryRemovalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EntryRemoval, $Out> {
  EntryRemovalCopyWith<$R, EntryRemoval, $Out> get $asEntryRemoval =>
      $base.as((v, t, t2) => _EntryRemovalCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EntryRemovalCopyWith<$R, $In extends EntryRemoval, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get entry;
  $R call({String? entryId, MfpFoodEntry? entry, RemovalReason? reason});
  EntryRemovalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EntryRemovalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EntryRemoval, $Out>
    implements EntryRemovalCopyWith<$R, EntryRemoval, $Out> {
  _EntryRemovalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EntryRemoval> $mapper =
      EntryRemovalMapper.ensureInitialized();
  @override
  MfpFoodEntryCopyWith<$R, MfpFoodEntry, MfpFoodEntry> get entry =>
      $value.entry.copyWith.$chain((v) => call(entry: v));
  @override
  $R call({String? entryId, MfpFoodEntry? entry, RemovalReason? reason}) =>
      $apply(
        FieldCopyWithData({
          if (entryId != null) #entryId: entryId,
          if (entry != null) #entry: entry,
          if (reason != null) #reason: reason,
        }),
      );
  @override
  EntryRemoval $make(CopyWithData data) => EntryRemoval(
    entryId: data.get(#entryId, or: $value.entryId),
    entry: data.get(#entry, or: $value.entry),
    reason: data.get(#reason, or: $value.reason),
  );

  @override
  EntryRemovalCopyWith<$R2, EntryRemoval, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EntryRemovalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

