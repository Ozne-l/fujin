import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/chat/pending_text.dart';
import 'package:fujin/domain/chat/pending_text_state.dart';
import 'package:fujin/domain/chat/sent_text.dart';

const _owner = 'owner-1';
const _coach = 'coach-1';
final _attempt = DateTime.utc(2026, 11, 18, 9);

EkkloMessage _message(
  String id, {
  required String content,
  required DateTime at,
  String sender = _owner,
}) => EkkloMessage(
  id: id,
  conversationId: 'c-1',
  senderId: sender,
  type: EkkloMessageType.text,
  createdAt: at,
  content: content,
);

PendingText _pending(String content, {String? after}) => PendingText(
  message: _message('pending-1', content: content, at: _attempt),
  state: PendingTextState.failed,
  after: after,
);

void main() {
  group('a text whose answer was lost', () {
    test('was sent when my same text follows the newest known message', () {
      final page = [
        _message('m-1', content: 'ok', at: _attempt),
        _message('m-2', content: 'ok', at: _attempt),
      ];

      check(
        sentText(_pending('ok', after: 'm-1'), page, ownerId: _owner)?.id,
      ).equals('m-2');
    });

    test('was not sent when the same text only comes before the attempt', () {
      final page = [
        _message('m-1', content: 'ok', at: _attempt),
        _message('m-2', content: 'Et toi ?', at: _attempt, sender: _coach),
      ];

      check(
        sentText(_pending('ok', after: 'm-2'), page, ownerId: _owner),
      ).isNull();
    });

    test('was not sent when the coach wrote the same text', () {
      final page = [
        _message('m-1', content: 'ok', at: _attempt, sender: _coach),
      ];

      check(sentText(_pending('ok'), page, ownerId: _owner)).isNull();
    });

    test('falls back to the time of the attempt when the anchor is gone', () {
      final before = _attempt.subtract(const Duration(minutes: 1));
      final page = [
        _message('m-1', content: 'ok', at: before),
        _message('m-3', content: 'ok', at: _attempt),
      ];

      check(
        sentText(_pending('ok', after: 'm-0'), page, ownerId: _owner)?.id,
      ).equals('m-3');
    });

    test('was not sent when its same text is another one of mine', () {
      final page = [
        _message('m-1', content: 'Et toi ?', at: _attempt, sender: _coach),
        _message('m-2', content: 'ok', at: _attempt),
      ];

      check(
        sentText(
          _pending('ok', after: 'm-1'),
          page,
          ownerId: _owner,
          taken: {'m-2'},
        ),
      ).isNull();
    });

    test('was sent as the next same text when the first is taken', () {
      final page = [
        _message('m-1', content: 'Et toi ?', at: _attempt, sender: _coach),
        _message('m-2', content: 'ok', at: _attempt),
        _message('m-3', content: 'ok', at: _attempt),
      ];

      check(
        sentText(
          _pending('ok', after: 'm-1'),
          page,
          ownerId: _owner,
          taken: {'m-2'},
        )?.id,
      ).equals('m-3');
    });
  });
}
