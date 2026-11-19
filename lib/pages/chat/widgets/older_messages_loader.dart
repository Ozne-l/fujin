import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:motor/motor.dart';

class OlderMessagesLoader extends StatelessWidget {
  const OlderMessagesLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colour = context.colors.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FujinSpace.s1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: FujinSpace.s2,
        children: [
          SequenceMotionBuilder<int, double>(
            sequence: FujinMotion.spinTurns,
            converter: MotionConverter.single,
            builder: (context, turns, _, child) =>
                Transform.rotate(angle: turns * 2 * pi, child: child),
            child: MediaGlyph(
              ChatMediaIcon.loader,
              size: FujinSize.tileIcon,
              color: colour,
            ),
          ),
          Flexible(
            child: Text(
              context.intl.chatLoadingOlder,
              style: FujinText.inter12Regular.copyWith(color: colour),
            ),
          ),
        ],
      ),
    );
  }
}
