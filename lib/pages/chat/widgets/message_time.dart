import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:motor/motor.dart';

class MessageTime extends StatelessWidget {
  const MessageTime({required this.at, this.seen = false, super.key});

  final DateTime at;
  final bool seen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: FujinSpace.s1,
      children: [
        Text(
          ChatText.time(context.intl, at),
          style: FujinText.inter11Regular.copyWith(color: colors.textTertiary),
        ),
        SingleMotionBuilder(
          motion: FujinMotion.dissolve,
          value: switch (seen) {
            true => 1,
            false => 0,
          },
          builder: (context, opacity, child) => switch (opacity > 0) {
            true => Opacity(opacity: opacity.clamp(0, 1), child: child),
            false => const SizedBox.shrink(),
          },
          child: Text(
            context.intl.chatSeen,
            style: FujinText.inter11Medium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
