import 'package:fujin/data/upload/upload_notice.dart';

final class UploadOrder {
  const UploadOrder({
    required this.fileId,
    required this.messageId,
    required this.position,
    required this.path,
    required this.url,
    required this.publicUrl,
    required this.mimeType,
    required this.notice,
  });

  final String fileId;
  final String messageId;
  final int position;
  final String path;
  final Uri url;
  final String publicUrl;
  final String mimeType;
  final UploadNotice notice;
}
