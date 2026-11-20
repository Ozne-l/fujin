import 'package:fujin/data/notifications/media_label.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class MediaLabelText {
  static String of(AppLocalizations intl, MediaLabel label) => switch (label) {
    PhotosLabel(:final count) => intl.chatNotificationPhotos(count),
    VideosLabel(:final count) => intl.chatNotificationVideos(count),
    VoiceLabel() => intl.chatNotificationVoice,
    MixedLabel(count: final count?) => intl.chatNotificationMedia(count),
    MixedLabel(count: null) => intl.chatNotificationPhotosAndVideos,
  };
}
