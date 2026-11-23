import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/chat_link.dart';
import 'package:fujin/domain/chat/pending_text.dart';

part 'conversation_state.mapper.dart';

@MappableClass()
final class ConversationState with ConversationStateMappable {
  const ConversationState({
    required this.conversationId,
    required this.ownerId,
    required this.conversation,
    required this.messages,
    required this.link,
    required this.loadingNewest,
    required this.loadingOlder,
    required this.hasOlder,
    required this.protectsCapture,
    this.pendingTexts = const [],
    this.deleting = const {},
    this.postedFrom = const {},
  });

  final String conversationId;
  final String? ownerId;
  final EkkloConversation? conversation;
  final List<EkkloMessage> messages;
  final ChatLink link;
  final bool loadingNewest;
  final bool loadingOlder;
  final bool hasOlder;
  final bool protectsCapture;
  final List<PendingText> pendingTexts;
  final Set<String> deleting;
  final Map<String, String> postedFrom;

  bool get canSend => conversation?.canSend ?? false;

  bool isMine(EkkloMessage message) => message.senderId == ownerId;
}
