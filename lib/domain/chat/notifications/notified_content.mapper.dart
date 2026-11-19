// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notified_content.dart';

class NotifiedContentMapper extends ClassMapperBase<NotifiedContent> {
  NotifiedContentMapper._();

  static NotifiedContentMapper? _instance;
  static NotifiedContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotifiedContentMapper._());
      NotifiedTextMapper.ensureInitialized();
      NotifiedMediaMapper.ensureInitialized();
      NotifiedUnsupportedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotifiedContent';

  @override
  final MappableFields<NotifiedContent> fields = const {};
  @override
  final bool ignoreNull = true;

  static NotifiedContent _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'NotifiedContent',
      'kind',
      '${data.value['kind']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotifiedContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotifiedContent>(map);
  }

  static NotifiedContent fromJson(String json) {
    return ensureInitialized().decodeJson<NotifiedContent>(json);
  }
}

mixin NotifiedContentMappable {
  String toJson();
  Map<String, dynamic> toMap();
  NotifiedContentCopyWith<NotifiedContent, NotifiedContent, NotifiedContent>
  get copyWith;
}

abstract class NotifiedContentCopyWith<$R, $In extends NotifiedContent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  NotifiedContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class NotifiedTextMapper extends SubClassMapperBase<NotifiedText> {
  NotifiedTextMapper._();

  static NotifiedTextMapper? _instance;
  static NotifiedTextMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotifiedTextMapper._());
      NotifiedContentMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NotifiedText';

  static String _$text(NotifiedText v) => v.text;
  static const Field<NotifiedText, String> _f$text = Field('text', _$text);

  @override
  final MappableFields<NotifiedText> fields = const {#text: _f$text};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'text';
  @override
  late final ClassMapperBase superMapper =
      NotifiedContentMapper.ensureInitialized();

  static NotifiedText _instantiate(DecodingData data) {
    return NotifiedText(data.dec(_f$text));
  }

  @override
  final Function instantiate = _instantiate;

  static NotifiedText fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotifiedText>(map);
  }

  static NotifiedText fromJson(String json) {
    return ensureInitialized().decodeJson<NotifiedText>(json);
  }
}

mixin NotifiedTextMappable {
  String toJson() {
    return NotifiedTextMapper.ensureInitialized().encodeJson<NotifiedText>(
      this as NotifiedText,
    );
  }

  Map<String, dynamic> toMap() {
    return NotifiedTextMapper.ensureInitialized().encodeMap<NotifiedText>(
      this as NotifiedText,
    );
  }

  NotifiedTextCopyWith<NotifiedText, NotifiedText, NotifiedText> get copyWith =>
      _NotifiedTextCopyWithImpl<NotifiedText, NotifiedText>(
        this as NotifiedText,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NotifiedTextMapper.ensureInitialized().stringifyValue(
      this as NotifiedText,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotifiedTextMapper.ensureInitialized().equalsValue(
      this as NotifiedText,
      other,
    );
  }

  @override
  int get hashCode {
    return NotifiedTextMapper.ensureInitialized().hashValue(
      this as NotifiedText,
    );
  }
}

extension NotifiedTextValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotifiedText, $Out> {
  NotifiedTextCopyWith<$R, NotifiedText, $Out> get $asNotifiedText =>
      $base.as((v, t, t2) => _NotifiedTextCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotifiedTextCopyWith<$R, $In extends NotifiedText, $Out>
    implements NotifiedContentCopyWith<$R, $In, $Out> {
  @override
  $R call({String? text});
  NotifiedTextCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NotifiedTextCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotifiedText, $Out>
    implements NotifiedTextCopyWith<$R, NotifiedText, $Out> {
  _NotifiedTextCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotifiedText> $mapper =
      NotifiedTextMapper.ensureInitialized();
  @override
  $R call({String? text}) =>
      $apply(FieldCopyWithData({if (text != null) #text: text}));
  @override
  NotifiedText $make(CopyWithData data) =>
      NotifiedText(data.get(#text, or: $value.text));

  @override
  NotifiedTextCopyWith<$R2, NotifiedText, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotifiedTextCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NotifiedMediaMapper extends SubClassMapperBase<NotifiedMedia> {
  NotifiedMediaMapper._();

  static NotifiedMediaMapper? _instance;
  static NotifiedMediaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotifiedMediaMapper._());
      NotifiedContentMapper.ensureInitialized().addSubMapper(_instance!);
      MediaLabelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotifiedMedia';

  static MediaLabel _$label(NotifiedMedia v) => v.label;
  static const Field<NotifiedMedia, MediaLabel> _f$label = Field(
    'label',
    _$label,
  );
  static String? _$caption(NotifiedMedia v) => v.caption;
  static const Field<NotifiedMedia, String> _f$caption = Field(
    'caption',
    _$caption,
    opt: true,
  );

  @override
  final MappableFields<NotifiedMedia> fields = const {
    #label: _f$label,
    #caption: _f$caption,
  };
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'media';
  @override
  late final ClassMapperBase superMapper =
      NotifiedContentMapper.ensureInitialized();

  static NotifiedMedia _instantiate(DecodingData data) {
    return NotifiedMedia(data.dec(_f$label), caption: data.dec(_f$caption));
  }

  @override
  final Function instantiate = _instantiate;

  static NotifiedMedia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotifiedMedia>(map);
  }

  static NotifiedMedia fromJson(String json) {
    return ensureInitialized().decodeJson<NotifiedMedia>(json);
  }
}

mixin NotifiedMediaMappable {
  String toJson() {
    return NotifiedMediaMapper.ensureInitialized().encodeJson<NotifiedMedia>(
      this as NotifiedMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return NotifiedMediaMapper.ensureInitialized().encodeMap<NotifiedMedia>(
      this as NotifiedMedia,
    );
  }

  NotifiedMediaCopyWith<NotifiedMedia, NotifiedMedia, NotifiedMedia>
  get copyWith => _NotifiedMediaCopyWithImpl<NotifiedMedia, NotifiedMedia>(
    this as NotifiedMedia,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NotifiedMediaMapper.ensureInitialized().stringifyValue(
      this as NotifiedMedia,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotifiedMediaMapper.ensureInitialized().equalsValue(
      this as NotifiedMedia,
      other,
    );
  }

  @override
  int get hashCode {
    return NotifiedMediaMapper.ensureInitialized().hashValue(
      this as NotifiedMedia,
    );
  }
}

extension NotifiedMediaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotifiedMedia, $Out> {
  NotifiedMediaCopyWith<$R, NotifiedMedia, $Out> get $asNotifiedMedia =>
      $base.as((v, t, t2) => _NotifiedMediaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotifiedMediaCopyWith<$R, $In extends NotifiedMedia, $Out>
    implements NotifiedContentCopyWith<$R, $In, $Out> {
  MediaLabelCopyWith<$R, MediaLabel, MediaLabel> get label;
  @override
  $R call({MediaLabel? label, String? caption});
  NotifiedMediaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NotifiedMediaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotifiedMedia, $Out>
    implements NotifiedMediaCopyWith<$R, NotifiedMedia, $Out> {
  _NotifiedMediaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotifiedMedia> $mapper =
      NotifiedMediaMapper.ensureInitialized();
  @override
  MediaLabelCopyWith<$R, MediaLabel, MediaLabel> get label =>
      $value.label.copyWith.$chain((v) => call(label: v));
  @override
  $R call({MediaLabel? label, Object? caption = $none}) => $apply(
    FieldCopyWithData({
      if (label != null) #label: label,
      if (caption != $none) #caption: caption,
    }),
  );
  @override
  NotifiedMedia $make(CopyWithData data) => NotifiedMedia(
    data.get(#label, or: $value.label),
    caption: data.get(#caption, or: $value.caption),
  );

  @override
  NotifiedMediaCopyWith<$R2, NotifiedMedia, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NotifiedMediaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NotifiedUnsupportedMapper
    extends SubClassMapperBase<NotifiedUnsupported> {
  NotifiedUnsupportedMapper._();

  static NotifiedUnsupportedMapper? _instance;
  static NotifiedUnsupportedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotifiedUnsupportedMapper._());
      NotifiedContentMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NotifiedUnsupported';

  @override
  final MappableFields<NotifiedUnsupported> fields = const {};
  @override
  final bool ignoreNull = true;

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'unsupported';
  @override
  late final ClassMapperBase superMapper =
      NotifiedContentMapper.ensureInitialized();

  static NotifiedUnsupported _instantiate(DecodingData data) {
    return NotifiedUnsupported();
  }

  @override
  final Function instantiate = _instantiate;

  static NotifiedUnsupported fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotifiedUnsupported>(map);
  }

  static NotifiedUnsupported fromJson(String json) {
    return ensureInitialized().decodeJson<NotifiedUnsupported>(json);
  }
}

mixin NotifiedUnsupportedMappable {
  String toJson() {
    return NotifiedUnsupportedMapper.ensureInitialized()
        .encodeJson<NotifiedUnsupported>(this as NotifiedUnsupported);
  }

  Map<String, dynamic> toMap() {
    return NotifiedUnsupportedMapper.ensureInitialized()
        .encodeMap<NotifiedUnsupported>(this as NotifiedUnsupported);
  }

  NotifiedUnsupportedCopyWith<
    NotifiedUnsupported,
    NotifiedUnsupported,
    NotifiedUnsupported
  >
  get copyWith =>
      _NotifiedUnsupportedCopyWithImpl<
        NotifiedUnsupported,
        NotifiedUnsupported
      >(this as NotifiedUnsupported, $identity, $identity);
  @override
  String toString() {
    return NotifiedUnsupportedMapper.ensureInitialized().stringifyValue(
      this as NotifiedUnsupported,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotifiedUnsupportedMapper.ensureInitialized().equalsValue(
      this as NotifiedUnsupported,
      other,
    );
  }

  @override
  int get hashCode {
    return NotifiedUnsupportedMapper.ensureInitialized().hashValue(
      this as NotifiedUnsupported,
    );
  }
}

extension NotifiedUnsupportedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotifiedUnsupported, $Out> {
  NotifiedUnsupportedCopyWith<$R, NotifiedUnsupported, $Out>
  get $asNotifiedUnsupported => $base.as(
    (v, t, t2) => _NotifiedUnsupportedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NotifiedUnsupportedCopyWith<
  $R,
  $In extends NotifiedUnsupported,
  $Out
>
    implements NotifiedContentCopyWith<$R, $In, $Out> {
  @override
  $R call();
  NotifiedUnsupportedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotifiedUnsupportedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotifiedUnsupported, $Out>
    implements NotifiedUnsupportedCopyWith<$R, NotifiedUnsupported, $Out> {
  _NotifiedUnsupportedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotifiedUnsupported> $mapper =
      NotifiedUnsupportedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  NotifiedUnsupported $make(CopyWithData data) => NotifiedUnsupported();

  @override
  NotifiedUnsupportedCopyWith<$R2, NotifiedUnsupported, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NotifiedUnsupportedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

