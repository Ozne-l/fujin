import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/rect_hook.dart';

part 'photo_request.mapper.dart';

@MappableClass()
final class PhotoRequest with PhotoRequestMappable {
  const PhotoRequest({
    required this.source,
    required this.output,
    this.crop,
    this.quarterTurns = 0,
  });

  final String source;
  final String output;

  @MappableField(hook: RectHook())
  final Rect? crop;

  final int quarterTurns;
}
