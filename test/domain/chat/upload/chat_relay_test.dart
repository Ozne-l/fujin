import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, group, test;
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/upload/upload_completion.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_marker.dart';
import 'package:fujin/domain/chat/upload/chat_relay.dart';
import 'package:fujin/domain/chat/upload/relay_outcome.dart';
import 'package:fujin/domain/chat/upload/upload_deadline.dart';

import '../../../support/fake_backends.dart';
import '../../../support/fake_upload_notifications.dart';

final _start = DateTime.utc(2026, 11, 19, 9);
const _messageId = 'm-relay';
const _mediaCall =
    'POST /api/v1/messaging/conversations/${FakeChat.conversationId}'
    '/direct-media';
const _voiceCall =
    'POST /api/v1/messaging/conversations/${FakeChat.conversationId}'
    '/voice-message';
const _videoUrl = 'https://chat-media.test/media/upload-1-squat.mp4';
const _voiceUrl = 'https://chat-media.test/media/upload-2-voice.m4a';

final class _Relay {
  _Relay() {
    final directory = Directory.systemTemp.createTempSync('fujin_relay_');
    addTearDown(() => directory.deleteSync(recursive: true));
    cachePath = FujinDatabase.cachePathIn(directory);
    folder = UploadFolder(directory);
    final database = FujinDatabase.openCacheInApp(cachePath);
    addTearDown(database.close);
    messages = MessageInProgressRepository(database);
  }

  final backends = FakeBackends();
  final notifications = FakeUploadNotifications();
  late final String cachePath;
  late final UploadFolder folder;
  late final MessageInProgressRepository messages;
  DateTime now = _start.add(const Duration(minutes: 2));

  Iterable<String> get calls => backends.requests.map(FakeBackends.chatCall);

  void seed({
    DateTime? completedAt,
    String conversationId = FakeChat.conversationId,
  }) {
    messages.start(
      MessageInProgress(
        id: _messageId,
        conversationId: conversationId,
        startedAt: _start,
        state: MessageInProgressState.uploading,
        caption: 'Ma série',
      ),
      [
        FileInProgress(
          id: 'f-video',
          messageId: _messageId,
          position: 0,
          kind: ChatMediaKind.video,
          path: folder.file(_messageId, 'f-video.mp4'),
          publicUrl: _videoUrl,
          completedAt: completedAt,
        ),
      ],
    );
    folder.create(_messageId);
  }

  Future<RelayOutcome> run() async => ChatRelay(
    messaging: (await backends.ekklo()).messaging,
    messages: messages,
    notifications: notifications,
    folder: folder,
    cachePath: cachePath,
    clock: () => now,
  ).relay(_messageId);
}

void main() {
  group('the relay', () {
    test('waits while a file is still uploading', () async {
      final relay = _Relay()..seed();

      check(await relay.run()).equals(RelayOutcome.later);
      check(relay.calls).isEmpty();
      check(relay.messages.message(_messageId)).isNotNull();
    });

    test('posts the message once every file is up, then forgets it and its '
        'files', () async {
      final relay = _Relay()..seed(completedAt: _start);

      check(await relay.run()).equals(RelayOutcome.posted);
      check(relay.calls.where((call) => call == _mediaCall)).length.equals(1);
      check(relay.backends.chat.messages.last)
        ..has(
          (message) => message['media_urls'],
          'urls',
        ).isA<List<Object?>>().deepEquals([_videoUrl])
        ..has((message) => message['message_type'], 'type').equals('video')
        ..has((message) => message['content'], 'caption').equals('Ma série');
      check(relay.messages.message(_messageId)).isNull();
      check(relay.folder.of(_messageId).existsSync()).isFalse();
    });

    test(
      'counts a completion left as a marker by the upload callback',
      () async {
        final relay = _Relay()..seed();
        UploadCompletion.markersOf(relay.cachePath).createSync();
        File(
          '${UploadCompletion.markersOf(relay.cachePath).path}/f-video',
        ).writeAsStringSync(
          UploadMarker(publicUrl: _videoUrl, at: _start).toJson(),
        );

        check(await relay.run()).equals(RelayOutcome.posted);
        check(
          UploadCompletion.markersOf(relay.cachePath).listSync(),
        ).isEmpty();
      },
    );

    test('does not post a message already found in the newest page', () async {
      final relay = _Relay()..seed(completedAt: _start);
      relay.backends.chat.deliver(
        FakeChat.message(
          id: 'm-posted',
          createdAt: _start,
          senderId: FakeChat.ownerId,
          type: 'video',
          mediaUrls: const [_videoUrl],
        ),
      );

      check(await relay.run()).equals(RelayOutcome.posted);
      check(relay.calls).not((calls) => calls.contains(_mediaCall));
      check(relay.messages.message(_messageId)).isNull();
    });

    test('tries again later when the network is lost', () async {
      final relay = _Relay()..seed(completedAt: _start);
      relay.backends.ekkloReachable = false;

      check(await relay.run()).equals(RelayOutcome.later);
      check(relay.messages.message(_messageId)).isNotNull();
    });

    test(
      'gives up with a failure notice when Ekklo refuses the request',
      () async {
        final relay = _Relay()
          ..seed(completedAt: _start, conversationId: 'c-unknown');

        check(await relay.run()).equals(RelayOutcome.gaveUp);
        check(
          relay.messages.message(_messageId)?.state,
        ).equals(MessageInProgressState.failed);
        check(relay.notifications.failed).deepEquals({_messageId});
      },
    );

    test('tries again later when Ekklo answers with a server error', () async {
      final relay = _Relay()..seed(completedAt: _start);
      relay.backends.refusedChatCalls.add(_mediaCall);

      check(await relay.run()).equals(RelayOutcome.later);
      check(
        relay.messages.message(_messageId)?.state,
      ).equals(MessageInProgressState.uploading);
      check(relay.notifications.failed).isEmpty();
    });

    test('gives up on a voice message saved without its duration', () async {
      final relay = _Relay();
      relay.messages.start(
        MessageInProgress(
          id: _messageId,
          conversationId: FakeChat.conversationId,
          startedAt: _start,
          state: MessageInProgressState.uploading,
        ),
        [
          FileInProgress(
            id: 'f-voice',
            messageId: _messageId,
            position: 0,
            kind: ChatMediaKind.voice,
            path: relay.folder.file(_messageId, 'f-voice.m4a'),
            publicUrl: _voiceUrl,
            completedAt: _start,
          ),
        ],
      );

      check(await relay.run()).equals(RelayOutcome.gaveUp);
      check(relay.calls).not((calls) => calls.contains(_voiceCall));
      check(relay.notifications.failed).deepEquals({_messageId});
    });

    test('gives up 24 hours after the message started', () async {
      final relay = _Relay()
        ..seed()
        ..now = _start.add(UploadDeadline.giveUpAfter);

      check(await relay.run()).equals(RelayOutcome.gaveUp);
      check(
        relay.messages.message(_messageId)?.state,
      ).equals(MessageInProgressState.failed);
      check(relay.notifications.failed).deepEquals({_messageId});
      check(relay.calls).isEmpty();
    });

    test('has nothing to do for a message already gone', () async {
      final relay = _Relay();

      check(await relay.run()).equals(RelayOutcome.gone);
      check(relay.calls).isEmpty();
    });
  });
}
