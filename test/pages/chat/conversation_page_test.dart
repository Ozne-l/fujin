import 'dart:async';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat/conversation_page.dart';
import 'package:fujin/pages/chat/reply_notifier.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_page.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_chat_notifications.dart';
import '../../support/fake_media_processor.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

const _coach = 'Nora Lindqvist';
const _cannotReply = 'Tu ne peux pas répondre dans cette conversation.';
const _hint = 'Message';
const _back = 'Retour';

FakeChatJson _text(
  String id,
  String content, {
  required Duration ago,
  String senderId = FakeChat.coachId,
}) => FakeChat.message(
  id: id,
  createdAt: now.subtract(ago),
  senderId: senderId,
  content: content,
);

FakeBackends _backends({
  List<FakeChatJson> messages = const [],
  bool canSend = true,
  bool protected = false,
}) => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    owner: FakeChat.user(screenCaptureProtection: protected),
    conversations: [FakeChat.conversation(canSend: canSend)],
    messages: messages,
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(
    find.descendant(of: find.byType(TabPlate), matching: find.text('Messages')),
  );
  await tester.pumpAndSettle();
}

Finder _visible(String text) => find.text(text).hitTestable();

bool _draftFocused(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus;

void main() {
  testWidgets('reads the thread by day, the coach on the left and mine on '
      'the right', (tester) async {
    await pumpFujin(
      tester,
      _backends(
        messages: [
          _text(
            'm1',
            'Comment s’est passée ta semaine ?',
            ago: const Duration(days: 1),
          ),
          _text(
            'm2',
            'Plutôt bien.',
            ago: const Duration(hours: 2),
            senderId: FakeChat.ownerId,
          ),
          FakeChat.message(
            id: 'm3',
            createdAt: now.subtract(const Duration(hours: 1)),
            type: 'poll',
          ),
        ],
      ),
    );

    await _open(tester);

    check(find.text(_coach).evaluate()).length.equals(1);
    final yesterday = tester.getCenter(find.text('Hier')).dy;
    final question = tester.getRect(
      find.text('Comment s’est passée ta semaine ?'),
    );
    final today = tester.getCenter(find.text('Aujourd’hui')).dy;
    final answer = tester.getRect(find.text('Plutôt bien.'));
    check(yesterday).isLessThan(question.top);
    check(question.bottom).isLessThan(today);
    check(today).isLessThan(answer.top);
    check(answer.right).isGreaterThan(question.right);
    check(
      find.text('Contenu à ouvrir dans Ekklo').evaluate(),
    ).length.equals(1);
    check(find.text(_hint).evaluate()).length.equals(1);
  });

  testWidgets('titles a quote of my message « Toi » and a quote of the '
      'coach with the coach’s name', (tester) async {
    await pumpFujin(
      tester,
      _backends(
        messages: [
          _text(
            'm1',
            'Plutôt bien.',
            ago: const Duration(hours: 3),
            senderId: FakeChat.ownerId,
          ),
          _text('m2', 'Pense à boire.', ago: const Duration(hours: 2)),
          FakeChat.message(
            id: 'm3',
            createdAt: now.subtract(const Duration(hours: 1)),
            content: 'Bravo !',
            replyTo: {
              'id': 'm1',
              'sender_id': FakeChat.ownerId,
              'sender_name': 'Sam Okafor',
              'content': 'Plutôt bien.',
              'message_type': 'text',
            },
          ),
          FakeChat.message(
            id: 'm4',
            createdAt: now.subtract(const Duration(minutes: 30)),
            senderId: FakeChat.ownerId,
            content: 'Promis.',
            replyTo: {
              'id': 'm2',
              'sender_id': FakeChat.coachId,
              'content': 'Pense à boire.',
              'message_type': 'text',
            },
          ),
        ],
      ),
    );

    await _open(tester);

    check(find.text('Toi').evaluate()).length.equals(1);
    check(find.text('Sam Okafor').evaluate()).isEmpty();
    check(find.text(_coach).evaluate()).length.equals(2);
  });

  testWidgets('keeps the keyboard on the draft when a reply starts and is '
      'cancelled', (tester) async {
    await pumpFujin(
      tester,
      _backends(
        messages: [_text('m1', 'Salut !', ago: const Duration(hours: 1))],
      ),
    );
    await _open(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ConversationPage)),
    );
    final replies = container.read(
      replyProvider(FakeChat.conversationId).notifier,
    );
    await tester.enterText(find.byType(TextField), 'Bonjour');
    await tester.pump();

    replies.message = container.read(chatServiceProvider).message('m1');
    await tester.pumpAndSettle();
    final replying = _draftFocused(tester);
    replies.cancel();
    await tester.pumpAndSettle();

    check(replying).isTrue();
    check(_draftFocused(tester)).isTrue();
    check(find.text('Bonjour').evaluate()).length.equals(1);
  });

  testWidgets('greys the send icon on iOS while the draft is empty', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await pumpFujin(tester, _backends());
    await _open(tester);
    final send = find.descendant(
      of: find.bySemanticsLabel('Envoyer'),
      matching: find.byType(SvgPicture),
    );

    final colour = switch (tester.widget<SvgPicture>(send).bytesLoader) {
      final SvgAssetLoader loader => loader.theme?.currentColor,
      _ => null,
    };
    final disabled = tester.element(send).colors.buttonDisabledText;
    debugDefaultTargetPlatformOverride = null;

    check(colour).equals(disabled);
  });

  testWidgets('says why there is no composer when the coach closed replies', (
    tester,
  ) async {
    await pumpFujin(tester, _backends(canSend: false));

    await _open(tester);

    check(find.text(_cannotReply).evaluate()).length.equals(1);
    check(find.text(_hint).evaluate()).isEmpty();
  });

  testWidgets('keeps the thread readable and hides the composer offline', (
    tester,
  ) async {
    final network = StreamController<bool>.broadcast();
    addTearDown(network.close);
    await pumpFujin(
      tester,
      _backends(
        messages: [_text('m1', 'Salut !', ago: const Duration(hours: 1))],
      ),
      connectivity: network.stream,
    );
    await _open(tester);

    network.add(false);
    await tester.pumpAndSettle();

    check(find.text('Pas de connexion').evaluate()).length.equals(1);
    check(find.text('Salut !').evaluate()).length.equals(1);
    check(find.text(_hint).evaluate()).isEmpty();
  });

  testWidgets('offers to sign in to Ekklo again when the session expired', (
    tester,
  ) async {
    final backends = _backends(
      messages: [_text('m1', 'Salut !', ago: const Duration(hours: 1))],
    );
    final tokens = await backends.ekkloTokenStore();
    await pumpFujin(tester, backends, ekklo: backends.ekkloWith(tokens));
    await _open(tester);

    await tokens.clear();
    await ProviderScope.containerOf(
      tester.element(find.byType(ConversationPage)),
    ).read(chatServiceProvider).refresh();
    await tester.pumpAndSettle();

    check(find.text('Ta session Ekklo a expiré.').evaluate()).length.equals(1);
    check(find.text('Salut !').evaluate()).length.equals(1);
    check(find.text(_hint).evaluate()).isEmpty();

    await tester.tap(find.text('Se reconnecter à Ekklo'));
    await tester.pumpAndSettle();
    check(find.byType(EkkloSignInPage).evaluate()).length.equals(1);
  });

  testWidgets('loads the older page when the top of the thread is reached', (
    tester,
  ) async {
    const total = EkkloMessaging.pageSize + 10;
    await pumpFujin(
      tester,
      _backends(
        messages: [
          for (var index = 1; index <= total; index++)
            _text(
              'm$index',
              'Message n°$index',
              ago: Duration(minutes: total - index),
            ),
        ],
      ),
    );
    await _open(tester);
    check(find.text('Message n°1').evaluate()).isEmpty();

    for (var swipe = 0; swipe < total; swipe++) {
      if (_visible('Message n°1').evaluate().isNotEmpty) break;
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pump(const Duration(milliseconds: 500));
    }

    check(_visible('Message n°1').evaluate()).length.equals(1);
  });

  testWidgets('blocks screen captures while a protected conversation is '
      'open', (tester) async {
    final media = FakeMediaProcessor();
    await pumpFujin(tester, _backends(protected: true), mediaProcessor: media);

    await _open(tester);
    check(media.secure).isTrue();

    await tester.tap(find.byTooltip(_back));
    await tester.pumpAndSettle();
    check(media.secure).isFalse();
  });

  testWidgets('leaves screen captures allowed for an unprotected '
      'conversation', (tester) async {
    final media = FakeMediaProcessor();
    await pumpFujin(tester, _backends(), mediaProcessor: media);

    await _open(tester);

    check(media.secure).isFalse();
  });

  testWidgets('asks for notifications and clears the conversation’s on '
      'opening', (tester) async {
    final notifications = FakeChatNotifications();
    await pumpFujin(tester, _backends(), chatNotifications: notifications);

    await _open(tester);

    check(notifications.permissionRequests).equals(1);
    check(notifications.cancelled).deepEquals([FakeChat.conversationId]);
  });

  testWidgets('goes back to the journal from a conversation opened by a '
      'notification at launch', (tester) async {
    await pumpFujin(
      tester,
      _backends(
        messages: [_text('m1', 'Salut !', ago: const Duration(hours: 1))],
      ),
      chatNotifications: FakeChatNotifications(
        launchConversation: FakeChat.conversationId,
      ),
    );
    check(find.text('Salut !').evaluate()).length.equals(1);

    await tester.tap(find.byTooltip(_back));
    await tester.pumpAndSettle();

    check(find.byType(ConversationPage).evaluate()).isEmpty();
    check(find.text(breakfast).evaluate()).isNotEmpty();
  });

  testWidgets('fits my bubble to a single photo sent with a caption', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      _backends(
        messages: [
          FakeChat.message(
            id: 'm1',
            createdAt: now.subtract(const Duration(hours: 1)),
            senderId: FakeChat.ownerId,
            type: 'image',
            content: 'Mon dîner',
            mediaUrls: ['${chatMediaUri.resolve('/media/dinner.jpg')}'],
          ),
        ],
      ),
    );

    await _open(tester);

    final photo = tester.getRect(find.byType(PhotoTile));
    final bubble = tester.getRect(
      find.ancestor(
        of: find.byType(PhotoTile),
        matching: find.byType(ChatBubble),
      ),
    );
    check(bubble.right - photo.right).equals(photo.left - bubble.left);
  });

  testWidgets(
    'offers neither media nor voice messages on iOS',
    (tester) async {
      await pumpFujin(tester, _backends());

      await _open(tester);

      check(find.bySemanticsLabel('Médias').evaluate()).isEmpty();
      check(find.bySemanticsLabel('Message vocal').evaluate()).isEmpty();
      check(find.bySemanticsLabel('Envoyer').evaluate()).length.equals(1);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets('quotes a deleted message as deleted', (tester) async {
    await pumpFujin(
      tester,
      _backends(
        messages: [
          FakeChat.message(
            id: 'm2',
            createdAt: now.subtract(const Duration(hours: 1)),
            content: 'Je l’ai vu avant.',
            replyTo: {
              'id': 'm1',
              'sender_id': FakeChat.ownerId,
              'message_type': 'text',
              'deleted': true,
            },
          ),
        ],
      ),
    );

    await _open(tester);

    check(find.text('Message supprimé').evaluate()).length.equals(1);
  });
}
