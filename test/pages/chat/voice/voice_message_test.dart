import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:checks/checks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat/conversation_page.dart';
import 'package:fujin/pages/chat/reply_notifier.dart';
import 'package:fujin/pages/chat/upload/upload_bubble.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_scrubber.dart';
import 'package:fujin/pages/chat/widgets/voice_bubble.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../support/fake_backends.dart';
import '../../../support/fake_media_uploader.dart';
import '../../../support/fake_video_player.dart';
import '../../../support/fake_voice_recorder.dart';
import '../../../support/fixtures.dart';
import '../../../support/pump_fujin.dart';

const _voice = 'Message vocal';
const _send = 'Envoyer';
const _delete = 'Supprimer l’enregistrement';
const _hint = 'Message';
const _offline = 'Pas de connexion';
const _replying = 'Réponse à';
const _notLoaded = 'Message vocal pas chargé';
const double _androidSlop = 8;
const double _step = 2;
const _question = 'Raconte-moi en vocal comment le genou a réagi.';

FakeBackends _backends({
  String type = 'text',
  String content = _question,
  List<String> mediaUrls = const [],
}) => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    conversations: [FakeChat.conversation()],
    messages: [
      FakeChat.message(
        id: 'm1',
        createdAt: now.subtract(const Duration(minutes: 5)),
        type: type,
        content: content,
        mediaUrls: mediaUrls,
      ),
    ],
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(
    find.descendant(of: find.byType(TabPlate), matching: find.text('Messages')),
  );
  await tester.pumpAndSettle();
}

Future<void> _record(WidgetTester tester) async {
  await tester.tap(find.bySemanticsLabel(_voice));
  await tester.pump();
  await tester.pump();
}

FakeBackends _withVoiceNote() => _backends(
  type: 'audio',
  content: '',
  mediaUrls: ['${chatMediaUri.resolve('/media/note.m4a')}'],
)..chatMedia['note.m4a'] = FakeVoiceRecorder.recordedBytes;

Future<FakeVideoPlayer> _openVoiceNote(
  WidgetTester tester, {
  Stream<bool> connectivity = const Stream.empty(),
}) async {
  final player = FakeVideoPlayer(duration: const Duration(seconds: 10));
  await pumpFujin(
    tester,
    _withVoiceNote(),
    fileVideo: player,
    connectivity: connectivity,
  );
  await _open(tester);
  await _settleFiles(tester);
  return player;
}

Future<void> _settleFiles(WidgetTester tester) async {
  for (var turn = 0; turn < 10; turn++) {
    await _turn(tester);
  }
}

Future<void> _enqueued(
  WidgetTester tester,
  FakeMediaUploader uploader,
  int orders,
) async {
  for (var turn = 0; turn < 40 && uploader.orders.length < orders; turn++) {
    await _turn(tester);
  }
  await tester.pumpAndSettle();
}

Future<void> _turn(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 10)),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

Finder _glyphs(String asset) => find.byWidgetPredicate(
  (widget) => widget is MediaGlyph && widget.asset == asset,
);

Offset _along(WidgetTester tester, double fraction) {
  final wave = tester.getRect(find.byType(VoiceScrubber));
  return Offset(wave.left + wave.width * fraction, wave.center.dy);
}

double _shown(WidgetTester tester, Finder finder) =>
    switch (finder.evaluate().isEmpty) {
      true => 0,
      false =>
        tester
            .widgetList<FadeTransition>(
              find.ancestor(
                of: finder.first,
                matching: find.byType(FadeTransition),
              ),
            )
            .fold(1, (shown, fade) => shown * fade.opacity.value),
    };

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(ConversationPage)));

void _replyToM1(ProviderContainer container) =>
    container.read(replyProvider(FakeChat.conversationId).notifier).message =
        container.read(chatServiceProvider).message('m1');

MessageInProgressRepository _inProgress(ProviderContainer container) =>
    container.read(messageInProgressRepositoryProvider);

void main() {
  testWidgets('records with a running time in place of the composer', (
    tester,
  ) async {
    final recorder = FakeVoiceRecorder();
    await pumpFujin(tester, _backends(), voiceRecorder: recorder);
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 7));

    check(find.text('0:07').evaluate()).length.equals(1);
    check(find.byTooltip(_delete).evaluate()).length.equals(1);
    check(find.text(_hint).evaluate()).isEmpty();
    check(recorder.recording).isNotNull();
  });

  testWidgets('refuses a message under 1 second and sends nothing', (
    tester,
  ) async {
    final recorder = FakeVoiceRecorder();
    await pumpFujin(tester, _backends(), voiceRecorder: recorder);
    await _open(tester);
    final container = _container(tester);

    await _record(tester);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.tap(find.byTooltip(_send));
    await tester.pumpAndSettle();

    check(find.text('Message vocal trop court').evaluate()).length.equals(1);
    check(find.text('Il faut au moins 1 seconde.').evaluate()).length.equals(1);
    check(find.text(_hint).evaluate()).length.equals(1);
    check(File(recorder.started.single).existsSync()).isFalse();
    check(_inProgress(container).all()).isEmpty();
  });

  testWidgets('sends a recording of 1 second with its read-back length and '
      'the reply', (tester) async {
    final recorder = FakeVoiceRecorder();
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: recorder,
      fileVideo: FakeVideoPlayer(
        duration: const Duration(milliseconds: 1400),
      ),
    );
    await _open(tester);
    final container = _container(tester);
    _replyToM1(container);
    await tester.pump();

    await _record(tester);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byTooltip(_send));
    await tester.pumpAndSettle();

    final repository = _inProgress(container);
    final sent = repository.all().single;
    check(sent)
      ..has((message) => message.durationSeconds, 'duration').equals(1)
      ..has((message) => message.replyToId, 'reply').equals('m1');
    check(repository.files(sent.id).single.path)
        .isNotNull()
        .has((path) => File(path).readAsBytesSync(), 'bytes')
        .deepEquals(FakeVoiceRecorder.recordedBytes);
    check(File(recorder.started.single).existsSync()).isFalse();
    check(container.read(replyProvider(FakeChat.conversationId))).isNull();
    check(find.text(_hint).evaluate()).length.equals(1);
  });

  testWidgets('warns at 4:50, then stops at 5:00 and keeps the recording to '
      'play before sending', (tester) async {
    final recorder = FakeVoiceRecorder();
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: recorder,
      fileVideo: FakeVideoPlayer(duration: const Duration(minutes: 5)),
    );
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(minutes: 4, seconds: 49));
    check(find.text('Il reste 10 secondes').evaluate()).isEmpty();
    await tester.pump(const Duration(seconds: 1));
    check(find.text('4:50').evaluate()).length.equals(1);
    check(find.text('Il reste 10 secondes').evaluate()).length.equals(1);

    await tester.pump(const Duration(seconds: 10));
    await tester.pump();

    check(
      find.text('5 minutes au maximum : enregistrement arrêté').evaluate(),
    ).length.equals(1);
    check(find.text('5:00').evaluate()).length.equals(1);
    check(find.bySemanticsLabel('Lire').evaluate()).length.equals(1);
    check(recorder.recording).isNull();
    check(File(recorder.started.single).existsSync()).isTrue();
  });

  testWidgets('deletes the recording with « Supprimer l’enregistrement »', (
    tester,
  ) async {
    final recorder = FakeVoiceRecorder();
    await pumpFujin(tester, _backends(), voiceRecorder: recorder);
    await _open(tester);
    final container = _container(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byTooltip(_delete));
    await tester.pumpAndSettle();

    check(File(recorder.started.single).existsSync()).isFalse();
    check(find.text(_hint).evaluate()).length.equals(1);
    check(_inProgress(container).all()).isEmpty();
  });

  testWidgets('deletes the recording when leaving the conversation', (
    tester,
  ) async {
    final recorder = FakeVoiceRecorder();
    await pumpFujin(tester, _backends(), voiceRecorder: recorder);
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();

    check(find.byType(ConversationPage).evaluate()).isEmpty();
    check(File(recorder.started.single).existsSync()).isFalse();
    check(recorder.recording).isNull();
  });

  testWidgets('sends a recording whose send was tapped just before leaving '
      'the conversation', (tester) async {
    final recorder = FakeVoiceRecorder();
    final player = FakeVideoPlayer(duration: const Duration(seconds: 3))
      ..gate = Completer<void>();
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: recorder,
      fileVideo: player,
    );
    await _open(tester);
    final container = _container(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byTooltip(_send));
    await tester.pump();
    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();
    player.gate?.complete();
    await tester.pumpAndSettle();

    check(find.byType(ConversationPage).evaluate()).isEmpty();
    final repository = _inProgress(container);
    final sent = repository.all().single;
    check(sent).has((message) => message.durationSeconds, 'duration').equals(3);
    check(repository.files(sent.id).single.path)
        .isNotNull()
        .has((path) => File(path).readAsBytesSync(), 'bytes')
        .deepEquals(FakeVoiceRecorder.recordedBytes);
  });

  testWidgets('says how to allow the microphone when it is refused', (
    tester,
  ) async {
    final recorder = FakeVoiceRecorder(allows: false);
    await pumpFujin(tester, _backends(), voiceRecorder: recorder);
    await _open(tester);

    await _record(tester);
    await tester.pumpAndSettle();

    check(find.text('Pas d’accès au micro').evaluate()).length.equals(1);
    check(
      find
          .text('Autorise le micro pour Fūjin dans les réglages du téléphone.')
          .evaluate(),
    ).length.equals(1);
    check(find.text(_hint).evaluate()).length.equals(1);
    check(recorder.started).isEmpty();
  });

  testWidgets('keeps the live recording bar usable through a lost '
      'connection, up to its stop', (tester) async {
    final recorder = FakeVoiceRecorder();
    final network = StreamController<bool>.broadcast();
    addTearDown(network.close);
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: recorder,
      connectivity: network.stream,
      fileVideo: FakeVideoPlayer(duration: const Duration(minutes: 5)),
    );
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 3));
    network.add(false);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    check(recorder.recording).isNotNull();
    check(find.byTooltip(_delete).evaluate()).length.equals(1);
    check(find.text(_offline).evaluate()).isEmpty();

    await tester.pump(const Duration(minutes: 5));
    await tester.pump();

    check(recorder.recording).isNull();
    check(File(recorder.started.single).existsSync()).isTrue();
    check(find.bySemanticsLabel('Lire').evaluate()).length.equals(1);
    check(find.text(_offline).evaluate()).isEmpty();
  });

  testWidgets('keeps the reply a recording answers in view through a lost '
      'connection', (tester) async {
    final network = StreamController<bool>.broadcast();
    addTearDown(network.close);
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: FakeVoiceRecorder(),
      connectivity: network.stream,
      fileVideo: FakeVideoPlayer(duration: const Duration(minutes: 5)),
    );
    await _open(tester);
    _replyToM1(_container(tester));
    await tester.pumpAndSettle();

    await _record(tester);
    await tester.pump(const Duration(seconds: 3));
    network.add(false);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    check(find.byTooltip(_delete).evaluate()).length.equals(1);
    check(find.textContaining(_replying).evaluate()).length.equals(1);
  });

  testWidgets('keeps the stopped recording bar usable through a lost '
      'connection, then shows the offline card once it is deleted', (
    tester,
  ) async {
    final recorder = FakeVoiceRecorder();
    final network = StreamController<bool>.broadcast();
    addTearDown(network.close);
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: recorder,
      connectivity: network.stream,
      fileVideo: FakeVideoPlayer(duration: const Duration(minutes: 5)),
    );
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(minutes: 5));
    await tester.pump();
    network.add(false);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    check(File(recorder.started.single).existsSync()).isTrue();
    check(find.bySemanticsLabel('Lire').evaluate()).length.equals(1);
    check(find.text(_offline).evaluate()).isEmpty();

    await tester.tap(find.byTooltip(_delete));
    await tester.pumpAndSettle();

    check(File(recorder.started.single).existsSync()).isFalse();
    check(find.text(_offline).evaluate()).length.equals(1);
  });

  testWidgets('swaps the composer for the voice bar and back, leaving only '
      'one of them', (tester) async {
    await pumpFujin(tester, _backends(), voiceRecorder: FakeVoiceRecorder());
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 1));

    check(find.text(_hint).evaluate()).isEmpty();
    check(find.byTooltip(_delete).evaluate()).length.equals(1);

    await tester.tap(find.byTooltip(_delete));
    await tester.pumpAndSettle();

    check(find.text(_hint).evaluate()).length.equals(1);
    check(find.byTooltip(_delete).evaluate()).isEmpty();
  });

  testWidgets('swaps the composer for the voice bar at once with reduced '
      'motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpFujin(tester, _backends(), voiceRecorder: FakeVoiceRecorder());
    await _open(tester);

    await _record(tester);

    check(find.text(_hint).evaluate()).isEmpty();
    check(find.byTooltip(_delete).evaluate()).length.equals(1);
  });

  testWidgets('seeks a voice message where the drag on its waveform is '
      'released, not during the drag', (tester) async {
    final player = await _openVoiceNote(tester);

    final gesture = await tester.startGesture(_along(tester, 0.1));
    for (final fraction in [0.3, 0.5, 0.75]) {
      await gesture.moveTo(_along(tester, fraction));
      await tester.pump();
    }

    check(player.last.seeks).isEmpty();

    await gesture.up();
    await tester.pump();

    check(
      player.last.seeks.single.inMilliseconds,
    ).isA<int>().isCloseTo(7500, 50);
  });

  for (final (platform, slop) in [
    ('Android', _androidSlop),
    ('iOS', kTouchSlop),
  ]) {
    testWidgets('seeks a voice message dragged slowly along its waveform '
        'instead of swiping to reply, with the touch slop of $platform', (
      tester,
    ) async {
      tester.view.gestureSettings = ui.GestureSettings(
        physicalTouchSlop: slop * tester.view.devicePixelRatio,
      );
      addTearDown(tester.view.resetGestureSettings);
      final player = await _openVoiceNote(tester);

      final from = _along(tester, 0.1);
      final to = _along(tester, 0.75);
      final gesture = await tester.startGesture(from);
      for (var x = from.dx + _step; x < to.dx; x += _step) {
        await gesture.moveTo(Offset(x, from.dy));
        await tester.pump();
      }
      await gesture.moveTo(to);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      check(
        player.last.seeks.single.inMilliseconds,
      ).isA<int>().isCloseTo(7500, 50);
      check(find.textContaining(_replying).evaluate()).isEmpty();
    });
  }

  testWidgets('lifts a playing voice message as it plays, without loading it '
      'again', (tester) async {
    final player = await _openVoiceNote(tester);
    await tester.tap(find.bySemanticsLabel('Lire'));
    await tester.pump();

    await tester.longPress(find.byType(VoiceBubble));
    await tester.pumpAndSettle();

    check(player.controllers).length.equals(1);
    check(_glyphs(ChatMediaIcon.pause).evaluate()).length.equals(2);
    check(_glyphs(ChatMediaIcon.play).evaluate()).isEmpty();
  });

  testWidgets('says a voice message did not load and loads it again on a '
      'touch', (tester) async {
    final player = FakeVideoPlayer(
      duration: const Duration(seconds: 10),
      failures: 1,
    );
    await pumpFujin(tester, _withVoiceNote(), fileVideo: player);
    await _open(tester);
    await _settleFiles(tester);

    check(find.bySemanticsLabel(_notLoaded).evaluate()).length.equals(1);
    check(find.bySemanticsLabel('Lire').evaluate()).isEmpty();

    await tester.tap(find.bySemanticsLabel(_notLoaded));
    await _settleFiles(tester);

    check(find.bySemanticsLabel(_notLoaded).evaluate()).isEmpty();
    check(player.controllers).length.equals(2);
    check(player.controllers.first.disposed).isTrue();

    await tester.tap(find.bySemanticsLabel('Lire'));
    await tester.pump();

    check(player.last.value.isPlaying).isTrue();
  });

  testWidgets('seeks a voice message to the point tapped on its waveform', (
    tester,
  ) async {
    final player = await _openVoiceNote(tester);

    await tester.tapAt(_along(tester, 0.4));
    await tester.pump();

    check(
      player.last.seeks.single.inMilliseconds,
    ).isA<int>().isCloseTo(4000, 50);
  });

  testWidgets('fades my sent voice message from its upload into its message', (
    tester,
  ) async {
    final uploader = FakeMediaUploader();
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: FakeVoiceRecorder(),
      fileVideo: FakeVideoPlayer(duration: const Duration(seconds: 2)),
      mediaUploader: uploader,
    );
    await _open(tester);

    await _record(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byTooltip(_send));
    await _enqueued(tester, uploader, 1);
    check(_shown(tester, find.byType(UploadBubble))).equals(1);

    uploader.completeAll();
    final errors = <Object>[];
    final uploads = <double>[];
    for (var turn = 0; turn < 40; turn++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 16));
      if (tester.takeException() case final Object error) errors.add(error);
      uploads.add(_shown(tester, find.byType(UploadBubble)));
    }

    check(errors).isEmpty();
    check(uploads.last).equals(0);
    check(uploads.where((shown) => shown > 0 && shown < 1)).isNotEmpty();
  });

  testWidgets('shows my first voice message once posted while my second one '
      'is still sending', (tester) async {
    final uploader = FakeMediaUploader();
    var clock = now;
    await pumpFujin(
      tester,
      _backends(),
      voiceRecorder: FakeVoiceRecorder(),
      fileVideo: FakeVideoPlayer(duration: const Duration(seconds: 2)),
      mediaUploader: uploader,
      clock: () => clock,
    );
    await _open(tester);

    for (final sent in [1, 2]) {
      await _record(tester);
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.byTooltip(_send));
      await _enqueued(tester, uploader, sent);
      clock = clock.add(const Duration(minutes: 1));
    }
    check(find.byType(UploadBubble).evaluate()).length.equals(2);

    uploader.finish(uploader.orders.first);
    await _settleFiles(tester);
    await tester.pumpAndSettle();

    check(find.byType(VoiceBubble).evaluate()).length.equals(1);
    check(find.byType(UploadBubble).evaluate()).length.equals(1);
  });

  testWidgets('shows my voice message that Ekklo posted although its send '
      'failed', (tester) async {
    final uploader = FakeMediaUploader();
    final backends = _backends();
    await pumpFujin(
      tester,
      backends,
      voiceRecorder: FakeVoiceRecorder(),
      fileVideo: FakeVideoPlayer(duration: const Duration(seconds: 2)),
      mediaUploader: uploader,
    );
    await _open(tester);
    await _record(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byTooltip(_send));
    await _enqueued(tester, uploader, 1);
    final order = uploader.orders.single;

    backends.refusedChatCalls.add(
      'POST /api/v1/messaging/conversations/${FakeChat.conversationId}'
      '/voice-message',
    );
    uploader.finish(order);
    await _settleFiles(tester);
    await tester.pumpAndSettle();
    check(find.byType(VoiceBubble).evaluate()).isEmpty();

    backends.chat.deliver(
      FakeChat.message(
        id: 'posted',
        createdAt: now.add(const Duration(minutes: 1)),
        senderId: FakeChat.ownerId,
        type: 'audio',
        mediaUrls: [order.publicUrl],
      ),
    );
    await _settleFiles(tester);
    await tester.pumpAndSettle();

    check(find.byType(VoiceBubble).evaluate()).length.equals(1);
  });

  testWidgets('keeps a voice message playing while the connection goes and '
      'comes back', (tester) async {
    final network = StreamController<bool>.broadcast();
    addTearDown(network.close);
    final player = await _openVoiceNote(tester, connectivity: network.stream);
    await tester.tap(find.bySemanticsLabel('Lire'));
    await tester.pump();
    final playing = player.last;
    check(playing.value.isPlaying).isTrue();

    network.add(false);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    check(find.text(_offline).evaluate()).length.equals(1);

    network.add(true);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    check(player.controllers).length.equals(1);
    check(playing)
      ..has((controller) => controller.disposed, 'disposed').isFalse()
      ..has((controller) => controller.value.isPlaying, 'playing').isTrue();
  });
}
