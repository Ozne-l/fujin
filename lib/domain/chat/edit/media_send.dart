import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';

part 'media_send.mapper.dart';

@MappableClass()
final class MediaSend with MediaSendMappable {
  const MediaSend({required this.media, this.caption = '', this.replyToId});

  static const maximumMedia = 10;

  final List<EditedMedia> media;
  final String caption;
  final String? replyToId;
}
