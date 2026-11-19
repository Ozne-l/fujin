import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fujin/data/notifications/local_chat_notifications.dart';
import 'package:fujin/data/upload/upload_notice.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

final class LocalUploadNotifications implements UploadNotifications {
  LocalUploadNotifications(this._intl);

  static const channelId = 'background_downloader';
  static const _icon = '@mipmap/ic_launcher_monochrome';

  final AppLocalizations _intl;
  final _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> showWaiting(String messageId, UploadNotice notice) =>
      _plugin.show(
        id: LocalChatNotifications.idOf(messageId),
        title: _intl.chatUploadNotificationTitle(
          notice.coach ?? _intl.chatNotificationCoach,
        ),
        body: _intl.chatUploadNotificationWaiting,
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
    title: _intl.chatUploadNotificationFailedTitle,
    body: _intl.chatUploadNotificationFailedBody,
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
      _intl.chatUploadChannelName,
      channelDescription: _intl.chatUploadChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      icon: _icon,
      ongoing: ongoing,
      onlyAlertOnce: true,
      silent: true,
      category: category,
    ),
  );
}
