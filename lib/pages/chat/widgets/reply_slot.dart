import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat/widgets/bottom_switcher.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';
import 'package:fujin/pages/chat_media/widgets/tray_reply_card.dart';

class ReplySlot extends StatelessWidget {
  const ReplySlot({required this.reply, required this.onCancel, super.key});

  static const Offset _rise = Offset(0, 0.25);

  final MediaReply? reply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final reduced = FujinMotion.reduced(context);
    final motion = switch (reduced) {
      true => FujinMotion.dissolve,
      false => FujinMotion.grow,
    };
    return AnimatedSwitcher(
      duration: motion.duration,
      switchInCurve: motion.curve,
      switchOutCurve: motion.curve,
      layoutBuilder: BottomSwitcher.layout,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: switch (reduced) {
          true => child,
          false => SlideTransition(
            position: Tween(begin: _rise, end: Offset.zero).animate(animation),
            child: child,
          ),
        },
      ),
      child: switch (reply) {
        final reply? => Padding(
          key: const ValueKey(true),
          padding: const EdgeInsets.only(bottom: FujinSpace.s2),
          child: TrayReplyCard(reply: reply, onCancel: onCancel),
        ),
        null => const SizedBox.shrink(key: ValueKey(false)),
      },
    );
  }
}
