import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';
import 'package:fujin/data/media/video_outcome.dart';

part 'exported_video.mapper.dart';

@MappableClass()
final class ExportedVideo with ExportedVideoMappable {
  const ExportedVideo({
    required this.path,
    required this.bytes,
    required this.duration,
    required this.uprightWidth,
    required this.uprightHeight,
    required this.outcome,
    this.poster,
  });

  final String path;
  final int bytes;

  @MappableField(key: 'duration_ms', hook: MillisecondsHook())
  final Duration duration;

  final int uprightWidth;
  final int uprightHeight;
  final VideoOutcome outcome;
  final String? poster;
}
