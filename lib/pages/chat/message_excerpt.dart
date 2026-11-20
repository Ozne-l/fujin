import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/widgets.dart';
import 'package:fujin/app/notifications/media_label_text.dart';
import 'package:fujin/data/notifications/media_label.dart';
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
        (EkkloMessageKind.media, final media) => MediaLabelText.of(
          intl,
          MediaLabel.of(media),
        ),
      };

  static String _shortened(String text) => switch (text.trim().characters) {
    final characters when characters.length > _deletionLength =>
      '${characters.take(_deletionLength).toString().trimRight()}$_ellipsis',
    final characters => '$characters',
  };
}
