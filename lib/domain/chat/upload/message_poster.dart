import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/domain/chat/upload/posted_message.dart';

final class MessagePoster {
  const MessagePoster(this._messaging);

  final EkkloMessaging _messaging;

  Future<EkkloMessage> post(
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
