import 'package:fujin/data/notifications/notified_content.dart';

abstract interface class ChatNotificationCopy {
  String get channelName;

  String get channelDescription;

  String get coach;

  String get owner;

  String textOf(NotifiedContent content);
}
