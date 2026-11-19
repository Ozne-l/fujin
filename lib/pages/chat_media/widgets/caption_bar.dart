import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/glass_text_field.dart';

class CaptionBar extends StatelessWidget {
  const CaptionBar({
    required this.controller,
    required this.onSend,
    super.key,
  });

  static const double _icon = 22;
  static const double _actionInset =
      (FujinSize.field - FujinSize.touchTarget) / 2;

  final TextEditingController controller;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: FujinSpace.s2,
      children: [
        Expanded(
          child: GlassTextField(
            controller: controller,
            hint: context.intl.chatTrayCaption,
            radius: FujinRadius.pill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: _actionInset),
          child: IconButton(
            onPressed: onSend,
            tooltip: context.intl.chatSend,
            icon: MediaGlyph(
              ChatMediaIcon.send,
              size: _icon,
              color: colors.buttonPrimaryText,
            ),
            style: IconButton.styleFrom(
              fixedSize: const Size.square(FujinSize.touchTarget),
              backgroundColor: colors.buttonPrimaryBackground,
            ).copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
          ),
        ),
      ],
    );
  }
}
