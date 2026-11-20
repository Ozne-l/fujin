import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/reply_quote.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';
import 'package:fujin/pages/common/glass_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class TrayReplyCard extends ConsumerWidget {
  const TrayReplyCard({required this.reply, required this.onCancel, super.key});

  static const LiquidRoundedSuperellipse _shape = LiquidRoundedSuperellipse(
    borderRadius: FujinRadius.field,
  );

  final MediaReply reply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final brightness = Theme.of(context).brightness;
    final (bar, title) = ReplyQuote.colours(colors, mine: reply.mine);
    return GlassBody.ownLayer(
      settings: FujinGlass.control(brightness),
      shape: _shape,
      reduced: FujinGlass.reduced(context, ref),
      opaque: Color.alphaBlend(colors.backgroundGlass, colors.backgroundCard),
      fill: colors.backgroundGlass,
      child: SizedBox(
        height: FujinSize.replyCardHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: FujinSpace.s3),
          child: Row(
            spacing: FujinSize.replyBarGap,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: bar,
                  borderRadius: BorderRadius.circular(FujinRadius.pill),
                ),
                child: const SizedBox(
                  width: FujinSize.replyBar,
                  height: FujinSize.replyCardBarHeight,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: FujinSize.chatLineGap,
                  children: [
                    Text(
                      reply.title,
                      style: FujinText.inter12Semibold.copyWith(
                        color: title,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      reply.excerpt,
                      style: FujinText.inter13Regular.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onCancel,
                tooltip: context.intl.chatTrayCancelReply,
                icon: Icon(
                  Icons.close,
                  size: FujinSize.replyCancelIcon,
                  color: colors.textPrimary,
                ),
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(FujinSize.replyCancel),
                  minimumSize: const Size.square(FujinSize.replyCancel),
                ).copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
