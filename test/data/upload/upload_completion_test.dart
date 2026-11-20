import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, test;
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/upload/upload_completion.dart';

final _startedAt = DateTime.utc(2026, 11, 19, 9);
final _completedAt = DateTime.utc(2026, 11, 19, 9, 3);
const _publicUrl = 'https://chat-media.test/media/upload-1-f-1.jpg';

String _cachePath() {
  final directory = Directory.systemTemp.createTempSync('fujin_completion_');
  addTearDown(() => directory.deleteSync(recursive: true));
  return FujinDatabase.cachePathIn(directory);
}

MessageInProgressRepository _seeded(String cachePath) {
  final database = FujinDatabase.openCacheInApp(cachePath);
  addTearDown(database.close);
  return MessageInProgressRepository(database)..start(
    MessageInProgress(
      id: 'm-1',
      conversationId: 'conversation-1',
      startedAt: _startedAt,
      state: MessageInProgressState.uploading,
    ),
    [
      const FileInProgress(
        id: 'f-1',
        messageId: 'm-1',
        position: 0,
        kind: ChatMediaKind.image,
        path: '/upload/f-1.jpg',
        publicUrl: _publicUrl,
      ),
    ],
  );
}

void main() {
  test('a completion is written straight into the cache when it opens', () {
    final cachePath = _cachePath();
    final messages = _seeded(cachePath);

    UploadCompletion.record(
      cachePath: cachePath,
      fileId: 'f-1',
      publicUrl: _publicUrl,
      at: _completedAt,
    );

    check(messages.files('m-1').single.completedAt).equals(_completedAt);
    check(UploadCompletion.markersOf(cachePath).existsSync()).isFalse();
  });

  test('a completion the cache cannot take is left as a marker, which the '
      'next sweep records and removes', () {
    final cachePath = _cachePath();
    Directory(cachePath).createSync();

    UploadCompletion.record(
      cachePath: cachePath,
      fileId: 'f-1',
      publicUrl: _publicUrl,
      at: _completedAt,
    );
    Directory(cachePath).deleteSync();
    final messages = _seeded(cachePath);

    check(messages.files('m-1').single.completedAt).isNull();
    UploadCompletion.sweep(messages, cachePath: cachePath);

    check(messages.files('m-1').single.completedAt).equals(_completedAt);
    check(UploadCompletion.markersOf(cachePath).listSync()).isEmpty();
  });
}
