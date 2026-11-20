import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fujin/data/notifications/local_chat_notifications.dart';
import 'package:fujin/data/upload/upload_notice.dart';
import 'package:fujin/data/upload/upload_notification_copy.dart';
import 'package:fujin/data/upload/upload_notifications.dart';

final class LocalUploadNotifications implements UploadNotifications {
  LocalUploadNotifications(this._copy);

  static const channelId = 'background_downloader';

  final UploadNotificationCopy _copy;
  final _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> showWaiting(String messageId, UploadNotice notice) =>
      _plugin.show(
        id: LocalChatNotifications.idOf(messageId),
        title: _copy.title(notice.coach),
        body: _copy.waiting,
        payload: notice.conversationId,
        notificationDetails: _details(
          AndroidNotificationCategory.progress,
          ongoing: true,
        ),
      );

  @override
  Future<void> showFailed(
    String messageId, {
    required String conversationId,
  }) => _plugin.show(
    id: LocalChatNotifications.idOf(messageId),
    title: _copy.failedTitle,
    body: _copy.failedBody,
    payload: conversationId,
    notificationDetails: _details(
      AndroidNotificationCategory.error,
      ongoing: false,
    ),
  );

  @override
  Future<void> cancel(String messageId) =>
      _plugin.cancel(id: LocalChatNotifications.idOf(messageId));

  NotificationDetails _details(
    AndroidNotificationCategory category, {
    required bool ongoing,
  }) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      _copy.channelName,
      channelDescription: _copy.channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      icon: LocalChatNotifications.icon,
      ongoing: ongoing,
      onlyAlertOnce: true,
      silent: true,
      category: category,
    ),
  );
}
