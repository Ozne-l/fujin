abstract interface class UploadNotificationCopy {
  String get channelName;

  String get channelDescription;

  String title(String? coach);

  String progress(int count, int position, String progress);

  String get waiting;

  String get failedTitle;

  String get failedBody;
}
