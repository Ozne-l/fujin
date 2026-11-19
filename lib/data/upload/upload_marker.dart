import 'package:dart_mappable/dart_mappable.dart';

part 'upload_marker.mapper.dart';

@MappableClass()
final class UploadMarker with UploadMarkerMappable {
  const UploadMarker({required this.publicUrl, required this.at});

  static UploadMarker? decode(String text) {
    try {
      return UploadMarkerMapper.fromJson(text);
    } on Object {
      return null;
    }
  }

  final String publicUrl;
  final DateTime at;
}
