import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/chat_change.dart';
import 'package:fujin/domain/chat/with_reaction.dart';

ChatChange reduceChatEvent(
  EkkloMessagingEvent event, {
  required EkkloMessage? current,
  required String ownerId,
}) => switch (event) {
  EkkloNewMessage(:final message) ||
  EkkloMessageEdited(:final message) => MessageSaved(message),
  EkkloMessageDeleted(:final conversationId, :final messageId) =>
    MessageRemoved(conversationId: conversationId, messageId: messageId),
  EkkloReactionEvent() => switch (current) {
    null => const NothingChanged(),
    final message => MessageSaved(
      withReaction(
        message,
        EkkloReaction(
          emoji: event.emoji,
          count: event.newCount,
          mine: switch (event.userId == ownerId) {
            true => event.mineNow,
            false =>
              message.reactions
                      .where((reaction) => reaction.emoji == event.emoji)
                      .firstOrNull
                      ?.mine ??
                  false,
          },
        ),
      ),
    ),
  },
  EkkloMessageRead() => const NothingChanged(),
};
