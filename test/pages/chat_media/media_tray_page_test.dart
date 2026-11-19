import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        FakeViewPadding,
        Finder,
        WidgetTester,
        addTearDown,
        find,
        group,
        testWidgets;
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/media/video_probe.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/domain/chat/edit/photo_edit.dart';
import 'package:fujin/pages/chat_media/media_menu_anchor.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';
import 'package:fujin/pages/chat_media/media_scratch.dart';
import 'package:fujin/pages/chat_media/photo_editor_page.dart';
import 'package:fujin/pages/chat_media/picked_media.dart';
import 'package:fujin/pages/chat_media/video_editor_page.dart';
import 'package:fujin/pages/chat_media/widgets/crop_overlay.dart';
import 'package:fujin/pages/chat_media/widgets/crop_stage.dart';
import 'package:fujin/pages/chat_media/widgets/cropped_picture.dart';
import 'package:fujin/pages/chat_media/widgets/video_timeline.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_media_picker.dart';
import '../../support/fake_media_processor.dart';
import '../../support/pump_fujin.dart';

const _coach = 'Thomas Leroy';
const _open = 'Ouvrir les médias';
const _send = 'Envoyer';
const _close = 'Fermer';
const _reply = MediaReply(
  messageId: 'm-1',
  title: 'Réponse à Thomas Leroy',
  excerpt: 'Envoie-moi la vidéo de ta dernière série.',
  mine: false,
);
const _clip = '/picked/clip.mp4';
const _gestureZone = 32.0;
const _phone = Size(390, 844);

PickedPhoto _photo(int index) => _photoAt('/picked/photo-$index.jpg');

PickedPhoto _photoAt(String path) =>
    PickedPhoto(path, width: 4000, height: 3000);

List<File> _copies(int count) {
  final directory = Directory.systemTemp.createTempSync('fujin_tray_');
  addTearDown(() => directory.deleteSync(recursive: true));
  return [
    for (var index = 0; index < count; index++)
      File('${directory.path}/photo-$index.jpg')..writeAsStringSync(''),
  ];
}

final class _Host {
  final sent = <MediaSend>[];
  final picker = FakeMediaPicker();
  final processor = FakeMediaProcessor()
    ..probes[_clip] = const VideoProbe(
      uprightWidth: 1920,
      uprightHeight: 1080,
      rotation: 0,
      duration: Duration(seconds: 42),
      hdr: false,
    );

  Future<void> pump(WidgetTester tester, {MediaReply? reply}) async {
    await pumpFujin(
      tester,
      FakeBackends(),
      mediaPicker: picker,
      mediaProcessor: processor,
    );
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: Center(
                child: MediaMenuAnchor(
                  coach: _coach,
                  reply: reply,
                  onSend: sent.add,
                  builder: (context, open) =>
                      TextButton(onPressed: open, child: const Text(_open)),
                ),
              ),
            ),
          ),
        );
    await tester.pumpAndSettle();
  }

  Future<void> pickFromGallery(
    WidgetTester tester,
    List<PickedMedia> media,
  ) async {
    picker.chosen = media;
    await tester.tap(find.text(_open));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Photos et vidéos'));
    await tester.pumpAndSettle();
  }
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('the media menu', () {
    testWidgets('opens the tray with what the gallery gave, ten at most', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);

      await host.pickFromGallery(tester, [_photo(1), _photo(2)]);

      check(host.picker.galleryLimits).deepEquals([MediaSend.maximumMedia]);
      check(find.text('2 médias').evaluate()).length.equals(1);
      check(find.text('Pour $_coach').evaluate()).length.equals(1);
    });

    testWidgets('stays on the conversation when the camera is cancelled', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);

      await _tap(tester, find.text(_open));
      await _tap(tester, find.text('Prendre une photo'));

      check(find.text(_open).hitTestable().evaluate()).length.equals(1);
      check(find.text('Pour $_coach').evaluate()).isEmpty();
    });

    testWidgets('opens the tray with the photo just taken', (tester) async {
      final host = _Host()..picker.shot = _photo(1);
      await host.pump(tester);

      await _tap(tester, find.text(_open));
      await _tap(tester, find.text('Prendre une photo'));

      check(find.text('1 média').evaluate()).length.equals(1);
    });

    testWidgets('opens the tray with the video just filmed', (tester) async {
      final host = _Host()..picker.filmed = const PickedVideo(_clip);
      await host.pump(tester);

      await _tap(tester, find.text(_open));
      await _tap(tester, find.text('Filmer une vidéo'));

      check(find.text('1 média').evaluate()).length.equals(1);
      check(find.text('0:42').evaluate()).length.equals(1);
    });

    testWidgets('reopens the tray with media the system kept for Fūjin', (
      tester,
    ) async {
      final host = _Host()..picker.lostMedia = [_photo(1)];

      await host.pump(tester);

      check(find.text('1 média').evaluate()).length.equals(1);
    });
  });

  group('the tray', () {
    testWidgets('sends the media, the trimmed caption and the reply', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester, reply: _reply);
      await host.pickFromGallery(tester, [_photo(1), _photo(2)]);

      await tester.enterText(find.byType(TextField), '  Ma dernière série  ');
      await _tap(tester, find.byTooltip(_send));

      final sent = host.sent.single;
      check(sent.caption).equals('Ma dernière série');
      check(sent.replyToId).equals('m-1');
      check(
        sent.media.map((media) => media.path),
      ).deepEquals(['/picked/photo-1.jpg', '/picked/photo-2.jpg']);
      check(find.text(_open).hitTestable().evaluate()).length.equals(1);
    });

    testWidgets('sends without the reply once it is cancelled', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester, reply: _reply);
      await host.pickFromGallery(tester, [_photo(1)]);

      check(find.text('Réponse à Thomas Leroy').evaluate()).length.equals(1);
      await _tap(tester, find.byTooltip('Annuler la réponse'));
      await _tap(tester, find.byTooltip(_send));

      check(host.sent.single.replyToId).isNull();
    });

    testWidgets('keeps ten media and says it is the maximum', (tester) async {
      final host = _Host();
      await host.pump(tester);

      await host.pickFromGallery(tester, [
        for (var index = 0; index < 12; index++) _photo(index),
      ]);

      check(find.text('10 médias').evaluate()).length.equals(1);
      check(
        find.text('10 médias au maximum par message.').evaluate(),
      ).length.equals(1);
      check(find.bySemanticsLabel('Ajouter des médias').evaluate()).isEmpty();
    });

    testWidgets('leaves out a video it cannot read', (tester) async {
      final host = _Host();
      await host.pump(tester);

      await host.pickFromGallery(tester, [
        _photo(1),
        const PickedVideo('/picked/broken.mp4'),
      ]);

      check(find.text('1 média').evaluate()).length.equals(1);
    });

    testWidgets('closes when its last medium is removed', (tester) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);

      await _tap(tester, find.bySemanticsLabel('Retirer'));

      check(find.text(_open).hitTestable().evaluate()).length.equals(1);
      check(host.sent).isEmpty();
    });

    testWidgets('deletes the copy of a removed medium, keeps the others', (
      tester,
    ) async {
      final copies = _copies(2);
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [
        for (final copy in copies) _photoAt(copy.path),
      ]);

      await _tap(tester, find.bySemanticsLabel('Retirer').first);

      check(copies.first.existsSync()).isFalse();
      check(copies.last.existsSync()).isTrue();
      check(find.text('1 média').evaluate()).length.equals(1);
    });

    testWidgets('deletes every picked copy when the media are dropped', (
      tester,
    ) async {
      final copies = _copies(2);
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [
        for (final copy in copies) _photoAt(copy.path),
      ]);
      await tester.enterText(find.byType(TextField), 'Ma série');

      await _tap(tester, find.byTooltip(_close));
      await _tap(tester, find.text('Abandonner'));

      check(copies.where((copy) => copy.existsSync())).isEmpty();
      check(host.sent).isEmpty();
    });

    testWidgets('empties its scratch folder once closed', (tester) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);
      final cache = ProviderScope.containerOf(
        tester.element(find.byType(Navigator).first),
      ).read(appCacheDirectoryProvider);
      final path = await tester.runAsync(
        () => MediaScratch(cache).frame(_clip, Duration.zero, 1),
      );
      final frame = File('$path')..writeAsStringSync('');

      await _tap(tester, find.byTooltip(_close));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );

      check(frame.existsSync()).isFalse();
      check(MediaScratch(cache).folder.existsSync()).isFalse();
    });

    testWidgets('closes at once when nothing was changed', (tester) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);

      await _tap(tester, find.byTooltip(_close));

      check(find.text('Abandonner ces médias ?').evaluate()).isEmpty();
      check(find.text(_open).hitTestable().evaluate()).length.equals(1);
    });

    testWidgets('asks before dropping a caption, and keeps it on Garder', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);
      await tester.enterText(find.byType(TextField), 'Ma série');

      await _tap(tester, find.byTooltip(_close));
      check(find.text('Abandonner ces médias ?').evaluate()).length.equals(1);
      await _tap(tester, find.text('Garder'));

      check(find.text('1 média').evaluate()).length.equals(1);
      await _tap(tester, find.byTooltip(_close));
      await _tap(tester, find.text('Abandonner'));

      check(find.text(_open).hitTestable().evaluate()).length.equals(1);
      check(host.sent).isEmpty();
    });
  });

  group('the photo editor', () {
    testWidgets('returns the turned photo on Terminé and marks it cropped', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);

      await _tap(tester, find.text('Modifier'));
      check(find.text('Modifier la photo').evaluate()).length.equals(1);
      await _tap(tester, find.text('Pivoter'));
      await _tap(tester, find.byTooltip('Terminé'));

      check(find.text('Recadrée').evaluate()).length.equals(1);
      await _tap(tester, find.byTooltip(_send));
      check(
            host.sent.single.media.single,
          )
          .isA<EditedPhoto>()
          .has((photo) => photo.edit.quarterTurns, 'turns')
          .equals(3);
    });

    testWidgets('drops its changes on Annuler', (tester) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);

      await _tap(tester, find.text('Modifier'));
      await _tap(tester, find.text('Pivoter'));
      await _tap(tester, find.byTooltip('Annuler'));

      check(find.text('Recadrée').evaluate()).isEmpty();
      await _tap(tester, find.byTooltip(_send));
      check(
            host.sent.single.media.single,
          )
          .isA<EditedPhoto>()
          .has((photo) => photo.edit, 'edit')
          .equals(const PhotoEdit());
    });

    testWidgets('undoes the format and the turn on Réinitialiser', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [_photo(1)]);

      await _tap(tester, find.text('Modifier'));
      await _tap(tester, find.text('1:1'));
      await _tap(tester, find.text('Pivoter'));
      await _tap(tester, find.text('Réinitialiser'));
      await _tap(tester, find.byTooltip('Terminé'));

      check(find.text('Recadrée').evaluate()).isEmpty();
    });
  });

  group('the video editor', () {
    testWidgets('mutes the video without marking it', (tester) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [const PickedVideo(_clip)]);

      await _tap(tester, find.text('Modifier'));
      check(find.text('Modifier la vidéo').evaluate()).length.equals(1);
      await _tap(tester, find.text('Son'));
      check(find.text('Son coupé').evaluate()).length.equals(1);
      await _tap(tester, find.byTooltip('Terminé'));

      check(find.text('Coupée').evaluate()).isEmpty();
      await _tap(tester, find.byTooltip(_send));
      check(
        host.sent.single.media.single,
      ).isA<EditedVideo>().has((video) => video.edit.muted, 'muted').isTrue();
    });

    testWidgets('removes a passage from the final duration and puts it back', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [const PickedVideo(_clip)]);
      await _tap(tester, find.text('Modifier'));
      check(find.text('0:42').evaluate()).length.equals(1);

      await _tap(tester, find.byType(VideoTimeline));
      check(find.text('0:07').evaluate()).length.equals(1);
      await _tap(tester, find.text('Retirer ce passage'));

      check(find.text('0:35').evaluate()).length.equals(1);
      await _tap(tester, find.text('Remettre 0:07'));
      check(find.text('0:42').evaluate()).length.equals(1);
    });

    testWidgets('shows the video across the screen while trimming', (
      tester,
    ) async {
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [const PickedVideo(_clip)]);

      await _tap(tester, find.text('Modifier'));

      final screen = tester.getSize(find.byType(VideoEditorPage));
      check(
        tester.getSize(find.byType(CroppedPicture)).width,
      ).equals(screen.width - 2 * FujinSize.screenMargin);
    });

    testWidgets('keeps the trim handles out of the back gesture zones', (
      tester,
    ) async {
      final pixels = _gestureZone * tester.view.devicePixelRatio;
      tester.view.systemGestureInsets = FakeViewPadding(
        left: pixels,
        right: pixels,
      );
      addTearDown(tester.view.resetSystemGestureInsets);
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [const PickedVideo(_clip)]);

      await _tap(tester, find.text('Modifier'));

      final screen = tester.getSize(find.byType(VideoEditorPage));
      final timeline = tester.getRect(find.byType(VideoTimeline));
      check(timeline.left).isGreaterOrEqual(_gestureZone);
      check(timeline.right).isLessOrEqual(screen.width - _gestureZone);
      await tester.dragFrom(
        Offset(
          timeline.right - VideoTimeline.handleWidth / 2,
          timeline.center.dy,
        ),
        Offset(-timeline.width / 6, 0),
      );
      await tester.pumpAndSettle();
      check(find.text('Modifier la vidéo').evaluate()).length.equals(1);
      check(find.text('0:42').evaluate()).isEmpty();
    });
  });

  group('the crop stage', () {
    Future<Rect> openCrop(
      WidgetTester tester,
      PickedMedia media, {
      required bool video,
    }) async {
      tester.view.physicalSize = _phone * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      final pixels = _gestureZone * tester.view.devicePixelRatio;
      tester.view.systemGestureInsets = FakeViewPadding(
        left: pixels,
        right: pixels,
      );
      addTearDown(tester.view.resetSystemGestureInsets);
      final host = _Host();
      await host.pump(tester);
      await host.pickFromGallery(tester, [media]);
      await _tap(tester, find.text('Modifier'));
      if (video) await _tap(tester, find.text('Recadrer'));
      return tester.getRect(
        find.descendant(
          of: find.byType(CropStage),
          matching: find.byType(Positioned),
        ),
      );
    }

    testWidgets(
      'grabs a photo crop handle on its mark, clear of the back gesture',
      (
        tester,
      ) async {
        final crop = await openCrop(tester, _photo(1), video: false);

        final screen = tester.getSize(find.byType(PhotoEditorPage));
        check(crop.left).isGreaterOrEqual(
          _gestureZone + CropOverlay.edgeClearance,
        );
        check(crop.right).isLessOrEqual(
          screen.width - _gestureZone - CropOverlay.edgeClearance,
        );
        await tester.dragFrom(
          Offset(crop.left - 2, crop.center.dy),
          Offset(crop.width / 4, 0),
        );
        await _tap(tester, find.byTooltip('Terminé'));
        check(find.text('Recadrée').evaluate()).length.equals(1);
      },
    );

    testWidgets('keeps the video crop handles out of the back gesture zones', (
      tester,
    ) async {
      final crop = await openCrop(
        tester,
        const PickedVideo(_clip),
        video: true,
      );

      final screen = tester.getSize(find.byType(VideoEditorPage));
      check(crop.left).isGreaterOrEqual(
        _gestureZone + CropOverlay.edgeClearance,
      );
      check(crop.right).isLessOrEqual(
        screen.width - _gestureZone - CropOverlay.edgeClearance,
      );
    });
  });
}
