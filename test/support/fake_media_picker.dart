import 'package:fujin/pages/chat_media/media_picker.dart';
import 'package:fujin/pages/chat_media/picked_media.dart';

final class FakeMediaPicker implements MediaPicker {
  List<PickedMedia> chosen = const [];
  PickedMedia? shot;
  PickedMedia? filmed;
  List<PickedMedia> lostMedia = const [];
  final galleryLimits = <int>[];

  @override
  Future<List<PickedMedia>> gallery({required int limit}) async {
    galleryLimits.add(limit);
    return chosen;
  }

  @override
  Future<PickedMedia?> photo() async => shot;

  @override
  Future<PickedMedia?> video() async => filmed;

  @override
  Future<List<PickedMedia>> lost() async {
    final lost = lostMedia;
    lostMedia = const [];
    return lost;
  }
}
