import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/notifications/chat_notification.dart';

part 'conversation_notice.mapper.dart';

@MappableClass(discriminatorKey: 'notice')
sealed class ConversationNotice with ConversationNoticeMappable {
  const ConversationNotice();
}

@MappableClass(discriminatorValue: 'show')
final class ShowNotice extends ConversationNotice with ShowNoticeMappable {
  const ShowNotice(this.notification);

  final ChatNotification notification;
}

@MappableClass(discriminatorValue: 'remove')
final class RemoveNotice extends ConversationNotice with RemoveNoticeMappable {
  const RemoveNotice(this.conversationId);

  final String conversationId;
}
