import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat/message_delivery.dart';
import 'package:fujin/pages/chat/thread_item.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:fujin/pages/chat/widgets/media_gallery.dart';
import 'package:fujin/pages/chat/widgets/reply_quote.dart';
import 'package:fujin/pages/chat/widgets/unsupported_card.dart';
import 'package:fujin/pages/chat/widgets/voice_bubble.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({
    required this.item,
    required this.coachName,
    required this.onOpenMedia,
    super.key,
  });

  final ThreadMessage item;
  final String coachName;
  final ValueChanged<int> onOpenMedia;

  static const double _captionInset = 10;

  @override
  Widget build(BuildContext context) {
    final message = item.message;
    final mine = item.mine;
    final quote = switch (message.replyTo) {
      null => null,
      final reply => ReplyQuote(
        reply: reply,
        mine: item.quotesMine,
        coachName: coachName,
        quoted: item.quoted,
      ),
    };
    final caption = switch (message.content) {
      '' => null,
      final content => Text(
        content,
        style: FujinText.inter15RegularL22.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
    };

    Widget textBubble(Widget? text) => ChatBubble(
      mine: mine,
      failed: item.delivery == MessageDelivery.failed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSpace.s2,
        children: [?quote, ?text],
      ),
    );

    final visual = [
      for (final media in message.media)
        if (media.kind != EkkloMediaKind.voice) media,
    ];

    return switch (message.kind) {
      EkkloMessageKind.text => textBubble(caption),
      EkkloMessageKind.unsupported => const UnsupportedCard(),
      EkkloMessageKind.voice => switch (message.media) {
        [final voice, ...] => VoiceBubble(url: voice.url, mine: mine),
        [] => const UnsupportedCard(),
      },
      EkkloMessageKind.media when mine => ChatBubble(
        mine: mine,
        padding: ChatBubble.mediaPadding,
        child: SizedBox(
          width: MediaGallery.widthOf(visual),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s2,
            children: [
              ?quote,
              MediaGallery(media: visual, onOpen: onOpenMedia),
              if (caption case final caption?)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _captionInset,
                  ),
                  child: caption,
                ),
            ],
          ),
        ),
      ),
      EkkloMessageKind.media => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s1,
        children: [
          if (quote != null || caption != null) textBubble(caption),
          MediaGallery(media: visual, onOpen: onOpenMedia),
        ],
      ),
    };
  }
}
