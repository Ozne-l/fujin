// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message_action.dart';

class MessageActionMapper extends ClassMapperBase<MessageAction> {
  MessageActionMapper._();

  static MessageActionMapper? _instance;
  static MessageActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageActionMapper._());
      ReplyActionMapper.ensureInitialized();
      DeleteActionMapper.ensureInitialized();
      ReactActionMapper.ensureInitialized();
      MoreEmojiActionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageAction';

  @override
  final MappableFields<MessageAction> fields = const {};
  @override
  final bool ignoreNull = true;

  static MessageAction _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'MessageAction',
      'action',
      '${data.value['action']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageAction>(map);
  }

  static MessageAction fromJson(String json) {
    return ensureInitialized().decodeJson<MessageAction>(json);
  }
}

mixin MessageActionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MessageActionCopyWith<MessageAction, MessageAction, MessageAction>
  get copyWith;
}

abstract class MessageActionCopyWith<$R, $In extends MessageAction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MessageActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ReplyActionMapper extends SubClassMapperBase<ReplyAction> {
  ReplyActionMapper._();

  static ReplyActionMapper? _instance;
  static ReplyActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReplyActionMapper._());
      MessageActionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ReplyAction';

  @override
  final MappableFields<ReplyAction> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'action';
  @override
  final dynamic discriminatorValue = 'reply';
  @override
  late final ClassMapperBase superMapper =
      MessageActionMapper.ensureInitialized();

  static ReplyAction _instantiate(DecodingData data) {
    return ReplyAction();
  }

  @override
  final Function instantiate = _instantiate;

  static ReplyAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReplyAction>(map);
  }

  static ReplyAction fromJson(String json) {
    return ensureInitialized().decodeJson<ReplyAction>(json);
  }
}

mixin ReplyActionMappable {
  String toJson() {
    return ReplyActionMapper.ensureInitialized().encodeJson<ReplyAction>(
      this as ReplyAction,
    );
  }

  Map<String, dynamic> toMap() {
    return ReplyActionMapper.ensureInitialized().encodeMap<ReplyAction>(
      this as ReplyAction,
    );
  }

  ReplyActionCopyWith<ReplyAction, ReplyAction, ReplyAction> get copyWith =>
      _ReplyActionCopyWithImpl<ReplyAction, ReplyAction>(
        this as ReplyAction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReplyActionMapper.ensureInitialized().stringifyValue(
      this as ReplyAction,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReplyActionMapper.ensureInitialized().equalsValue(
      this as ReplyAction,
      other,
    );
  }

  @override
  int get hashCode {
    return ReplyActionMapper.ensureInitialized().hashValue(this as ReplyAction);
  }
}

extension ReplyActionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReplyAction, $Out> {
  ReplyActionCopyWith<$R, ReplyAction, $Out> get $asReplyAction =>
      $base.as((v, t, t2) => _ReplyActionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReplyActionCopyWith<$R, $In extends ReplyAction, $Out>
    implements MessageActionCopyWith<$R, $In, $Out> {
  @override
  $R call();
  ReplyActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReplyActionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReplyAction, $Out>
    implements ReplyActionCopyWith<$R, ReplyAction, $Out> {
  _ReplyActionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReplyAction> $mapper =
      ReplyActionMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  ReplyAction $make(CopyWithData data) => ReplyAction();

  @override
  ReplyActionCopyWith<$R2, ReplyAction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReplyActionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class DeleteActionMapper extends SubClassMapperBase<DeleteAction> {
  DeleteActionMapper._();

  static DeleteActionMapper? _instance;
  static DeleteActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeleteActionMapper._());
      MessageActionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'DeleteAction';

  @override
  final MappableFields<DeleteAction> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'action';
  @override
  final dynamic discriminatorValue = 'delete';
  @override
  late final ClassMapperBase superMapper =
      MessageActionMapper.ensureInitialized();

  static DeleteAction _instantiate(DecodingData data) {
    return DeleteAction();
  }

  @override
  final Function instantiate = _instantiate;

  static DeleteAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeleteAction>(map);
  }

  static DeleteAction fromJson(String json) {
    return ensureInitialized().decodeJson<DeleteAction>(json);
  }
}

mixin DeleteActionMappable {
  String toJson() {
    return DeleteActionMapper.ensureInitialized().encodeJson<DeleteAction>(
      this as DeleteAction,
    );
  }

  Map<String, dynamic> toMap() {
    return DeleteActionMapper.ensureInitialized().encodeMap<DeleteAction>(
      this as DeleteAction,
    );
  }

  DeleteActionCopyWith<DeleteAction, DeleteAction, DeleteAction> get copyWith =>
      _DeleteActionCopyWithImpl<DeleteAction, DeleteAction>(
        this as DeleteAction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DeleteActionMapper.ensureInitialized().stringifyValue(
      this as DeleteAction,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeleteActionMapper.ensureInitialized().equalsValue(
      this as DeleteAction,
      other,
    );
  }

  @override
  int get hashCode {
    return DeleteActionMapper.ensureInitialized().hashValue(
      this as DeleteAction,
    );
  }
}

extension DeleteActionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeleteAction, $Out> {
  DeleteActionCopyWith<$R, DeleteAction, $Out> get $asDeleteAction =>
      $base.as((v, t, t2) => _DeleteActionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeleteActionCopyWith<$R, $In extends DeleteAction, $Out>
    implements MessageActionCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DeleteActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeleteActionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeleteAction, $Out>
    implements DeleteActionCopyWith<$R, DeleteAction, $Out> {
  _DeleteActionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeleteAction> $mapper =
      DeleteActionMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DeleteAction $make(CopyWithData data) => DeleteAction();

  @override
  DeleteActionCopyWith<$R2, DeleteAction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DeleteActionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ReactActionMapper extends SubClassMapperBase<ReactAction> {
  ReactActionMapper._();

  static ReactActionMapper? _instance;
  static ReactActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReactActionMapper._());
      MessageActionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ReactAction';

  static String _$emoji(ReactAction v) => v.emoji;
  static const Field<ReactAction, String> _f$emoji = Field('emoji', _$emoji);

  @override
  final MappableFields<ReactAction> fields = const {#emoji: _f$emoji};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'action';
  @override
  final dynamic discriminatorValue = 'react';
  @override
  late final ClassMapperBase superMapper =
      MessageActionMapper.ensureInitialized();

  static ReactAction _instantiate(DecodingData data) {
    return ReactAction(data.dec(_f$emoji));
  }

  @override
  final Function instantiate = _instantiate;

  static ReactAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReactAction>(map);
  }

  static ReactAction fromJson(String json) {
    return ensureInitialized().decodeJson<ReactAction>(json);
  }
}

mixin ReactActionMappable {
  String toJson() {
    return ReactActionMapper.ensureInitialized().encodeJson<ReactAction>(
      this as ReactAction,
    );
  }

  Map<String, dynamic> toMap() {
    return ReactActionMapper.ensureInitialized().encodeMap<ReactAction>(
      this as ReactAction,
    );
  }

  ReactActionCopyWith<ReactAction, ReactAction, ReactAction> get copyWith =>
      _ReactActionCopyWithImpl<ReactAction, ReactAction>(
        this as ReactAction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReactActionMapper.ensureInitialized().stringifyValue(
      this as ReactAction,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReactActionMapper.ensureInitialized().equalsValue(
      this as ReactAction,
      other,
    );
  }

  @override
  int get hashCode {
    return ReactActionMapper.ensureInitialized().hashValue(this as ReactAction);
  }
}

extension ReactActionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReactAction, $Out> {
  ReactActionCopyWith<$R, ReactAction, $Out> get $asReactAction =>
      $base.as((v, t, t2) => _ReactActionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReactActionCopyWith<$R, $In extends ReactAction, $Out>
    implements MessageActionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? emoji});
  ReactActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReactActionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReactAction, $Out>
    implements ReactActionCopyWith<$R, ReactAction, $Out> {
  _ReactActionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReactAction> $mapper =
      ReactActionMapper.ensureInitialized();
  @override
  $R call({String? emoji}) =>
      $apply(FieldCopyWithData({if (emoji != null) #emoji: emoji}));
  @override
  ReactAction $make(CopyWithData data) =>
      ReactAction(data.get(#emoji, or: $value.emoji));

  @override
  ReactActionCopyWith<$R2, ReactAction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReactActionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MoreEmojiActionMapper extends SubClassMapperBase<MoreEmojiAction> {
  MoreEmojiActionMapper._();

  static MoreEmojiActionMapper? _instance;
  static MoreEmojiActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MoreEmojiActionMapper._());
      MessageActionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MoreEmojiAction';

  @override
  final MappableFields<MoreEmojiAction> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'action';
  @override
  final dynamic discriminatorValue = 'more_emoji';
  @override
  late final ClassMapperBase superMapper =
      MessageActionMapper.ensureInitialized();

  static MoreEmojiAction _instantiate(DecodingData data) {
    return MoreEmojiAction();
  }

  @override
  final Function instantiate = _instantiate;

  static MoreEmojiAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MoreEmojiAction>(map);
  }

  static MoreEmojiAction fromJson(String json) {
    return ensureInitialized().decodeJson<MoreEmojiAction>(json);
  }
}

mixin MoreEmojiActionMappable {
  String toJson() {
    return MoreEmojiActionMapper.ensureInitialized()
        .encodeJson<MoreEmojiAction>(this as MoreEmojiAction);
  }

  Map<String, dynamic> toMap() {
    return MoreEmojiActionMapper.ensureInitialized().encodeMap<MoreEmojiAction>(
      this as MoreEmojiAction,
    );
  }

  MoreEmojiActionCopyWith<MoreEmojiAction, MoreEmojiAction, MoreEmojiAction>
  get copyWith =>
      _MoreEmojiActionCopyWithImpl<MoreEmojiAction, MoreEmojiAction>(
        this as MoreEmojiAction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MoreEmojiActionMapper.ensureInitialized().stringifyValue(
      this as MoreEmojiAction,
    );
  }

  @override
  bool operator ==(Object other) {
    return MoreEmojiActionMapper.ensureInitialized().equalsValue(
      this as MoreEmojiAction,
      other,
    );
  }

  @override
  int get hashCode {
    return MoreEmojiActionMapper.ensureInitialized().hashValue(
      this as MoreEmojiAction,
    );
  }
}

extension MoreEmojiActionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MoreEmojiAction, $Out> {
  MoreEmojiActionCopyWith<$R, MoreEmojiAction, $Out> get $asMoreEmojiAction =>
      $base.as((v, t, t2) => _MoreEmojiActionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MoreEmojiActionCopyWith<$R, $In extends MoreEmojiAction, $Out>
    implements MessageActionCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MoreEmojiActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MoreEmojiActionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MoreEmojiAction, $Out>
    implements MoreEmojiActionCopyWith<$R, MoreEmojiAction, $Out> {
  _MoreEmojiActionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MoreEmojiAction> $mapper =
      MoreEmojiActionMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MoreEmojiAction $make(CopyWithData data) => MoreEmojiAction();

  @override
  MoreEmojiActionCopyWith<$R2, MoreEmojiAction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MoreEmojiActionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

