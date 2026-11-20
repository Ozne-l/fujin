import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat/widgets/chat_composer.dart';
import 'package:fujin/pages/common/fujin_switch.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../test/support/fake_backends.dart';
import '../test/support/fake_video_player.dart';
import '../test/support/fixtures.dart';
import '../test/support/pump_fujin.dart';

enum _Scenario {
  tabSwitch,
  sendReview,
  journalScroll,
  settingsSwitch,
  chatThread,
}

const _rounds = 3;
const _entriesPerMeal = 6;
const _journal = 'Journal';
const _settings = 'Réglages';
const _slide = Duration(milliseconds: 600);
const _flingDistance = 1200.0;
const _flingSpeed = 2400.0;
const _messages = 60;
const _photoEvery = 12;
const _reactionEvery = 7;
const _plate = 'plate.jpg';
const _squat = 'squat.mp4';
const _frame = Duration(milliseconds: 16);
const _settleFrames = 60;
const _send = 'Envoyer';

final List<MfpFoodEntry> _day = [
  for (var index = 0; index < _entriesPerMeal; index++) ...[
    entry('B-$index'),
    entry('L-$index', food: rice, meal: lunch, unit: cup),
    entry(
      'S-$index',
      food: skyr,
      description: 'Skyr nature',
      brand: 'Isey',
      meal: snacks,
      servingValue: 250,
      nutrients: nutrients(kcal: 160, protein: 25, carbs: 10, fat: 0.5),
    ),
  ],
];

FakeBackends _backends() => FakeBackends(
  mealNames: [breakfast, lunch, snacks],
  entries: _day,
  ekkloSearches: {
    'skyr': [isey, siggis],
  },
);

FakeChatJson _chatMessage(int index) {
  final createdAt = now.subtract(Duration(minutes: (_messages - index) * 7));
  final senderId = index.isEven ? FakeChat.coachId : FakeChat.ownerId;
  final reactions = [
    if (index % _reactionEvery == 0) FakeChat.reaction('👍', mine: index.isOdd),
  ];
  return switch (index) {
    _ when index == _messages ~/ 2 => FakeChat.message(
      id: 'm-$index',
      createdAt: createdAt,
      senderId: senderId,
      type: 'video',
      content: 'Ta descente au squat',
      mediaUrls: ['$chatMediaUri${FakeChat.mediaPath}$_squat'],
    ),
    _ when index % _photoEvery == 0 => FakeChat.message(
      id: 'm-$index',
      createdAt: createdAt,
      senderId: senderId,
      type: 'image',
      content: 'Mon assiette $index',
      mediaUrls: ['$chatMediaUri${FakeChat.mediaPath}$_plate'],
      reactions: reactions,
    ),
    _ => FakeChat.message(
      id: 'm-$index',
      createdAt: createdAt,
      senderId: senderId,
      content: index % 3 == 0
          ? 'Message $index\nAvec une deuxième ligne pour la bulle.'
          : 'Message $index',
      reactions: reactions,
    ),
  };
}

Future<FakeBackends> _chatBackends() async {
  final chat = FakeChat(
    origin: chatMediaUri,
    clock: () => now,
    messages: [
      for (var index = 1; index < _messages; index++) _chatMessage(index),
    ],
  );
  chat.messages.add(
    FakeChat.message(
      id: 'm-$_messages',
      createdAt: now.subtract(const Duration(minutes: 1)),
      content: 'Je réponds à ta question',
      replyTo: chat.replyTo('m-${_messages - 3}'),
      reactions: [FakeChat.reaction('❤️', count: 2)],
    ),
  );
  final backends = FakeBackends(mealNames: [breakfast], chat: chat);
  for (final name in const [_plate, _squat]) {
    final bytes = await rootBundle.load('assets/dev_chat/$name');
    backends.chatMedia[name] = bytes.buffer.asUint8List();
  }
  return backends;
}

Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < _settleFrames; frame++) {
    await tester.pump(_frame);
  }
}

Future<void> _openMessages(WidgetTester tester) async {
  await tester.tap(_tab('Messages'));
  await _settle(tester);
}

Future<void> _chatRound(WidgetTester tester, int round) async {
  final centre = _screenCentre(tester);
  for (final direction in const [1, -1]) {
    await tester.flingFrom(
      centre,
      Offset(0, direction * _flingDistance),
      _flingSpeed,
    );
    await _settle(tester);
  }
  final text = 'Envoi $round\nSur deux lignes\net une troisième';
  await tester.enterText(
    find.descendant(
      of: find.byType(ChatComposer),
      matching: find.byType(TextField),
    ),
    text,
  );
  await _settle(tester);
  await tester.tap(find.bySemanticsLabel(_send).last);
  await _settle(tester);
  await tester.longPress(find.text(text).last);
  await _settle(tester);
  await tester.tapAt(const Offset(10, 10));
  await _settle(tester);
}

Finder _tab(String label) => find.descendant(
  of: find.byType(TabPlate),
  matching: find.text(label),
);

Offset _screenCentre(WidgetTester tester) =>
    (tester.view.physicalSize / tester.view.devicePixelRatio).center(
      Offset.zero,
    );

Future<void> _slideTab(WidgetTester tester, String from, String to) async {
  final start = tester.getCenter(_tab(from));
  await tester.timedDragFrom(start, tester.getCenter(_tab(to)) - start, _slide);
  await tester.pumpAndSettle();
}

Future<void> _flingDownAndUp(WidgetTester tester) async {
  final centre = _screenCentre(tester);
  await tester.flingFrom(centre, const Offset(0, -_flingDistance), _flingSpeed);
  await tester.pumpAndSettle();
  await tester.flingFrom(centre, const Offset(0, _flingDistance), _flingSpeed);
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(_tab(_settings));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byType(FujinSwitch));
  await tester.pumpAndSettle();
}

Future<void> _toggleSwitch(WidgetTester tester) async {
  final centre = tester.getCenter(find.byType(FujinSwitch));
  for (final direction in const [1, -1]) {
    await tester.timedDragFrom(
      centre,
      Offset(direction * FujinSize.switchWidth, 0),
      _slide,
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _reviewAndBack(WidgetTester tester) async {
  await tester.tap(find.text('Envoyer ${_day.length} aliments vers Ekklo'));
  await tester.pumpAndSettle();
  await _flingDownAndUp(tester);
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;

  Future<void> measure(
    _Scenario scenario,
    Future<void> Function() round,
  ) async {
    await round();
    await binding.traceAction(() async {
      for (var index = 0; index < _rounds; index++) {
        await round();
      }
    }, reportKey: scenario.name);
  }

  testWidgets('switches tabs with the lens over the tab plate', (tester) async {
    await pumpFujin(tester, _backends());
    await measure(_Scenario.tabSwitch, () async {
      await _slideTab(tester, _journal, _settings);
      await _slideTab(tester, _settings, _journal);
    });
  });

  testWidgets('opens and scrolls the send review', (tester) async {
    await pumpFujin(tester, _backends());
    await measure(_Scenario.sendReview, () => _reviewAndBack(tester));
  });

  testWidgets('scrolls the journal under its blurred header', (tester) async {
    await pumpFujin(tester, _backends());
    await measure(_Scenario.journalScroll, () => _flingDownAndUp(tester));
  });

  testWidgets('slides a settings switch on and off', (tester) async {
    await pumpFujin(tester, _backends());
    await _openSettings(tester);
    await measure(_Scenario.settingsSwitch, () => _toggleSwitch(tester));
  });

  testWidgets('scrolls, sends and long-presses in the chat', (tester) async {
    binding.testTextInput.register();
    addTearDown(binding.testTextInput.unregister);
    await pumpFujin(
      tester,
      await _chatBackends(),
      urlVideo: FakeVideoPlayer(),
    );
    await _openMessages(tester);
    var round = 0;
    await measure(_Scenario.chatThread, () => _chatRound(tester, round++));
  });
}
