// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'file_in_progress.dart';

class FileInProgressMapper extends ClassMapperBase<FileInProgress> {
  FileInProgressMapper._();

  static FileInProgressMapper? _instance;
  static FileInProgressMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FileInProgressMapper._());
      ChatMediaKindMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FileInProgress';

  static String _$id(FileInProgress v) => v.id;
  static const Field<FileInProgress, String> _f$id = Field('id', _$id);
  static String _$messageId(FileInProgress v) => v.messageId;
  static const Field<FileInProgress, String> _f$messageId = Field(
    'messageId',
    _$messageId,
    key: r'message_id',
  );
  static int _$position(FileInProgress v) => v.position;
  static const Field<FileInProgress, int> _f$position = Field(
    'position',
    _$position,
  );
  static ChatMediaKind _$kind(FileInProgress v) => v.kind;
  static const Field<FileInProgress, ChatMediaKind> _f$kind = Field(
    'kind',
    _$kind,
  );
  static Map<String, Object?>? _$source(FileInProgress v) => v.source;
  static const Field<FileInProgress, Map<String, Object?>> _f$source = Field(
    'source',
    _$source,
    opt: true,
    hook: JsonTextHook(),
  );
  static String? _$path(FileInProgress v) => v.path;
  static const Field<FileInProgress, String> _f$path = Field(
    'path',
    _$path,
    opt: true,
  );
  static int? _$originalBytes(FileInProgress v) => v.originalBytes;
  static const Field<FileInProgress, int> _f$originalBytes = Field(
    'originalBytes',
    _$originalBytes,
    key: r'original_bytes',
    opt: true,
  );
  static String? _$publicUrl(FileInProgress v) => v.publicUrl;
  static const Field<FileInProgress, String> _f$publicUrl = Field(
    'publicUrl',
    _$publicUrl,
    key: r'public_url',
    opt: true,
  );
  static DateTime? _$completedAt(FileInProgress v) => v.completedAt;
  static const Field<FileInProgress, DateTime> _f$completedAt = Field(
    'completedAt',
    _$completedAt,
    key: r'completed_at',
    opt: true,
  );

  @override
  final MappableFields<FileInProgress> fields = const {
    #id: _f$id,
    #messageId: _f$messageId,
    #position: _f$position,
    #kind: _f$kind,
    #source: _f$source,
    #path: _f$path,
    #originalBytes: _f$originalBytes,
    #publicUrl: _f$publicUrl,
    #completedAt: _f$completedAt,
  };
  @override
  final bool ignoreNull = true;

  static FileInProgress _instantiate(DecodingData data) {
    return FileInProgress(
      id: data.dec(_f$id),
      messageId: data.dec(_f$messageId),
      position: data.dec(_f$position),
      kind: data.dec(_f$kind),
      source: data.dec(_f$source),
      path: data.dec(_f$path),
      originalBytes: data.dec(_f$originalBytes),
      publicUrl: data.dec(_f$publicUrl),
      completedAt: data.dec(_f$completedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FileInProgress fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FileInProgress>(map);
  }

  static FileInProgress fromJson(String json) {
    return ensureInitialized().decodeJson<FileInProgress>(json);
  }
}

mixin FileInProgressMappable {
  String toJson() {
    return FileInProgressMapper.ensureInitialized().encodeJson<FileInProgress>(
      this as FileInProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return FileInProgressMapper.ensureInitialized().encodeMap<FileInProgress>(
      this as FileInProgress,
    );
  }

  FileInProgressCopyWith<FileInProgress, FileInProgress, FileInProgress>
  get copyWith => _FileInProgressCopyWithImpl<FileInProgress, FileInProgress>(
    this as FileInProgress,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FileInProgressMapper.ensureInitialized().stringifyValue(
      this as FileInProgress,
    );
  }

  @override
  bool operator ==(Object other) {
    return FileInProgressMapper.ensureInitialized().equalsValue(
      this as FileInProgress,
      other,
    );
  }

  @override
  int get hashCode {
    return FileInProgressMapper.ensureInitialized().hashValue(
      this as FileInProgress,
    );
  }
}

extension FileInProgressValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FileInProgress, $Out> {
  FileInProgressCopyWith<$R, FileInProgress, $Out> get $asFileInProgress =>
      $base.as((v, t, t2) => _FileInProgressCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FileInProgressCopyWith<$R, $In extends FileInProgress, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>?
  get source;
  $R call({
    String? id,
    String? messageId,
    int? position,
    ChatMediaKind? kind,
    Map<String, Object?>? source,
    String? path,
    int? originalBytes,
    String? publicUrl,
    DateTime? completedAt,
  });
  FileInProgressCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FileInProgressCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FileInProgress, $Out>
    implements FileInProgressCopyWith<$R, FileInProgress, $Out> {
  _FileInProgressCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FileInProgress> $mapper =
      FileInProgressMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>?
  get source => $value.source != null
      ? MapCopyWith(
          $value.source!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(source: v),
        )
      : null;
  @override
  $R call({
    String? id,
    String? messageId,
    int? position,
    ChatMediaKind? kind,
    Object? source = $none,
    Object? path = $none,
    Object? originalBytes = $none,
    Object? publicUrl = $none,
    Object? completedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (messageId != null) #messageId: messageId,
      if (position != null) #position: position,
      if (kind != null) #kind: kind,
      if (source != $none) #source: source,
      if (path != $none) #path: path,
      if (originalBytes != $none) #originalBytes: originalBytes,
      if (publicUrl != $none) #publicUrl: publicUrl,
      if (completedAt != $none) #completedAt: completedAt,
    }),
  );
  @override
  FileInProgress $make(CopyWithData data) => FileInProgress(
    id: data.get(#id, or: $value.id),
    messageId: data.get(#messageId, or: $value.messageId),
    position: data.get(#position, or: $value.position),
    kind: data.get(#kind, or: $value.kind),
    source: data.get(#source, or: $value.source),
    path: data.get(#path, or: $value.path),
    originalBytes: data.get(#originalBytes, or: $value.originalBytes),
    publicUrl: data.get(#publicUrl, or: $value.publicUrl),
    completedAt: data.get(#completedAt, or: $value.completedAt),
  );

  @override
  FileInProgressCopyWith<$R2, FileInProgress, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FileInProgressCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

