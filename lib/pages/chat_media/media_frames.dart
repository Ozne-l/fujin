import 'package:fujin/app/providers.dart';
import 'package:fujin/data/media/frame_request.dart';
import 'package:fujin/data/media/media_processing_exception.dart';
import 'package:fujin/pages/chat_media/media_scratch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

typedef MediaFrames = ({
  String source,
  Duration duration,
  int count,
  int maxSize,
});

final StreamProviderFamily<List<String?>, MediaFrames> mediaFramesProvider =
    StreamProvider.autoDispose.family<List<String?>, MediaFrames>((
      ref,
      frames,
    ) async* {
      final processor = ref.watch(mediaProcessorProvider);
      final scratch = MediaScratch(ref.watch(appCacheDirectoryProvider));
      final paths = List<String?>.filled(frames.count, null);
      yield List.unmodifiable(paths);
      for (var index = 0; index < frames.count; index++) {
        final at = frames.duration * ((2 * index + 1) / (2 * frames.count));
        try {
          final frame = await processor.extractFrame(
            FrameRequest(
              source: frames.source,
              output: await scratch.frame(frames.source, at, frames.maxSize),
              at: at,
              maxSize: frames.maxSize,
            ),
          );
          paths[index] = frame?.path;
        } on MediaProcessingException {
          paths[index] = null;
        }
        yield List.unmodifiable(paths);
      }
    }, retry: (retryCount, error) => null);

const int _posterSize = 1080;

MediaFrames posterFrames(String source, Duration duration) => (
  source: source,
  duration: duration,
  count: 1,
  maxSize: _posterSize,
);
