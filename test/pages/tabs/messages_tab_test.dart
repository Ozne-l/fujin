import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        FakeAccessibilityFeatures,
        Finder,
        WidgetTester,
        addTearDown,
        find,
        testWidgets;
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
const _popFrames = 40;
const _popFrame = Duration(milliseconds: 16);
const _openingFrames = 30;
const _openingFrame = Duration(milliseconds: 50);
const _arrivalFrames = 20;
const _arrivalFrame = Duration(milliseconds: 1);
const _reconnection = Duration(milliseconds: 50);

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

double _width(WidgetTester tester, String text) =>
    tester.getRect(_inPlate(text)).width;

Future<void> _shows(WidgetTester tester, String text) async {
  for (
    var frame = 0;
    frame < _arrivalFrames && _inPlate(text).evaluate().isEmpty;
    frame++
  ) {
    await tester.pump(_arrivalFrame);
  }
}

Future<void> _coachWrites(
  WidgetTester tester,
  FakeBackends backends,
  String id,
) async {
  backends.chat.deliver(FakeChat.message(id: id, createdAt: now));
  await tester.pump();
}

Future<void> _readElsewhere(
  WidgetTester tester,
  FakeBackends backends, {
  required int leaving,
}) async {
  backends.chat.conversations.first['unread_count'] = leaving;
  await tester.runAsync(() async {
    backends.dropSockets();
    await Future<void>.delayed(_reconnection);
  });
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(_reconnection));
}

Future<double> _swell(WidgetTester tester, String text) async {
  await _shows(tester, text);
  var widest = _width(tester, text);
  for (var frame = 0; frame < _popFrames; frame++) {
    await tester.pump(_popFrame);
    widest = math.max(widest, _width(tester, text));
  }
  await tester.pumpAndSettle();
  return widest / _width(tester, text);
}

void _reduceMotion(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

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

  testWidgets('shows the badge of an opening at rest', (tester) async {
    await pumpFujin(tester, _backends(unread: 3), settle: false);
    final widths = <double>[];
    for (var frame = 0; frame < _openingFrames; frame++) {
      await tester.pump(_openingFrame);
      if (_inPlate('3').evaluate().isNotEmpty) widths.add(_width(tester, '3'));
    }
    await tester.pumpAndSettle();

    check(widths).isNotEmpty();
    check(widths.toSet()).deepEquals({_width(tester, '3')});
  });

  testWidgets('pops the badge when the unread count rises, not when it '
      'falls', (tester) async {
    final backends = _backends(unread: 1);
    await pumpFujin(tester, backends);

    await _coachWrites(tester, backends, 'm-1');
    check(await _swell(tester, '2')).isGreaterThan(1.05);

    await _readElsewhere(tester, backends, leaving: 1);
    check(await _swell(tester, '1')).equals(1);
  });

  testWidgets('grows a badge from nothing when a first message comes in', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);

    await _coachWrites(tester, backends, 'm-1');
    await _shows(tester, '1');
    final first = _width(tester, '1');
    await tester.pumpAndSettle();
    check(first).isLessThan(_width(tester, '1'));
  });

  testWidgets('changes the count at once when the phone asks for less '
      'motion', (tester) async {
    _reduceMotion(tester);
    final backends = _backends(unread: 1);
    await pumpFujin(tester, backends);

    await _coachWrites(tester, backends, 'm-1');
    check(await _swell(tester, '2')).equals(1);
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
