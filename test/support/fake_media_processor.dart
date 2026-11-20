import 'dart:async';

import 'package:fujin/data/media/exported_video.dart';
import 'package:fujin/data/media/extracted_frame.dart';
import 'package:fujin/data/media/frame_request.dart';
import 'package:fujin/data/media/media_failure.dart';
import 'package:fujin/data/media/media_processing_exception.dart';
import 'package:fujin/data/media/media_processor.dart';
import 'package:fujin/data/media/photo_request.dart';
import 'package:fujin/data/media/processed_photo.dart';
import 'package:fujin/data/media/video_export_event.dart';
import 'package:fujin/data/media/video_export_request.dart';
import 'package:fujin/data/media/video_probe.dart';

final class FakeMediaProcessor implements MediaProcessor {
  final probes = <String, VideoProbe>{};
  final exportRequests = <VideoExportRequest>[];
  final photoRequests = <PhotoRequest>[];
  final frameRequests = <FrameRequest>[];
  final _exports = <StreamController<VideoExportEvent>>[];
  MediaFailure? failure;
  bool secure = false;
  Completer<void>? probeGate;

  @override
  Future<VideoProbe> probeVideo(String source) async {
    if (probeGate case final gate?) await gate.future;
    _throwFailure();
    return switch (probes[source]) {
      final probe? => probe,
      null => throw MediaProcessingException(
        MediaFailure.unreadableSource,
        source,
      ),
    };
  }

  @override
  Stream<VideoExportEvent> exportVideo(VideoExportRequest request) {
    exportRequests.add(request);
    if (failure case final failure?) {
      return Stream.error(MediaProcessingException(failure));
    }
    final export = StreamController<VideoExportEvent>();
    _exports.add(export);
    return export.stream;
  }

  void progress(int percent) => _exports.last.add(VideoExportProgress(percent));

  void finish(ExportedVideo video) {
    final export = _exports.last..add(VideoExportDone(video));
    unawaited(export.close());
  }

  @override
  Future<ProcessedPhoto> processPhoto(PhotoRequest request) async {
    photoRequests.add(request);
    _throwFailure();
    return ProcessedPhoto(
      path: request.output,
      width: _photoWidth,
      height: _photoHeight,
      bytes: _photoBytes,
    );
  }

  @override
  Future<ExtractedFrame?> extractFrame(FrameRequest request) async {
    frameRequests.add(request);
    _throwFailure();
    return ExtractedFrame(
      path: request.output,
      width: request.maxSize,
      height: request.maxSize,
    );
  }

  @override
  Future<void> setSecure({required bool secure}) async {
    this.secure = secure;
  }

  static const _photoWidth = 1536;
  static const _photoHeight = 2048;
  static const _photoBytes = 280000;

  void _throwFailure() {
    if (failure case final failure?) throw MediaProcessingException(failure);
  }
}
