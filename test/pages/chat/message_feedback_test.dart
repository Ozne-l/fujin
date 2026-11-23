import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/haptic.dart';
import '../../support/pump_fujin.dart';

const _send = 'Envoyer';
const _sending = 'Envoi…';
const _notSent = 'Non envoyé.';
const _seen = 'Vu';
const _postText =
    'POST /api/v1/messaging/conversations/${FakeChat.conversationId}/messages';

FakeChatJson _text(String id, String senderId, Duration ago) =>
    FakeChat.message(
      id: id,
      createdAt: now.subtract(ago),
      senderId: senderId,
      content: id,
    );

FakeBackends _backends() => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    conversations: [FakeChat.conversation()],
    messages: [
      _text('question', FakeChat.coachId, const Duration(hours: 3)),
      _text('first', FakeChat.ownerId, const Duration(hours: 2)),
      _text('second', FakeChat.ownerId, const Duration(hours: 1)),
    ],
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(
    find.descendant(of: find.byType(TabPlate), matching: find.text('Messages')),
  );
  await tester.pumpAndSettle();
}

Future<void> _sendRefused(
  WidgetTester tester,
  FakeBackends backends, {
  required bool slowly,
}) async {
  backends.refusedChatCalls.add(_postText);
  final gate = Completer<void>();
  if (slowly) backends.chatGates[_postText] = gate;
  await tester.enterText(find.byType(TextField), 'Oui, 8 heures.');
  await tester.pump();
  await tester.tap(find.bySemanticsLabel(_send));
  await _pumpUntil(tester, _sending);
  gate.complete();
  await _pumpUntil(tester, _notSent);
}

Future<void> _pumpUntil(WidgetTester tester, String text) async {
  for (var frame = 0; frame < 30; frame++) {
    if (find.text(text).evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  testWidgets('reads « Vu » under my last message once the coach reads it', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _open(tester);
    check(find.text(_seen).evaluate()).isEmpty();

    backends.chat.announce('message_read', {
      'conversation_id': FakeChat.conversationId,
      'message_id': 'second',
      'user_id': FakeChat.coachId,
    });
    await tester.pumpAndSettle();

    check(find.text(_seen).evaluate()).length.equals(1);
    check(
      tester.getTopLeft(find.text(_seen)).dy,
    ).isGreaterThan(tester.getTopLeft(find.text('second')).dy);
  });

  for (final (moment, slowly) in [
    ('at once', false),
    ('after « Envoi… »', true),
  ]) {
    testWidgets('a text refused $moment buzzes once', (tester) async {
      final haptics = Haptic.record(tester);
      final backends = _backends();
      await pumpFujin(tester, backends);
      await _open(tester);

      await _sendRefused(tester, backends, slowly: slowly);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 40));
      await tester.pumpAndSettle();

      check(find.text(_notSent).evaluate()).length.equals(1);
      check(haptics.where((type) => type == Haptic.error)).length.equals(1);
    });
  }

  testWidgets('a text refused after « Envoi… » shakes its status', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _open(tester);

    await _sendRefused(tester, backends, slowly: true);
    final positions = <double>{};
    for (var frame = 0; frame < 20; frame++) {
      positions.add(tester.getTopLeft(find.text(_notSent)).dx);
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pumpAndSettle();

    check(positions.length).isGreaterThan(1);
    check(
      tester.getTopLeft(find.text(_notSent)).dx,
    ).equals(positions.first);
  });

  testWidgets('a text that fails stays still with reduced motion', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final haptics = Haptic.record(tester);
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _open(tester);

    await _sendRefused(tester, backends, slowly: true);
    final positions = <double>{};
    for (var frame = 0; frame < 20; frame++) {
      positions.add(tester.getTopLeft(find.text(_notSent)).dx);
      await tester.pump(const Duration(milliseconds: 16));
    }

    check(positions).length.equals(1);
    check(haptics.where((type) => type == Haptic.error)).length.equals(1);
  });
}
