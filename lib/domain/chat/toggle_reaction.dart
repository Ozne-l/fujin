import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/with_reaction.dart';

EkkloMessage toggleReaction(EkkloMessage message, String emoji) =>
    switch (message.reactions
        .where((reaction) => reaction.emoji == emoji)
        .firstOrNull) {
      null => withReaction(
        message,
        EkkloReaction(emoji: emoji, count: 1, mine: true),
      ),
      EkkloReaction(mine: true, :final count) => withReaction(
        message,
        EkkloReaction(emoji: emoji, count: count - 1),
      ),
      EkkloReaction(mine: false, :final count) => withReaction(
        message,
        EkkloReaction(emoji: emoji, count: count + 1, mine: true),
      ),
    };
