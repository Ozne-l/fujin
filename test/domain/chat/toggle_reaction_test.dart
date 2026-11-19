import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/toggle_reaction.dart';

EkkloMessage _message(List<Map<String, Object?>> reactions) =>
    EkkloMessageMapper.fromMap(
      FakeChat.message(
        id: 'm-1',
        createdAt: DateTime.utc(2026, 11, 18, 9),
        content: 'Bravo',
        reactions: reactions,
      ),
    );

void main() {
  group('toggling a reaction', () {
    test('adds mine with a count of one', () {
      final toggled = toggleReaction(_message(const []), '❤️');

      check(toggled.reactions).deepEquals([
        const EkkloReaction(emoji: '❤️', count: 1, mine: true),
      ]);
      check(
        toggled.receivedJson['reactions'],
      ).isA<List<Object?>>().length.equals(1);
    });

    test('joins the coach on the same emoji', () {
      final toggled = toggleReaction(
        _message([FakeChat.reaction('👍')]),
        '👍',
      );

      check(toggled.reactions).deepEquals([
        const EkkloReaction(emoji: '👍', count: 2, mine: true),
      ]);
    });

    test('leaves the coach’s reaction when I take mine back', () {
      final toggled = toggleReaction(
        _message([FakeChat.reaction('👍', count: 2, mine: true)]),
        '👍',
      );

      check(toggled.reactions).deepEquals([
        const EkkloReaction(emoji: '👍', count: 1),
      ]);
    });

    test('removes the chip when mine was the only one', () {
      final toggled = toggleReaction(
        _message([FakeChat.reaction('👍', mine: true)]),
        '👍',
      );

      check(toggled.reactions).isEmpty();
      check(toggled.receivedJson.containsKey('reactions')).isFalse();
    });
  });
}
