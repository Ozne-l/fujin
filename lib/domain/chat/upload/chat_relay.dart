import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/upload/upload_completion.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/domain/chat/upload/message_poster.dart';
import 'package:fujin/domain/chat/upload/relay_outcome.dart';
import 'package:fujin/domain/chat/upload/upload_deadline.dart';

final class ChatRelay {
  ChatRelay({
    required EkkloMessaging messaging,
    required this._messages,
    required this._notifications,
    required this._folder,
    required this._cachePath,
    required this._clock,
  }) : _poster = MessagePoster(messaging);

  static const _firstServerErrorStatus = 500;

  final MessagePoster _poster;
  final MessageInProgressRepository _messages;
  final UploadNotifications _notifications;
  final UploadFolder _folder;
  final String _cachePath;
  final DateTime Function() _clock;

  Future<RelayOutcome> relay(String messageId) async {
    UploadCompletion.sweep(_messages, cachePath: _cachePath);
    final message = _messages.message(messageId);
    if (message == null) return RelayOutcome.gone;
    if (message.state == MessageInProgressState.failed) {
      return RelayOutcome.gone;
    }
    if (UploadDeadline.passed(message, now: _clock())) {
      return _giveUp(message);
    }
    final files = _messages.files(messageId);
    final complete =
        message.state == MessageInProgressState.uploading &&
        files.isNotEmpty &&
        files.every((file) => file.isComplete);
    if (!complete) return RelayOutcome.later;
    try {
      await _poster.post(message, files);
    } on EkkloApiException catch (error) {
      return switch (error.statusCode) {
        >= _firstServerErrorStatus => RelayOutcome.later,
        _ => _giveUp(message),
      };
    } on EkkloException {
      return RelayOutcome.later;
    } on FormatException {
      return _giveUp(message);
    }
    await _notifications.cancel(messageId);
    _messages.delete(messageId);
    _folder.delete(messageId);
    return RelayOutcome.posted;
  }

  Future<RelayOutcome> _giveUp(MessageInProgress message) async {
    _messages.save(message.copyWith(state: MessageInProgressState.failed));
    await _notifications.showFailed(
      message.id,
      conversationId: message.conversationId,
    );
    return RelayOutcome.gaveUp;
  }
}
