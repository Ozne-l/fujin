import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/upload/upload_phase.dart';
import 'package:fujin/domain/chat/upload/uploading_media.dart';

part 'message_upload.mapper.dart';

@MappableClass()
final class MessageUpload with MessageUploadMappable {
  const MessageUpload({
    required this.id,
    required this.conversationId,
    required this.startedAt,
    required this.phase,
    required this.media,
    this.caption = '',
    this.replyToId,
    this.durationSeconds,
    this.publicUrls = const [],
  });

  final String id;
  final String conversationId;
  final DateTime startedAt;
  final UploadPhase phase;
  final List<UploadingMedia> media;
  final String caption;
  final String? replyToId;
  final int? durationSeconds;
  final List<String> publicUrls;

  int? get originalBytes => media
      .map((item) => item.originalBytes)
      .fold<int?>(
        null,
        (total, bytes) => switch ((total, bytes)) {
          (null, null) => null,
          (final total?, null) => total,
          (null, final bytes?) => bytes,
          (final total?, final bytes?) => total + bytes,
        },
      );
}
