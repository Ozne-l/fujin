import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show Finder, WidgetTester, find, testWidgets;
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat_viewer/chat_viewer_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_video_player.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

const _bowl = 'Essaie ce bol au déjeuner, 45 g de protéines.';
const _descent = 'Regarde la descente : le dos reste droit jusqu’en bas.';
const _loading = 'Chargement de la vidéo';
const _notLoaded = 'Vidéo pas chargée';
const _retry = 'Réessayer';
const _pause = 'Pause';
const _play = 'Lire';
const _mute = 'Couper le son';
const _unmute = 'Remettre le son';

DateTime _at(int daysAgo, int hour, int minute) {
  final today = now.toLocal();
  return DateTime(today.year, today.month, today.day - daysAgo, hour, minute);
}

String _media(String name) => '${chatMediaUri.resolve('/media/$name')}';

FakeChatJson _photos() => FakeChat.message(
  id: 'photos',
  createdAt: _at(1, 9, 13),
  type: 'image',
  content: _bowl,
  mediaUrls: [_media('bowl.jpg'), _media('salad.jpg')],
);

FakeChatJson _video() => FakeChat.message(
  id: 'video',
  createdAt: _at(0, 18, 52),
  type: 'video',
  content: _descent,
  mediaUrls: [_media('descent.mp4')],
);

Future<FakeBackends> _view(
  WidgetTester tester,
  FakeChatJson message, {
  FakeVideoPlayer? video,
}) async {
  final backends = FakeBackends(
    mealNames: [breakfast],
    chat: FakeChat(
      origin: chatMediaUri,
      clock: () => now,
      messages: [message],
    ),
  );
  await pumpFujin(tester, backends, urlVideo: video);
  unawaited(
    ProviderScope.containerOf(tester.element(find.byType(FujinApp)))
        .read(routerProvider)
        .push(
          FujinRoute.chatMedia.forMedia(
            FakeChat.conversationId,
            '${message['id']}',
            index: 0,
          ),
        ),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  return backends;
}

Future<void> _settleFiles(WidgetTester tester) async {
  for (var turn = 0; turn < 10; turn++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Finder _label(String label) => find.bySemanticsLabel(label);

Finder _button(String tooltip) => find.byTooltip(tooltip).hitTestable();

Finder _inViewer(String text) =>
    find.descendant(of: find.byType(ChatViewerPage), matching: find.text(text));

void _testViewer(
  String description,
  Future<void> Function(WidgetTester tester) body,
) => testWidgets(description, (tester) async {
  final semantics = tester.ensureSemantics();
  await body(tester);
  semantics.dispose();
});

void main() {
  _testViewer('pages through the photos of a message with their place, '
      'date and caption', (tester) async {
    await _view(tester, _photos());

    check(_inViewer('Nora Lindqvist').evaluate()).length.equals(1);
    check(_inViewer('1 sur 2 · hier, 09:13').evaluate()).length.equals(1);
    check(_inViewer(_bowl).evaluate()).length.equals(1);

    await tester.fling(
      find.byType(PageView),
      const Offset(-300, 0),
      1000,
    );
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    check(_inViewer('2 sur 2 · hier, 09:13').evaluate()).length.equals(1);
    check(_inViewer(_bowl).evaluate()).length.equals(1);
  });

  _testViewer('shows the photo once loading it again succeeds', (
    tester,
  ) async {
    final backends = await _view(tester, _photos());
    await _settleFiles(tester);
    final photo = find.descendant(
      of: find.byType(ChatViewerPage),
      matching: find.byType(Image),
    );

    check(photo.evaluate()).isEmpty();
    check(_inViewer(_retry).evaluate()).length.equals(1);

    backends.chatMedia['bowl.jpg'] = File(
      'assets/dev_chat/plate.jpg',
    ).readAsBytesSync();
    await tester.tap(_inViewer(_retry));
    await tester.pump();
    await _settleFiles(tester);

    check(_inViewer(_retry).evaluate()).isEmpty();
    check(photo.evaluate()).length.equals(1);
  });

  _testViewer('veils the video until it plays, then plays it with its sound', (
    tester,
  ) async {
    final video = FakeVideoPlayer()..gate = Completer();

    await _view(tester, _video(), video: video);

    check(_inViewer('Aujourd’hui, 18:52').evaluate()).length.equals(1);
    check(_inViewer(_descent).evaluate()).length.equals(1);
    check(_label(_loading).evaluate()).length.equals(1);
    check(_button(_pause).evaluate()).isEmpty();

    video.gate?.complete();
    await tester.pump();
    await tester.pump();

    check(_label(_loading).evaluate()).isEmpty();
    check(video.last.value)
      ..has((value) => value.isPlaying, 'playing').isTrue()
      ..has((value) => value.volume, 'volume').equals(1);
    check(_button(_pause).evaluate()).length.equals(1);
    check(find.text('0:42').evaluate()).length.equals(1);
  });

  _testViewer('shows and hides the controls with a tap on the video', (
    tester,
  ) async {
    await _view(tester, _video());

    check(_button(_pause).evaluate()).length.equals(1);

    await tester.tap(find.byType(PageView));
    await tester.pump(const Duration(seconds: 1));

    check(_button(_pause).evaluate()).isEmpty();
    check(_button(_mute).evaluate()).isEmpty();
    check(_button('Fermer').evaluate()).isEmpty();

    await tester.tap(find.byType(PageView));
    await tester.pump(const Duration(seconds: 1));

    check(_button(_pause).evaluate()).length.equals(1);
    check(_button('Fermer').evaluate()).length.equals(1);
  });

  _testViewer('pauses and plays again from the controls', (tester) async {
    final video = FakeVideoPlayer();
    await _view(tester, _video(), video: video);

    await tester.tap(_button(_pause));
    await tester.pump();

    check(video.last.value.isPlaying).isFalse();
    check(_button(_play).evaluate()).length.equals(1);

    await tester.tap(_button(_play));
    await tester.pump();

    check(video.last.value.isPlaying).isTrue();
  });

  _testViewer('says the video did not load and loads it again on retry', (
    tester,
  ) async {
    final video = FakeVideoPlayer(failures: 1);

    await _view(tester, _video(), video: video);

    check(_inViewer(_notLoaded).evaluate()).length.equals(1);
    check(_button(_pause).evaluate()).isEmpty();

    await tester.tap(_inViewer(_retry));
    await tester.pump();
    await tester.pump();

    check(_inViewer(_notLoaded).evaluate()).isEmpty();
    check(video.controllers).length.equals(2);
    check(video.controllers.first.disposed).isTrue();
    check(video.last.value.isPlaying).isTrue();
    check(_button(_pause).evaluate()).length.equals(1);
  });

  _testViewer('cuts the sound and puts it back', (tester) async {
    final video = FakeVideoPlayer();
    await _view(tester, _video(), video: video);

    await tester.tap(_button(_mute));
    await tester.pump();

    check(video.last.value.volume).equals(0);
    check(_button(_unmute).evaluate()).length.equals(1);

    await tester.tap(_button(_unmute));
    await tester.pump();

    check(video.last.value.volume).equals(1);
    check(_button(_mute).evaluate()).length.equals(1);
  });

  _testViewer('stops the video when the viewer closes', (tester) async {
    final video = FakeVideoPlayer();
    await _view(tester, _video(), video: video);

    await tester.tap(_button('Fermer'));
    await tester.pump(const Duration(seconds: 1));

    check(find.byType(ChatViewerPage).evaluate()).isEmpty();
    check(video.last.disposed).isTrue();
  });
}
