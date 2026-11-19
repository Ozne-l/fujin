import 'dart:ui';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/media/kept_passage.dart';
import 'package:fujin/domain/chat/edit/crop_aspect.dart';
import 'package:fujin/domain/chat/edit/edit_mark.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';
import 'package:fujin/domain/chat/edit/video_passage.dart';

import '../../../support/rect_checks.dart';

const _video = VideoEdit.untouched(Duration(seconds: 42));
const _landscape = Size(1920, 1080);

Duration _s(num seconds) => Duration(milliseconds: (seconds * 1000).round());

VideoPassage _passage(num start, num end) =>
    VideoPassage(start: _s(start), end: _s(end));

KeptPassage _kept(num start, num end) =>
    KeptPassage(start: _s(start), end: _s(end));

void main() {
  group('an untouched video', () {
    test('sends the whole file, unmarked', () {
      check(_video.keptPassages).isEmpty();
      check(_video.keptDuration).equals(_s(42));
      check(_video.isEdited).isFalse();
      check(_video.mark).isNull();
    });
  });

  group('trimming', () {
    test('keeps the passage between the two handles', () {
      final edit = _video.trimmed(start: _s(5)).trimmed(end: _s(37));

      check(edit.keptPassages).deepEquals([_kept(5, 37)]);
      check(edit.keptDuration).equals(_s(32));
      check(edit.mark).equals(EditMark.trimmed);
    });

    test('keeps at least a second between the handles', () {
      final edit = _video.trimmed(end: _s(10)).trimmed(start: _s(20));

      check(edit.start).equals(_s(9));
      check(edit.trimmed(end: _s(2)).end).equals(_s(10));
    });

    test('stays inside the video', () {
      final edit = _video.trimmed(start: _s(-3)).trimmed(end: _s(60));

      check(edit.start).equals(Duration.zero);
      check(edit.end).equals(_s(42));
      check(edit.isCut).isFalse();
    });

    test('clips a removed passage and forgets one left outside', () {
      final edit = _video
          .removing(_passage(10, 14))
          .removing(_passage(30, 33))
          .trimmed(start: _s(12))
          .trimmed(end: _s(29));

      check(edit.removed).deepEquals([_passage(12, 14)]);
      check(edit.keptPassages).deepEquals([_kept(14, 29)]);
    });
  });

  group('removing a passage', () {
    test('keeps what is before and after it', () {
      final edit = _video.trimmed(start: _s(4)).removing(_passage(18, 24));

      check(edit.keptPassages).deepEquals([_kept(4, 18), _kept(24, 42)]);
      check(edit.keptDuration).equals(_s(32));
    });

    test('drops a kept piece shorter than half a second', () {
      final edit = _video.removing(_passage(20, 41.7));

      check(edit.keptPassages).deepEquals([_kept(0, 20)]);
    });

    test('merges passages that overlap', () {
      final edit = _video.removing(_passage(10, 15)).removing(_passage(13, 20));

      check(edit.removed).deepEquals([_passage(10, 20)]);
    });

    test('is refused under half a second or outside the trimmed video', () {
      final trimmed = _video.trimmed(start: _s(5));

      check(trimmed.canRemove(_passage(10, 10.4))).isFalse();
      check(trimmed.canRemove(_passage(3, 8))).isFalse();
      check(trimmed.canRemove(_passage(10, 10.5))).isTrue();
    });

    test('is refused when less than a second would be left', () {
      final short = _video.trimmed(start: _s(10)).trimmed(end: _s(13));

      check(short.canRemove(_passage(10.3, 12.4))).isFalse();
      check(short.canRemove(_passage(10, 12))).isTrue();
    });

    test('can be restored', () {
      final edit = _video.removing(_passage(18, 24));

      final restored = edit.restoring(_passage(18, 24));

      check(restored.keptPassages).isEmpty();
      check(restored.isEdited).isFalse();
    });
  });

  group('a selection in the timeline', () {
    test('is a sixth of the trimmed video around the touch', () {
      final edit = _video.trimmed(start: _s(6)).trimmed(end: _s(42));

      check(edit.selectionAt(_s(20))).equals(_passage(17, 23));
    });

    test('stays inside the trimmed video', () {
      check(_video.selectionAt(_s(1))).equals(_passage(0, 7));
      check(_video.selectionAt(_s(41))).equals(_passage(35, 42));
    });

    test('is impossible when nothing could be removed', () {
      final short = _video.trimmed(end: _s(1.2));

      check(short.selectionAt(_s(0.5))).isNull();
    });
  });

  group('the preview', () {
    final edit = _video
        .trimmed(start: _s(4))
        .trimmed(end: _s(38))
        .removing(_passage(18, 24));

    test('jumps over removed passages and stops after the last', () {
      check(edit.keeps(_s(10))).isTrue();
      check(edit.keeps(_s(20))).isFalse();
      check(edit.nextKeptStart(_s(1))).equals(_s(4));
      check(edit.nextKeptStart(_s(20))).equals(_s(24));
      check(edit.nextKeptStart(_s(39))).isNull();
      check(edit.firstKeptStart).equals(_s(4));
    });

    test('reads its position in the final video', () {
      check(edit.finalPosition(_s(2))).equals(Duration.zero);
      check(edit.finalPosition(_s(10))).equals(_s(6));
      check(edit.finalPosition(_s(20))).equals(_s(14));
      check(edit.finalPosition(_s(30))).equals(_s(20));
      check(edit.finalPosition(_s(40))).equals(_s(28));
    });
  });

  group('crop and sound', () {
    test('a preset centres its ratio in the upright picture', () {
      final edit = _video.withAspect(CropAspect.nineSixteen, _landscape);

      const width = 1080 * 9 / 16 / 1920;
      check(edit.crop).isNotNull().isNear(
        const Rect.fromLTRB((1 - width) / 2, 0, (1 + width) / 2, 1),
      );
      check(edit.mark).equals(EditMark.cropped);
    });

    test('a video only without sound is edited but unmarked', () {
      final muted = _video.toggledSound();

      check(muted.isEdited).isTrue();
      check(muted.mark).isNull();
      check(muted.toggledSound().isEdited).isFalse();
    });

    test('a trimmed video without sound is marked cut', () {
      final edit = _video.trimmed(start: _s(4)).toggledSound();

      check(edit.mark).equals(EditMark.trimmed);
    });

    test('maps onto the export with passages, crop and sound', () {
      final edit = _video
          .trimmed(start: _s(4))
          .removing(_passage(18, 24))
          .withAspect(CropAspect.square, _landscape)
          .toggledSound();

      final request = edit.request(
        source: 'content://v/1',
        output: '/v.mp4',
        poster: '/v.jpg',
        recipient: 'Thomas',
        position: 2,
        count: 4,
      );

      check(request)
        ..has((request) => request.passages, 'passages').deepEquals([
          _kept(4, 18),
          _kept(24, 42),
        ])
        ..has((request) => request.crop, 'crop').equals(edit.crop)
        ..has((request) => request.muted, 'muted').isTrue()
        ..has((request) => request.recipient, 'recipient').equals('Thomas')
        ..has((request) => request.position, 'position').equals(2)
        ..has((request) => request.count, 'count').equals(4);
    });
  });
}
