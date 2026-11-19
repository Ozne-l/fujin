import 'package:fujin/data/media/extracted_frame.dart';
import 'package:fujin/data/media/frame_request.dart';
import 'package:fujin/data/media/photo_request.dart';
import 'package:fujin/data/media/processed_photo.dart';
import 'package:fujin/data/media/video_export_event.dart';
import 'package:fujin/data/media/video_export_request.dart';
import 'package:fujin/data/media/video_probe.dart';

abstract interface class MediaProcessor {
  Future<VideoProbe> probeVideo(String source);

  Stream<VideoExportEvent> exportVideo(VideoExportRequest request);

  Future<ProcessedPhoto> processPhoto(PhotoRequest request);

  Future<ExtractedFrame?> extractFrame(FrameRequest request);

  Future<void> setSecure({required bool secure});
}
