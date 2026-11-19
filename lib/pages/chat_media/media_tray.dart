import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';

part 'media_tray.mapper.dart';

@MappableClass()
final class MediaTray with MediaTrayMappable {
  const MediaTray({this.media = const [], this.selected = 0});

  final List<EditedMedia> media;
  final int selected;

  int get room => MediaSend.maximumMedia - media.length;

  bool get isFull => room <= 0;

  EditedMedia? get shown => switch (media) {
    [] => null,
    _ => media[selected.clamp(0, media.length - 1)],
  };

  bool isDirty(String caption) =>
      caption.trim().isNotEmpty || media.any((media) => media.isEdited);
}
