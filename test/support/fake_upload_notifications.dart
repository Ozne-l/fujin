import 'package:fujin/data/upload/upload_notice.dart';
import 'package:fujin/data/upload/upload_notifications.dart';

final class FakeUploadNotifications implements UploadNotifications {
  final Set<String> waiting = {};
  final Set<String> failed = {};

  @override
  Future<void> showWaiting(String messageId, UploadNotice notice) async =>
      waiting.add(messageId);

  @override
  Future<void> showFailed(
    String messageId, {
    required String conversationId,
  }) async {
    waiting.remove(messageId);
    failed.add(messageId);
  }

  @override
  Future<void> cancel(String messageId) async {
    waiting.remove(messageId);
    failed.remove(messageId);
  }
}
