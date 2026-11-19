import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/glass_text_field.dart';

typedef ComposerButton = Widget Function(VoidCallback? onPressed);

class ChatComposer extends HookWidget {
  const ChatComposer({
    required this.controller,
    this.onSend,
    this.onVoice,
    this.media,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSend;
  final VoidCallback? onVoice;
  final Widget Function(BuildContext context, ComposerButton button)? media;

  static const double _icon = 22;
  static const double _mediaInset =
      (FujinSize.field - FujinSize.searchField) / 2;
  static const double _actionInset =
      (FujinSize.field - FujinSize.touchTarget) / 2;

  @override
  Widget build(BuildContext context) {
    useListenable(controller);
    final text = controller.text.trim();
    final colors = context.colors;

    Widget mediaButton(VoidCallback? onPressed) => Semantics(
      button: true,
      enabled: onPressed != null,
      label: context.intl.chatMedia,
      excludeSemantics: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: FujinSize.searchField,
          child: Center(
            child: MediaGlyph(
              ChatMediaIcon.image,
              size: _icon,
              color: GlassFinish.clear.foreground(colors),
            ),
          ),
        ),
      ),
    );

    final (actionIcon, actionLabel, action) = switch ((text, onSend, onVoice)) {
      ('', _, final onVoice?) => (
        ChatMediaIcon.mic,
        context.intl.chatVoice,
        onVoice,
      ),
      ('', _, null) || (_, null, _) => (
        ChatMediaIcon.send,
        context.intl.chatSend,
        null,
      ),
      (_, final onSend?, _) => (
        ChatMediaIcon.send,
        context.intl.chatSend,
        () => onSend(text),
      ),
    };
    final actionFinish = switch (text) {
      '' => GlassFinish.clear,
      _ => GlassFinish.ink,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: FujinSpace.s2,
      children: [
        Expanded(
          child: GlassTextField(
            controller: controller,
            hint: context.intl.chatComposerHint,
            endInset: FujinSpace.s1,
            trailing: switch (media) {
              final media? => Padding(
                padding: const EdgeInsets.only(bottom: _mediaInset),
                child: media(context, mediaButton),
              ),
              null => null,
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: _actionInset),
          child: Semantics(
            button: true,
            enabled: action != null,
            label: actionLabel,
            excludeSemantics: true,
            onTap: action,
            child: IconButton(
              onPressed: action,
              icon: MediaGlyph(
                actionIcon,
                size: _icon,
                color: switch (action) {
                  null => colors.buttonDisabledText,
                  _ => actionFinish.foreground(colors),
                },
              ),
              style: GlassFill.style(colors, actionFinish, floating: true)
                  .merge(
                    IconButton.styleFrom(
                      fixedSize: const Size.square(FujinSize.touchTarget),
                    ),
                  )
                  .copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
            ),
          ),
        ),
      ],
    );
  }
}
