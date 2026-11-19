// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'upload_metadata.dart';

class UploadMetadataMapper extends ClassMapperBase<UploadMetadata> {
  UploadMetadataMapper._();

  static UploadMetadataMapper? _instance;
  static UploadMetadataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UploadMetadataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UploadMetadata';

  static String _$fileId(UploadMetadata v) => v.fileId;
  static const Field<UploadMetadata, String> _f$fileId = Field(
    'fileId',
    _$fileId,
    key: r'file_id',
  );
  static String _$messageId(UploadMetadata v) => v.messageId;
  static const Field<UploadMetadata, String> _f$messageId = Field(
    'messageId',
    _$messageId,
    key: r'message_id',
  );
  static String _$publicUrl(UploadMetadata v) => v.publicUrl;
  static const Field<UploadMetadata, String> _f$publicUrl = Field(
    'publicUrl',
    _$publicUrl,
    key: r'public_url',
  );
  static String? _$cachePath(UploadMetadata v) => v.cachePath;
  static const Field<UploadMetadata, String> _f$cachePath = Field(
    'cachePath',
    _$cachePath,
    key: r'cache_path',
    opt: true,
  );

  @override
  final MappableFields<UploadMetadata> fields = const {
    #fileId: _f$fileId,
    #messageId: _f$messageId,
    #publicUrl: _f$publicUrl,
    #cachePath: _f$cachePath,
  };
  @override
  final bool ignoreNull = true;

  static UploadMetadata _instantiate(DecodingData data) {
    return UploadMetadata(
      fileId: data.dec(_f$fileId),
      messageId: data.dec(_f$messageId),
      publicUrl: data.dec(_f$publicUrl),
      cachePath: data.dec(_f$cachePath),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UploadMetadata fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UploadMetadata>(map);
  }

  static UploadMetadata fromJson(String json) {
    return ensureInitialized().decodeJson<UploadMetadata>(json);
  }
}

mixin UploadMetadataMappable {
  String toJson() {
    return UploadMetadataMapper.ensureInitialized().encodeJson<UploadMetadata>(
      this as UploadMetadata,
    );
  }

  Map<String, dynamic> toMap() {
    return UploadMetadataMapper.ensureInitialized().encodeMap<UploadMetadata>(
      this as UploadMetadata,
    );
  }

  UploadMetadataCopyWith<UploadMetadata, UploadMetadata, UploadMetadata>
  get copyWith => _UploadMetadataCopyWithImpl<UploadMetadata, UploadMetadata>(
    this as UploadMetadata,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UploadMetadataMapper.ensureInitialized().stringifyValue(
      this as UploadMetadata,
    );
  }

  @override
  bool operator ==(Object other) {
    return UploadMetadataMapper.ensureInitialized().equalsValue(
      this as UploadMetadata,
      other,
    );
  }

  @override
  int get hashCode {
    return UploadMetadataMapper.ensureInitialized().hashValue(
      this as UploadMetadata,
    );
  }
}

extension UploadMetadataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UploadMetadata, $Out> {
  UploadMetadataCopyWith<$R, UploadMetadata, $Out> get $asUploadMetadata =>
      $base.as((v, t, t2) => _UploadMetadataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UploadMetadataCopyWith<$R, $In extends UploadMetadata, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? fileId,
    String? messageId,
    String? publicUrl,
    String? cachePath,
  });
  UploadMetadataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UploadMetadataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UploadMetadata, $Out>
    implements UploadMetadataCopyWith<$R, UploadMetadata, $Out> {
  _UploadMetadataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UploadMetadata> $mapper =
      UploadMetadataMapper.ensureInitialized();
  @override
  $R call({
    String? fileId,
    String? messageId,
    String? publicUrl,
    Object? cachePath = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fileId != null) #fileId: fileId,
      if (messageId != null) #messageId: messageId,
      if (publicUrl != null) #publicUrl: publicUrl,
      if (cachePath != $none) #cachePath: cachePath,
    }),
  );
  @override
  UploadMetadata $make(CopyWithData data) => UploadMetadata(
    fileId: data.get(#fileId, or: $value.fileId),
    messageId: data.get(#messageId, or: $value.messageId),
    publicUrl: data.get(#publicUrl, or: $value.publicUrl),
    cachePath: data.get(#cachePath, or: $value.cachePath),
  );

  @override
  UploadMetadataCopyWith<$R2, UploadMetadata, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UploadMetadataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

