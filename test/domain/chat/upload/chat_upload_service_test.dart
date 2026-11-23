import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart'
    show TestFailure, addTearDown, group, test;
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/media/exported_video.dart';
import 'package:fujin/data/media/media_failure.dart';
import 'package:fujin/data/media/video_outcome.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';
import 'package:fujin/domain/chat/upload/chat_relay.dart';
import 'package:fujin/domain/chat/upload/chat_upload_service.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/domain/chat/upload/relay_outcome.dart';
import 'package:fujin/domain/chat/upload/upload_deadline.dart';
import 'package:fujin/domain/chat/upload/upload_phase.dart';

import '../../../support/fake_backends.dart';
import '../../../support/fake_media_processor.dart';
import '../../../support/fake_media_uploader.dart';
import '../../../support/fake_relay_scheduler.dart';
import '../../../support/fake_upload_notifications.dart';
import '../../../support/until.dart';

final _start = DateTime.utc(2026, 11, 19, 9);
const _settle = Duration(milliseconds: 1);
const String _conversation = FakeChat.conversationId;
const _presignCall = 'POST /api/v1/uploads/presigned-url';
const _voiceCall =
    'POST /api/v1/messaging/conversations/$_conversation/voice-message';
const _mediaCall =
    'POST /api/v1/messaging/conversations/$_conversation/direct-media';

const _photo = EditedPhoto(path: '/picked/meal.jpg', width: 4, height: 3);
const _secondPhoto = EditedPhoto(
  path: '/picked/salad.jpg',
  width: 3,
  height: 4,
);
const _video = EditedVideo(
  path: '/picked/squat.mp4',
  width: 1080,
  height: 1920,
  edit: VideoEdit.untouched(Duration(seconds: 88)),
);

final class _Upload {
  _Upload() : backends = FakeBackends();

  final FakeBackends backends;
  final uploader = FakeMediaUploader();
  final relay = FakeRelayScheduler();
  final notifications = FakeUploadNotifications();
  final processor = FakeMediaProcessor();
  final accepted = <EkkloMessage>[];
  final shown = <List<MessageUpload>>[];
  late final FujinDatabase<CacheTable> database;
  late final MessageInProgressRepository messages;
  late final Directory cache;
  late final UploadFolder folder;
  late final ChatUploadService service;
  DateTime now = _start;

  Iterable<String> get calls => backends.requests.map(FakeBackends.chatCall);

  Future<_Upload> started({
    void Function(MessageInProgressRepository messages)? seed,
  }) async {
    database = FujinDatabase.cacheInMemory();
    addTearDown(database.close);
    cache = Directory.systemTemp.createTempSync('fujin_upload_');
    addTearDown(() => cache.deleteSync(recursive: true));
    folder = UploadFolder(cache);
    messages = MessageInProgressRepository(database);
    seed?.call(messages);
    final client = await backends.ekklo();
    service = ChatUploadService(
      messaging: client.messaging,
      messages: messages,
      chats: ChatRepository(database),
      processor: processor,
      uploader: uploader,
      relay: relay,
      notifications: notifications,
      folder: folder,
      cachePath: null,
      accept: (message, {required postedFrom}) => accepted.add(message),
      clock: () => now,
    );
    addTearDown(service.dispose);
    final subscription = service.watch(_conversation).listen(shown.add);
    addTearDown(subscription.cancel);
    await service.start();
    return this;
  }

  MessageInProgress get only => switch (messages.all()) {
    [final message] => message,
    final all => throw TestFailure('expected one message, got $all'),
  };

  Future<void> ordered(int count) =>
      until<int>(() => uploader.orders.length, (length) => length >= count);

  Future<void> posted() => until<List<MessageInProgress>>(
    messages.all,
    (all) => all.isEmpty,
  );

  Future<void> inState(MessageInProgressState state) =>
      until<MessageInProgressState>(
        () => messages.all().firstOrNull?.state,
        (now) => now == state,
      );

  Future<Set<String>> failureNotice() => until<Set<String>>(
    () => notifications.failed,
    (ids) => ids.isNotEmpty,
  );

  Future<UploadPhase> phase(bool Function(UploadPhase phase) test) =>
      until(() => shown.lastOrNull?.firstOrNull?.phase, test);
}

ExportedVideo _exported(String path, VideoOutcome outcome) => ExportedVideo(
  path: path,
  bytes: 212000000,
  duration: const Duration(seconds: 88),
  uprightWidth: 1080,
  uprightHeight: 1920,
  outcome: outcome,
);

void main() {
  group('sending media', () {
    test('photos are processed, uploaded, then posted once every file is up; '
        'the row, its files and the relay are then gone', () async {
      final upload = await _Upload().started();

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(
          media: [_photo, _secondPhoto],
          caption: 'Mes repas du jour.',
          replyToId: 'm-7',
        ),
      );
      await upload.ordered(2);
      final id = upload.only.id;

      check(
        upload.processor.photoRequests.map((request) => request.output),
      ).every((output) => output.startsWith(upload.folder.of(id).path));
      check(upload.only.state).equals(MessageInProgressState.uploading);
      check(upload.relay.scheduled).deepEquals({id});
      check(
        upload.calls.where((call) => call == _presignCall),
      ).length.equals(2);
      final publicUrls = [
        for (final file in upload.messages.files(id)) file.publicUrl,
      ];

      upload.uploader.complete(upload.uploader.orders.first.fileId);
      await Future<void>.delayed(_settle);
      check(upload.calls).not((calls) => calls.contains(_mediaCall));

      upload.uploader.complete(upload.uploader.orders.last.fileId);
      await upload.posted();

      final sent = upload.backends.chat.messages.last;
      check(sent['media_urls']).isA<List<Object?>>().deepEquals(publicUrls);
      check(sent['message_type']).equals('image');
      check(sent['content']).equals('Mes repas du jour.');
      check(upload.accepted.map((message) => message.id)).deepEquals([
        '${sent['id']}',
      ]);
      check(upload.relay.scheduled).isEmpty();
      check(upload.folder.of(id).existsSync()).isFalse();
      check(upload.shown.last).isEmpty();
    });

    test(
      'a video shows its export as preparing, then its upload as sending '
      'weighted by size, and keeps the original size of an HDR video',
      () async {
        final upload = await _Upload().started();

        await upload.service.sendMedia(
          _conversation,
          const MediaSend(media: [_video]),
        );
        await until(
          () => upload.processor.exportRequests.length,
          (n) => n == 1,
        );
        upload.processor.progress(38);

        check(
            await upload.phase(
              (phase) => phase is UploadPreparing && phase.percent > 0,
            ),
          ).isA<UploadPreparing>()
          ..has((phase) => phase.videos, 'videos').equals(1)
          ..has((phase) => phase.percent, 'percent').equals(38);

        upload.processor.finish(
          _exported(
            upload.processor.exportRequests.single.output,
            VideoOutcome.original,
          ),
        );
        await upload.ordered(1);
        upload.uploader.progress(upload.uploader.orders.single.fileId, 0.42);

        check(
              await upload.phase(
                (phase) => phase is UploadSending && phase.percent > 0,
              ),
            )
            .isA<UploadSending>()
            .has((phase) => phase.percent, 'percent')
            .equals(42);
        check(upload.shown.last.single.originalBytes).equals(212000000);
        check(upload.uploader.orders.single)
          ..has((order) => order.mimeType, 'mime type').equals('video/mp4')
          ..has((order) => order.notice.count, 'count').equals(1);
      },
    );

    test('an export that ends after sign-out writes nothing and asks for no '
        'upload', () async {
      final upload = await _Upload().started();
      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_video]),
      );
      await until(() => upload.processor.exportRequests.length, (n) => n == 1);

      upload.service.dispose();
      upload.database.close();
      upload.processor.finish(
        _exported(
          upload.processor.exportRequests.single.output,
          VideoOutcome.original,
        ),
      );
      await Future<void>.delayed(_settle * 20);

      check(upload.calls).not((calls) => calls.contains(_presignCall));
      check(upload.uploader.orders).isEmpty();
    });

    test('a presign that answers after sign-out writes nothing and asks for '
        'no upload', () async {
      final upload = await _Upload().started();
      final gate = upload.backends.chatGates[_presignCall] = Completer();
      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await until(
        () => upload.calls.where((call) => call == _presignCall).length,
        (n) => n == 1,
      );

      upload.service.dispose();
      upload.database.close();
      gate.complete();
      await Future<void>.delayed(_settle * 20);

      check(upload.uploader.orders).isEmpty();
      check(upload.relay.scheduled).isEmpty();
    });

    test('a processing failure leaves the message not sent with a notice; '
        'retrying processes it again and sends it', () async {
      final upload = await _Upload().started();
      upload.processor.failure = MediaFailure.unreadableSource;

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await upload.inState(MessageInProgressState.failed);
      final id = upload.only.id;

      check(await upload.failureNotice()).deepEquals({id});
      check(
        await upload.phase((phase) => phase is UploadNotSent),
      ).isA<UploadNotSent>();
      check(upload.relay.scheduled).isEmpty();

      upload.processor.failure = null;
      upload.now = _start.add(const Duration(minutes: 5));
      await upload.service.retry(id);
      await upload.ordered(1);

      check(upload.notifications.failed).isEmpty();
      check(upload.only.startedAt).equals(upload.now);
      upload.uploader.completeAll();
      await upload.posted();
    });

    test('an expired upload address is renewed with a new presign, '
        'three times at most', () async {
      final upload = await _Upload().started();

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await upload.ordered(1);
      final fileId = upload.uploader.orders.single.fileId;
      for (
        var renewal = 1;
        renewal <= ChatUploadService.maximumRenewals;
        renewal++
      ) {
        upload.uploader.fail(fileId, expired: true);
        await upload.ordered(renewal + 1);
      }

      check({
        for (final order in upload.uploader.orders) order.url,
      }).length.equals(ChatUploadService.maximumRenewals + 1);

      upload.uploader.fail(fileId, expired: true);
      await upload.inState(MessageInProgressState.failed);
    });

    test('a file finished by the system whose completion has not arrived yet '
        'is not uploaded again when another file completes', () async {
      final upload = await _Upload().started();

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo, _secondPhoto]),
      );
      await upload.ordered(2);
      final [first, second] = upload.uploader.orders;
      upload.uploader
        ..settle(second)
        ..finish(first);
      await until(
        () => upload.messages
            .files(upload.only.id)
            .where(
              (file) => file.isComplete,
            ),
        (complete) => complete.length == 1,
      );

      check(upload.uploader.orders).length.equals(2);
      check(
        upload.calls.where((call) => call == _presignCall),
      ).length.equals(2);

      upload.uploader.finish(second);
      await upload.posted();

      check(upload.uploader.orders).length.equals(2);
      check(
        upload.backends.chat.messages.last['media_urls'],
      ).isA<List<Object?>>().deepEquals([first.publicUrl, second.publicUrl]);
    });

    test('a late completion of an earlier address does not complete the file '
        'uploading at its new address', () async {
      final upload = await _Upload().started();

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await upload.ordered(1);
      final earlier = upload.uploader.orders.single;
      upload.uploader.fail(earlier.fileId, expired: true);
      await upload.ordered(2);
      upload.uploader
        ..finish(earlier)
        ..progress(earlier.fileId, 0.5);
      await upload.phase(
        (phase) => phase is UploadSending && phase.percent > 0,
      );

      check(upload.messages.all()).length.equals(1);
      check(upload.calls).not((calls) => calls.contains(_mediaCall));

      final renewed = upload.uploader.orders.last;
      upload.uploader.finish(renewed);
      await upload.posted();

      check(
        upload.backends.chat.messages.last['media_urls'],
      ).isA<List<Object?>>().deepEquals([renewed.publicUrl]);
    });

    test('a presign without network keeps the message waiting with a notice, '
        'and the upload starts once back online', () async {
      final upload = await _Upload().started();
      upload.backends.lostChatCalls.add(_presignCall);

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await until(() => upload.notifications.waiting, (ids) => ids.isNotEmpty);

      check(upload.only.state).equals(MessageInProgressState.uploading);
      check(upload.uploader.orders).isEmpty();

      upload.backends.lostChatCalls.clear();
      upload.service
        ..setOnline(online: false)
        ..setOnline(online: true);
      await upload.ordered(1);
      upload.uploader.progress(upload.uploader.orders.single.fileId, 0.1);

      check(upload.notifications.waiting).isEmpty();
    });

    test('a post whose reply was lost is not posted again once the message '
        'is found in the newest page', () async {
      final upload = await _Upload().started();
      upload.backends.lostChatCalls.add(_mediaCall);

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await upload.ordered(1);
      upload.uploader.completeAll();
      await until(() => upload.notifications.waiting, (ids) => ids.isNotEmpty);

      upload.backends.lostChatCalls.clear();
      upload.service.setForeground(foreground: true);
      await upload.posted();

      check(upload.calls.where((call) => call == _mediaCall)).length.equals(1);
      check(upload.accepted.single.id).equals(
        '${upload.backends.chat.messages.last['id']}',
      );
    });

    test('a post whose reply was lost keeps the relay scheduled, and the '
        'relay posts it once', () async {
      final upload = await _Upload().started();
      upload.backends.lostChatCalls.add(_mediaCall);

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await upload.ordered(1);
      upload.uploader.completeAll();
      await until(() => upload.notifications.waiting, (ids) => ids.isNotEmpty);
      final id = upload.only.id;

      check(upload.relay.scheduled).deepEquals({id});

      upload.backends.lostChatCalls.clear();
      final relayed = await ChatRelay(
        messaging: (await upload.backends.ekklo()).messaging,
        messages: upload.messages,
        notifications: upload.notifications,
        folder: upload.folder,
        cachePath: FujinDatabase.cachePathIn(upload.cache),
        clock: () => upload.now,
      ).relay(id);

      check(relayed).equals(RelayOutcome.posted);
      check(upload.calls.where((call) => call == _mediaCall)).length.equals(1);
      check(upload.messages.all()).isEmpty();
    });

    test('a refused post leaves the message not sent', () async {
      final upload = await _Upload().started();
      upload.backends.refusedChatCalls.add(_mediaCall);

      await upload.service.sendMedia(
        _conversation,
        const MediaSend(media: [_photo]),
      );
      await upload.ordered(1);
      upload.uploader.completeAll();
      await upload.inState(MessageInProgressState.failed);

      check(upload.accepted).isEmpty();
    });

    test(
      'a message still not sent 24 hours after it started is given up',
      () async {
        final upload = await _Upload().started();

        await upload.service.sendMedia(
          _conversation,
          const MediaSend(media: [_photo]),
        );
        await upload.ordered(1);
        final id = upload.only.id;
        upload.now = _start.add(UploadDeadline.giveUpAfter);
        upload.service.setForeground(foreground: true);
        await upload.inState(MessageInProgressState.failed);

        check(await upload.failureNotice()).deepEquals({id});
        check(upload.uploader.cancelled).contains(id);
        check(upload.relay.scheduled).isEmpty();
      },
    );
  });

  group('sending a voice message', () {
    test('takes the recording into the upload folder and posts it with its '
        'duration and reply', () async {
      final upload = await _Upload().started();
      final recording = File(
        '${upload.cache.path}/voice.m4a',
      )..writeAsBytesSync([1, 2, 3]);

      await upload.service.sendVoice(
        conversationId: _conversation,
        path: recording.path,
        durationSeconds: 37,
        replyToId: 'm-7',
      );
      final message = upload.only;
      final file = upload.messages.files(message.id).single;

      check(recording.existsSync()).isFalse();
      check(file)
        ..has((file) => file.kind, 'kind').equals(ChatMediaKind.voice)
        ..has((file) => file.path, 'path').isNotNull().startsWith(
          upload.folder.of(message.id).path,
        );
      check(message)
        ..has((message) => message.durationSeconds, 'duration').equals(37)
        ..has((message) => message.replyToId, 'reply').equals('m-7');

      await upload.ordered(1);
      check(upload.uploader.orders.single.mimeType).equals('audio/m4a');
      upload.uploader.completeAll();
      await upload.posted();

      check(upload.calls.where((call) => call == _voiceCall)).length.equals(1);
      check(upload.backends.chat.messages.last['message_type']).equals('audio');
    });
  });

  group('after a restart', () {
    test(
      'a message left processing is processed again from its source, and '
      'an upload no longer running is presigned and enqueued again',
      () async {
        final processing = MessageInProgress(
          id: 'm-processing',
          conversationId: _conversation,
          startedAt: _start,
          state: MessageInProgressState.processing,
        );
        final uploading = processing.copyWith(
          id: 'm-uploading',
          state: MessageInProgressState.uploading,
        );
        final upload = await _Upload().started(
          seed: (messages) => messages
            ..start(processing, [
              FileInProgress(
                id: 'f-processing',
                messageId: processing.id,
                position: 0,
                kind: ChatMediaKind.image,
                source: _photo.toMap(),
              ),
            ])
            ..start(uploading, [
              FileInProgress(
                id: 'f-stale',
                messageId: uploading.id,
                position: 0,
                kind: ChatMediaKind.image,
                path: '/gone/f-stale.jpg',
                publicUrl: 'https://chat-media.test/media/old',
              ),
            ]),
        );

        await upload.ordered(2);

        check(upload.processor.photoRequests.single.source).equals(_photo.path);
        check(
          upload.uploader.orders.map((order) => order.fileId),
        ).unorderedEquals(['f-processing', 'f-stale']);
        check(
          upload.messages.files('m-uploading').map((file) => file.publicUrl),
        ).not((urls) => urls.contains('https://chat-media.test/media/old'));
      },
    );

    test('a file without its source cannot be processed again and its '
        'message is not sent', () async {
      final upload = await _Upload().started(
        seed: (messages) => messages.start(
          MessageInProgress(
            id: 'm-lost',
            conversationId: _conversation,
            startedAt: _start,
            state: MessageInProgressState.processing,
          ),
          [
            const FileInProgress(
              id: 'f-lost',
              messageId: 'm-lost',
              position: 0,
              kind: ChatMediaKind.image,
            ),
          ],
        ),
      );

      await upload.inState(MessageInProgressState.failed);
    });
  });
}
