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

  static const double _height = 56;
  static const double _bar = 3;
  static const double _barHeight = 36;
  static const double _gap = 10;
  static const double _lineGap = 2;
  static const double _cancel = 40;
  static const double _cancelIcon = 20;
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
        height: _height,
        child: Padding(
          padding: const EdgeInsets.only(left: FujinSpace.s3),
          child: Row(
            spacing: _gap,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: bar,
                  borderRadius: BorderRadius.circular(FujinRadius.pill),
                ),
                child: const SizedBox(width: _bar, height: _barHeight),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: _lineGap,
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
                  size: _cancelIcon,
                  color: colors.textPrimary,
                ),
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(_cancel),
                  minimumSize: const Size.square(_cancel),
                ).copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
