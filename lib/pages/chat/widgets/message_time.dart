import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';

class MessageTime extends StatelessWidget {
  const MessageTime({required this.at, super.key});

  final DateTime at;

  @override
  Widget build(BuildContext context) => Text(
    ChatText.time(context.intl, at),
    style: FujinText.inter11Regular.copyWith(
      color: context.colors.textTertiary,
    ),
  );
}
