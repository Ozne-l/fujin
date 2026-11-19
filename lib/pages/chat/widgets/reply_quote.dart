import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyQuote extends StatelessWidget {
  const ReplyQuote({
    required this.reply,
    required this.mine,
    required this.coachName,
    this.quoted,
    super.key,
  });

  final EkkloReplyTo reply;
  final bool mine;
  final String coachName;
  final EkkloMessage? quoted;

  static const double _bar = 3;
  static const double _gap = 10;
  static const double _lineGap = 2;
  static const double _inset = 6;
  static const Size _thumb = Size.square(36);

  static EkkloReplyTo of(EkkloMessage message) => EkkloReplyTo(
    id: message.id,
    senderId: message.senderId,
    content: message.content,
    type: message.type,
  );

  static (String?, String) line(
    AppLocalizations intl,
    EkkloReplyTo reply,
    EkkloMessage? quoted,
  ) => switch ((reply.deleted, reply.type, firstVisual(quoted)?.kind)) {
    (true, _, _) => (null, intl.chatQuoteDeleted),
    (false, EkkloMessageType.image, _) ||
    (false, EkkloMessageType.mixed, EkkloMediaKind.image) => (
      ChatMediaIcon.image,
      intl.chatPhoto,
    ),
    (false, EkkloMessageType.video, _) ||
    (false, EkkloMessageType.mixed, EkkloMediaKind.video || null) => (
      ChatMediaIcon.video,
      intl.chatVideo,
    ),
    (false, EkkloMessageType.audio || EkkloMessageType.voice, _) ||
    (false, EkkloMessageType.mixed, EkkloMediaKind.voice) => (
      ChatMediaIcon.mic,
      intl.chatVoice,
    ),
    (false, EkkloMessageType.text, _) => (null, reply.content ?? ''),
    (false, EkkloMessageType.unknown, _) => (
      null,
      reply.content ?? intl.chatUnsupportedTitle,
    ),
  };

  static EkkloMedia? firstVisual(EkkloMessage? message) => message?.media
      .where((media) => media.kind != EkkloMediaKind.voice)
      .firstOrNull;

  static (Color bar, Color title) colours(
    FujinColors colors, {
    required bool mine,
  }) => switch (mine) {
    true => (colors.borderFocus, colors.textLink),
    false => (colors.sourceEkklo, colors.sourceEkkloText),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    final (bar, authorColour) = colours(colors, mine: mine);
    final (icon, text) = line(intl, reply, quoted);
    final author = switch (mine) {
      true => intl.chatViewerYou,
      false => reply.senderName ?? coachName,
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(FujinRadius.tile),
      child: ColoredBox(
        color: colors.backgroundCard,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, _inset, _inset, _inset),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: _gap,
              children: [
                SizedBox(
                  width: _bar,
                  child: ColoredBox(color: bar),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: _lineGap,
                    children: [
                      Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FujinText.inter12Semibold.copyWith(
                          color: authorColour,
                        ),
                      ),
                      Row(
                        spacing: FujinSpace.s1,
                        children: [
                          if (icon case final icon?)
                            MediaGlyph(
                              icon,
                              size: FujinSize.pillSmallIcon,
                              color: colors.textSecondary,
                            ),
                          Flexible(
                            child: Text(
                              text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FujinText.inter13Regular.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (firstVisual(quoted) case final media?)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(FujinRadius.key),
                      child: _Thumbnail(media: media),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends ConsumerWidget {
  const _Thumbnail({required this.media});

  final EkkloMedia media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const size = ReplyQuote._thumb;
    return switch (media.kind) {
      EkkloMediaKind.video => switch (ref.watch(
        videoPosterProvider(media.url),
      )) {
        AsyncValue(value: final poster?) => Image.file(
          poster.file,
          width: size.width,
          height: size.height,
          fit: BoxFit.cover,
          excludeFromSemantics: true,
        ),
        AsyncValue() => SizedBox.fromSize(
          size: size,
          child: ColoredBox(color: context.colors.backgroundNeutral),
        ),
      },
      EkkloMediaKind.image ||
      EkkloMediaKind.voice => PhotoTile(url: media.url, size: size),
    };
  }
}
