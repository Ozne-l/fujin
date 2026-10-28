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
      RemoveEntryRunningMapper.ensureInitialized();
      RemoveEntryDoneMapper.ensureInitialized();
      RemoveEntryFailedMapper.ensureInitialized();
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

class RemoveEntryRunningMapper extends SubClassMapperBase<RemoveEntryRunning> {
  RemoveEntryRunningMapper._();

  static RemoveEntryRunningMapper? _instance;
  static RemoveEntryRunningMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveEntryRunningMapper._());
      RemoveEntryStateMapper.ensureInitialized().addSubMapper(_instance!);
      EntryRemovalMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveEntryRunning';

  static EntryRemoval _$removal(RemoveEntryRunning v) => v.removal;
  static const Field<RemoveEntryRunning, EntryRemoval> _f$removal = Field(
    'removal',
    _$removal,
  );

  @override
  final MappableFields<RemoveEntryRunning> fields = const {
    #removal: _f$removal,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'running';
  @override
  late final ClassMapperBase superMapper =
      RemoveEntryStateMapper.ensureInitialized();

  static RemoveEntryRunning _instantiate(DecodingData data) {
    return RemoveEntryRunning(data.dec(_f$removal));
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveEntryRunning fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveEntryRunning>(map);
  }

  static RemoveEntryRunning fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveEntryRunning>(json);
  }
}

mixin RemoveEntryRunningMappable {
  String toJson() {
    return RemoveEntryRunningMapper.ensureInitialized()
        .encodeJson<RemoveEntryRunning>(this as RemoveEntryRunning);
  }

  Map<String, dynamic> toMap() {
    return RemoveEntryRunningMapper.ensureInitialized()
        .encodeMap<RemoveEntryRunning>(this as RemoveEntryRunning);
  }

  RemoveEntryRunningCopyWith<
    RemoveEntryRunning,
    RemoveEntryRunning,
    RemoveEntryRunning
  >
  get copyWith =>
      _RemoveEntryRunningCopyWithImpl<RemoveEntryRunning, RemoveEntryRunning>(
        this as RemoveEntryRunning,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoveEntryRunningMapper.ensureInitialized().stringifyValue(
      this as RemoveEntryRunning,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoveEntryRunningMapper.ensureInitialized().equalsValue(
      this as RemoveEntryRunning,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoveEntryRunningMapper.ensureInitialized().hashValue(
      this as RemoveEntryRunning,
    );
  }
}

extension RemoveEntryRunningValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoveEntryRunning, $Out> {
  RemoveEntryRunningCopyWith<$R, RemoveEntryRunning, $Out>
  get $asRemoveEntryRunning => $base.as(
    (v, t, t2) => _RemoveEntryRunningCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RemoveEntryRunningCopyWith<
  $R,
  $In extends RemoveEntryRunning,
  $Out
>
    implements RemoveEntryStateCopyWith<$R, $In, $Out> {
  EntryRemovalCopyWith<$R, EntryRemoval, EntryRemoval> get removal;
  @override
  $R call({EntryRemoval? removal});
  RemoveEntryRunningCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RemoveEntryRunningCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoveEntryRunning, $Out>
    implements RemoveEntryRunningCopyWith<$R, RemoveEntryRunning, $Out> {
  _RemoveEntryRunningCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoveEntryRunning> $mapper =
      RemoveEntryRunningMapper.ensureInitialized();
  @override
  EntryRemovalCopyWith<$R, EntryRemoval, EntryRemoval> get removal =>
      $value.removal.copyWith.$chain((v) => call(removal: v));
  @override
  $R call({EntryRemoval? removal}) =>
      $apply(FieldCopyWithData({if (removal != null) #removal: removal}));
  @override
  RemoveEntryRunning $make(CopyWithData data) =>
      RemoveEntryRunning(data.get(#removal, or: $value.removal));

  @override
  RemoveEntryRunningCopyWith<$R2, RemoveEntryRunning, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoveEntryRunningCopyWithImpl<$R2, $Out2>($value, $cast, t);
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

class RemoveEntryFailedMapper extends SubClassMapperBase<RemoveEntryFailed> {
  RemoveEntryFailedMapper._();

  static RemoveEntryFailedMapper? _instance;
  static RemoveEntryFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveEntryFailedMapper._());
      RemoveEntryStateMapper.ensureInitialized().addSubMapper(_instance!);
      EntryRemovalMapper.ensureInitialized();
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveEntryFailed';

  static EntryRemoval _$removal(RemoveEntryFailed v) => v.removal;
  static const Field<RemoveEntryFailed, EntryRemoval> _f$removal = Field(
    'removal',
    _$removal,
  );
  static ReadProblem _$problem(RemoveEntryFailed v) => v.problem;
  static const Field<RemoveEntryFailed, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );
  static bool _$removedFromEkklo(RemoveEntryFailed v) => v.removedFromEkklo;
  static const Field<RemoveEntryFailed, bool> _f$removedFromEkklo = Field(
    'removedFromEkklo',
    _$removedFromEkklo,
    key: r'removed_from_ekklo',
  );
  static bool _$blockedInDev(RemoveEntryFailed v) => v.blockedInDev;
  static const Field<RemoveEntryFailed, bool> _f$blockedInDev = Field(
    'blockedInDev',
    _$blockedInDev,
    key: r'blocked_in_dev',
  );

  @override
  final MappableFields<RemoveEntryFailed> fields = const {
    #removal: _f$removal,
    #problem: _f$problem,
    #removedFromEkklo: _f$removedFromEkklo,
    #blockedInDev: _f$blockedInDev,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'state';
  @override
  final dynamic discriminatorValue = 'failed';
  @override
  late final ClassMapperBase superMapper =
      RemoveEntryStateMapper.ensureInitialized();

  static RemoveEntryFailed _instantiate(DecodingData data) {
    return RemoveEntryFailed(
      data.dec(_f$removal),
      data.dec(_f$problem),
      removedFromEkklo: data.dec(_f$removedFromEkklo),
      blockedInDev: data.dec(_f$blockedInDev),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveEntryFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveEntryFailed>(map);
  }

  static RemoveEntryFailed fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveEntryFailed>(json);
  }
}

mixin RemoveEntryFailedMappable {
  String toJson() {
    return RemoveEntryFailedMapper.ensureInitialized()
        .encodeJson<RemoveEntryFailed>(this as RemoveEntryFailed);
  }

  Map<String, dynamic> toMap() {
    return RemoveEntryFailedMapper.ensureInitialized()
        .encodeMap<RemoveEntryFailed>(this as RemoveEntryFailed);
  }

  RemoveEntryFailedCopyWith<
    RemoveEntryFailed,
    RemoveEntryFailed,
    RemoveEntryFailed
  >
  get copyWith =>
      _RemoveEntryFailedCopyWithImpl<RemoveEntryFailed, RemoveEntryFailed>(
        this as RemoveEntryFailed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoveEntryFailedMapper.ensureInitialized().stringifyValue(
      this as RemoveEntryFailed,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoveEntryFailedMapper.ensureInitialized().equalsValue(
      this as RemoveEntryFailed,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoveEntryFailedMapper.ensureInitialized().hashValue(
      this as RemoveEntryFailed,
    );
  }
}

extension RemoveEntryFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoveEntryFailed, $Out> {
  RemoveEntryFailedCopyWith<$R, RemoveEntryFailed, $Out>
  get $asRemoveEntryFailed => $base.as(
    (v, t, t2) => _RemoveEntryFailedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RemoveEntryFailedCopyWith<
  $R,
  $In extends RemoveEntryFailed,
  $Out
>
    implements RemoveEntryStateCopyWith<$R, $In, $Out> {
  EntryRemovalCopyWith<$R, EntryRemoval, EntryRemoval> get removal;
  @override
  $R call({
    EntryRemoval? removal,
    ReadProblem? problem,
    bool? removedFromEkklo,
    bool? blockedInDev,
  });
  RemoveEntryFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RemoveEntryFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoveEntryFailed, $Out>
    implements RemoveEntryFailedCopyWith<$R, RemoveEntryFailed, $Out> {
  _RemoveEntryFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoveEntryFailed> $mapper =
      RemoveEntryFailedMapper.ensureInitialized();
  @override
  EntryRemovalCopyWith<$R, EntryRemoval, EntryRemoval> get removal =>
      $value.removal.copyWith.$chain((v) => call(removal: v));
  @override
  $R call({
    EntryRemoval? removal,
    ReadProblem? problem,
    bool? removedFromEkklo,
    bool? blockedInDev,
  }) => $apply(
    FieldCopyWithData({
      if (removal != null) #removal: removal,
      if (problem != null) #problem: problem,
      if (removedFromEkklo != null) #removedFromEkklo: removedFromEkklo,
      if (blockedInDev != null) #blockedInDev: blockedInDev,
    }),
  );
  @override
  RemoveEntryFailed $make(CopyWithData data) => RemoveEntryFailed(
    data.get(#removal, or: $value.removal),
    data.get(#problem, or: $value.problem),
    removedFromEkklo: data.get(#removedFromEkklo, or: $value.removedFromEkklo),
    blockedInDev: data.get(#blockedInDev, or: $value.blockedInDev),
  );

  @override
  RemoveEntryFailedCopyWith<$R2, RemoveEntryFailed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoveEntryFailedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

