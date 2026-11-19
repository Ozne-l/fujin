import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/widgets.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/chat/widgets/reply_quote.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';

abstract final class MessageExcerpt {
  static const int _deletionLength = 80;
  static const String _ellipsis = '…';

  static MediaReply reply(
    AppLocalizations intl,
    EkkloMessage message, {
    required bool mine,
    required String coach,
  }) => MediaReply(
    messageId: message.id,
    title: switch (mine) {
      true => intl.chatReplyToYou,
      false => intl.chatReplyTo(coach),
    },
    excerpt: ReplyQuote.line(
      intl,
      ReplyQuote.of(message),
      message,
    ).$2,
    mine: mine,
  );

  static String deletion(AppLocalizations intl, EkkloMessage message) =>
      switch ((message.kind, message.media)) {
        (EkkloMessageKind.text, _) => _shortened(message.content),
        (EkkloMessageKind.voice, _) => intl.chatVoice,
        (EkkloMessageKind.unsupported, _) ||
        (EkkloMessageKind.media, []) => intl.chatUnsupportedTitle,
        (EkkloMessageKind.media, final media) => switch ({
          for (final item in media) item.kind,
        }) {
          Set(length: 1, first: EkkloMediaKind.image) =>
            intl.chatNotificationPhotos(media.length),
          Set(length: 1, first: EkkloMediaKind.video) =>
            intl.chatNotificationVideos(media.length),
          Set(length: 1, first: EkkloMediaKind.voice) => intl.chatVoice,
          _ => intl.chatNotificationMedia(media.length),
        },
      };

  static String _shortened(String text) => switch (text.trim().characters) {
    final characters when characters.length > _deletionLength =>
      '${characters.take(_deletionLength).toString().trimRight()}$_ellipsis',
    final characters => '$characters',
  };
}
