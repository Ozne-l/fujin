import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/common/fujin_glass_button.dart';
import 'package:fujin/pages/common/fujin_glass_button_size.dart';
import 'package:fujin/pages/common/glass_layer.dart';
import 'package:motor/motor.dart';

class JumpToBottomButton extends HookWidget {
  const JumpToBottomButton({
    required this.controller,
    required this.unread,
    required this.onPressed,
    super.key,
  });

  final ScrollController controller;
  final ValueListenable<int> unread;
  final VoidCallback onPressed;

  static const String _icon = 'assets/icons/arrow_down.svg';
  static const double _hiddenScale = 0.6;
  static const EdgeInsets _badgePadding = EdgeInsets.symmetric(
    horizontal: FujinSize.badgePaddingHorizontal,
    vertical: FujinSize.badgePaddingVertical,
  );

  static bool _away(ScrollController controller) => switch (controller) {
    ScrollController(hasClients: false) => false,
    ScrollController(:final position) =>
      position.hasContentDimensions &&
          position.hasViewportDimension &&
          position.pixels > position.viewportDimension,
  };

  @override
  Widget build(BuildContext context) {
    useListenable(controller);
    final count = useValueListenable<int>(unread);
    final visible = _away(controller);
    final reduced = FujinMotion.reduced(context);
    final intl = context.intl;
    final badge = ChatText.badge(intl, count);
    final button = GlassLayer(
      child: FujinGlassButton(
        icon: _icon,
        label: intl.chatJumpToLatest(count),
        onPressed: onPressed,
        size: FujinGlassButtonSize.small,
      ),
    );
    return SingleMotionBuilder(
      motion: FujinMotion.dissolveOf(context, FujinMotion.pop),
      value: switch (visible) {
        true => 1,
        false => 0,
      },
      builder: (context, shown, child) => switch (shown) {
        <= 0 => const SizedBox.shrink(),
        _ => IgnorePointer(
          ignoring: !visible,
          child: ExcludeSemantics(
            excluding: !visible,
            child: Opacity(
              opacity: shown.clamp(0, 1),
              child: Transform.scale(
                scale: switch (reduced) {
                  true => 1,
                  false => _hiddenScale + (1 - _hiddenScale) * shown,
                },
                child: child,
              ),
            ),
          ),
        ),
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          if (badge case final badge?)
            PositionedDirectional(
              end: 0,
              top: -FujinSize.badgeRise,
              child: ExcludeSemantics(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: context.colors.backgroundAccent,
                  ),
                  child: Padding(
                    padding: _badgePadding,
                    child: Text(
                      badge,
                      maxLines: 1,
                      style: FujinText.inter11Semibold.copyWith(
                        color: context.colors.textOnAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
