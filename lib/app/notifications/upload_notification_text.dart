import 'package:fujin/data/upload/upload_notification_copy.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

final class UploadNotificationText implements UploadNotificationCopy {
  const UploadNotificationText(this._intl);

  final AppLocalizations _intl;

  @override
  String get channelName => _intl.chatUploadChannelName;

  @override
  String get channelDescription => _intl.chatUploadChannelDescription;

  @override
  String title(String? coach) =>
      _intl.chatUploadNotificationTitle(coach ?? _intl.chatNotificationCoach);

  @override
  String progress(int count, int position, String progress) =>
      _intl.chatUploadNotificationProgress(count, position, progress);

  @override
  String get waiting => _intl.chatUploadNotificationWaiting;

  @override
  String get failedTitle => _intl.chatUploadNotificationFailedTitle;

  @override
  String get failedBody => _intl.chatUploadNotificationFailedBody;
}
