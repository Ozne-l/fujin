import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/chat_change.dart';
import 'package:fujin/domain/chat/reduce_chat_event.dart';

final _at = DateTime.utc(2026, 11, 18, 9);

EkkloMessage _message({
  String id = 'm-1',
  List<Map<String, Object?>> reactions = const [],
  String content = 'Hello',
}) => EkkloMessageMapper.fromMap(
  FakeChat.message(
    id: id,
    createdAt: _at,
    content: content,
    reactions: reactions,
  ),
);

EkkloReactionEvent _reaction({
  required String userId,
  required int newCount,
  required bool mineNow,
  bool added = true,
  String emoji = '❤️',
}) => switch (added) {
  true => EkkloReactionAdded(
    conversationId: FakeChat.conversationId,
    messageId: 'm-1',
    emoji: emoji,
    newCount: newCount,
    mineNow: mineNow,
    userId: userId,
  ),
  false => EkkloReactionRemoved(
    conversationId: FakeChat.conversationId,
    messageId: 'm-1',
    emoji: emoji,
    newCount: newCount,
    mineNow: mineNow,
    userId: userId,
  ),
};

ChatChange _reduce(EkkloMessagingEvent event, {EkkloMessage? current}) =>
    reduceChatEvent(event, current: current, ownerId: FakeChat.ownerId);

EkkloMessage _saved(ChatChange change) => switch (change) {
  MessageSaved(:final message) => message,
  MessagesRead() ||
  MessageRemoved() ||
  NothingChanged() => throw StateError('$change'),
};

void main() {
  test('saves a new message and an edited one by id', () {
    final message = _message();

    check(
          _reduce(EkkloNewMessage(message)),
        )
        .isA<MessageSaved>()
        .has((change) => change.message.id, 'id')
        .equals(
          'm-1',
        );
    check(
      _saved(_reduce(EkkloMessageEdited(_message(content: 'Edited')))),
    ).has((message) => message.content, 'content').equals('Edited');
  });

  test('removes a deleted message', () {
    check(
      _reduce(
        const EkkloMessageDeleted(
          conversationId: FakeChat.conversationId,
          messageId: 'm-1',
        ),
      ),
    ).equals(
      const MessageRemoved(
        conversationId: FakeChat.conversationId,
        messageId: 'm-1',
      ),
    );
  });

  group('a read mark', () {
    EkkloMessage sent(String id, {String senderId = FakeChat.ownerId}) =>
        EkkloMessageMapper.fromMap(
          FakeChat.message(id: id, createdAt: _at, senderId: senderId),
        );
    final seenBefore = EkkloMessageMapper.fromMap({
      ...FakeChat.message(
        id: 'm-0',
        createdAt: _at,
        senderId: FakeChat.ownerId,
      ),
      'read_by_other': true,
    });
    final thread = [
      seenBefore,
      sent('m-1'),
      sent('m-2', senderId: FakeChat.coachId),
      sent('m-3'),
      sent('m-4'),
    ];
    ChatChange read({String? messageId, String? userId = FakeChat.coachId}) =>
        reduceChatEvent(
          EkkloMessageRead(
            conversationId: FakeChat.conversationId,
            messageId: messageId,
            userId: userId,
          ),
          current: null,
          ownerId: FakeChat.ownerId,
          thread: thread,
        );
    List<EkkloMessage> marked(ChatChange change) => switch (change) {
      MessagesRead(:final messages) => messages,
      MessageSaved() ||
      MessageRemoved() ||
      NothingChanged() => throw StateError('$change'),
    };

    test('from the coach marks my unread messages up to that one', () {
      final messages = marked(read(messageId: 'm-3'));

      check(messages.map((message) => message.id)).deepEquals(['m-1', 'm-3']);
      check(messages.every((message) => message.readByOther)).isTrue();
    });

    test('without a message marks all my unread messages', () {
      check(
        marked(read()).map((message) => message.id),
      ).deepEquals(['m-1', 'm-3', 'm-4']);
    });

    test('is kept in the JSON the cache stores', () {
      final [first, ...] = marked(read(messageId: 'm-1'));

      check(
        EkkloMessageMapper.fromMap(first.receivedJson).readByOther,
      ).isTrue();
    });

    test('from me changes nothing', () {
      check(
        read(messageId: 'm-4', userId: FakeChat.ownerId),
      ).isA<NothingChanged>();
    });

    test('on a message that is not cached changes nothing', () {
      check(read(messageId: 'm-9')).isA<NothingChanged>();
    });

    test('on messages already read changes nothing', () {
      check(read(messageId: 'm-0')).isA<NothingChanged>();
    });
  });

  group('a reaction', () {
    test('is ignored on a message that is not cached', () {
      check(
        _reduce(
          _reaction(userId: FakeChat.coachId, newCount: 1, mineNow: true),
        ),
      ).isA<NothingChanged>();
    });

    test('from the coach sets the count and keeps my mark', () {
      final reacted = _saved(
        _reduce(
          _reaction(userId: FakeChat.coachId, newCount: 2, mineNow: false),
          current: _message(
            reactions: [FakeChat.reaction('❤️', mine: true)],
          ),
        ),
      );

      check(reacted.reactions).deepEquals([
        const EkkloReaction(emoji: '❤️', count: 2, mine: true),
      ]);
    });

    test('from the coach on a new emoji is not mine', () {
      final reacted = _saved(
        _reduce(
          _reaction(userId: FakeChat.coachId, newCount: 1, mineNow: true),
          current: _message(),
        ),
      );

      check(reacted.reactions).deepEquals([
        const EkkloReaction(emoji: '❤️', count: 1),
      ]);
    });

    test('of mine takes mine_now', () {
      final reacted = _saved(
        _reduce(
          _reaction(userId: FakeChat.ownerId, newCount: 2, mineNow: true),
          current: _message(reactions: [FakeChat.reaction('❤️')]),
        ),
      );

      check(reacted.reactions).deepEquals([
        const EkkloReaction(emoji: '❤️', count: 2, mine: true),
      ]);
    });

    test('removed down to zero drops the emoji', () {
      final reacted = _saved(
        _reduce(
          _reaction(
            userId: FakeChat.ownerId,
            newCount: 0,
            mineNow: false,
            added: false,
          ),
          current: _message(
            reactions: [
              FakeChat.reaction('❤️', mine: true),
              FakeChat.reaction('👍'),
            ],
          ),
        ),
      );

      check(reacted.reactions).deepEquals([
        const EkkloReaction(emoji: '👍', count: 1),
      ]);
    });

    test('is kept in the JSON the cache stores', () {
      final reacted = _saved(
        _reduce(
          _reaction(userId: FakeChat.ownerId, newCount: 1, mineNow: true),
          current: _message(),
        ),
      );

      check(
        EkkloMessageMapper.fromMap(reacted.receivedJson).reactions,
      ).deepEquals([const EkkloReaction(emoji: '❤️', count: 1, mine: true)]);
    });
  });
}
