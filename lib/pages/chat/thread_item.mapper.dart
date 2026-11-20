// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'thread_item.dart';

class ThreadItemMapper extends ClassMapperBase<ThreadItem> {
  ThreadItemMapper._();

  static ThreadItemMapper? _instance;
  static ThreadItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ThreadItemMapper._());
      ThreadDayMapper.ensureInitialized();
      ThreadMessageMapper.ensureInitialized();
      ThreadUploadMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ThreadItem';

  @override
  final MappableFields<ThreadItem> fields = const {};
  @override
  final bool ignoreNull = true;

  static ThreadItem _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'ThreadItem',
      'item',
      '${data.value['item']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ThreadItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ThreadItem>(map);
  }

  static ThreadItem fromJson(String json) {
    return ensureInitialized().decodeJson<ThreadItem>(json);
  }
}

mixin ThreadItemMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ThreadItemCopyWith<ThreadItem, ThreadItem, ThreadItem> get copyWith;
}

abstract class ThreadItemCopyWith<$R, $In extends ThreadItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ThreadItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class ThreadDayMapper extends SubClassMapperBase<ThreadDay> {
  ThreadDayMapper._();

  static ThreadDayMapper? _instance;
  static ThreadDayMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ThreadDayMapper._());
      ThreadItemMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ThreadDay';

  static DateTime _$day(ThreadDay v) => v.day;
  static const Field<ThreadDay, DateTime> _f$day = Field('day', _$day);

  @override
  final MappableFields<ThreadDay> fields = const {#day: _f$day};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'item';
  @override
  final dynamic discriminatorValue = 'day';
  @override
  late final ClassMapperBase superMapper = ThreadItemMapper.ensureInitialized();

  static ThreadDay _instantiate(DecodingData data) {
    return ThreadDay(data.dec(_f$day));
  }

  @override
  final Function instantiate = _instantiate;

  static ThreadDay fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ThreadDay>(map);
  }

  static ThreadDay fromJson(String json) {
    return ensureInitialized().decodeJson<ThreadDay>(json);
  }
}

mixin ThreadDayMappable {
  String toJson() {
    return ThreadDayMapper.ensureInitialized().encodeJson<ThreadDay>(
      this as ThreadDay,
    );
  }

  Map<String, dynamic> toMap() {
    return ThreadDayMapper.ensureInitialized().encodeMap<ThreadDay>(
      this as ThreadDay,
    );
  }

  ThreadDayCopyWith<ThreadDay, ThreadDay, ThreadDay> get copyWith =>
      _ThreadDayCopyWithImpl<ThreadDay, ThreadDay>(
        this as ThreadDay,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ThreadDayMapper.ensureInitialized().stringifyValue(
      this as ThreadDay,
    );
  }

  @override
  bool operator ==(Object other) {
    return ThreadDayMapper.ensureInitialized().equalsValue(
      this as ThreadDay,
      other,
    );
  }

  @override
  int get hashCode {
    return ThreadDayMapper.ensureInitialized().hashValue(this as ThreadDay);
  }
}

extension ThreadDayValueCopy<$R, $Out> on ObjectCopyWith<$R, ThreadDay, $Out> {
  ThreadDayCopyWith<$R, ThreadDay, $Out> get $asThreadDay =>
      $base.as((v, t, t2) => _ThreadDayCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ThreadDayCopyWith<$R, $In extends ThreadDay, $Out>
    implements ThreadItemCopyWith<$R, $In, $Out> {
  @override
  $R call({DateTime? day});
  ThreadDayCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ThreadDayCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ThreadDay, $Out>
    implements ThreadDayCopyWith<$R, ThreadDay, $Out> {
  _ThreadDayCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ThreadDay> $mapper =
      ThreadDayMapper.ensureInitialized();
  @override
  $R call({DateTime? day}) =>
      $apply(FieldCopyWithData({if (day != null) #day: day}));
  @override
  ThreadDay $make(CopyWithData data) =>
      ThreadDay(data.get(#day, or: $value.day));

  @override
  ThreadDayCopyWith<$R2, ThreadDay, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ThreadDayCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ThreadMessageMapper extends SubClassMapperBase<ThreadMessage> {
  ThreadMessageMapper._();

  static ThreadMessageMapper? _instance;
  static ThreadMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ThreadMessageMapper._());
      ThreadItemMapper.ensureInitialized().addSubMapper(_instance!);
      EkkloMessageMapper.ensureInitialized();
      MessageDeliveryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ThreadMessage';

  static EkkloMessage _$message(ThreadMessage v) => v.message;
  static const Field<ThreadMessage, EkkloMessage> _f$message = Field(
    'message',
    _$message,
  );
  static bool _$mine(ThreadMessage v) => v.mine;
  static const Field<ThreadMessage, bool> _f$mine = Field('mine', _$mine);
  static EkkloMessage? _$quoted(ThreadMessage v) => v.quoted;
  static const Field<ThreadMessage, EkkloMessage> _f$quoted = Field(
    'quoted',
    _$quoted,
    opt: true,
  );
  static bool _$quotesMine(ThreadMessage v) => v.quotesMine;
  static const Field<ThreadMessage, bool> _f$quotesMine = Field(
    'quotesMine',
    _$quotesMine,
    key: r'quotes_mine',
    opt: true,
    def: false,
  );
  static MessageDelivery _$delivery(ThreadMessage v) => v.delivery;
  static const Field<ThreadMessage, MessageDelivery> _f$delivery = Field(
    'delivery',
    _$delivery,
    opt: true,
    def: MessageDelivery.sent,
  );
  static bool _$seen(ThreadMessage v) => v.seen;
  static const Field<ThreadMessage, bool> _f$seen = Field(
    'seen',
    _$seen,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ThreadMessage> fields = const {
    #message: _f$message,
    #mine: _f$mine,
    #quoted: _f$quoted,
    #quotesMine: _f$quotesMine,
    #delivery: _f$delivery,
    #seen: _f$seen,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'item';
  @override
  final dynamic discriminatorValue = 'message';
  @override
  late final ClassMapperBase superMapper = ThreadItemMapper.ensureInitialized();

  static ThreadMessage _instantiate(DecodingData data) {
    return ThreadMessage(
      message: data.dec(_f$message),
      mine: data.dec(_f$mine),
      quoted: data.dec(_f$quoted),
      quotesMine: data.dec(_f$quotesMine),
      delivery: data.dec(_f$delivery),
      seen: data.dec(_f$seen),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ThreadMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ThreadMessage>(map);
  }

  static ThreadMessage fromJson(String json) {
    return ensureInitialized().decodeJson<ThreadMessage>(json);
  }
}

mixin ThreadMessageMappable {
  String toJson() {
    return ThreadMessageMapper.ensureInitialized().encodeJson<ThreadMessage>(
      this as ThreadMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return ThreadMessageMapper.ensureInitialized().encodeMap<ThreadMessage>(
      this as ThreadMessage,
    );
  }

  ThreadMessageCopyWith<ThreadMessage, ThreadMessage, ThreadMessage>
  get copyWith => _ThreadMessageCopyWithImpl<ThreadMessage, ThreadMessage>(
    this as ThreadMessage,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ThreadMessageMapper.ensureInitialized().stringifyValue(
      this as ThreadMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return ThreadMessageMapper.ensureInitialized().equalsValue(
      this as ThreadMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return ThreadMessageMapper.ensureInitialized().hashValue(
      this as ThreadMessage,
    );
  }
}

extension ThreadMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ThreadMessage, $Out> {
  ThreadMessageCopyWith<$R, ThreadMessage, $Out> get $asThreadMessage =>
      $base.as((v, t, t2) => _ThreadMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ThreadMessageCopyWith<$R, $In extends ThreadMessage, $Out>
    implements ThreadItemCopyWith<$R, $In, $Out> {
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message;
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage>? get quoted;
  @override
  $R call({
    EkkloMessage? message,
    bool? mine,
    EkkloMessage? quoted,
    bool? quotesMine,
    MessageDelivery? delivery,
    bool? seen,
  });
  ThreadMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ThreadMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ThreadMessage, $Out>
    implements ThreadMessageCopyWith<$R, ThreadMessage, $Out> {
  _ThreadMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ThreadMessage> $mapper =
      ThreadMessageMapper.ensureInitialized();
  @override
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage> get message =>
      $value.message.copyWith.$chain((v) => call(message: v));
  @override
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage>? get quoted =>
      $value.quoted?.copyWith.$chain((v) => call(quoted: v));
  @override
  $R call({
    EkkloMessage? message,
    bool? mine,
    Object? quoted = $none,
    bool? quotesMine,
    MessageDelivery? delivery,
    bool? seen,
  }) => $apply(
    FieldCopyWithData({
      if (message != null) #message: message,
      if (mine != null) #mine: mine,
      if (quoted != $none) #quoted: quoted,
      if (quotesMine != null) #quotesMine: quotesMine,
      if (delivery != null) #delivery: delivery,
      if (seen != null) #seen: seen,
    }),
  );
  @override
  ThreadMessage $make(CopyWithData data) => ThreadMessage(
    message: data.get(#message, or: $value.message),
    mine: data.get(#mine, or: $value.mine),
    quoted: data.get(#quoted, or: $value.quoted),
    quotesMine: data.get(#quotesMine, or: $value.quotesMine),
    delivery: data.get(#delivery, or: $value.delivery),
    seen: data.get(#seen, or: $value.seen),
  );

  @override
  ThreadMessageCopyWith<$R2, ThreadMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ThreadMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ThreadUploadMapper extends SubClassMapperBase<ThreadUpload> {
  ThreadUploadMapper._();

  static ThreadUploadMapper? _instance;
  static ThreadUploadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ThreadUploadMapper._());
      ThreadItemMapper.ensureInitialized().addSubMapper(_instance!);
      MessageUploadMapper.ensureInitialized();
      EkkloMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ThreadUpload';

  static MessageUpload _$upload(ThreadUpload v) => v.upload;
  static const Field<ThreadUpload, MessageUpload> _f$upload = Field(
    'upload',
    _$upload,
  );
  static EkkloMessage? _$quoted(ThreadUpload v) => v.quoted;
  static const Field<ThreadUpload, EkkloMessage> _f$quoted = Field(
    'quoted',
    _$quoted,
    opt: true,
  );
  static bool _$quotesMine(ThreadUpload v) => v.quotesMine;
  static const Field<ThreadUpload, bool> _f$quotesMine = Field(
    'quotesMine',
    _$quotesMine,
    key: r'quotes_mine',
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ThreadUpload> fields = const {
    #upload: _f$upload,
    #quoted: _f$quoted,
    #quotesMine: _f$quotesMine,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'item';
  @override
  final dynamic discriminatorValue = 'upload';
  @override
  late final ClassMapperBase superMapper = ThreadItemMapper.ensureInitialized();

  static ThreadUpload _instantiate(DecodingData data) {
    return ThreadUpload(
      upload: data.dec(_f$upload),
      quoted: data.dec(_f$quoted),
      quotesMine: data.dec(_f$quotesMine),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ThreadUpload fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ThreadUpload>(map);
  }

  static ThreadUpload fromJson(String json) {
    return ensureInitialized().decodeJson<ThreadUpload>(json);
  }
}

mixin ThreadUploadMappable {
  String toJson() {
    return ThreadUploadMapper.ensureInitialized().encodeJson<ThreadUpload>(
      this as ThreadUpload,
    );
  }

  Map<String, dynamic> toMap() {
    return ThreadUploadMapper.ensureInitialized().encodeMap<ThreadUpload>(
      this as ThreadUpload,
    );
  }

  ThreadUploadCopyWith<ThreadUpload, ThreadUpload, ThreadUpload> get copyWith =>
      _ThreadUploadCopyWithImpl<ThreadUpload, ThreadUpload>(
        this as ThreadUpload,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ThreadUploadMapper.ensureInitialized().stringifyValue(
      this as ThreadUpload,
    );
  }

  @override
  bool operator ==(Object other) {
    return ThreadUploadMapper.ensureInitialized().equalsValue(
      this as ThreadUpload,
      other,
    );
  }

  @override
  int get hashCode {
    return ThreadUploadMapper.ensureInitialized().hashValue(
      this as ThreadUpload,
    );
  }
}

extension ThreadUploadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ThreadUpload, $Out> {
  ThreadUploadCopyWith<$R, ThreadUpload, $Out> get $asThreadUpload =>
      $base.as((v, t, t2) => _ThreadUploadCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ThreadUploadCopyWith<$R, $In extends ThreadUpload, $Out>
    implements ThreadItemCopyWith<$R, $In, $Out> {
  MessageUploadCopyWith<$R, MessageUpload, MessageUpload> get upload;
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage>? get quoted;
  @override
  $R call({MessageUpload? upload, EkkloMessage? quoted, bool? quotesMine});
  ThreadUploadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ThreadUploadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ThreadUpload, $Out>
    implements ThreadUploadCopyWith<$R, ThreadUpload, $Out> {
  _ThreadUploadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ThreadUpload> $mapper =
      ThreadUploadMapper.ensureInitialized();
  @override
  MessageUploadCopyWith<$R, MessageUpload, MessageUpload> get upload =>
      $value.upload.copyWith.$chain((v) => call(upload: v));
  @override
  EkkloMessageCopyWith<$R, EkkloMessage, EkkloMessage>? get quoted =>
      $value.quoted?.copyWith.$chain((v) => call(quoted: v));
  @override
  $R call({MessageUpload? upload, Object? quoted = $none, bool? quotesMine}) =>
      $apply(
        FieldCopyWithData({
          if (upload != null) #upload: upload,
          if (quoted != $none) #quoted: quoted,
          if (quotesMine != null) #quotesMine: quotesMine,
        }),
      );
  @override
  ThreadUpload $make(CopyWithData data) => ThreadUpload(
    upload: data.get(#upload, or: $value.upload),
    quoted: data.get(#quoted, or: $value.quoted),
    quotesMine: data.get(#quotesMine, or: $value.quotesMine),
  );

  @override
  ThreadUploadCopyWith<$R2, ThreadUpload, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ThreadUploadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

