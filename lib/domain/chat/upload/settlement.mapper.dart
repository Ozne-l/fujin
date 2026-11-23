// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settlement.dart';

class SettlementMapper extends ClassMapperBase<Settlement> {
  SettlementMapper._();

  static SettlementMapper? _instance;
  static SettlementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettlementMapper._());
      MessagePostedMapper.ensureInitialized();
      MessageNotReadyMapper.ensureInitialized();
      MessageWaitingMapper.ensureInitialized();
      MessageGivenUpMapper.ensureInitialized();
      MessageGoneMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Settlement';

  @override
  final MappableFields<Settlement> fields = const {};
  @override
  final bool ignoreNull = true;

  static Settlement _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'Settlement',
      'settlement',
      '${data.value['settlement']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Settlement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Settlement>(map);
  }

  static Settlement fromJson(String json) {
    return ensureInitialized().decodeJson<Settlement>(json);
  }
}

mixin SettlementMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SettlementCopyWith<Settlement, Settlement, Settlement> get copyWith;
}

abstract class SettlementCopyWith<$R, $In extends Settlement, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SettlementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MessagePostedMapper extends SubClassMapperBase<MessagePosted> {
  MessagePostedMapper._();

  static MessagePostedMapper? _instance;
  static MessagePostedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessagePostedMapper._());
      SettlementMapper.ensureInitialized().addSubMapper(_instance!);
      EkkloMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessagePosted';

  static EkkloMessage _$message(MessagePosted v) => v.message;
  static const Field<MessagePosted, EkkloMessage> _f$message = Field(
    'message',
    _$message,
  );

  @override
  final MappableFields<MessagePosted> fields = const {#message: _f$message};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'settlement';
  @override
  final dynamic discriminatorValue = 'posted';
  @override
  late final ClassMapperBase superMapper = SettlementMapper.ensureInitialized();

  static MessagePosted _instantiate(DecodingData data) {
    return MessagePosted(data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static MessagePosted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessagePosted>(map);
  }

  static MessagePosted fromJson(String json) {
    return ensureInitialized().decodeJson<MessagePosted>(json);
  }
}

mixin MessagePostedMappable {
  String toJson() {
    return MessagePostedMapper.ensureInitialized().encodeJson<MessagePosted>(
      this as MessagePosted,
    );
  }

  Map<String, dynamic> toMap() {
    return MessagePostedMapper.ensureInitialized().encodeMap<MessagePosted>(
      this as MessagePosted,
    );
  }

  MessagePostedCopyWith<MessagePosted, MessagePosted, MessagePosted>
  get copyWith => _MessagePostedCopyWithImpl<MessagePosted, MessagePosted>(
    this as MessagePosted,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessagePostedMapper.ensureInitialized().stringifyValue(
      this as MessagePosted,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessagePostedMapper.ensureInitialized().equalsValue(
      this as MessagePosted,
      other,
    );
  }

  @override
  int get hashCode {
    return MessagePostedMapper.ensureInitialized().hashValue(
      this as MessagePosted,
    );
  }
}

extension MessagePostedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessagePosted, $Out> {
  MessagePostedCopyWith<$R, MessagePosted, $Out> get $asMessagePosted =>
      $base.as((v, t, t2) => _MessagePostedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessagePostedCopyWith<$R, $In extends MessagePosted, $Out>
    implements SettlementCopyWith<$R, $In, $Out> {
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message;
  @override
  $R call({EkkloMessage? message});
  MessagePostedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessagePostedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessagePosted, $Out>
    implements MessagePostedCopyWith<$R, MessagePosted, $Out> {
  _MessagePostedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessagePosted> $mapper =
      MessagePostedMapper.ensureInitialized();
  @override
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message =>
      $value.message.copyWith.$chain((v) => call(message: v));
  @override
  $R call({EkkloMessage? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  MessagePosted $make(CopyWithData data) =>
      MessagePosted(data.get(#message, or: $value.message));

  @override
  MessagePostedCopyWith<$R2, MessagePosted, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessagePostedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageNotReadyMapper extends SubClassMapperBase<MessageNotReady> {
  MessageNotReadyMapper._();

  static MessageNotReadyMapper? _instance;
  static MessageNotReadyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageNotReadyMapper._());
      SettlementMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageNotReady';

  @override
  final MappableFields<MessageNotReady> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'settlement';
  @override
  final dynamic discriminatorValue = 'not_ready';
  @override
  late final ClassMapperBase superMapper = SettlementMapper.ensureInitialized();

  static MessageNotReady _instantiate(DecodingData data) {
    return MessageNotReady();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageNotReady fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageNotReady>(map);
  }

  static MessageNotReady fromJson(String json) {
    return ensureInitialized().decodeJson<MessageNotReady>(json);
  }
}

mixin MessageNotReadyMappable {
  String toJson() {
    return MessageNotReadyMapper.ensureInitialized()
        .encodeJson<MessageNotReady>(this as MessageNotReady);
  }

  Map<String, dynamic> toMap() {
    return MessageNotReadyMapper.ensureInitialized().encodeMap<MessageNotReady>(
      this as MessageNotReady,
    );
  }

  MessageNotReadyCopyWith<MessageNotReady, MessageNotReady, MessageNotReady>
  get copyWith =>
      _MessageNotReadyCopyWithImpl<MessageNotReady, MessageNotReady>(
        this as MessageNotReady,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageNotReadyMapper.ensureInitialized().stringifyValue(
      this as MessageNotReady,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageNotReadyMapper.ensureInitialized().equalsValue(
      this as MessageNotReady,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageNotReadyMapper.ensureInitialized().hashValue(
      this as MessageNotReady,
    );
  }
}

extension MessageNotReadyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageNotReady, $Out> {
  MessageNotReadyCopyWith<$R, MessageNotReady, $Out> get $asMessageNotReady =>
      $base.as((v, t, t2) => _MessageNotReadyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageNotReadyCopyWith<$R, $In extends MessageNotReady, $Out>
    implements SettlementCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageNotReadyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageNotReadyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageNotReady, $Out>
    implements MessageNotReadyCopyWith<$R, MessageNotReady, $Out> {
  _MessageNotReadyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageNotReady> $mapper =
      MessageNotReadyMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageNotReady $make(CopyWithData data) => MessageNotReady();

  @override
  MessageNotReadyCopyWith<$R2, MessageNotReady, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageNotReadyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageWaitingMapper extends SubClassMapperBase<MessageWaiting> {
  MessageWaitingMapper._();

  static MessageWaitingMapper? _instance;
  static MessageWaitingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageWaitingMapper._());
      SettlementMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageWaiting';

  @override
  final MappableFields<MessageWaiting> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'settlement';
  @override
  final dynamic discriminatorValue = 'waiting';
  @override
  late final ClassMapperBase superMapper = SettlementMapper.ensureInitialized();

  static MessageWaiting _instantiate(DecodingData data) {
    return MessageWaiting();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageWaiting fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageWaiting>(map);
  }

  static MessageWaiting fromJson(String json) {
    return ensureInitialized().decodeJson<MessageWaiting>(json);
  }
}

mixin MessageWaitingMappable {
  String toJson() {
    return MessageWaitingMapper.ensureInitialized().encodeJson<MessageWaiting>(
      this as MessageWaiting,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageWaitingMapper.ensureInitialized().encodeMap<MessageWaiting>(
      this as MessageWaiting,
    );
  }

  MessageWaitingCopyWith<MessageWaiting, MessageWaiting, MessageWaiting>
  get copyWith => _MessageWaitingCopyWithImpl<MessageWaiting, MessageWaiting>(
    this as MessageWaiting,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageWaitingMapper.ensureInitialized().stringifyValue(
      this as MessageWaiting,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageWaitingMapper.ensureInitialized().equalsValue(
      this as MessageWaiting,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageWaitingMapper.ensureInitialized().hashValue(
      this as MessageWaiting,
    );
  }
}

extension MessageWaitingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageWaiting, $Out> {
  MessageWaitingCopyWith<$R, MessageWaiting, $Out> get $asMessageWaiting =>
      $base.as((v, t, t2) => _MessageWaitingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageWaitingCopyWith<$R, $In extends MessageWaiting, $Out>
    implements SettlementCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageWaitingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageWaitingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageWaiting, $Out>
    implements MessageWaitingCopyWith<$R, MessageWaiting, $Out> {
  _MessageWaitingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageWaiting> $mapper =
      MessageWaitingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageWaiting $make(CopyWithData data) => MessageWaiting();

  @override
  MessageWaitingCopyWith<$R2, MessageWaiting, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageWaitingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageGivenUpMapper extends SubClassMapperBase<MessageGivenUp> {
  MessageGivenUpMapper._();

  static MessageGivenUpMapper? _instance;
  static MessageGivenUpMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageGivenUpMapper._());
      SettlementMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageGivenUp';

  @override
  final MappableFields<MessageGivenUp> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'settlement';
  @override
  final dynamic discriminatorValue = 'given_up';
  @override
  late final ClassMapperBase superMapper = SettlementMapper.ensureInitialized();

  static MessageGivenUp _instantiate(DecodingData data) {
    return MessageGivenUp();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageGivenUp fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageGivenUp>(map);
  }

  static MessageGivenUp fromJson(String json) {
    return ensureInitialized().decodeJson<MessageGivenUp>(json);
  }
}

mixin MessageGivenUpMappable {
  String toJson() {
    return MessageGivenUpMapper.ensureInitialized().encodeJson<MessageGivenUp>(
      this as MessageGivenUp,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageGivenUpMapper.ensureInitialized().encodeMap<MessageGivenUp>(
      this as MessageGivenUp,
    );
  }

  MessageGivenUpCopyWith<MessageGivenUp, MessageGivenUp, MessageGivenUp>
  get copyWith => _MessageGivenUpCopyWithImpl<MessageGivenUp, MessageGivenUp>(
    this as MessageGivenUp,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageGivenUpMapper.ensureInitialized().stringifyValue(
      this as MessageGivenUp,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageGivenUpMapper.ensureInitialized().equalsValue(
      this as MessageGivenUp,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageGivenUpMapper.ensureInitialized().hashValue(
      this as MessageGivenUp,
    );
  }
}

extension MessageGivenUpValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageGivenUp, $Out> {
  MessageGivenUpCopyWith<$R, MessageGivenUp, $Out> get $asMessageGivenUp =>
      $base.as((v, t, t2) => _MessageGivenUpCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageGivenUpCopyWith<$R, $In extends MessageGivenUp, $Out>
    implements SettlementCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageGivenUpCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageGivenUpCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageGivenUp, $Out>
    implements MessageGivenUpCopyWith<$R, MessageGivenUp, $Out> {
  _MessageGivenUpCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageGivenUp> $mapper =
      MessageGivenUpMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageGivenUp $make(CopyWithData data) => MessageGivenUp();

  @override
  MessageGivenUpCopyWith<$R2, MessageGivenUp, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageGivenUpCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageGoneMapper extends SubClassMapperBase<MessageGone> {
  MessageGoneMapper._();

  static MessageGoneMapper? _instance;
  static MessageGoneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageGoneMapper._());
      SettlementMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageGone';

  @override
  final MappableFields<MessageGone> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'settlement';
  @override
  final dynamic discriminatorValue = 'gone';
  @override
  late final ClassMapperBase superMapper = SettlementMapper.ensureInitialized();

  static MessageGone _instantiate(DecodingData data) {
    return MessageGone();
  }

  @override
  final Function instantiate = _instantiate;

  static MessageGone fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageGone>(map);
  }

  static MessageGone fromJson(String json) {
    return ensureInitialized().decodeJson<MessageGone>(json);
  }
}

mixin MessageGoneMappable {
  String toJson() {
    return MessageGoneMapper.ensureInitialized().encodeJson<MessageGone>(
      this as MessageGone,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageGoneMapper.ensureInitialized().encodeMap<MessageGone>(
      this as MessageGone,
    );
  }

  MessageGoneCopyWith<MessageGone, MessageGone, MessageGone> get copyWith =>
      _MessageGoneCopyWithImpl<MessageGone, MessageGone>(
        this as MessageGone,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageGoneMapper.ensureInitialized().stringifyValue(
      this as MessageGone,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageGoneMapper.ensureInitialized().equalsValue(
      this as MessageGone,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageGoneMapper.ensureInitialized().hashValue(this as MessageGone);
  }
}

extension MessageGoneValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageGone, $Out> {
  MessageGoneCopyWith<$R, MessageGone, $Out> get $asMessageGone =>
      $base.as((v, t, t2) => _MessageGoneCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageGoneCopyWith<$R, $In extends MessageGone, $Out>
    implements SettlementCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MessageGoneCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageGoneCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageGone, $Out>
    implements MessageGoneCopyWith<$R, MessageGone, $Out> {
  _MessageGoneCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageGone> $mapper =
      MessageGoneMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MessageGone $make(CopyWithData data) => MessageGone();

  @override
  MessageGoneCopyWith<$R2, MessageGone, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageGoneCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

