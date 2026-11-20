import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/chat_change.dart';
import 'package:fujin/domain/chat/marked_read.dart';
import 'package:fujin/domain/chat/with_reaction.dart';

ChatChange reduceChatEvent(
  EkkloMessagingEvent event, {
  required EkkloMessage? current,
  required String ownerId,
  List<EkkloMessage> thread = const [],
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
  EkkloMessageRead(:final userId) when userId == ownerId =>
    const NothingChanged(),
  EkkloMessageRead(:final conversationId, :final messageId) =>
    switch (_readUpTo(
      thread,
      messageId: messageId,
      ownerId: ownerId,
    )) {
      [] => const NothingChanged(),
      final read => MessagesRead(
        conversationId: conversationId,
        messages: read,
      ),
    },
};

List<EkkloMessage> _readUpTo(
  List<EkkloMessage> thread, {
  required String? messageId,
  required String ownerId,
}) => [
  for (final message in thread.take(switch (messageId) {
    null => thread.length,
    final id => thread.indexWhere((message) => message.id == id) + 1,
  }))
    if (message.senderId == ownerId && !message.readByOther)
      markedRead(message),
];
