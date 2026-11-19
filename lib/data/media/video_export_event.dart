import 'package:fujin/data/media/exported_video.dart';

sealed class VideoExportEvent {
  const VideoExportEvent();
}

final class VideoExportProgress extends VideoExportEvent {
  const VideoExportProgress(this.percent);

  final int percent;
}

final class VideoExportDone extends VideoExportEvent {
  const VideoExportDone(this.video);

  final ExportedVideo video;
}
