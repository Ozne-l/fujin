import 'dart:ui';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/media/photo_request.dart';
import 'package:fujin/domain/chat/edit/crop_aspect.dart';
import 'package:fujin/domain/chat/edit/crop_geometry.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';
import 'package:fujin/domain/chat/edit/edit_mark.dart';
import 'package:fujin/domain/chat/edit/photo_edit.dart';

import '../../../support/rect_checks.dart';

const _landscape = Size(4000, 3000);

void main() {
  group('a crop preset', () {
    test('takes the largest centred frame of its ratio', () {
      final edit = const PhotoEdit().withAspect(CropAspect.square, _landscape);

      check(edit.crop).isNotNull().isNear(
        const Rect.fromLTRB(0.125, 0, 0.875, 1),
      );
      check(edit.aspect).equals(CropAspect.square);
    });

    test('Original and Libre leave the whole picture', () {
      check(
        const PhotoEdit().withAspect(CropAspect.original, _landscape).crop,
      ).isNull();
      check(
        const PhotoEdit().withAspect(CropAspect.free, _landscape).crop,
      ).isNull();
    });

    test('is the ratio of the turned picture after a quarter turn', () {
      final edit = const PhotoEdit()
          .rotated(_landscape)
          .withAspect(CropAspect.fourFive, _landscape);

      check(edit.quarterTurns).equals(3);
      check(edit.shownCrop).isNear(const Rect.fromLTRB(0, 0.03125, 1, 0.96875));
      check(
        edit.crop,
      ).isNotNull().isNear(const Rect.fromLTRB(0.03125, 0, 0.96875, 1));
    });

    test('is applied again to the turned picture when turning', () {
      final portrait = const PhotoEdit().withAspect(
        CropAspect.fourFive,
        _landscape,
      );

      final turned = portrait.rotated(_landscape);

      final shown = turned.shownSize(_landscape);
      final crop = turned.shownCrop;
      check(
        crop.width * shown.width / (crop.height * shown.height),
      ).isCloseTo(4 / 5, 1e-6);
      check(crop.width).isCloseTo(1, 1e-9);
    });
  });

  group('a free crop', () {
    test('turns with the picture', () {
      final cropped = const PhotoEdit().dragged(
        CropHandle.topLeft,
        const Offset(0.25, 0.5),
        _landscape,
      );

      final turned = cropped.rotated(_landscape);

      check(turned.crop).equals(cropped.crop);
      check(
        turned.shownCrop,
      ).isNear(const Rect.fromLTRB(0.5, 0, 1, 0.75));
    });

    test('keeps an eighth of the short side when dragged past itself', () {
      final edit = const PhotoEdit().dragged(
        CropHandle.bottomRight,
        const Offset(-2, -2),
        _landscape,
      );

      check(edit.crop).isNotNull().isNear(
        const Rect.fromLTRB(0, 0, 375 / 4000, 1 / 8),
      );
    });

    test('moves inside the picture only', () {
      final edit = const PhotoEdit()
          .withAspect(CropAspect.square, _landscape)
          .dragged(CropHandle.inside, const Offset(0.5, 0.5), _landscape);

      check(edit.crop).isNotNull().isNear(const Rect.fromLTRB(0.25, 0, 1, 1));
    });
  });

  group('a crop at a ratio', () {
    test('keeps its ratio and its opposite corner when a corner moves', () {
      final edit = const PhotoEdit()
          .withAspect(CropAspect.square, _landscape)
          .dragged(CropHandle.topLeft, const Offset(0.125, 0), _landscape);

      final crop = edit.crop;
      check(crop).isNotNull().isNear(
        const Rect.fromLTRB(0.25, 1 / 6, 0.875, 1),
      );
    });

    test('stops at the edge of the picture', () {
      final edit = const PhotoEdit()
          .withAspect(CropAspect.fourFive, _landscape)
          .dragged(CropHandle.bottomRight, const Offset(1, 1), _landscape);

      final crop = edit.crop;
      check(crop).isNotNull()
        ..has((crop) => crop.bottom, 'bottom').isLessOrEqual(1)
        ..has((crop) => crop.right, 'right').isLessOrEqual(1);
    });
  });

  group('an edit', () {
    test('is marked cropped once cropped or turned, and not after reset', () {
      check(const PhotoEdit().mark).isNull();
      check(const PhotoEdit().rotated(_landscape).mark).equals(
        EditMark.cropped,
      );
      check(
        const PhotoEdit().withAspect(CropAspect.square, _landscape).mark,
      ).equals(EditMark.cropped);
    });

    test('turns four times back to the picture as it was', () {
      var edit = const PhotoEdit();
      for (var turn = 0; turn < 4; turn++) {
        edit = edit.rotated(_landscape);
      }

      check(edit.isEdited).isFalse();
    });

    test('maps its upright crop and turns onto the photo pass', () {
      final edit = const PhotoEdit()
          .rotated(_landscape)
          .withAspect(CropAspect.fourFive, _landscape);

      final request = edit.request(source: 'content://p/1', output: '/o.jpg');

      check(request)
        ..has((request) => request.source, 'source').equals('content://p/1')
        ..has((request) => request.output, 'output').equals('/o.jpg')
        ..has((request) => request.quarterTurns, 'quarterTurns').equals(3)
        ..has((request) => request.crop, 'crop').equals(edit.crop);
    });

    test('sends no crop for the whole picture', () {
      check(
        const PhotoEdit().request(source: 's', output: 'o'),
      ).equals(const PhotoRequest(source: 's', output: 'o'));
      check(CropGeometry.normalized(CropGeometry.whole)).isNull();
    });
  });
}
