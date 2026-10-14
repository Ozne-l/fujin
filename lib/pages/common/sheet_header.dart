import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    required this.title,
    this.subtitle,
    this.titleStyle = FujinText.hina28,
    super.key,
  });

  final String title;
  final String? subtitle;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: FujinSpace.s3,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: FujinSpace.s1,
          children: [
            Text(
              title,
              style: titleStyle.copyWith(color: FujinColorRole.textPrimary),
            ),
            if (subtitle case final subtitle?)
              Text(
                subtitle,
                style: FujinText.inter13Regular.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
          ],
        ),
      ),
      FujinIconButton(
        icon: Icons.close,
        tooltip: context.intl.close,
        onPressed: Navigator.of(context).pop,
      ),
    ],
  );
}
