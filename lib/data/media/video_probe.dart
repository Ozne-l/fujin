import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';

part 'video_probe.mapper.dart';

@MappableClass()
final class VideoProbe with VideoProbeMappable {
  const VideoProbe({
    required this.uprightWidth,
    required this.uprightHeight,
    required this.rotation,
    required this.duration,
    required this.hdr,
  });

  final int uprightWidth;
  final int uprightHeight;
  final int rotation;

  @MappableField(key: 'duration_ms', hook: MillisecondsHook())
  final Duration duration;

  final bool hdr;
}
