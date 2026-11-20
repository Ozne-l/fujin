import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/notifications/notified_message.dart';

part 'chat_notification.mapper.dart';

@MappableClass()
final class ChatNotification with ChatNotificationMappable {
  const ChatNotification({
    required this.conversationId,
    required this.messages,
    this.coachName,
    this.ownerName,
  });

  final String conversationId;
  final List<NotifiedMessage> messages;
  final String? coachName;
  final String? ownerName;
}
