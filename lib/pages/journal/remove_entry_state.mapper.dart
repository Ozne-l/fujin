// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'remove_entry_state.dart';

class RemoveEntryStateMapper extends ClassMapperBase<RemoveEntryState> {
  RemoveEntryStateMapper._();

  static RemoveEntryStateMapper? _instance;
  static RemoveEntryStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveEntryStateMapper._());
      RemoveEntryIdleMapper.ensureInitialized();
      RemoveEntryDoneMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveEntryState';

  @override
  final MappableFields<RemoveEntryState> fields = const {};
  @override
  final bool ignoreNull = true;

  static RemoveEntryState _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'RemoveEntryState',
      'state',
      '${data.value['state']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveEntryState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveEntryState>(map);
  }

  static RemoveEntryState fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveEntryState>(json);
  }
}

mixin RemoveEntryStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  RemoveEntryStateCopyWith<RemoveEntryState, RemoveEntryState, RemoveEntryState>
  get copyWith;
}

abstract class RemoveEntryStateCopyWith<$R, $In extends RemoveEntryState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  RemoveEntryStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class RemoveEntryIdleMapper extends SubClassMapperBase<RemoveEntryIdle> {
  RemoveEntryIdleMapper._();

  static RemoveEntryIdleMapper? _instance;
  static RemoveEntryIdleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveEntryIdleMapper._());
      RemoveEntryStateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveEntryIdle';

  @override
  final MappableFields<RemoveEntryIdle> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'idle';
  @override
  late final ClassMapperBase superMapper =
      RemoveEntryStateMapper.ensureInitialized();

  static RemoveEntryIdle _instantiate(DecodingData data) {
    return RemoveEntryIdle();
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveEntryIdle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveEntryIdle>(map);
  }

  static RemoveEntryIdle fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveEntryIdle>(json);
  }
}

mixin RemoveEntryIdleMappable {
  String toJson() {
    return RemoveEntryIdleMapper.ensureInitialized()
        .encodeJson<RemoveEntryIdle>(this as RemoveEntryIdle);
  }

  Map<String, dynamic> toMap() {
    return RemoveEntryIdleMapper.ensureInitialized().encodeMap<RemoveEntryIdle>(
      this as RemoveEntryIdle,
    );
  }

  RemoveEntryIdleCopyWith<RemoveEntryIdle, RemoveEntryIdle, RemoveEntryIdle>
  get copyWith =>
      _RemoveEntryIdleCopyWithImpl<RemoveEntryIdle, RemoveEntryIdle>(
        this as RemoveEntryIdle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoveEntryIdleMapper.ensureInitialized().stringifyValue(
      this as RemoveEntryIdle,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoveEntryIdleMapper.ensureInitialized().equalsValue(
      this as RemoveEntryIdle,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoveEntryIdleMapper.ensureInitialized().hashValue(
      this as RemoveEntryIdle,
    );
  }
}

extension RemoveEntryIdleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoveEntryIdle, $Out> {
  RemoveEntryIdleCopyWith<$R, RemoveEntryIdle, $Out> get $asRemoveEntryIdle =>
      $base.as((v, t, t2) => _RemoveEntryIdleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RemoveEntryIdleCopyWith<$R, $In extends RemoveEntryIdle, $Out>
    implements RemoveEntryStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  RemoveEntryIdleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RemoveEntryIdleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoveEntryIdle, $Out>
    implements RemoveEntryIdleCopyWith<$R, RemoveEntryIdle, $Out> {
  _RemoveEntryIdleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoveEntryIdle> $mapper =
      RemoveEntryIdleMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  RemoveEntryIdle $make(CopyWithData data) => RemoveEntryIdle();

  @override
  RemoveEntryIdleCopyWith<$R2, RemoveEntryIdle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoveEntryIdleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RemoveEntryDoneMapper extends SubClassMapperBase<RemoveEntryDone> {
  RemoveEntryDoneMapper._();

  static RemoveEntryDoneMapper? _instance;
  static RemoveEntryDoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveEntryDoneMapper._());
      RemoveEntryStateMapper.ensureInitialized().addSubMapper(_instance!);
      EntryRemovalMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveEntryDone';

  static EntryRemoval _$removal(RemoveEntryDone v) => v.removal;
  static const Field<RemoveEntryDone, EntryRemoval> _f$removal = Field(
    'removal',
    _$removal,
  );
  static bool _$ekkloRemoved(RemoveEntryDone v) => v.ekkloRemoved;
  static const Field<RemoveEntryDone, bool> _f$ekkloRemoved = Field(
    'ekkloRemoved',
    _$ekkloRemoved,
    key: r'ekklo_removed',
  );

  @override
  final MappableFields<RemoveEntryDone> fields = const {
    #removal: _f$removal,
    #ekkloRemoved: _f$ekkloRemoved,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'done';
  @override
  late final ClassMapperBase superMapper =
      RemoveEntryStateMapper.ensureInitialized();

  static RemoveEntryDone _instantiate(DecodingData data) {
    return RemoveEntryDone(
      data.dec(_f$removal),
      ekkloRemoved: data.dec(_f$ekkloRemoved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveEntryDone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveEntryDone>(map);
  }

  static RemoveEntryDone fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveEntryDone>(json);
  }
}

mixin RemoveEntryDoneMappable {
  String toJson() {
    return RemoveEntryDoneMapper.ensureInitialized()
        .encodeJson<RemoveEntryDone>(this as RemoveEntryDone);
  }

  Map<String, dynamic> toMap() {
    return RemoveEntryDoneMapper.ensureInitialized().encodeMap<RemoveEntryDone>(
      this as RemoveEntryDone,
    );
  }

  RemoveEntryDoneCopyWith<RemoveEntryDone, RemoveEntryDone, RemoveEntryDone>
  get copyWith =>
      _RemoveEntryDoneCopyWithImpl<RemoveEntryDone, RemoveEntryDone>(
        this as RemoveEntryDone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoveEntryDoneMapper.ensureInitialized().stringifyValue(
      this as RemoveEntryDone,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoveEntryDoneMapper.ensureInitialized().equalsValue(
      this as RemoveEntryDone,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoveEntryDoneMapper.ensureInitialized().hashValue(
      this as RemoveEntryDone,
    );
  }
}

extension RemoveEntryDoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoveEntryDone, $Out> {
  RemoveEntryDoneCopyWith<$R, RemoveEntryDone, $Out> get $asRemoveEntryDone =>
      $base.as((v, t, t2) => _RemoveEntryDoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RemoveEntryDoneCopyWith<$R, $In extends RemoveEntryDone, $Out>
    implements RemoveEntryStateCopyWith<$R, $In, $Out> {
  EntryRemovalCopyWith<$R, EntryRemoval, EntryRemoval> get removal;
  @override
  $R call({EntryRemoval? removal, bool? ekkloRemoved});
  RemoveEntryDoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RemoveEntryDoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoveEntryDone, $Out>
    implements RemoveEntryDoneCopyWith<$R, RemoveEntryDone, $Out> {
  _RemoveEntryDoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoveEntryDone> $mapper =
      RemoveEntryDoneMapper.ensureInitialized();
  @override
  EntryRemovalCopyWith<$R, EntryRemoval, EntryRemoval> get removal =>
      $value.removal.copyWith.$chain((v) => call(removal: v));
  @override
  $R call({EntryRemoval? removal, bool? ekkloRemoved}) => $apply(
    FieldCopyWithData({
      if (removal != null) #removal: removal,
      if (ekkloRemoved != null) #ekkloRemoved: ekkloRemoved,
    }),
  );
  @override
  RemoveEntryDone $make(CopyWithData data) => RemoveEntryDone(
    data.get(#removal, or: $value.removal),
    ekkloRemoved: data.get(#ekkloRemoved, or: $value.ekkloRemoved),
  );

  @override
  RemoveEntryDoneCopyWith<$R2, RemoveEntryDone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoveEntryDoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

