import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';
import 'package:fujin/pages/chat_media/widgets/tray_reply_card.dart';
import 'package:fujin/pages/common/rising_slot.dart';

class ReplySlot extends StatelessWidget {
  const ReplySlot({required this.reply, required this.onCancel, super.key});

  final MediaReply? reply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) => RisingSlot(
    child: switch (reply) {
      final reply? => Padding(
        padding: const EdgeInsets.only(bottom: FujinSpace.s2),
        child: TrayReplyCard(reply: reply, onCancel: onCancel),
      ),
      null => null,
    },
  );
}
