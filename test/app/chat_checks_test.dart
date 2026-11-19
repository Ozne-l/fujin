import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, find, testWidgets;
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/notifications/chat_notification.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../support/fake_backends.dart';
import '../support/fake_chat_notifications.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

const String _conversation = FakeChat.conversationId;

Future<void> _rereadChat(WidgetTester tester) async {
  await ProviderScope.containerOf(
    tester.element(find.byType(TabPlate)),
  ).read(chatServiceProvider).refresh();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the background checks run while the chat is available and '
      'stop, with its notifications, once it is not', (tester) async {
    final backends = FakeBackends(mealNames: [breakfast]);
    final notifications = FakeChatNotifications();
    await pumpFujin(tester, backends, chatNotifications: notifications);
    check(notifications.checking).isTrue();
    await notifications.show(
      const ChatNotification(conversationId: _conversation, messages: []),
    );

    backends.chat.owner = FakeChat.user(messaging: false);
    await _rereadChat(tester);

    check(notifications.checking).isFalse();
    check(notifications.shown).isEmpty();
    check(notifications.cancelled).deepEquals([_conversation]);
  });
}
