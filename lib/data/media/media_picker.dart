import 'package:fujin/data/media/picked_media.dart';

abstract interface class MediaPicker {
  Future<List<PickedMedia>> gallery({required int limit});

  Future<PickedMedia?> photo();

  Future<PickedMedia?> video();

  Future<List<PickedMedia>> lost();
}
