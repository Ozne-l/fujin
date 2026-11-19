import 'package:fujin/domain/chat/notifications/chat_notification.dart';

abstract interface class ChatNotifications {
  Stream<String> get opened;

  String? takeLaunchConversation();

  Future<void> show(ChatNotification notification);

  Future<void> cancel(String conversationId);

  Future<void> cancelAll();

  Future<bool> requestPermission();

  Future<void> startChecks();

  Future<void> stopChecks();
}
