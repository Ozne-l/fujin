import 'package:fujin/pages/chat_media/picked_media.dart';

abstract interface class MediaPicker {
  Future<List<PickedMedia>> gallery({required int limit});

  Future<PickedMedia?> photo();

  Future<PickedMedia?> video();

  Future<List<PickedMedia>> lost();
}
