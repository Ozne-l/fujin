sealed class PickedMedia {
  const PickedMedia(this.path);

  final String path;
}

final class PickedPhoto extends PickedMedia {
  const PickedPhoto(super.path, {required this.width, required this.height});

  final int width;
  final int height;
}

final class PickedVideo extends PickedMedia {
  const PickedVideo(super.path);
}
