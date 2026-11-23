import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/upload/upload_completion.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/domain/chat/upload/message_settler.dart';
import 'package:fujin/domain/chat/upload/relay_outcome.dart';
import 'package:fujin/domain/chat/upload/settlement.dart';

final class ChatRelay {
  ChatRelay({
    required EkkloMessaging messaging,
    required this._messages,
    required UploadNotifications notifications,
    required UploadFolder folder,
    required this._cachePath,
    required DateTime Function() clock,
  }) : _settler = MessageSettler(
         messaging: messaging,
         messages: _messages,
         notifications: notifications,
         folder: folder,
         clock: clock,
       );

  final MessageSettler _settler;
  final MessageInProgressRepository _messages;
  final String _cachePath;

  Future<RelayOutcome> relay(String messageId) async {
    UploadCompletion.sweep(_messages, cachePath: _cachePath);
    return switch (await _settler.settle(messageId)) {
      MessagePosted() => RelayOutcome.posted,
      MessageNotReady() || MessageWaiting() => RelayOutcome.later,
      MessageGivenUp() => RelayOutcome.gaveUp,
      MessageGone() => RelayOutcome.gone,
    };
  }
}
