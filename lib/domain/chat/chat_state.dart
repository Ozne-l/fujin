import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/chat_link.dart';

part 'chat_state.mapper.dart';

@MappableClass(discriminatorKey: 'chat')
sealed class ChatState with ChatStateMappable {
  const ChatState();
}

@MappableClass(discriminatorValue: 'unknown')
final class ChatUnknown extends ChatState with ChatUnknownMappable {
  const ChatUnknown();
}

@MappableClass(discriminatorValue: 'absent')
final class ChatAbsent extends ChatState with ChatAbsentMappable {
  const ChatAbsent();
}

@MappableClass(discriminatorValue: 'present')
final class ChatPresent extends ChatState with ChatPresentMappable {
  const ChatPresent({
    required this.owner,
    required this.conversations,
    required this.link,
  });

  final EkkloUser owner;
  final List<EkkloConversation> conversations;
  final ChatLink link;

  int get unreadCount => conversations.fold(
    0,
    (total, conversation) => total + conversation.unreadCount,
  );

  EkkloConversation? conversation(String id) =>
      conversations.where((conversation) => conversation.id == id).firstOrNull;

  bool protectsCapture(String conversationId) =>
      owner.screenCaptureProtection ||
      switch (conversation(conversationId)?.coach) {
        null => false,
        final coach => owner.coachesSettings.any(
          (settings) =>
              settings.coachId == coach.id && settings.screenCaptureProtection,
        ),
      };
}
