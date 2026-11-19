import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/kept_passage.dart';
import 'package:fujin/data/media/rect_hook.dart';

part 'video_export_request.mapper.dart';

@MappableClass()
final class VideoExportRequest with VideoExportRequestMappable {
  const VideoExportRequest({
    required this.source,
    required this.output,
    required this.poster,
    this.passages = const [],
    this.crop,
    this.muted = false,
    this.recipient,
    this.position = 1,
    this.count = 1,
  });

  final String source;
  final String output;
  final String poster;
  final List<KeptPassage> passages;

  @MappableField(hook: RectHook())
  final Rect? crop;

  final bool muted;
  final String? recipient;
  final int position;
  final int count;
}
