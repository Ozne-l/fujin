import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/keeping_read.dart';
import 'package:fujin/domain/chat/marked_read.dart';

final _at = DateTime.utc(2026, 11, 18, 9);

EkkloMessage _message({String content = 'Hello'}) => EkkloMessageMapper.fromMap(
  FakeChat.message(
    id: 'm-1',
    createdAt: _at,
    senderId: FakeChat.ownerId,
    content: content,
  ),
);

void main() {
  group('a message Ekklo sends again', () {
    test('stays seen when it comes without the mark', () {
      final kept = keepingRead(
        _message(content: 'Edited'),
        cached: markedRead(_message()),
      );

      check(kept)
        ..has((message) => message.readByOther, 'readByOther').isTrue()
        ..has((message) => message.content, 'content').equals('Edited')
        ..has(
          (message) => message.receivedJson['read_by_other'],
          'read_by_other',
        ).equals(true);
    });

    test('is left as it comes when it was not seen', () {
      final incoming = _message(content: 'Edited');

      check(keepingRead(incoming, cached: _message())).equals(incoming);
    });

    test('is left as it comes when it was not cached', () {
      final incoming = markedRead(_message());

      check(keepingRead(incoming, cached: null)).equals(incoming);
    });
  });
}
