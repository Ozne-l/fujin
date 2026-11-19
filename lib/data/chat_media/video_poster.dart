import 'dart:io';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';

part 'video_poster.mapper.dart';

@MappableClass()
final class VideoPoster with VideoPosterMappable {
  const VideoPoster({
    required this.path,
    required this.width,
    required this.height,
    this.duration,
  });

  final String path;
  final int width;
  final int height;

  @MappableField(key: 'duration_ms', hook: MillisecondsHook())
  final Duration? duration;

  File get file => File(path);
}
