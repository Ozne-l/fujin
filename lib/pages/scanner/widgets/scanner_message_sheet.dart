import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/sheet_card.dart';
import 'package:fujin/pages/common/sheet_pictogram.dart';

class ScannerMessageSheet extends StatelessWidget {
  const ScannerMessageSheet({
    required this.icon,
    required this.title,
    required this.detail,
    required this.primary,
    this.secondary,
    this.tone = PillTone.neutral,
    super.key,
  });

  final Widget icon;
  final PillTone tone;
  final String title;
  final String detail;
  final (String, VoidCallback) primary;
  final (String, VoidCallback)? secondary;

  @override
  Widget build(BuildContext context) {
    final (primaryLabel, onPrimary) = primary;
    return SheetCard(
      handle: true,
      spacing: FujinSpace.s3,
      children: [
        SheetPictogram(icon: icon, tone: tone),
        Text(
          title,
          style: FujinText.hina24.copyWith(color: context.colors.textPrimary),
        ),
        Text(
          detail,
          style: FujinText.inter15Regular.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: FujinSpace.s1),
        FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
        if (secondary case (final label, final onSecondary))
          OutlinedButton(onPressed: onSecondary, child: Text(label)),
      ],
    );
  }
}
