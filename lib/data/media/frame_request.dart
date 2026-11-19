import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';

part 'frame_request.mapper.dart';

@MappableClass()
final class FrameRequest with FrameRequestMappable {
  const FrameRequest({
    required this.source,
    required this.output,
    required this.at,
    required this.maxSize,
  });

  final String source;
  final String output;

  @MappableField(key: 'at_ms', hook: MillisecondsHook())
  final Duration at;

  final int maxSize;
}
