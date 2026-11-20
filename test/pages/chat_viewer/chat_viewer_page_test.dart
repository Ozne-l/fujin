import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        FakeAccessibilityFeatures,
        Finder,
        WidgetTester,
        addTearDown,
        find,
        testWidgets;
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:fujin/pages/chat_viewer/chat_viewer_page.dart';
import 'package:fujin/pages/chat_viewer/widgets/video_stage.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_zoom.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
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
const _androidTouchSlop = 8.0;

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

FakeBackends _backends(
  FakeChatJson message, {
  Map<String, List<int>> media = const {},
}) {
  final backends = FakeBackends(
    mealNames: [breakfast],
    chat: FakeChat(
      origin: chatMediaUri,
      clock: () => now,
      messages: [message],
    ),
  );
  backends.chatMedia.addAll(media);
  return backends;
}

Future<FakeBackends> _view(
  WidgetTester tester,
  FakeChatJson message, {
  FakeVideoPlayer? video,
  Map<String, List<int>> media = const {},
}) async {
  final backends = _backends(message, media: media);
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

List<int> _plate() => File('assets/dev_chat/plate.jpg').readAsBytesSync();

Map<String, List<int>> _loaded() {
  final plate = _plate();
  return {'bowl.jpg': plate, 'salad.jpg': plate};
}

Finder _photo() => find.descendant(
  of: find.byType(ChatViewerPage),
  matching: find.bySemanticsLabel('Photo'),
);

Future<void> _doubleTapAt(WidgetTester tester, Offset spot) async {
  await tester.tapAt(spot);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.tapAt(spot);
  await tester.pump();
}

Future<void> _frames(WidgetTester tester) async {
  for (var frame = 0; frame < 10; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
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

Finder _pages() => find.descendant(
  of: find.byType(ChatViewerPage),
  matching: find.byType(PageView),
);

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
      _pages(),
      const Offset(-300, 0),
      1000,
    );
    await _frames(tester);

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

    backends.chatMedia['bowl.jpg'] = _plate();
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

    await tester.tap(_pages());
    await tester.pump(const Duration(seconds: 1));

    check(_button(_pause).evaluate()).isEmpty();
    check(_button(_mute).evaluate()).isEmpty();
    check(_button('Fermer').evaluate()).isEmpty();

    await tester.tap(_pages());
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

  _testViewer('keeps the controls and shows no veil through a short buffer '
      'after a seek', (tester) async {
    final video = FakeVideoPlayer()..seekBuffer = Completer();
    await _view(tester, _video(), video: video);

    await tester.tap(find.byType(Slider));
    await tester.pump();
    await tester.pump(VideoStage.bufferingGrace ~/ 2);

    check(video.last.value.isBuffering).isTrue();
    check(_label(_loading).evaluate()).isEmpty();
    check(_button(_pause).evaluate()).length.equals(1);

    video.seekBuffer?.complete();
    await tester.pump();
    await tester.pump(VideoStage.bufferingGrace);

    check(_label(_loading).evaluate()).isEmpty();
    check(_button(_pause).evaluate()).length.equals(1);
  });

  _testViewer('veils a seek buffer that lasts and keeps the controls', (
    tester,
  ) async {
    final video = FakeVideoPlayer()..seekBuffer = Completer();
    await _view(tester, _video(), video: video);

    await tester.tap(find.byType(Slider));
    await tester.pump();
    await tester.pump(VideoStage.bufferingGrace);

    check(_label(_loading).evaluate()).length.equals(1);
    check(_button(_pause).evaluate()).length.equals(1);

    video.seekBuffer?.complete();
    await tester.pump();
    await tester.pump();

    check(_label(_loading).evaluate()).isEmpty();
    check(_button(_pause).evaluate()).length.equals(1);
  });

  _testViewer('shows the end of the video with its controls and no veil '
      'while the player still buffers, then plays it again from the start', (
    tester,
  ) async {
    final video = FakeVideoPlayer()..seekBuffer = Completer();
    await _view(tester, _video(), video: video);

    await video.last.complete();
    await tester.pump();
    await tester.pump(VideoStage.bufferingGrace * 2);

    check(video.last.value)
      ..has((value) => value.isCompleted, 'completed').isTrue()
      ..has((value) => value.isBuffering, 'buffering').isTrue();
    check(_label(_loading).evaluate()).isEmpty();
    check(find.text('0:42').evaluate()).length.equals(2);

    await tester.tap(_button(_play));
    await tester.pump();

    check(video.last.seeks).deepEquals([video.duration, Duration.zero]);
    check(video.last.value.isPlaying).isTrue();
  });

  _testViewer('pauses while the thumb is dragged and seeks once where it is '
      'let go, then plays on', (tester) async {
    final video = FakeVideoPlayer();
    await _view(tester, _video(), video: video);
    final slider = find.byType(Slider);

    final drag = await tester.startGesture(tester.getCenter(slider));
    await tester.pump();
    for (var step = 0; step < 10; step++) {
      await drag.moveBy(const Offset(10, 0));
      await tester.pump();
    }
    final dragged = Duration(
      milliseconds: tester.widget<Slider>(slider).value.round(),
    );

    check(video.last.value.isPlaying).isFalse();
    check(video.last.seeks).isEmpty();
    check(dragged).isGreaterThan(const Duration(seconds: 21));
    check(find.text(ChatText.clock(dragged)).evaluate()).length.equals(1);

    await drag.up();
    await tester.pump();

    check(video.last.seeks).deepEquals([dragged]);
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
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    check(find.byType(ChatViewerPage).evaluate()).isEmpty();
    check(video.last.disposed).isTrue();
  });

  _testViewer('opens a loaded photo of the thread in the viewer with a tap', (
    tester,
  ) async {
    await pumpFujin(tester, _backends(_photos(), media: _loaded()));
    await tester.tap(
      find.descendant(
        of: find.byType(TabPlate),
        matching: find.text('Messages'),
      ),
    );
    await tester.pumpAndSettle();
    await _settleFiles(tester);

    await tester.tap(find.byType(PhotoTile).first);
    await _frames(tester);

    check(_inViewer('1 sur 2 · hier, 09:13').evaluate()).length.equals(1);
  });

  _testViewer('closes the viewer when the photo is dragged down far enough '
      'with an Android touch slop', (tester) async {
    tester.view.gestureSettings = ui.GestureSettings(
      physicalTouchSlop: _androidTouchSlop * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetGestureSettings);
    await _view(tester, _photos(), media: _loaded());
    await _settleFiles(tester);

    await tester.timedDrag(
      _pages(),
      const Offset(0, 300),
      const Duration(seconds: 1),
    );
    await _frames(tester);

    check(find.byType(ChatViewerPage).evaluate()).isEmpty();
  });

  _testViewer('puts the photo back and stays open after a short drag down', (
    tester,
  ) async {
    await _view(tester, _photos(), media: _loaded());
    await _settleFiles(tester);
    final rest = tester.getRect(_photo());

    await tester.timedDrag(
      _pages(),
      const Offset(0, 60),
      const Duration(seconds: 1),
    );
    await _frames(tester);

    check(find.byType(ChatViewerPage).evaluate()).length.equals(1);
    check(tester.getRect(_photo())).equals(rest);
  });

  _testViewer('with reduced motion, puts the photo back at once after a short '
      'drag down', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(reduceMotion: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _view(tester, _photos(), media: _loaded());
    await _settleFiles(tester);
    final rest = tester.getRect(_photo());

    await tester.timedDrag(
      _pages(),
      const Offset(0, 60),
      const Duration(seconds: 1),
    );
    await tester.pump();

    check(tester.getRect(_photo())).equals(rest);
  });

  _testViewer('zooms the photo with a double-tap and pages no more until a '
      'second double-tap', (tester) async {
    await _view(tester, _photos(), media: _loaded());
    await _settleFiles(tester);
    final rest = tester.getRect(_photo());

    await _doubleTapAt(tester, rest.center);
    await _frames(tester);

    check(
      tester.getRect(_photo()).width,
    ).isCloseTo(rest.width * ViewerZoom.maxScale, 1);

    await tester.fling(_pages(), const Offset(-300, 0), 1000);
    await _frames(tester);

    check(_inViewer('1 sur 2 · hier, 09:13').evaluate()).length.equals(1);

    await _doubleTapAt(tester, rest.center);
    await _frames(tester);

    check(tester.getRect(_photo())).equals(rest);

    await tester.fling(_pages(), const Offset(-300, 0), 1000);
    await _frames(tester);

    check(_inViewer('2 sur 2 · hier, 09:13').evaluate()).length.equals(1);
  });

  _testViewer('skips ten seconds with a double-tap on the sides of the video, '
      'not in its middle', (tester) async {
    final video = FakeVideoPlayer();
    await _view(tester, _video(), video: video);
    final stage = tester.getRect(find.byType(VideoStage));

    await _doubleTapAt(tester, stage.centerRight - const Offset(20, 0));
    await tester.pump(const Duration(milliseconds: 100));

    check(video.last.seeks).deepEquals([const Duration(seconds: 10)]);
    check(_label('+10 s').evaluate()).length.equals(1);

    await _doubleTapAt(tester, stage.center);
    await tester.pump();

    check(video.last.seeks).length.equals(1);

    await _doubleTapAt(tester, stage.centerLeft + const Offset(20, 0));
    await tester.pump(const Duration(milliseconds: 100));

    check(video.last.seeks).length.equals(2);
    check(_label('−10 s').evaluate()).length.equals(1);

    await _frames(tester);

    check(_label('−10 s').evaluate()).isEmpty();
  });
}
