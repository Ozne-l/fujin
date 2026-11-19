import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class CannotReplyNote extends StatelessWidget {
  const CannotReplyNote({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: FujinSpace.s2,
      children: [
        Icon(
          Icons.lock_outline,
          size: FujinSize.tileIcon,
          color: context.colors.textSecondary,
        ),
        Flexible(
          child: Text(
            context.intl.chatCannotReply,
            style: FujinText.inter13Regular.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    ),
  );
}
