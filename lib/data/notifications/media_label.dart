import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';

part 'media_label.mapper.dart';

@MappableClass(discriminatorKey: 'kind')
sealed class MediaLabel with MediaLabelMappable {
  const MediaLabel();

  static MediaLabel of(List<EkkloMedia> media) => switch ({
    for (final item in media) item.kind,
  }) {
    Set(length: 1, first: EkkloMediaKind.image) => PhotosLabel(media.length),
    Set(length: 1, first: EkkloMediaKind.video) => VideosLabel(media.length),
    Set(length: 1, first: EkkloMediaKind.voice) => const VoiceLabel(),
    _ => MixedLabel(media.length),
  };
}

@MappableClass(discriminatorValue: 'photos')
final class PhotosLabel extends MediaLabel with PhotosLabelMappable {
  const PhotosLabel(this.count);

  final int count;
}

@MappableClass(discriminatorValue: 'videos')
final class VideosLabel extends MediaLabel with VideosLabelMappable {
  const VideosLabel(this.count);

  final int count;
}

@MappableClass(discriminatorValue: 'voice')
final class VoiceLabel extends MediaLabel with VoiceLabelMappable {
  const VoiceLabel();
}

@MappableClass(discriminatorValue: 'mixed')
final class MixedLabel extends MediaLabel with MixedLabelMappable {
  const MixedLabel(this.count);

  final int? count;
}
