import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class AddStatePanel extends StatelessWidget {
  const AddStatePanel({
    required this.icon,
    required this.title,
    required this.detail,
    this.alert = false,
    this.action,
    this.note,
    this.actionIcon = Icons.refresh,
    super.key,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool alert;
  final (String, VoidCallback)? action;
  final String? note;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      FujinSize.textInset,
      FujinSpace.s8,
      FujinSize.textInset,
      FujinSpace.s4,
    ),
    child: Column(
      spacing: FujinSpace.s3,
      children: [
        Container(
          width: FujinSize.pictogram + FujinSpace.s3,
          height: FujinSize.pictogram + FujinSpace.s3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: switch (alert) {
              true => context.colors.backgroundAlert,
              false => context.colors.borderCard,
            },
          ),
          child: Icon(
            icon,
            size: FujinSize.pictogramIcon,
            color: switch (alert) {
              true => context.colors.textAlert,
              false => context.colors.textSecondary,
            },
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: FujinText.hina22.copyWith(color: context.colors.textPrimary),
        ),
        Text(
          detail,
          textAlign: TextAlign.center,
          style: FujinText.inter15Regular.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        if (action case (final label, final onPressed))
          FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(actionIcon),
            label: Text(label),
          ),
        if (note case final note?)
          Text(
            note,
            style: FujinText.inter12Regular.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
      ],
    ),
  );
}
