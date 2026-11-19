import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/domain/chat/upload/upload_deadline.dart';

final _start = DateTime.utc(2026, 11, 19, 9);

final _message = MessageInProgress(
  id: 'm-1',
  conversationId: 'c-1',
  startedAt: _start,
  state: MessageInProgressState.uploading,
);

void main() {
  group('the upload deadline', () {
    test('has not passed a moment before 24 hours', () {
      check(
        UploadDeadline.passed(
          _message,
          now: _start.add(
            UploadDeadline.giveUpAfter - const Duration(seconds: 1),
          ),
        ),
      ).isFalse();
    });

    test('has passed 24 hours after the message started', () {
      check(
        UploadDeadline.passed(
          _message,
          now: _start.add(UploadDeadline.giveUpAfter),
        ),
      ).isTrue();
    });
  });
}
