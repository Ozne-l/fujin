import 'package:fujin/app/notifications/media_label_text.dart';
import 'package:fujin/data/notifications/chat_notification_copy.dart';
import 'package:fujin/data/notifications/notified_content.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

final class ChatNotificationText implements ChatNotificationCopy {
  const ChatNotificationText(this._intl);

  final AppLocalizations _intl;

  @override
  String get channelName => _intl.chatNotificationChannelName;

  @override
  String get channelDescription => _intl.chatNotificationChannelDescription;

  @override
  String get coach => _intl.chatNotificationCoach;

  @override
  String get owner => _intl.appName;

  @override
  String textOf(NotifiedContent content) => switch (content) {
    NotifiedText(:final text) => text,
    NotifiedUnsupported() => _intl.chatNotificationUnsupported,
    NotifiedMedia(:final label, caption: null) => MediaLabelText.of(
      _intl,
      label,
    ),
    NotifiedMedia(:final label, caption: final caption?) =>
      _intl.chatNotificationCaption(MediaLabelText.of(_intl, label), caption),
  };
}
