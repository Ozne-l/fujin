import 'package:fujin/pages/chat_media/media_picker.dart';
import 'package:fujin/pages/chat_media/picked_files.dart';
import 'package:fujin/pages/chat_media/picked_media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

final class ImageMediaPicker implements MediaPicker {
  ImageMediaPicker() {
    if (ImagePickerPlatform.instance case final ImagePickerAndroid android) {
      android.useAndroidPhotoPicker = true;
    }
  }

  final _picker = ImagePicker();

  @override
  Future<List<PickedMedia>> gallery({required int limit}) async =>
      pickedFiles(await _picker.pickMultipleMedia(limit: limit));

  @override
  Future<PickedMedia?> photo() async =>
      switch (await _picker.pickImage(source: ImageSource.camera)) {
        final file? => pickedPhoto(file),
        null => null,
      };

  @override
  Future<PickedMedia?> video() async =>
      switch (await _picker.pickVideo(source: ImageSource.camera)) {
        final file? => PickedVideo(file.path),
        null => null,
      };

  @override
  Future<List<PickedMedia>> lost() async {
    final response = await _picker.retrieveLostData();
    return switch (response.files) {
      final files? => pickedFiles(files),
      null => const [],
    };
  }
}
