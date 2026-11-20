import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

const _question = 'Tu as bien dormi ?';
const _answer = 'Plutôt bien.';
const _arrival = 'Pense à boire.';
const _frame = Duration(milliseconds: 16);
const _midway = Duration(milliseconds: 100);
final _jump = RegExp('^Aller aux derniers messages');

FakeChatJson _text(
  String id,
  String content, {
  Duration ago = const Duration(hours: 1),
  String senderId = FakeChat.coachId,
  Map<String, Object?>? replyTo,
}) => FakeChat.message(
  id: id,
  createdAt: now.subtract(ago),
  senderId: senderId,
  content: content,
  replyTo: replyTo,
);

List<FakeChatJson> _many(int total) => [
  for (var index = 1; index <= total; index++)
    _text('m$index', 'Message n°$index', ago: Duration(minutes: total - index)),
];

FakeBackends _backends(List<FakeChatJson> messages) => FakeBackends(
  mealNames: [breakfast],
  chat: FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    conversations: [FakeChat.conversation()],
    messages: messages,
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(
    find.descendant(of: find.byType(TabPlate), matching: find.text('Messages')),
  );
  await tester.pumpAndSettle();
}

Future<void> _send(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pump();
  await tester.tap(find.bySemanticsLabel('Envoyer'));
  await tester.pump();
}

Finder _built(String text) => find.text(text, skipOffstage: false);

double _opacity(WidgetTester tester, String text) => tester
    .widgetList<Opacity>(
      find.ancestor(
        of: _built(text),
        matching: find.byType(Opacity, skipOffstage: false),
      ),
    )
    .fold(1, (opacity, widget) => opacity * widget.opacity);

Finder _visible(String text) => find.text(text).hitTestable();

void _reduceMotion(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

void main() {
  testWidgets('slides a new coach message up into the bottom of the thread', (
    tester,
  ) async {
    final backends = _backends([
      _text('m1', _question),
      _text('m2', _answer, senderId: FakeChat.ownerId),
    ]);
    await pumpFujin(tester, backends);
    await _open(tester);

    backends.chat.deliver(_text('m3', _arrival, ago: Duration.zero));
    await tester.pump();
    await tester.pump(_midway);
    final rising = tester.getTopLeft(find.text(_arrival)).dy;
    final fading = _opacity(tester, _arrival);
    await tester.pumpAndSettle();

    check(fading).isLessThan(1);
    check(rising).isGreaterThan(tester.getTopLeft(find.text(_arrival)).dy);
    check(_opacity(tester, _arrival)).equals(1);
  });

  testWidgets('flies my sent text from the composer into its bubble', (
    tester,
  ) async {
    await pumpFujin(tester, _backends([_text('m1', _question)]));
    await _open(tester);

    await _send(tester, _answer);
    await tester.pump(_frame);
    await tester.pump(_midway);
    check(_built(_answer).evaluate()).length.equals(2);

    await tester.pumpAndSettle();
    check(_built(_answer).evaluate()).length.equals(1);
    check(_visible(_answer).evaluate()).length.equals(1);
  });

  testWidgets('keeps my flying text on one plain line all the way', (
    tester,
  ) async {
    const sent = 'T shirt dress';
    await pumpFujin(tester, _backends([_text('m1', _question)]));
    await _open(tester);

    await _send(tester, sent);
    final lines = <int>{};
    final decorations = <TextDecoration?>{};
    for (var step = 0; step < 20; step++) {
      await tester.pump(_frame);
      for (final paragraph in tester.renderObjectList<RenderParagraph>(
        _built(sent),
      )) {
        lines.add(
          paragraph
              .getBoxesForSelection(
                const TextSelection(baseOffset: 0, extentOffset: sent.length),
              )
              .map((box) => box.top.round())
              .toSet()
              .length,
        );
        decorations.add(paragraph.text.style?.decoration);
      }
    }

    check(lines).deepEquals({1});
    check(
      decorations,
    ).not((it) => it.contains(TextDecoration.underline));
  });

  testWidgets('goes back down to my message when I send while scrolled up', (
    tester,
  ) async {
    await pumpFujin(tester, _backends(_many(40)));
    await _open(tester);
    await tester.drag(find.byType(ListView), const Offset(0, 1500));
    await tester.pumpAndSettle();
    check(_visible('Message n°40').evaluate()).isEmpty();

    await _send(tester, _answer);
    await tester.pumpAndSettle();

    check(_visible(_answer).evaluate()).length.equals(1);
    check(find.bySemanticsLabel(_jump).evaluate()).isEmpty();
  });

  testWidgets('under reduced motion, shows my sent text without a flight', (
    tester,
  ) async {
    _reduceMotion(tester);
    await pumpFujin(tester, _backends([_text('m1', _question)]));
    await _open(tester);

    await _send(tester, _answer);
    await tester.pump(_frame);
    await tester.pump(_midway);

    check(_built(_answer).evaluate()).length.equals(1);
  });

  testWidgets('shows an older page at once when the top is reached', (
    tester,
  ) async {
    const total = EkkloMessaging.pageSize + 10;
    await pumpFujin(tester, _backends(_many(total)));
    await _open(tester);
    const older = 'Message n°10';

    double? shown;
    for (var swipe = 0; swipe < total && shown == null; swipe++) {
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      for (var step = 0; step < 30 && shown == null; step++) {
        await tester.pump(_frame);
        if (_built(older).evaluate().isNotEmpty) {
          shown = _opacity(tester, older);
        }
      }
    }

    check(shown).equals(1);
  });

  testWidgets('offers the latest messages once scrolled a screen up, counts '
      'the coach’s new ones and goes back down on tap', (tester) async {
    final backends = _backends(_many(40));
    await pumpFujin(tester, backends);
    await _open(tester);
    check(find.bySemanticsLabel(_jump).evaluate()).isEmpty();

    await tester.drag(find.byType(ListView), const Offset(0, 1500));
    await tester.pumpAndSettle();
    check(find.bySemanticsLabel(_jump).evaluate()).length.equals(1);

    backends.chat.deliver(_text('m41', _arrival, ago: Duration.zero));
    await tester.pumpAndSettle();
    check(find.text('1').evaluate()).length.equals(1);
    check(_visible(_arrival).evaluate()).isEmpty();

    await tester.tap(find.bySemanticsLabel(_jump));
    await tester.pumpAndSettle();

    check(_visible(_arrival).evaluate()).length.equals(1);
    check(find.bySemanticsLabel(_jump).evaluate()).isEmpty();
  });

  testWidgets('brings the quoted message into view when its quote is tapped', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      _backends([
        ..._many(40),
        _text(
          'm41',
          _arrival,
          ago: Duration.zero,
          replyTo: {
            'id': 'm1',
            'sender_id': FakeChat.coachId,
            'content': 'Message n°1',
            'message_type': 'text',
          },
        ),
      ]),
    );
    await _open(tester);
    check(_visible('Message n°40').evaluate()).isNotEmpty();

    await tester.tap(find.text('Message n°1'));
    await tester.pumpAndSettle();

    check(_visible('Message n°1').evaluate()).isNotEmpty();
    check(_visible('Message n°40').evaluate()).isEmpty();
  });

  testWidgets('folds a deleted message away before it leaves the thread', (
    tester,
  ) async {
    final backends = _backends([
      _text('m1', _question),
      _text('m2', _answer, senderId: FakeChat.ownerId),
    ]);
    await pumpFujin(tester, backends);
    await _open(tester);

    backends.chat.delete('m1');
    await tester.pump();
    await tester.pump(_frame);
    await tester.pump(_midway);
    check(find.text(_question).evaluate()).length.equals(1);
    check(_opacity(tester, _question)).isLessThan(1);

    await tester.pumpAndSettle();
    check(find.text(_question).evaluate()).isEmpty();
  });

  testWidgets('leaves out a message deleted while scrolled out of view', (
    tester,
  ) async {
    final backends = _backends(_many(40));
    await pumpFujin(tester, backends);
    await _open(tester);
    await tester.drag(find.byType(ListView), const Offset(0, 1500));
    await tester.pumpAndSettle();
    check(_built('Message n°40').evaluate()).isEmpty();

    backends.chat.delete('m40');
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();

    check(_built('Message n°40').evaluate()).isEmpty();
    check(_visible('Message n°39').evaluate()).length.equals(1);
  });

  testWidgets('under reduced motion, places a new message without sliding '
      'and removes a deleted one at once', (tester) async {
    _reduceMotion(tester);
    final backends = _backends([
      _text('m1', _question),
      _text('m2', _answer, senderId: FakeChat.ownerId),
    ]);
    await pumpFujin(tester, backends);
    await _open(tester);

    backends.chat.deliver(_text('m3', _arrival, ago: Duration.zero));
    await tester.pump();
    await tester.pump(_frame);
    final placed = tester.getTopLeft(find.text(_arrival)).dy;
    await tester.pumpAndSettle();
    check(tester.getTopLeft(find.text(_arrival)).dy).equals(placed);

    backends.chat.delete('m1');
    await tester.pump();
    await tester.pump(_frame);
    check(find.text(_question).evaluate()).isEmpty();
  });
}
