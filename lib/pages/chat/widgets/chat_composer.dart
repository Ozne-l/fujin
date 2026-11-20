import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/glass_text_field.dart';
import 'package:motor/motor.dart';

class ChatComposer extends HookWidget {
  const ChatComposer({
    required this.controller,
    this.onSend,
    this.onVoice,
    this.media,
    this.fieldKey,
    this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSend;
  final VoidCallback? onVoice;
  final Widget Function(
    BuildContext context,
    Widget Function(VoidCallback? onPressed) button,
  )?
  media;
  final GlobalKey? fieldKey;
  final FocusNode? focusNode;

  static const double _mediaInset =
      (FujinSize.field - FujinSize.searchField) / 2;
  static const double _actionInset =
      (FujinSize.field - FujinSize.touchTarget) / 2;

  @override
  Widget build(BuildContext context) {
    useListenable(controller);
    final text = controller.text.trim();
    final colors = context.colors;
    final reduced = FujinMotion.reduced(context);

    Widget mediaButton(VoidCallback? onPressed) =>
        _MediaButton(onPressed: onPressed);

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
            key: fieldKey,
            controller: controller,
            focusNode: focusNode,
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
              icon: AnimatedSwitcher(
                duration: FujinMotion.dissolve.duration,
                switchInCurve: FujinMotion.dissolve.curve,
                switchOutCurve: FujinMotion.dissolve.curve,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: switch (reduced) {
                    true => child,
                    false => ScaleTransition(
                      scale: Tween<double>(
                        begin: FujinMotion.swapScale,
                        end: 1,
                      ).animate(animation),
                      child: child,
                    ),
                  },
                ),
                child: MediaGlyph(
                  actionIcon,
                  key: ValueKey(actionIcon),
                  size: FujinSize.composerIcon,
                  color: switch (action) {
                    null => colors.buttonDisabledText,
                    _ => actionFinish.foreground(colors),
                  },
                ),
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

class _MediaButton extends HookWidget {
  const _MediaButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final pressed = useState(false);
    final onPressed = this.onPressed;
    final colors = context.colors;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: context.intl.chatMedia,
      excludeSemantics: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        onTapDown: (_) => pressed.value = onPressed != null,
        onTapUp: (_) => pressed.value = false,
        onTapCancel: () => pressed.value = false,
        child: SingleMotionBuilder(
          motion: FujinMotion.of(context, FujinMotion.lift),
          value: switch (pressed.value) {
            true => FujinMotion.pressShrink,
            false => 1,
          },
          builder: (context, scale, glyph) =>
              Transform.scale(scale: scale, child: glyph),
          child: SizedBox.square(
            dimension: FujinSize.searchField,
            child: Center(
              child: MediaGlyph(
                ChatMediaIcon.image,
                size: FujinSize.composerIcon,
                color: GlassFinish.clear.foreground(colors),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
