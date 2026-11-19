// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'delete_outcome.dart';

class DeleteOutcomeMapper extends ClassMapperBase<DeleteOutcome> {
  DeleteOutcomeMapper._();

  static DeleteOutcomeMapper? _instance;
  static DeleteOutcomeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeleteOutcomeMapper._());
      MessageDeletedMapper.ensureInitialized();
      KeptByEkkloMapper.ensureInitialized();
      NotDeletedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeleteOutcome';

  @override
  final MappableFields<DeleteOutcome> fields = const {};
  @override
  final bool ignoreNull = true;

  static DeleteOutcome _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'DeleteOutcome',
      'outcome',
      '${data.value['outcome']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeleteOutcome fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeleteOutcome>(map);
  }

  static DeleteOutcome fromJson(String json) {
    return ensureInitialized().decodeJson<DeleteOutcome>(json);
  }
}

mixin DeleteOutcomeMappable {
  String toJson();
  Map<String, dynamic> toMap();
  DeleteOutcomeCopyWith<DeleteOutcome, DeleteOutcome, DeleteOutcome>
  get copyWith;
}

abstract class DeleteOutcomeCopyWith<$R, $In extends DeleteOutcome, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  DeleteOutcomeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MessageDeletedMapper extends SubClassMapperBase<MessageDeleted> {
  MessageDeletedMapper._();

  static MessageDeletedMapper? _instance;
  static MessageDeletedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageDeletedMapper._());
      DeleteOutcomeMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageDeleted';

  @override
  final MappableFields<MessageDeleted> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'outcome';
  @override
  final dynamic discriminatorValue = 'deleted';
  @override
  late final ClassMapperBase superMapper =
      DeleteOutcomeMapper.ensureInitialized();

  static MessageDeleted _instantiate(DecodingData data) {
    return MessageDeleted();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageDeleted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageDeleted>(map);
  }

  static MessageDeleted fromJson(String json) {
    return ensureInitialized().decodeJson<MessageDeleted>(json);
  }
}

mixin MessageDeletedMappable {
  String toJson() {
    return MessageDeletedMapper.ensureInitialized().encodeJson<MessageDeleted>(
      this as MessageDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageDeletedMapper.ensureInitialized().encodeMap<MessageDeleted>(
      this as MessageDeleted,
    );
  }

  MessageDeletedCopyWith<MessageDeleted, MessageDeleted, MessageDeleted>
  get copyWith => _MessageDeletedCopyWithImpl<MessageDeleted, MessageDeleted>(
    this as MessageDeleted,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageDeletedMapper.ensureInitialized().stringifyValue(
      this as MessageDeleted,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageDeletedMapper.ensureInitialized().equalsValue(
      this as MessageDeleted,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageDeletedMapper.ensureInitialized().hashValue(
      this as MessageDeleted,
    );
  }
}

extension MessageDeletedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageDeleted, $Out> {
  MessageDeletedCopyWith<$R, MessageDeleted, $Out> get $asMessageDeleted =>
      $base.as((v, t, t2) => _MessageDeletedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageDeletedCopyWith<$R, $In extends MessageDeleted, $Out>
    implements DeleteOutcomeCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageDeletedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageDeletedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageDeleted, $Out>
    implements MessageDeletedCopyWith<$R, MessageDeleted, $Out> {
  _MessageDeletedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageDeleted> $mapper =
      MessageDeletedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageDeleted $make(CopyWithData data) => MessageDeleted();

  @override
  MessageDeletedCopyWith<$R2, MessageDeleted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageDeletedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class KeptByEkkloMapper extends SubClassMapperBase<KeptByEkklo> {
  KeptByEkkloMapper._();

  static KeptByEkkloMapper? _instance;
  static KeptByEkkloMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = KeptByEkkloMapper._());
      DeleteOutcomeMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'KeptByEkklo';

  @override
  final MappableFields<KeptByEkklo> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'outcome';
  @override
  final dynamic discriminatorValue = 'kept_by_ekklo';
  @override
  late final ClassMapperBase superMapper =
      DeleteOutcomeMapper.ensureInitialized();

  static KeptByEkklo _instantiate(DecodingData data) {
    return KeptByEkklo();
  }

  @override
  final Function instantiate = _instantiate;

  static KeptByEkklo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<KeptByEkklo>(map);
  }

  static KeptByEkklo fromJson(String json) {
    return ensureInitialized().decodeJson<KeptByEkklo>(json);
  }
}

mixin KeptByEkkloMappable {
  String toJson() {
    return KeptByEkkloMapper.ensureInitialized().encodeJson<KeptByEkklo>(
      this as KeptByEkklo,
    );
  }

  Map<String, dynamic> toMap() {
    return KeptByEkkloMapper.ensureInitialized().encodeMap<KeptByEkklo>(
      this as KeptByEkklo,
    );
  }

  KeptByEkkloCopyWith<KeptByEkklo, KeptByEkklo, KeptByEkklo> get copyWith =>
      _KeptByEkkloCopyWithImpl<KeptByEkklo, KeptByEkklo>(
        this as KeptByEkklo,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return KeptByEkkloMapper.ensureInitialized().stringifyValue(
      this as KeptByEkklo,
    );
  }

  @override
  bool operator ==(Object other) {
    return KeptByEkkloMapper.ensureInitialized().equalsValue(
      this as KeptByEkklo,
      other,
    );
  }

  @override
  int get hashCode {
    return KeptByEkkloMapper.ensureInitialized().hashValue(this as KeptByEkklo);
  }
}

extension KeptByEkkloValueCopy<$R, $Out>
    on ObjectCopyWith<$R, KeptByEkklo, $Out> {
  KeptByEkkloCopyWith<$R, KeptByEkklo, $Out> get $asKeptByEkklo =>
      $base.as((v, t, t2) => _KeptByEkkloCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class KeptByEkkloCopyWith<$R, $In extends KeptByEkklo, $Out>
    implements DeleteOutcomeCopyWith<$R, $In, $Out> {
  @override
  $R call();
  KeptByEkkloCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _KeptByEkkloCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, KeptByEkklo, $Out>
    implements KeptByEkkloCopyWith<$R, KeptByEkklo, $Out> {
  _KeptByEkkloCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<KeptByEkklo> $mapper =
      KeptByEkkloMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  KeptByEkklo $make(CopyWithData data) => KeptByEkklo();

  @override
  KeptByEkkloCopyWith<$R2, KeptByEkklo, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _KeptByEkkloCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NotDeletedMapper extends SubClassMapperBase<NotDeleted> {
  NotDeletedMapper._();

  static NotDeletedMapper? _instance;
  static NotDeletedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotDeletedMapper._());
      DeleteOutcomeMapper.ensureInitialized().addSubMapper(_instance!);
      ReadProblemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotDeleted';

  static ReadProblem _$problem(NotDeleted v) => v.problem;
  static const Field<NotDeleted, ReadProblem> _f$problem = Field(
    'problem',
    _$problem,
  );

  @override
  final MappableFields<NotDeleted> fields = const {#problem: _f$problem};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'outcome';
  @override
  final dynamic discriminatorValue = 'not_deleted';
  @override
  late final ClassMapperBase superMapper =
      DeleteOutcomeMapper.ensureInitialized();

  static NotDeleted _instantiate(DecodingData data) {
    return NotDeleted(data.dec(_f$problem));
  }

  @override
  final Function instantiate = _instantiate;

  static NotDeleted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotDeleted>(map);
  }

  static NotDeleted fromJson(String json) {
    return ensureInitialized().decodeJson<NotDeleted>(json);
  }
}

mixin NotDeletedMappable {
  String toJson() {
    return NotDeletedMapper.ensureInitialized().encodeJson<NotDeleted>(
      this as NotDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return NotDeletedMapper.ensureInitialized().encodeMap<NotDeleted>(
      this as NotDeleted,
    );
  }

  NotDeletedCopyWith<NotDeleted, NotDeleted, NotDeleted> get copyWith =>
      _NotDeletedCopyWithImpl<NotDeleted, NotDeleted>(
        this as NotDeleted,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NotDeletedMapper.ensureInitialized().stringifyValue(
      this as NotDeleted,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotDeletedMapper.ensureInitialized().equalsValue(
      this as NotDeleted,
      other,
    );
  }

  @override
  int get hashCode {
    return NotDeletedMapper.ensureInitialized().hashValue(this as NotDeleted);
  }
}

extension NotDeletedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotDeleted, $Out> {
  NotDeletedCopyWith<$R, NotDeleted, $Out> get $asNotDeleted =>
      $base.as((v, t, t2) => _NotDeletedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotDeletedCopyWith<$R, $In extends NotDeleted, $Out>
    implements DeleteOutcomeCopyWith<$R, $In, $Out> {
  @override
  $R call({ReadProblem? problem});
  NotDeletedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NotDeletedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotDeleted, $Out>
    implements NotDeletedCopyWith<$R, NotDeleted, $Out> {
  _NotDeletedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotDeleted> $mapper =
      NotDeletedMapper.ensureInitialized();
  @override
  $R call({ReadProblem? problem}) =>
      $apply(FieldCopyWithData({if (problem != null) #problem: problem}));
  @override
  NotDeleted $make(CopyWithData data) =>
      NotDeleted(data.get(#problem, or: $value.problem));

  @override
  NotDeletedCopyWith<$R2, NotDeleted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotDeletedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

