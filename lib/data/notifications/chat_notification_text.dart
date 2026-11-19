import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:fujin/domain/chat/notifications/media_label.dart';
import 'package:fujin/domain/chat/notifications/notified_content.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class ChatNotificationText {
  static AppLocalizations ofDevice() => lookupAppLocalizations(
    basicLocaleListResolution(
      PlatformDispatcher.instance.locales,
      AppLocalizations.supportedLocales,
    ),
  );

  static String of(AppLocalizations intl, NotifiedContent content) =>
      switch (content) {
        NotifiedText(:final text) => text,
        NotifiedUnsupported() => intl.chatNotificationUnsupported,
        NotifiedMedia(:final label, caption: null) => _labelOf(intl, label),
        NotifiedMedia(:final label, caption: final caption?) =>
          intl.chatNotificationCaption(_labelOf(intl, label), caption),
      };

  static String _labelOf(AppLocalizations intl, MediaLabel label) =>
      switch (label) {
        PhotosLabel(:final count) => intl.chatNotificationPhotos(count),
        VideosLabel(:final count) => intl.chatNotificationVideos(count),
        VoiceLabel() => intl.chatNotificationVoice,
        MixedLabel(count: final count?) => intl.chatNotificationMedia(count),
        MixedLabel(count: null) => intl.chatNotificationPhotosAndVideos,
      };
}
