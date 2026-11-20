import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, find, testWidgets;
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../support/fake_backends.dart';
import '../support/fake_chat_notifications.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

const String _conversation = FakeChat.conversationId;
const _settings = 'Réglages';
const _accounts = 'COMPTES';
const _coach = 'Nora Lindqvist';
const _back = 'Retour';
const _message = 'message-1';

String _location(WidgetTester tester) => ProviderScope.containerOf(
  tester.element(find.byType(FujinApp)),
).read(routerProvider).state.uri.path;

void main() {
  testWidgets('a notification that launched Fūjin opens its conversation', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      chatNotifications: FakeChatNotifications(
        launchConversation: _conversation,
      ),
    );

    check(
      _location(tester),
    ).equals(FujinRoute.conversation.forConversation(_conversation));
  });

  testWidgets('a notification tapped while Fūjin runs opens its '
      'conversation over the current tab', (tester) async {
    final notifications = FakeChatNotifications();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      chatNotifications: notifications,
    );
    check(_location(tester)).equals(FujinRoute.journal.path);

    notifications.open(_conversation);
    await tester.pumpAndSettle();

    check(
      _location(tester),
    ).equals(FujinRoute.conversation.forConversation(_conversation));
  });

  testWidgets('a notification for the conversation on screen leaves it '
      'as it is, so one Retour lands on the opening tab', (tester) async {
    final notifications = FakeChatNotifications();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      chatNotifications: notifications,
    );
    await tester.tap(find.text(_settings));
    await tester.pumpAndSettle();
    notifications.open(_conversation);
    await tester.pumpAndSettle();

    notifications.open(_conversation);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(_back));
    await tester.pumpAndSettle();

    check(find.text(_coach).evaluate()).isEmpty();
    check(find.text(_accounts).evaluate()).length.equals(1);
  });

  testWidgets('a notification for the conversation under its media viewer '
      'stacks no second conversation', (tester) async {
    final notifications = FakeChatNotifications();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      chatNotifications: notifications,
    );
    final router = ProviderScope.containerOf(
      tester.element(find.byType(FujinApp)),
    ).read(routerProvider);
    await tester.tap(find.text(_settings));
    await tester.pumpAndSettle();
    notifications.open(_conversation);
    await tester.pumpAndSettle();
    unawaited(
      router.push(
        FujinRoute.chatMedia.forMedia(_conversation, _message, index: 0),
      ),
    );
    await tester.pumpAndSettle();

    notifications.open(_conversation);
    await tester.pumpAndSettle();
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(_back));
    await tester.pumpAndSettle();

    check(find.text(_coach).evaluate()).isEmpty();
    check(find.text(_accounts).evaluate()).length.equals(1);
  });
}
