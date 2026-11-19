import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/chat/cached_message.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

const _conversation = 'conv-1';
const _otherConversation = 'conv-2';
const _limit = 2;
final _start = DateTime.utc(2026, 11, 19, 10);

CachedMessage _message(
  String id,
  int minute, {
  String conversation = _conversation,
  String content = '',
}) => CachedMessage(
  id: id,
  conversationId: conversation,
  createdAt: _start.add(Duration(minutes: minute)),
  json: {
    'id': id,
    'content': content,
    'reactions': [
      {'emoji': '👍', 'count': 1, 'mine': false},
    ],
  },
);

void main() {
  late FujinDatabase<CacheTable> database;
  late ChatRepository chat;

  setUp(() {
    database = FujinDatabase.cacheInMemory();
    chat = ChatRepository(database);
  });

  tearDown(() => database.close());

  List<String> idsOf(List<CachedMessage> messages) => [
    for (final message in messages) message.id,
  ];

  group('a newest page read again', () {
    setUp(() {
      chat.saveMessages([
        for (final (minute, id) in ['m-1', 'm-2', 'm-3', 'm-4', 'm-5'].indexed)
          _message(id, minute),
        _message('other', 4, conversation: _otherConversation),
      ]);
    });

    test('replaces the cached messages from its oldest one onward and keeps '
        'the older ones', () {
      final edited = _message('m-3', 2, content: 'edited');

      chat.replaceNewestPage(_conversation, [edited, _message('m-5', 4)]);

      final messages = chat.messages(_conversation, limit: 10);
      check(idsOf(messages)).deepEquals(['m-1', 'm-2', 'm-3', 'm-5']);
      check(messages[2]).equals(edited);
      check(
        idsOf(chat.messages(_otherConversation, limit: 10)),
      ).deepEquals(['other']);
    });

    test('empty clears its conversation only', () {
      chat.replaceNewestPage(_conversation, const []);

      check(chat.messages(_conversation, limit: 10)).isEmpty();
      check(chat.messages(_otherConversation, limit: 10)).length.equals(1);
    });
  });

  group('messages', () {
    setUp(() {
      chat.saveMessages([
        _message('m-4', 3),
        _message('m-1', 0),
        _message('m-3', 2),
        _message('m-2', 1),
      ]);
    });

    test('are the newest ones, oldest first', () {
      check(
        idsOf(chat.messages(_conversation, limit: _limit)),
      ).deepEquals(['m-3', 'm-4']);
    });

    test('before a message are the ones just older than it', () {
      check(
        idsOf(chat.messages(_conversation, limit: _limit, before: 'm-3')),
      ).deepEquals(['m-1', 'm-2']);
      check(
        chat.messages(_conversation, limit: _limit, before: 'm-1'),
      ).isEmpty();
    });

    test('keep the order of instants a microsecond apart', () {
      final instant = DateTime.utc(2026, 11, 19, 12, 0, 0, 123);
      chat.saveMessages([
        CachedMessage(
          id: 'a-later',
          conversationId: _otherConversation,
          createdAt: instant.add(const Duration(microseconds: 456)),
          json: const {},
        ),
        CachedMessage(
          id: 'z-earlier',
          conversationId: _otherConversation,
          createdAt: instant,
          json: const {},
        ),
      ]);

      check(
        idsOf(chat.messages(_otherConversation, limit: _limit)),
      ).deepEquals(['z-earlier', 'a-later']);
    });

    test('lose a removed message', () {
      chat.removeMessage('m-2');

      check(
        idsOf(chat.messages(_conversation, limit: 10)),
      ).deepEquals(['m-1', 'm-3', 'm-4']);
    });
  });
}
