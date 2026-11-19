import 'package:fujin/data/chat/message_in_progress.dart';

abstract final class UploadDeadline {
  static const giveUpAfter = Duration(hours: 24);

  static bool passed(MessageInProgress message, {required DateTime now}) =>
      now.difference(message.startedAt) >= giveUpAfter;
}
