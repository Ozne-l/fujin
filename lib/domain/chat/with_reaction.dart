import 'package:ekklo_client/ekklo_client.dart';

const _reactionsKey = 'reactions';

EkkloMessage withReaction(EkkloMessage message, EkkloReaction reaction) {
  final reactions = switch ((
    message.reactions.any((existing) => existing.emoji == reaction.emoji),
    reaction.count > 0,
  )) {
    (_, false) => [
      for (final existing in message.reactions)
        if (existing.emoji != reaction.emoji) existing,
    ],
    (false, true) => [...message.reactions, reaction],
    (true, true) => [
      for (final existing in message.reactions)
        if (existing.emoji == reaction.emoji) reaction else existing,
    ],
  };
  final json = {...message.receivedJson}..remove(_reactionsKey);
  return message.copyWith(
    reactions: reactions,
    receivedJson: {
      ...json,
      if (reactions.isNotEmpty)
        _reactionsKey: [for (final reaction in reactions) reaction.toMap()],
    },
  );
}
