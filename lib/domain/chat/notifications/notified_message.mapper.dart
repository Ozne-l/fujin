// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notified_message.dart';

class NotifiedMessageMapper extends ClassMapperBase<NotifiedMessage> {
  NotifiedMessageMapper._();

  static NotifiedMessageMapper? _instance;
  static NotifiedMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotifiedMessageMapper._());
      NotifiedContentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotifiedMessage';

  static String _$id(NotifiedMessage v) => v.id;
  static const Field<NotifiedMessage, String> _f$id = Field('id', _$id);
  static DateTime _$sentAt(NotifiedMessage v) => v.sentAt;
  static const Field<NotifiedMessage, DateTime> _f$sentAt = Field(
    'sentAt',
    _$sentAt,
    key: r'sent_at',
  );
  static NotifiedContent _$content(NotifiedMessage v) => v.content;
  static const Field<NotifiedMessage, NotifiedContent> _f$content = Field(
    'content',
    _$content,
  );

  @override
  final MappableFields<NotifiedMessage> fields = const {
    #id: _f$id,
    #sentAt: _f$sentAt,
    #content: _f$content,
  };
  @override
  final bool ignoreNull = true;

  static NotifiedMessage _instantiate(DecodingData data) {
    return NotifiedMessage(
      id: data.dec(_f$id),
      sentAt: data.dec(_f$sentAt),
      content: data.dec(_f$content),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotifiedMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotifiedMessage>(map);
  }

  static NotifiedMessage fromJson(String json) {
    return ensureInitialized().decodeJson<NotifiedMessage>(json);
  }
}

mixin NotifiedMessageMappable {
  String toJson() {
    return NotifiedMessageMapper.ensureInitialized()
        .encodeJson<NotifiedMessage>(this as NotifiedMessage);
  }

  Map<String, dynamic> toMap() {
    return NotifiedMessageMapper.ensureInitialized().encodeMap<NotifiedMessage>(
      this as NotifiedMessage,
    );
  }

  NotifiedMessageCopyWith<NotifiedMessage, NotifiedMessage, NotifiedMessage>
  get copyWith =>
      _NotifiedMessageCopyWithImpl<NotifiedMessage, NotifiedMessage>(
        this as NotifiedMessage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NotifiedMessageMapper.ensureInitialized().stringifyValue(
      this as NotifiedMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotifiedMessageMapper.ensureInitialized().equalsValue(
      this as NotifiedMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return NotifiedMessageMapper.ensureInitialized().hashValue(
      this as NotifiedMessage,
    );
  }
}

extension NotifiedMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotifiedMessage, $Out> {
  NotifiedMessageCopyWith<$R, NotifiedMessage, $Out> get $asNotifiedMessage =>
      $base.as((v, t, t2) => _NotifiedMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotifiedMessageCopyWith<$R, $In extends NotifiedMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  NotifiedContentCopyWith<$R, NotifiedContent, NotifiedContent> get content;
  $R call({String? id, DateTime? sentAt, NotifiedContent? content});
  NotifiedMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotifiedMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotifiedMessage, $Out>
    implements NotifiedMessageCopyWith<$R, NotifiedMessage, $Out> {
  _NotifiedMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotifiedMessage> $mapper =
      NotifiedMessageMapper.ensureInitialized();
  @override
  NotifiedContentCopyWith<$R, NotifiedContent, NotifiedContent> get content =>
      $value.content.copyWith.$chain((v) => call(content: v));
  @override
  $R call({String? id, DateTime? sentAt, NotifiedContent? content}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (sentAt != null) #sentAt: sentAt,
      if (content != null) #content: content,
    }),
  );
  @override
  NotifiedMessage $make(CopyWithData data) => NotifiedMessage(
    id: data.get(#id, or: $value.id),
    sentAt: data.get(#sentAt, or: $value.sentAt),
    content: data.get(#content, or: $value.content),
  );

  @override
  NotifiedMessageCopyWith<$R2, NotifiedMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotifiedMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

