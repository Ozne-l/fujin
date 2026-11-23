import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/domain/chat/upload/upload_phase.dart';
import 'package:fujin/domain/chat/upload/uploading_media.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/thread_item.dart';
import 'package:fujin/pages/chat/upload/upload_tile.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:fujin/pages/chat/widgets/media_gallery.dart';
import 'package:fujin/pages/chat/widgets/message_row.dart';
import 'package:fujin/pages/chat/widgets/message_status.dart';
import 'package:fujin/pages/chat/widgets/reply_quote.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/failure_shake.dart';

class UploadBubble extends StatelessWidget {
  const UploadBubble({
    required this.item,
    required this.coachName,
    required this.onRetry,
    super.key,
  });

  final ThreadUpload item;
  final String coachName;
  final VoidCallback onRetry;

  static const int _bytesPerMegabyte = 1000000;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    final upload = item.upload;
    final failed = upload.phase is UploadNotSent;
    final body = FujinText.inter15RegularL22.copyWith(
      color: colors.textPrimary,
    );
    final quote = switch (item.quoted) {
      null => null,
      final quoted => ReplyQuote(
        reply: ReplyQuote.of(quoted),
        mine: item.quotesMine,
        coachName: coachName,
        quoted: quoted,
      ),
    };
    final content = switch (upload) {
      MessageUpload(
        media: [UploadingMedia(kind: ChatMediaKind.voice)],
        durationSeconds: final seconds?,
      ) =>
        ChatBubble(
          mine: true,
          failed: failed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s2,
            children: [
              ?quote,
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: FujinSpace.s2,
                children: [
                  MediaGlyph(
                    ChatMediaIcon.mic,
                    size: FujinSize.uploadVoiceIcon,
                    color: colors.textPrimary,
                  ),
                  Text(
                    ChatText.clock(Duration(seconds: seconds)),
                    semanticsLabel: intl.chatVoice,
                    style: body,
                  ),
                ],
              ),
            ],
          ),
        ),
      MessageUpload(:final media) => ChatBubble(
        mine: true,
        failed: failed,
        padding: ChatBubble.mediaPadding,
        child: SizedBox(
          width: MediaGallery.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s2,
            children: [
              ?quote,
              switch (media) {
                [final only] => UploadTile(media: only, single: true),
                _ => Wrap(
                  spacing: FujinSpace.s1,
                  runSpacing: FujinSpace.s1,
                  children: [
                    for (final item in media)
                      UploadTile(media: item, single: false),
                  ],
                ),
              },
              if (upload.caption case final caption when caption.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FujinSize.bubbleCaptionInset,
                  ),
                  child: Text(caption, style: body),
                ),
            ],
          ),
        ),
      ),
    };
    final quiet = FujinText.inter11Regular.copyWith(
      color: colors.textSecondary,
    );
    final status = switch (upload.phase) {
      UploadNotSent() => MessageStatus.failed(onRetry: onRetry),
      UploadPreparing(:final videos, :final percent) => Text(
        intl.chatUploadPreparing(videos, percent),
        style: quiet,
      ),
      UploadSending(waiting: true) => Text(
        intl.chatUploadNotificationWaiting,
        style: quiet,
      ),
      UploadSending(:final percent) => Text(
        intl.chatUploadSending(upload.media.length, percent),
        style: quiet,
      ),
    };
    final notice = switch ((failed, upload.originalBytes)) {
      (false, final bytes?) => ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: FujinSize.uploadNoticeWidth,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: FujinSpace.s1,
          children: [
            MediaGlyph(
              ChatMediaIcon.alert,
              size: FujinSize.uploadNoticeIcon,
              color: colors.textGold,
            ),
            Flexible(
              child: Text(
                intl.chatUploadOriginalSize(
                  (bytes / _bytesPerMegabyte).round(),
                ),
                style: FujinText.inter12Regular.copyWith(
                  color: colors.textGold,
                ),
              ),
            ),
          ],
        ),
      ),
      _ => null,
    };
    return MessageRow(
      mine: true,
      content: content,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSpace.s1,
        children: [
          FailureShake(failed: failed, buzz: true, child: status),
          ?notice,
        ],
      ),
    );
  }
}
