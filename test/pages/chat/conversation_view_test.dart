import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/chat_link.dart';
import 'package:fujin/domain/chat/conversation_state.dart';
import 'package:fujin/pages/chat/conversation_view.dart';
import 'package:fujin/pages/chat/thread_item.dart';

EkkloMessage _message(
  String id,
  DateTime at, {
  String senderId = FakeChat.coachId,
  FakeChatJson? replyTo,
}) => EkkloMessageMapper.fromMap(
  FakeChat.message(
    id: id,
    createdAt: at,
    senderId: senderId,
    content: id,
    replyTo: replyTo,
  ),
);

ConversationState _state(List<EkkloMessage> messages) => ConversationState(
  conversationId: FakeChat.conversationId,
  ownerId: FakeChat.ownerId,
  conversation: EkkloConversationMapper.fromMap(FakeChat.conversation()),
  messages: messages,
  link: ChatLink.online,
  loadingNewest: false,
  loadingOlder: false,
  hasOlder: false,
  protectsCapture: false,
);

void main() {
  test('messages come newest first, each day opened by its separator', () {
    final view = ConversationView.of(
      _state([
        _message('a', DateTime(2026, 10, 5, 9)),
        _message('b', DateTime(2026, 10, 5, 21)),
        _message('c', DateTime(2026, 10, 7, 8), senderId: FakeChat.ownerId),
      ]),
    );

    check(view.newestFirst).deepEquals([
      ThreadMessage(message: view.messageOf('c'), mine: true),
      ThreadDay(DateTime(2026, 10, 7)),
      ThreadMessage(message: view.messageOf('b'), mine: false),
      ThreadMessage(message: view.messageOf('a'), mine: false),
      ThreadDay(DateTime(2026, 10, 5)),
    ]);
  });

  test('a reply carries the quoted message and who wrote it', () {
    final mine = _message(
      'mine',
      DateTime(2026, 10, 7, 8),
      senderId: FakeChat.ownerId,
    );
    final answer = _message(
      'answer',
      DateTime(2026, 10, 7, 9),
      replyTo: {'id': 'mine', 'sender_id': FakeChat.ownerId},
    );
    final orphan = _message(
      'orphan',
      DateTime(2026, 10, 7, 10),
      replyTo: {'id': 'gone', 'sender_id': FakeChat.coachId},
    );

    final [orphanItem, answerItem, ...] = ConversationView.of(
      _state([mine, answer, orphan]),
    ).newestFirst;

    check(answerItem).isA<ThreadMessage>()
      ..has((item) => item.quoted, 'quoted').equals(mine)
      ..has((item) => item.quotesMine, 'quotesMine').isTrue();
    check(orphanItem).isA<ThreadMessage>()
      ..has((item) => item.quoted, 'quoted').isNull()
      ..has((item) => item.quotesMine, 'quotesMine').isFalse();
  });
}

extension on ConversationView {
  EkkloMessage messageOf(String id) => [
    for (final item in newestFirst)
      if (item case ThreadMessage(:final message) when message.id == id)
        message,
  ].single;
}
