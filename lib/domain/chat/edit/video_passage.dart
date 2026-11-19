import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/kept_passage.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';

part 'video_passage.mapper.dart';

@MappableClass()
final class VideoPassage with VideoPassageMappable {
  const VideoPassage({required this.start, required this.end});

  @MappableField(key: 'start_ms', hook: MillisecondsHook())
  final Duration start;

  @MappableField(key: 'end_ms', hook: MillisecondsHook())
  final Duration end;

  Duration get length => end - start;

  bool contains(Duration position) => position >= start && position < end;

  bool overlaps(VideoPassage other) => start <= other.end && other.start <= end;

  KeptPassage get kept => KeptPassage(start: start, end: end);
}
