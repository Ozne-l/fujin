import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';

part 'uploading_media.mapper.dart';

@MappableClass()
final class UploadingMedia with UploadingMediaMappable {
  const UploadingMedia({
    required this.id,
    required this.kind,
    this.media,
    this.percent,
    this.originalBytes,
  });

  final String id;
  final ChatMediaKind kind;
  final EditedMedia? media;
  final int? percent;
  final int? originalBytes;

  bool get sent => percent == null;
}
