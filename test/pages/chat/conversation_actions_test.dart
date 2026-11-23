import 'dart:async';
import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:flutter/gestures.dart'
    show kDoubleTapTimeout, kLongPressTimeout;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat/widgets/emoji_sheet.dart';
import 'package:fujin/pages/chat/widgets/message_gestures.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/haptic.dart';
import '../../support/pump_fujin.dart';

const _coach = 'Nora Lindqvist';
const _hint = 'Message';
const _send = 'Envoyer';
const _conversationPath =
    '/api/v1/messaging/conversations/${FakeChat.conversationId}';
const _postText = 'POST $_conversationPath/messages';
const _question = 'Tu as bien dormi ?';
const _answer = 'Plutôt bien.';
const _quickTap = Duration(milliseconds: 100);

FakeChatJson _text(
  String id,
  String content, {
  String senderId = FakeChat.coachId,
  List<FakeChatJson> reactions = const [],
}) => FakeChat.message(
  id: id,
  createdAt: now.subtract(const Duration(hours: 1)),
  senderId: senderId,
  content: content,
  reactions: reactions,
);

FakeBackends _backends({
  List<FakeChatJson>? messages,
  int unreadCount = 0,
}) => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    conversations: [FakeChat.conversation(unreadCount: unreadCount)],
    messages:
        messages ??
        [
          _text('m1', _question),
          _text('m2', _answer, senderId: FakeChat.ownerId),
        ],
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(
    find.descendant(of: find.byType(TabPlate), matching: find.text('Messages')),
  );
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pump();
  await tester.tap(find.bySemanticsLabel(_send));
  await tester.pump();
}

Future<void> _longPress(WidgetTester tester, String text) async {
  await tester.longPress(find.text(text));
  await tester.pumpAndSettle();
}

Map<String, Object?> _lastBody(FakeBackends backends, String call) =>
    switch (jsonDecode(
      backends.requests
          .lastWhere((request) => FakeBackends.chatCall(request) == call)
          .body,
    )) {
      final Map<String, Object?> body => body,
      _ => const {},
    };

int _count(FakeBackends backends, String call) => backends.requests
    .where((request) => FakeBackends.chatCall(request) == call)
    .length;

Finder _bubble(String text) => find.ancestor(
  of: find.text(text),
  matching: find.byType(MessageGestures),
);

bool _draftFocused(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus;

double _opacity(WidgetTester tester, String text) => tester
    .widget<FadeTransition>(
      find
          .ancestor(of: find.text(text), matching: find.byType(FadeTransition))
          .first,
    )
    .opacity
    .value;

void main() {
  group('a text', () {
    testWidgets('reads « Envoi… » until Ekklo answers, then its time', (
      tester,
    ) async {
      final backends = _backends();
      final gate = backends.chatGates[_postText] = Completer();
      await pumpFujin(tester, backends);
      await _open(tester);

      await _type(tester, 'Oui, 8 heures.');

      check(find.text('Envoi…').evaluate()).length.equals(1);
      check(find.text('Oui, 8 heures.').evaluate()).length.equals(1);
      check(find.text(_hint).evaluate()).length.equals(1);
      gate.complete();
      await tester.pumpAndSettle();

      check(find.text('Envoi…').evaluate()).isEmpty();
      check(find.text('Oui, 8 heures.').evaluate()).length.equals(1);
      check(backends.chat.messages.last['content']).equals('Oui, 8 heures.');
    });

    testWidgets('reads « Non envoyé. » and goes out on « Réessayer »', (
      tester,
    ) async {
      final backends = _backends()..refusedChatCalls.add(_postText);
      await pumpFujin(tester, backends);
      await _open(tester);

      await _type(tester, 'Oui, 8 heures.');
      await tester.pumpAndSettle();
      check(find.text('Non envoyé.').evaluate()).length.equals(1);
      check(_count(backends, _postText)).equals(1);

      backends.refusedChatCalls.clear();
      await tester.tap(find.text('Réessayer'));
      await tester.pumpAndSettle();

      check(find.text('Non envoyé.').evaluate()).isEmpty();
      check(find.text('Oui, 8 heures.').evaluate()).length.equals(1);
      check(_count(backends, _postText)).equals(2);
    });

    testWidgets('leaves no failed bubble when its lost answer had arrived', (
      tester,
    ) async {
      final backends = _backends()..lostChatCalls.add(_postText);
      await pumpFujin(tester, backends);
      await _open(tester);

      await _type(tester, 'Oui, 8 heures.');
      await tester.pumpAndSettle();

      check(find.text('Réessayer').evaluate()).isEmpty();
      check(_count(backends, _postText)).equals(1);
      check(find.text('Oui, 8 heures.').evaluate()).length.equals(1);
      check(find.text('Non envoyé.').evaluate()).isEmpty();
    });
  });

  group('a reply', () {
    testWidgets('starts from « Répondre » and sends the quoted message', (
      tester,
    ) async {
      final backends = _backends();
      await pumpFujin(tester, backends);
      await _open(tester);

      await _longPress(tester, _question);
      await tester.tap(find.text('Répondre'));
      await tester.pumpAndSettle();
      check(find.text('Réponse à $_coach').evaluate()).length.equals(1);

      await _type(tester, 'Oui, 8 heures.');
      await tester.pumpAndSettle();

      check(_lastBody(backends, _postText)['reply_to_id']).equals('m1');
      check(find.text('Réponse à $_coach').evaluate()).isEmpty();
    });

    testWidgets('starts from « Répondre » under a message taller than the '
        'screen', (tester) async {
      final long = [
        for (var line = 1; line <= 40; line++) 'Ligne $line du programme.',
      ].join('\n');
      await pumpFujin(tester, _backends(messages: [_text('m1', long)]));
      await _open(tester);

      await tester.longPressAt(
        tester.getBottomLeft(find.text(long)) + const Offset(20, -20),
      );
      await tester.pumpAndSettle();
      check(find.text('Répondre').hitTestable().evaluate()).length.equals(1);
      await tester.tap(find.text('Répondre'));
      await tester.pumpAndSettle();

      check(find.text('Réponse à $_coach').evaluate()).length.equals(1);
    });

    testWidgets('to my own message reads « Réponse à toi » and cancels', (
      tester,
    ) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _answer);
      await tester.tap(find.text('Répondre'));
      await tester.pumpAndSettle();
      check(find.text('Réponse à toi').evaluate()).length.equals(1);

      await tester.tap(find.byTooltip('Annuler la réponse'));
      await tester.pumpAndSettle();

      check(find.text('Réponse à toi').evaluate()).isEmpty();
    });

    testWidgets('starts when a swipe passes 64 px and lets go, with one '
        'haptic tick', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);
      final haptics = Haptic.record(tester);
      const below = MessageGestures.trigger - 14;
      const past = MessageGestures.trigger + 16;

      await tester.drag(_bubble(_question), const Offset(below, 0));
      await tester.pumpAndSettle();
      check(find.text('Réponse à $_coach').evaluate()).isEmpty();
      check(haptics).isEmpty();

      await tester.drag(_bubble(_question), const Offset(-past, 0));
      await tester.pumpAndSettle();
      check(find.text('Réponse à $_coach').evaluate()).isEmpty();

      await tester.drag(_bubble(_question), const Offset(past, 0));
      await tester.pumpAndSettle();
      check(find.text('Réponse à $_coach').evaluate()).length.equals(1);
      check(haptics).deepEquals([Haptic.threshold]);
      check(_draftFocused(tester)).isTrue();

      await tester.drag(_bubble(_answer), const Offset(-past, 0));
      await tester.pumpAndSettle();
      check(find.text('Réponse à toi').evaluate()).length.equals(1);
    });

    testWidgets('does not start from a drag that goes mostly down', (
      tester,
    ) async {
      await pumpFujin(tester, _backends());
      await _open(tester);
      final haptics = Haptic.record(tester);

      await tester.drag(
        _bubble(_question),
        const Offset(MessageGestures.trigger + 16, 120),
      );
      await tester.pumpAndSettle();

      check(find.text('Réponse à $_coach').evaluate()).isEmpty();
      check(haptics).isEmpty();
    });

    testWidgets('card fades in under the composer', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await tester.drag(
        _bubble(_question),
        const Offset(MessageGestures.trigger + 16, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final arriving = _opacity(tester, 'Réponse à $_coach');
      await tester.pumpAndSettle();

      check(arriving).isLessThan(1);
      check(_opacity(tester, 'Réponse à $_coach')).equals(1);
    });

    testWidgets('with reduced motion, the swiped bubble is back at once', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpFujin(tester, _backends());
      await _open(tester);
      final resting = tester.getTopLeft(find.text(_question).first).dx;

      await tester.drag(
        _bubble(_question),
        const Offset(MessageGestures.trigger + 16, 0),
      );
      await tester.pump();

      check(tester.getTopLeft(find.text(_question).first).dx).equals(resting);
      check(find.text('Réponse à $_coach').evaluate()).length.equals(1);
    });
  });

  group('a reaction', () {
    testWidgets('shows on the message at once', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _question);
      await tester.tap(find.text('❤️'));
      await tester.pumpAndSettle();

      check(find.text('❤️').evaluate()).length.equals(1);
      check(find.text('1').evaluate()).length.equals(1);
    });

    testWidgets('is taken back with « Réaction pas envoyée » when Ekklo '
        'refuses it', (tester) async {
      final backends = _backends()
        ..refusedChatCalls.add('POST $_conversationPath/messages/m1/reactions');
      await pumpFujin(tester, backends);
      await _open(tester);

      await _longPress(tester, _question);
      await tester.tap(find.text('😮'));
      await tester.pumpAndSettle();

      check(find.text('Réaction pas envoyée').evaluate()).length.equals(1);
      check(find.text('😮').evaluate()).isEmpty();
    });

    testWidgets('of mine goes away when its chip is touched', (tester) async {
      final backends = _backends(
        messages: [
          _text(
            'm1',
            _question,
            reactions: [FakeChat.reaction('👍', mine: true)],
          ),
        ],
      );
      await pumpFujin(tester, backends);
      await _open(tester);

      await tester.tap(find.text('👍'));
      await tester.pumpAndSettle();

      check(find.text('👍').evaluate()).isEmpty();
      check(
        _count(backends, 'DELETE $_conversationPath/messages/m1/reactions'),
      ).equals(1);
    });

    testWidgets('of a heart comes from a double tap on the message', (
      tester,
    ) async {
      final backends = _backends();
      await pumpFujin(tester, backends);
      await _open(tester);

      await tester.tap(find.text(_question));
      await tester.pump(_quickTap);
      await tester.tap(find.text(_question));
      await tester.pumpAndSettle();

      check(find.text('❤️').evaluate()).length.equals(1);
      check(
        _lastBody(backends, 'POST $_conversationPath/messages/m1/reactions'),
      ).deepEquals({'emoji': '❤️'});
    });

    testWidgets('of my heart goes away with a double tap on the message', (
      tester,
    ) async {
      final backends = _backends(
        messages: [
          _text(
            'm1',
            _question,
            reactions: [FakeChat.reaction('❤️', mine: true)],
          ),
        ],
      );
      await pumpFujin(tester, backends);
      await _open(tester);

      await tester.tap(find.text(_question));
      await tester.pump(_quickTap);
      await tester.tap(find.text(_question));
      await tester.pumpAndSettle();

      check(find.text('❤️').evaluate()).isEmpty();
      check(
        _count(backends, 'DELETE $_conversationPath/messages/m1/reactions'),
      ).equals(1);
    });

    testWidgets('does not come from two slow taps', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await tester.tap(find.text(_question));
      await tester.pump(kDoubleTapTimeout * 2);
      await tester.tap(find.text(_question));
      await tester.pumpAndSettle();

      check(find.text('❤️').evaluate()).isEmpty();
    });

    testWidgets('can be any emoji from « Autre emoji »', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _question);
      await tester.tap(find.bySemanticsLabel('Autre emoji'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: find.byType(EmojiSheet), matching: find.text('🐵')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: find.byType(EmojiSheet), matching: find.text('🐶')),
      );
      await tester.pumpAndSettle();

      check(find.byType(EmojiSheet).evaluate()).isEmpty();
      check(find.text('🐶').evaluate()).length.equals(1);
    });
  });

  group('the long press', () {
    testWidgets('offers « Supprimer » on my messages only', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _question);
      check(find.text('Répondre').evaluate()).length.equals(1);
      check(find.text('Supprimer').evaluate()).isEmpty();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await _longPress(tester, _answer);
      check(find.text('Supprimer').evaluate()).length.equals(1);
    });

    testWidgets('reacts with the emoji the finger slides to and lets go on', (
      tester,
    ) async {
      await pumpFujin(tester, _backends());
      await _open(tester);
      final haptics = Haptic.record(tester);

      final finger = await tester.startGesture(
        tester.getCenter(find.text(_question)),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      await finger.moveTo(tester.getCenter(find.text('😮')));
      await tester.pump();
      await finger.up();
      await tester.pumpAndSettle();

      check(find.text('Répondre').evaluate()).isEmpty();
      check(find.text('😮').evaluate()).length.equals(1);
      check(find.text('1').evaluate()).length.equals(1);
      check(haptics).contains(Haptic.select);
    });

    testWidgets('stays open when the finger lets go off the emojis', (
      tester,
    ) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      final finger = await tester.startGesture(
        tester.getCenter(find.text(_question)),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      await finger.moveBy(const Offset(0, 20));
      await finger.up();
      await tester.pumpAndSettle();

      check(find.text('Répondre').evaluate()).length.equals(1);
      check(find.text('😮').evaluate()).length.equals(1);
    });

    testWidgets('folds back before it is gone', (tester) async {
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _question);
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      check(find.text('Répondre').evaluate()).length.equals(1);

      await tester.pumpAndSettle();
      check(find.text('Répondre').evaluate()).isEmpty();
    });

    testWidgets('with reduced motion, is gone at once', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _question);
      check(find.text('Répondre').evaluate()).length.equals(1);
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await tester.pump();

      check(find.text('Répondre').evaluate()).isEmpty();
    });

    testWidgets('with reduced motion, a reaction shows without a flight', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpFujin(tester, _backends());
      await _open(tester);

      await _longPress(tester, _question);
      await tester.tap(find.text('👍'));
      await tester.pump();
      await tester.pump();

      check(find.text('👍').evaluate()).length.equals(1);
    });
  });

  group('deleting', () {
    testWidgets('asks first, reads « Suppression… », then removes it', (
      tester,
    ) async {
      final backends = _backends();
      final gate = backends.chatGates['DELETE $_conversationPath/messages/m2'] =
          Completer();
      await pumpFujin(tester, backends);
      await _open(tester);

      await _longPress(tester, _answer);
      await tester.tap(find.text('Supprimer'));
      await tester.pumpAndSettle();
      check(find.text('Supprimer ce message ?').evaluate()).length.equals(1);
      check(
        find
            .text(
              '« $_answer » Il sera retiré de la conversation, chez toi et '
              'chez $_coach.',
            )
            .evaluate(),
      ).length.equals(1);

      await tester.tap(find.text('Supprimer').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      check(find.text('Suppression…').evaluate()).length.equals(1);
      gate.complete();
      await tester.pumpAndSettle();

      check(find.text(_answer).evaluate()).isEmpty();
      check(find.text('Suppression…').evaluate()).isEmpty();
    });

    testWidgets('keeps a media message Ekklo refuses to delete', (
      tester,
    ) async {
      final backends = _backends(
        messages: [
          FakeChat.message(
            id: 'm3',
            createdAt: now.subtract(const Duration(hours: 1)),
            senderId: FakeChat.ownerId,
            type: 'image',
            content: 'Mon assiette',
            mediaUrls: [
              '$chatMediaUri/media/a.jpg',
              '$chatMediaUri/media/b.jpg',
            ],
          ),
        ],
      );
      await pumpFujin(tester, backends);
      await _open(tester);

      await _longPress(tester, 'Mon assiette');
      await tester.tap(find.text('Supprimer'));
      await tester.pumpAndSettle();
      check(
        find
            .textContaining('« 2 photos » Il sera retiré de la conversation')
            .evaluate(),
      ).length.equals(1);
      await tester.tap(find.text('Supprimer').last);
      await tester.pumpAndSettle();

      check(find.text('Pas supprimé dans Ekklo').evaluate()).length.equals(1);
      check(
        find.text('Ekklo ne supprime pas encore les médias').evaluate(),
      ).length.equals(1);
      check(find.text('Réessayer').evaluate()).isEmpty();
      check(find.text('Mon assiette').evaluate()).length.equals(1);
    });
  });

  testWidgets('marks the conversation read when it opens with unread '
      'messages', (tester) async {
    final backends = _backends(unreadCount: 2);
    await pumpFujin(tester, backends);

    await _open(tester);

    check(_count(backends, 'POST $_conversationPath/read')).equals(1);
    check(backends.chat.conversations.single['unread_count']).equals(0);
  });
}
