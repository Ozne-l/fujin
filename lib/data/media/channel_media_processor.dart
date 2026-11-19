import 'dart:async';

import 'package:flutter/services.dart';
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
import 'package:uuid/uuid.dart';

enum _Method {
  probeVideo,
  exportVideo,
  cancelExport,
  processPhoto,
  extractFrame,
  setSecure,
}

final class ChannelMediaProcessor implements MediaProcessor {
  ChannelMediaProcessor();

  static const methodChannel = MethodChannel('dev.oznel.fujin/media');
  static const progressChannel = EventChannel('dev.oznel.fujin/media_progress');
  static const _id = 'id';
  static const _percent = 'percent';
  static const _source = 'source';
  static const _secure = 'secure';

  late final Stream<Object?> _progress = progressChannel
      .receiveBroadcastStream();

  @override
  Future<VideoProbe> probeVideo(String source) async =>
      VideoProbeMapper.fromMap(
        await _required(_Method.probeVideo, {_source: source}),
      );

  @override
  Stream<VideoExportEvent> exportVideo(VideoExportRequest request) {
    final id = const Uuid().v4();
    StreamSubscription<int>? progress;
    var running = true;
    late final StreamController<VideoExportEvent> events;

    Future<void> run() async {
      progress = _progressOf(id).listen(
        (percent) => events.add(VideoExportProgress(percent)),
      );
      try {
        final exported = await _required(_Method.exportVideo, {
          ...request.toMap(),
          _id: id,
        });
        events.add(VideoExportDone(ExportedVideoMapper.fromMap(exported)));
      } on MediaProcessingException catch (error, stackTrace) {
        events.addError(error, stackTrace);
      } finally {
        running = false;
        await progress?.cancel();
        unawaited(events.close());
      }
    }

    events = StreamController(
      onListen: () => unawaited(run()),
      onCancel: () async {
        await progress?.cancel();
        if (running) await _call(_Method.cancelExport, {_id: id});
      },
    );
    return events.stream;
  }

  @override
  Future<ProcessedPhoto> processPhoto(PhotoRequest request) async =>
      ProcessedPhotoMapper.fromMap(
        await _required(_Method.processPhoto, request.toMap()),
      );

  @override
  Future<ExtractedFrame?> extractFrame(FrameRequest request) async =>
      switch (await _call(_Method.extractFrame, request.toMap())) {
        final frame? => ExtractedFrameMapper.fromMap(frame),
        null => null,
      };

  @override
  Future<void> setSecure({required bool secure}) =>
      _call(_Method.setSecure, {_secure: secure});

  Stream<int> _progressOf(String id) => _progress.expand(
    (event) => switch (event) {
      {_id: final String eventId, _percent: final int percent}
          when eventId == id =>
        [percent],
      _ => const <int>[],
    },
  );

  Future<Map<String, dynamic>> _required(
    _Method method,
    Map<String, Object?> arguments,
  ) async => switch (await _call(method, arguments)) {
    final result? => result,
    null => throw MediaProcessingException(MediaFailure.failed, method.name),
  };

  Future<Map<String, dynamic>?> _call(
    _Method method,
    Map<String, Object?> arguments,
  ) async {
    try {
      return await methodChannel.invokeMapMethod<String, dynamic>(
        method.name,
        arguments,
      );
    } on Exception catch (error) {
      throw MediaProcessingException.from(error);
    }
  }
}
