import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/domain/chat/upload/post_outcome.dart';
import 'package:fujin/domain/chat/upload/posted_message.dart';
import 'package:fujin/domain/chat/upload/upload_deadline.dart';

final class MessagePoster {
  const MessagePoster({
    required this._messaging,
    required this._messages,
    required this._notifications,
    required this._folder,
    required this._clock,
  });

  final EkkloMessaging _messaging;
  final MessageInProgressRepository _messages;
  final UploadNotifications _notifications;
  final UploadFolder _folder;
  final DateTime Function() _clock;

  Future<PostOutcome> post(String messageId) async {
    final message = _messages.message(messageId);
    if (message == null || message.state == MessageInProgressState.failed) {
      return const MessageGone();
    }
    if (UploadDeadline.passed(message, now: _clock())) return giveUp(message);
    final files = _messages.files(messageId);
    final ready =
        message.state == MessageInProgressState.uploading &&
        files.isNotEmpty &&
        files.every((file) => file.isComplete);
    if (!ready) return const MessageNotReady();
    final EkkloMessage sent;
    try {
      sent = await _send(message, files);
    } on EkkloException catch (error) {
      return switch (error) {
        EkkloNetworkException() => const MessageWaiting(),
        EkkloAuthException() ||
        EkkloApiException() ||
        EkkloUnexpectedResponseException() => await giveUp(message),
      };
    } on FormatException {
      return giveUp(message);
    }
    await _notifications.cancel(messageId);
    _messages.delete(messageId);
    _folder.delete(messageId);
    return MessagePosted(sent);
  }

  Future<PostOutcome> giveUp(MessageInProgress message) async {
    _messages.save(message.copyWith(state: MessageInProgressState.failed));
    await _notifications.showFailed(
      message.id,
      conversationId: message.conversationId,
    );
    return const MessageGivenUp();
  }

  Future<EkkloMessage> _send(
    MessageInProgress message,
    List<FileInProgress> files,
  ) async {
    final urls = [for (final file in files) ?file.publicUrl];
    final page = await _messaging.messages(message.conversationId);
    if (postedMessage(page.messages, urls) case final posted?) return posted;
    return switch ((files, message.durationSeconds)) {
      (
        [FileInProgress(kind: ChatMediaKind.voice, publicUrl: final url?)],
        final seconds?,
      ) =>
        _messaging.sendVoice(
          message.conversationId,
          url: Uri.parse(url),
          durationSeconds: seconds,
          replyToId: message.replyToId,
        ),
      ([FileInProgress(kind: ChatMediaKind.voice)], null) =>
        throw const FormatException(),
      _ => _messaging.sendMedia(
        message.conversationId,
        [
          for (final file in files)
            if (file.publicUrl case final url?)
              EkkloDirectMedia(
                url: Uri.parse(url),
                mediaType: switch (file.kind) {
                  ChatMediaKind.video => EkkloDirectMediaType.video,
                  ChatMediaKind.image ||
                  ChatMediaKind.voice => EkkloDirectMediaType.image,
                },
              ),
        ],
        caption: message.caption,
        replyToId: message.replyToId,
      ),
    };
  }
}
