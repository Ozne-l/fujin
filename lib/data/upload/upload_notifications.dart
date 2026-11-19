import 'package:fujin/data/upload/upload_notice.dart';

abstract interface class UploadNotifications {
  Future<void> showWaiting(String messageId, UploadNotice notice);

  Future<void> showFailed(String messageId, {required String conversationId});

  Future<void> cancel(String messageId);
}
