import 'dart:convert';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, testWidgets;
import 'package:fujin/pages/chat_media/picked_files.dart';
import 'package:fujin/pages/chat_media/picked_media.dart';
import 'package:image_picker/image_picker.dart' show XFile;

const _onePixelPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB'
    '0C8AAAAASUVORK5CYII=';

void main() {
  testWidgets('skips and deletes a photo it cannot decode, keeps the rest', (
    tester,
  ) async {
    final directory = Directory.systemTemp.createTempSync('fujin_picked_');
    addTearDown(() => directory.deleteSync(recursive: true));
    final good = File('${directory.path}/good.png')
      ..writeAsBytesSync(base64Decode(_onePixelPng));
    final broken = File('${directory.path}/broken.jpg')
      ..writeAsStringSync('not a picture');
    final clip = File('${directory.path}/clip.mp4')..writeAsStringSync('');

    final picked = await tester.runAsync(
      () =>
          pickedFiles([XFile(good.path), XFile(broken.path), XFile(clip.path)]),
    );

    check(picked).isNotNull().has((media) => media.length, 'length').equals(2);
    check(picked?.first)
        .isA<PickedPhoto>()
        .has((photo) => (photo.width, photo.height), 'size')
        .equals((1, 1));
    check(picked?.last).isA<PickedVideo>();
    check(broken.existsSync()).isFalse();
    check(good.existsSync()).isTrue();
  });
}
