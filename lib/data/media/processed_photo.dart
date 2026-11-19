import 'package:dart_mappable/dart_mappable.dart';

part 'processed_photo.mapper.dart';

@MappableClass()
final class ProcessedPhoto with ProcessedPhotoMappable {
  const ProcessedPhoto({
    required this.path,
    required this.width,
    required this.height,
    required this.bytes,
  });

  final String path;
  final int width;
  final int height;
  final int bytes;
}
