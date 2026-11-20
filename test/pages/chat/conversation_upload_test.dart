import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/media/picked_media.dart';
import 'package:fujin/pages/chat/conversation_page.dart';
import 'package:fujin/pages/chat/reply_notifier.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_media_picker.dart';
import '../../support/fake_media_uploader.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

const _presignCall = 'POST /api/v1/uploads/presigned-url';
const _waiting = 'En attente du réseau';
const _sending = 'Envoi ·';

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _sendWhileSpinning(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Envoyer'));
  await _spin(tester);
}

Future<void> _spin(WidgetTester tester) async {
  for (var frame = 0; frame < 20; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('an upload waiting for the network says so, then shows its '
      'progress again once back online', (tester) async {
    final network = StreamController<bool>.broadcast();
    addTearDown(network.close);
    final backends = FakeBackends(
      chat: FakeChat(
        origin: chatMediaUri,
        clock: () => now,
        conversations: [FakeChat.conversation()],
      ),
    )..lostChatCalls.add(_presignCall);
    final picker = FakeMediaPicker()
      ..chosen = [
        const PickedPhoto('/picked/meal.jpg', width: 4000, height: 3000),
      ];
    final uploader = FakeMediaUploader();
    await pumpFujin(
      tester,
      backends,
      connectivity: network.stream,
      mediaPicker: picker,
      mediaUploader: uploader,
    );
    await _tap(
      tester,
      find.descendant(
        of: find.byType(TabPlate),
        matching: find.text('Messages'),
      ),
    );

    await _tap(tester, find.bySemanticsLabel('Médias'));
    await _tap(tester, find.text('Photos et vidéos'));
    await _sendWhileSpinning(tester);

    check(find.text(_waiting).evaluate()).length.equals(1);
    check(find.textContaining(_sending).evaluate()).isEmpty();

    backends.lostChatCalls.clear();
    network.add(false);
    await _spin(tester);
    network.add(true);
    await _spin(tester);

    check(uploader.orders).length.equals(1);
    check(find.text(_waiting).evaluate()).isEmpty();
    check(find.textContaining(_sending).evaluate()).length.equals(1);
  });

  testWidgets('titles the quote of my own message « Toi » while it uploads', (
    tester,
  ) async {
    final backends = FakeBackends(
      chat: FakeChat(
        origin: chatMediaUri,
        clock: () => now,
        conversations: [FakeChat.conversation()],
        messages: [
          FakeChat.message(
            id: 'm1',
            createdAt: now.subtract(const Duration(hours: 1)),
            senderId: FakeChat.ownerId,
            content: 'Voici mon repas.',
          ),
        ],
      ),
    )..lostChatCalls.add(_presignCall);
    final picker = FakeMediaPicker()
      ..chosen = [
        const PickedPhoto('/picked/meal.jpg', width: 4000, height: 3000),
      ];
    await pumpFujin(
      tester,
      backends,
      mediaPicker: picker,
      mediaUploader: FakeMediaUploader(),
    );
    await _tap(
      tester,
      find.descendant(
        of: find.byType(TabPlate),
        matching: find.text('Messages'),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ConversationPage)),
    );
    container.read(replyProvider(FakeChat.conversationId).notifier).message =
        container.read(chatServiceProvider).message('m1');
    await tester.pumpAndSettle();

    await _tap(tester, find.bySemanticsLabel('Médias'));
    await _tap(tester, find.text('Photos et vidéos'));
    await _sendWhileSpinning(tester);

    check(find.text(_waiting).evaluate()).length.equals(1);
    check(find.text('Toi').evaluate()).length.equals(1);
  });
}
