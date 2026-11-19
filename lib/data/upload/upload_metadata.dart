import 'package:dart_mappable/dart_mappable.dart';

part 'upload_metadata.mapper.dart';

@MappableClass()
final class UploadMetadata with UploadMetadataMappable {
  const UploadMetadata({
    required this.fileId,
    required this.messageId,
    required this.publicUrl,
    this.cachePath,
  });

  static UploadMetadata? decode(String text) {
    try {
      return UploadMetadataMapper.fromJson(text);
    } on Object {
      return null;
    }
  }

  final String fileId;
  final String messageId;
  final String publicUrl;
  final String? cachePath;
}
