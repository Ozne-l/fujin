import 'dart:ui' as ui;

import 'package:fujin/data/media/forget_file.dart';
import 'package:fujin/data/media/picked_media.dart';
import 'package:image_picker/image_picker.dart';

const _videoPrefix = 'video/';
const _videoExtensions = {'.mp4', '.mov', '.3gp', '.webm', '.mkv'};

Future<List<PickedMedia>> pickedFiles(List<XFile> files) async => [
  for (final file in files)
    ?switch (_isVideo(file)) {
      true => PickedVideo(file.path),
      false => await pickedPhoto(file),
    },
];

Future<PickedPhoto?> pickedPhoto(XFile file) async {
  try {
    final buffer = await ui.ImmutableBuffer.fromFilePath(file.path);
    try {
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final photo = PickedPhoto(
        file.path,
        width: descriptor.width,
        height: descriptor.height,
      );
      descriptor.dispose();
      return photo;
    } finally {
      buffer.dispose();
    }
  } on Exception {
    await forgetFile(file.path);
    return null;
  }
}

bool _isVideo(XFile file) => switch (file.mimeType) {
  final mimeType? => mimeType.startsWith(_videoPrefix),
  null => _videoExtensions.any(file.path.toLowerCase().endsWith),
};
