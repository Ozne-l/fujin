import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat/conversation_page.dart';
import 'package:fujin/pages/chat/reply_notifier.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../support/fake_backends.dart';
import '../../../support/fake_video_player.dart';
import '../../../support/fake_voice_recorder.dart';
import '../../../support/fixtures.dart';
import '../../../support/pump_fujin.dart';

const _voice = 'Message vocal';
const _send = 'Envoyer';
const _delete = 'Supprimer l’enregistrement';
const _hint = 'Message';
const _offline = 'Pas de connexion';
const _question = 'Raconte-moi en vocal comment le genou a réagi.';

FakeBackends _backends() => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    conversations: [FakeChat.conversation()],
    messages: [
      FakeChat.message(
        id: 'm1',
        createdAt: now.subtract(const Duration(minutes: 5)),
        content: _question,
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

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(ConversationPage)));

MessageInProgressRepository _inProgress(ProviderContainer container) =>
    MessageInProgressRepository(container.read(chatCacheProvider));

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
    container.read(replyProvider(FakeChat.conversationId).notifier).message =
        container.read(chatServiceProvider).message('m1');
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
}
