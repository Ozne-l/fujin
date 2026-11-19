// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation_notice.dart';

class ConversationNoticeMapper extends ClassMapperBase<ConversationNotice> {
  ConversationNoticeMapper._();

  static ConversationNoticeMapper? _instance;
  static ConversationNoticeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConversationNoticeMapper._());
      ShowNoticeMapper.ensureInitialized();
      RemoveNoticeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ConversationNotice';

  @override
  final MappableFields<ConversationNotice> fields = const {};
  @override
  final bool ignoreNull = true;

  static ConversationNotice _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'ConversationNotice',
      'notice',
      '${data.value['notice']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConversationNotice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConversationNotice>(map);
  }

  static ConversationNotice fromJson(String json) {
    return ensureInitialized().decodeJson<ConversationNotice>(json);
  }
}

mixin ConversationNoticeMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ConversationNoticeCopyWith<
    ConversationNotice,
    ConversationNotice,
    ConversationNotice
  >
  get copyWith;
}

abstract class ConversationNoticeCopyWith<
  $R,
  $In extends ConversationNotice,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ConversationNoticeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class ShowNoticeMapper extends SubClassMapperBase<ShowNotice> {
  ShowNoticeMapper._();

  static ShowNoticeMapper? _instance;
  static ShowNoticeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShowNoticeMapper._());
      ConversationNoticeMapper.ensureInitialized().addSubMapper(_instance!);
      ChatNotificationMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ShowNotice';

  static ChatNotification _$notification(ShowNotice v) => v.notification;
  static const Field<ShowNotice, ChatNotification> _f$notification = Field(
    'notification',
    _$notification,
  );

  @override
  final MappableFields<ShowNotice> fields = const {
    #notification: _f$notification,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'notice';
  @override
  final dynamic discriminatorValue = 'show';
  @override
  late final ClassMapperBase superMapper =
      ConversationNoticeMapper.ensureInitialized();

  static ShowNotice _instantiate(DecodingData data) {
    return ShowNotice(data.dec(_f$notification));
  }

  @override
  final Function instantiate = _instantiate;

  static ShowNotice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ShowNotice>(map);
  }

  static ShowNotice fromJson(String json) {
    return ensureInitialized().decodeJson<ShowNotice>(json);
  }
}

mixin ShowNoticeMappable {
  String toJson() {
    return ShowNoticeMapper.ensureInitialized().encodeJson<ShowNotice>(
      this as ShowNotice,
    );
  }

  Map<String, dynamic> toMap() {
    return ShowNoticeMapper.ensureInitialized().encodeMap<ShowNotice>(
      this as ShowNotice,
    );
  }

  ShowNoticeCopyWith<ShowNotice, ShowNotice, ShowNotice> get copyWith =>
      _ShowNoticeCopyWithImpl<ShowNotice, ShowNotice>(
        this as ShowNotice,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ShowNoticeMapper.ensureInitialized().stringifyValue(
      this as ShowNotice,
    );
  }

  @override
  bool operator ==(Object other) {
    return ShowNoticeMapper.ensureInitialized().equalsValue(
      this as ShowNotice,
      other,
    );
  }

  @override
  int get hashCode {
    return ShowNoticeMapper.ensureInitialized().hashValue(this as ShowNotice);
  }
}

extension ShowNoticeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ShowNotice, $Out> {
  ShowNoticeCopyWith<$R, ShowNotice, $Out> get $asShowNotice =>
      $base.as((v, t, t2) => _ShowNoticeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ShowNoticeCopyWith<$R, $In extends ShowNotice, $Out>
    implements ConversationNoticeCopyWith<$R, $In, $Out> {
  ChatNotificationCopyWith<$R, ChatNotification, ChatNotification>
  get notification;
  @override
  $R call({ChatNotification? notification});
  ShowNoticeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ShowNoticeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ShowNotice, $Out>
    implements ShowNoticeCopyWith<$R, ShowNotice, $Out> {
  _ShowNoticeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ShowNotice> $mapper =
      ShowNoticeMapper.ensureInitialized();
  @override
  ChatNotificationCopyWith<$R, ChatNotification, ChatNotification>
  get notification =>
      $value.notification.copyWith.$chain((v) => call(notification: v));
  @override
  $R call({ChatNotification? notification}) => $apply(
    FieldCopyWithData({if (notification != null) #notification: notification}),
  );
  @override
  ShowNotice $make(CopyWithData data) =>
      ShowNotice(data.get(#notification, or: $value.notification));

  @override
  ShowNoticeCopyWith<$R2, ShowNotice, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ShowNoticeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RemoveNoticeMapper extends SubClassMapperBase<RemoveNotice> {
  RemoveNoticeMapper._();

  static RemoveNoticeMapper? _instance;
  static RemoveNoticeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemoveNoticeMapper._());
      ConversationNoticeMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'RemoveNotice';

  static String _$conversationId(RemoveNotice v) => v.conversationId;
  static const Field<RemoveNotice, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    key: r'conversation_id',
  );

  @override
  final MappableFields<RemoveNotice> fields = const {
    #conversationId: _f$conversationId,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'notice';
  @override
  final dynamic discriminatorValue = 'remove';
  @override
  late final ClassMapperBase superMapper =
      ConversationNoticeMapper.ensureInitialized();

  static RemoveNotice _instantiate(DecodingData data) {
    return RemoveNotice(data.dec(_f$conversationId));
  }

  @override
  final Function instantiate = _instantiate;

  static RemoveNotice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RemoveNotice>(map);
  }

  static RemoveNotice fromJson(String json) {
    return ensureInitialized().decodeJson<RemoveNotice>(json);
  }
}

mixin RemoveNoticeMappable {
  String toJson() {
    return RemoveNoticeMapper.ensureInitialized().encodeJson<RemoveNotice>(
      this as RemoveNotice,
    );
  }

  Map<String, dynamic> toMap() {
    return RemoveNoticeMapper.ensureInitialized().encodeMap<RemoveNotice>(
      this as RemoveNotice,
    );
  }

  RemoveNoticeCopyWith<RemoveNotice, RemoveNotice, RemoveNotice> get copyWith =>
      _RemoveNoticeCopyWithImpl<RemoveNotice, RemoveNotice>(
        this as RemoveNotice,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RemoveNoticeMapper.ensureInitialized().stringifyValue(
      this as RemoveNotice,
    );
  }

  @override
  bool operator ==(Object other) {
    return RemoveNoticeMapper.ensureInitialized().equalsValue(
      this as RemoveNotice,
      other,
    );
  }

  @override
  int get hashCode {
    return RemoveNoticeMapper.ensureInitialized().hashValue(
      this as RemoveNotice,
    );
  }
}

extension RemoveNoticeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RemoveNotice, $Out> {
  RemoveNoticeCopyWith<$R, RemoveNotice, $Out> get $asRemoveNotice =>
      $base.as((v, t, t2) => _RemoveNoticeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RemoveNoticeCopyWith<$R, $In extends RemoveNotice, $Out>
    implements ConversationNoticeCopyWith<$R, $In, $Out> {
  @override
  $R call({String? conversationId});
  RemoveNoticeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RemoveNoticeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RemoveNotice, $Out>
    implements RemoveNoticeCopyWith<$R, RemoveNotice, $Out> {
  _RemoveNoticeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RemoveNotice> $mapper =
      RemoveNoticeMapper.ensureInitialized();
  @override
  $R call({String? conversationId}) => $apply(
    FieldCopyWithData({
      if (conversationId != null) #conversationId: conversationId,
    }),
  );
  @override
  RemoveNotice $make(CopyWithData data) =>
      RemoveNotice(data.get(#conversationId, or: $value.conversationId));

  @override
  RemoveNoticeCopyWith<$R2, RemoveNotice, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RemoveNoticeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

