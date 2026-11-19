import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        MockStreamHandler,
        MockStreamHandlerEventSink,
        TestDefaultBinaryMessenger,
        TestDefaultBinaryMessengerBinding,
        TestWidgetsFlutterBinding,
        pumpEventQueue,
        setUp,
        tearDown,
        test;
import 'package:fujin/data/media/channel_media_processor.dart';
import 'package:fujin/data/media/frame_request.dart';
import 'package:fujin/data/media/kept_passage.dart';
import 'package:fujin/data/media/media_failure.dart';
import 'package:fujin/data/media/media_processing_exception.dart';
import 'package:fujin/data/media/photo_request.dart';
import 'package:fujin/data/media/video_export_event.dart';
import 'package:fujin/data/media/video_export_request.dart';
import 'package:fujin/data/media/video_outcome.dart';

const _request = VideoExportRequest(
  source: 'content://media/picker/0/video/42',
  output: '/cache/media/v-1.mp4',
  poster: '/cache/media/v-1.jpg',
);

const Map<String, Object> _exported = {
  'path': '/cache/media/v-1.mp4',
  'bytes': 9750000,
  'duration_ms': 13044,
  'upright_width': 1080,
  'upright_height': 1920,
  'poster': '/cache/media/v-1.jpg',
  'outcome': 'toneMapped',
};

final class _Kotlin {
  _Kotlin() {
    _messenger
      ..setMockMethodCallHandler(
        ChannelMediaProcessor.methodChannel,
        _answer,
      )
      ..setMockStreamHandler(
        ChannelMediaProcessor.progressChannel,
        MockStreamHandler.inline(onListen: (_, sink) => _sink = sink),
      );
  }

  static final TestDefaultBinaryMessenger _messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  final calls = <MethodCall>[];
  final answers = <String, Future<Object?> Function()>{};
  MockStreamHandlerEventSink? _sink;

  Map<Object?, Object?> argumentsOf(String method) =>
      calls.lastWhere((call) => call.method == method).arguments
          as Map<Object?, Object?>;

  void progress(Object? id, int percent) =>
      _sink?.success({'id': id, 'percent': percent});

  Future<Object?> _answer(MethodCall call) async {
    calls.add(call);
    return switch (answers[call.method]) {
      final answer? => answer(),
      null => null,
    };
  }

  void close() {
    _messenger
      ..setMockMethodCallHandler(ChannelMediaProcessor.methodChannel, null)
      ..setMockStreamHandler(ChannelMediaProcessor.progressChannel, null);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Kotlin kotlin;
  late ChannelMediaProcessor processor;

  setUp(() {
    kotlin = _Kotlin();
    processor = ChannelMediaProcessor();
  });

  tearDown(() => kotlin.close());

  test('sends kept passages in milliseconds and the crop as fractions '
      'of the upright picture', () async {
    kotlin.answers['exportVideo'] = () async => _exported;

    await processor
        .exportVideo(
          _request.copyWith(
            passages: const [
              KeptPassage(start: Duration.zero, end: Duration(seconds: 6)),
              KeptPassage(
                start: Duration(milliseconds: 9500),
                end: Duration(seconds: 12),
              ),
            ],
            crop: const Rect.fromLTRB(0.1, 0, 0.9, 0.75),
            muted: true,
            recipient: 'Ana',
          ),
        )
        .drain<void>();

    check(kotlin.argumentsOf('exportVideo'))
      ..has(
        (arguments) => arguments['passages'],
        'passages',
      ).isA<List<Object?>>().deepEquals([
        {'start_ms': 0, 'end_ms': 6000},
        {'start_ms': 9500, 'end_ms': 12000},
      ])
      ..has(
        (arguments) => arguments['crop'],
        'crop',
      ).isA<Map<Object?, Object?>>().deepEquals({
        'left': 0.1,
        'top': 0.0,
        'right': 0.9,
        'bottom': 0.75,
      })
      ..has((arguments) => arguments['muted'], 'muted').equals(true)
      ..has((arguments) => arguments['recipient'], 'recipient').equals('Ana')
      ..has((arguments) => arguments['id'], 'id').isA<String>();
  });

  test('sends no crop and no passage for an unedited video', () async {
    kotlin.answers['exportVideo'] = () async => _exported;

    await processor.exportVideo(_request).drain<void>();

    check(kotlin.argumentsOf('exportVideo'))
      ..has((arguments) => arguments.containsKey('crop'), 'has crop').isFalse()
      ..has(
        (arguments) => arguments['passages'],
        'passages',
      ).isA<List<Object?>>().isEmpty();
  });

  test('reports the progress of its own export, then the exported video, '
      'then ends', () async {
    final exported = Completer<Object?>();
    kotlin.answers['exportVideo'] = () => exported.future;

    final events = processor.exportVideo(_request).toList();
    await pumpEventQueue();
    final id = kotlin.argumentsOf('exportVideo')['id'];
    kotlin
      ..progress(id, 38)
      ..progress('another-export', 90)
      ..progress(id, 74);
    await pumpEventQueue();
    exported.complete(_exported);

    final received = await events;
    check(
      received.map(
        (event) => switch (event) {
          VideoExportProgress(:final percent) => percent,
          VideoExportDone() => 'done',
        },
      ),
    ).deepEquals([38, 74, 'done']);
    check(
        received.last,
      ).isA<VideoExportDone>().has((done) => done.video, 'video')
      ..has((video) => video.outcome, 'outcome').equals(VideoOutcome.toneMapped)
      ..has((video) => video.duration, 'duration').equals(
        const Duration(milliseconds: 13044),
      )
      ..has((video) => video.uprightHeight, 'upright height').equals(1920)
      ..has((video) => video.poster, 'poster').equals('/cache/media/v-1.jpg');
  });

  test('ends with the failure Kotlin returned', () async {
    kotlin.answers['exportVideo'] = () async =>
        throw PlatformException(code: 'exportFailed', message: 'muxer');

    await check(
      processor.exportVideo(_request).toList(),
    ).throws<MediaProcessingException>(
      (error) => error
          .has((it) => it.failure, 'failure')
          .equals(
            MediaFailure.exportFailed,
          ),
    );
  });

  test('asks Kotlin to cancel the export its listener left', () async {
    kotlin.answers['exportVideo'] = () => Completer<Object?>().future;

    final subscription = processor.exportVideo(_request).listen((_) {});
    await pumpEventQueue();
    await subscription.cancel();

    check(
      kotlin.argumentsOf('cancelExport')['id'],
    ).equals(kotlin.argumentsOf('exportVideo')['id']);
  });

  test('does not cancel an export that already ended', () async {
    kotlin.answers['exportVideo'] = () async => _exported;

    await processor.exportVideo(_request).drain<void>();

    check(
      kotlin.calls.map((call) => call.method),
    ).not((it) => it.contains('cancelExport'));
  });

  test('reads an unknown error code as a plain failure', () async {
    kotlin.answers['probeVideo'] = () async =>
        throw PlatformException(code: 'somethingNew');

    await check(
      processor.probeVideo('/cache/in.mp4'),
    ).throws<MediaProcessingException>(
      (error) =>
          error.has((it) => it.failure, 'failure').equals(MediaFailure.failed),
    );
  });

  test('reports a remote poster that could not be fetched as a network '
      'failure', () async {
    kotlin.answers['extractFrame'] = () async =>
        throw PlatformException(code: 'networkFailed', message: 'timeout');

    await check(
      processor.extractFrame(
        const FrameRequest(
          source: 'https://assets.ekklo.com/messages/v-1.mp4',
          output: '/cache/posters/v-1.jpg',
          at: Duration(seconds: 1),
          maxSize: 720,
        ),
      ),
    ).throws<MediaProcessingException>(
      (error) => error
          .has((it) => it.failure, 'failure')
          .equals(MediaFailure.networkFailed),
    );
  });

  test('reports media processing as unsupported where the channel '
      'does not exist', () async {
    kotlin.close();

    await check(
      processor.setSecure(secure: true),
    ).throws<MediaProcessingException>(
      (error) => error
          .has((it) => it.failure, 'failure')
          .equals(MediaFailure.unsupported),
    );
  });

  test('decodes a probe with its duration and upright size', () async {
    kotlin.answers['probeVideo'] = () async => {
      'upright_width': 1080,
      'upright_height': 1920,
      'rotation': 90,
      'duration_ms': 88032,
      'hdr': true,
    };

    final probe = await processor.probeVideo('/cache/in.mp4');

    check(probe)
      ..has((it) => it.uprightWidth, 'upright width').equals(1080)
      ..has((it) => it.duration, 'duration').equals(
        const Duration(milliseconds: 88032),
      )
      ..has((it) => it.hdr, 'hdr').isTrue();
  });

  test('sends a photo crop and its quarter turns', () async {
    kotlin.answers['processPhoto'] = () async => {
      'path': '/cache/p.jpg',
      'width': 1639,
      'height': 2048,
      'bytes': 283502,
    };

    final photo = await processor.processPhoto(
      const PhotoRequest(
        source: '/picked/p.jpg',
        output: '/cache/p.jpg',
        crop: Rect.fromLTRB(0, 0.25, 1, 0.75),
        quarterTurns: 3,
      ),
    );

    check(kotlin.argumentsOf('processPhoto'))
      ..has(
        (arguments) => arguments['crop'],
        'crop',
      ).isA<Map<Object?, Object?>>().deepEquals({
        'left': 0.0,
        'top': 0.25,
        'right': 1.0,
        'bottom': 0.75,
      })
      ..has((arguments) => arguments['quarter_turns'], 'turns').equals(3);
    check(photo.width).equals(1639);
  });

  test('sends a frame time in milliseconds and returns no frame '
      'when Kotlin finds none', () async {
    final frame = await processor.extractFrame(
      const FrameRequest(
        source: '/cache/in.mp4',
        output: '/cache/t-3.jpg',
        at: Duration(seconds: 3),
        maxSize: 160,
      ),
    );

    check(kotlin.argumentsOf('extractFrame')['at_ms']).equals(3000);
    check(frame).isNull();
  });
}
