import 'package:dart_mappable/dart_mappable.dart';

part 'extracted_frame.mapper.dart';

@MappableClass()
final class ExtractedFrame with ExtractedFrameMappable {
  const ExtractedFrame({
    required this.path,
    required this.width,
    required this.height,
  });

  final String path;
  final int width;
  final int height;
}
