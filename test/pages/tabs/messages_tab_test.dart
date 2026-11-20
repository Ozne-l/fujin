import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show Finder, WidgetTester, find, testWidgets;
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

const _messages = 'Messages';
const _settings = 'Réglages';
const _accounts = 'COMPTES';
const _coach = 'Nora Lindqvist';

FakeBackends _backends({int unread = 0, bool messaging = true}) => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    owner: FakeChat.user(messaging: messaging),
    conversations: [FakeChat.conversation(unreadCount: unread)],
  ),
);

Finder _inPlate(String text) =>
    find.descendant(of: find.byType(TabPlate), matching: find.text(text));

List<String> _labels(WidgetTester tester) =>
    [
      for (final label in ['Journal', 'Mémoire', _messages, _settings])
        if (_inPlate(label).evaluate().isNotEmpty) label,
    ]..sort(
      (a, b) => tester
          .getCenter(_inPlate(a))
          .dx
          .compareTo(
            tester.getCenter(_inPlate(b)).dx,
          ),
    );

Future<void> _rereadChat(WidgetTester tester) async {
  await ProviderScope.containerOf(
    tester.element(find.byType(TabPlate)),
  ).read(chatServiceProvider).refresh();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows Messages before Réglages when the chat is on', (
    tester,
  ) async {
    await pumpFujin(tester, _backends());

    check(
      _labels(tester),
    ).deepEquals(['Journal', 'Mémoire', _messages, _settings]);
  });

  testWidgets('keeps three tabs when the coach turned messaging off', (
    tester,
  ) async {
    await pumpFujin(tester, _backends(messaging: false));

    check(_labels(tester)).deepEquals(['Journal', 'Mémoire', _settings]);
  });

  testWidgets('badges the unread count', (tester) async {
    await pumpFujin(tester, _backends(unread: 3));

    check(_inPlate('3').evaluate()).length.equals(1);
    check(
      find.bySemanticsLabel('Messages, 3 non lus').evaluate(),
    ).length.equals(1);
  });

  testWidgets('badges 9+ past nine unread messages', (tester) async {
    await pumpFujin(tester, _backends(unread: 12));

    check(_inPlate('9+').evaluate()).length.equals(1);
    check(
      find.bySemanticsLabel('Messages, 12 non lus').evaluate(),
    ).length.equals(1);
  });

  testWidgets('shows no badge when everything is read', (tester) async {
    await pumpFujin(tester, _backends());

    check(_inPlate('0').evaluate()).isEmpty();
    check(find.bySemanticsLabel(RegExp('non lu')).evaluate()).isEmpty();
  });

  testWidgets('opens the conversation over the tab and comes back to it', (
    tester,
  ) async {
    await pumpFujin(tester, _backends());
    await tester.tap(_inPlate(_settings));
    await tester.pumpAndSettle();

    await tester.tap(_inPlate(_messages));
    await tester.pumpAndSettle();
    check(find.text(_coach).evaluate()).length.equals(1);

    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();
    check(find.text(_coach).evaluate()).isEmpty();
    check(find.text(_accounts).evaluate()).length.equals(1);
  });

  testWidgets('keeps the open tab when Messages comes and goes', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await tester.tap(_inPlate(_settings));
    await tester.pumpAndSettle();

    backends.chat.owner = FakeChat.user(messaging: false);
    await _rereadChat(tester);
    check(_labels(tester)).deepEquals(['Journal', 'Mémoire', _settings]);
    check(find.text(_accounts).evaluate()).length.equals(1);

    backends.chat.owner = FakeChat.user();
    await _rereadChat(tester);
    check(
      _labels(tester),
    ).deepEquals(['Journal', 'Mémoire', _messages, _settings]);
    check(find.text(_accounts).evaluate()).length.equals(1);
  });
}
