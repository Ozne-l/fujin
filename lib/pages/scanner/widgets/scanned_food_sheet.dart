import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/store_code.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/pill_size.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/sheet_card.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/scanner/scanner_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class ScannedFoodSheet extends StatelessWidget {
  const ScannedFoodSheet({
    required this.code,
    required this.food,
    required this.remembered,
    required this.onConfirm,
    required this.onSearch,
    super.key,
  });

  final String code;
  final MfpFood food;
  final bool remembered;
  final VoidCallback onConfirm;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final storeCode = isStoreCode(code);
    final verified = food.verified ?? false;
    final details = [
      if (!verified) context.intl.scannerUnverifiedDetail,
      if (storeCode) context.intl.scannerStoreCodeDetail,
    ];
    return SheetCard(
      handle: true,
      spacing: FujinSpace.s3,
      children: [
        Row(
          spacing: FujinSpace.s2,
          children: switch (remembered) {
            true => [
              const SourceDot(color: FujinColorRole.textLink),
              Flexible(
                child: Text(
                  context.intl.scannerFromMemory,
                  style: FujinText.inter12Medium.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ),
            ],
            false => [
              const SourceDot(color: FujinColorRole.sourceMfp),
              Text(
                context.intl.sourceMyFitnessPal,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
              Flexible(
                child: Text(
                  context.intl.scannerFoundByBarcode,
                  style: FujinText.inter12Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ),
            ],
          },
        ),
        Text(
          food.description,
          style: FujinText.hina24.copyWith(color: FujinColorRole.textPrimary),
        ),
        Text(
          ScannerText.foodLine(context.intl, food),
          style: FujinText.inter15Regular.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
        Wrap(
          spacing: FujinSpace.s2,
          runSpacing: FujinSpace.s1,
          children: [
            switch (verified) {
              true => StatusPill(
                label: context.intl.addVerified,
                tone: PillTone.validated,
                icon: Icons.check,
                size: PillSize.small,
              ),
              false => StatusPill(
                label: context.intl.addUnverified,
                tone: PillTone.attention,
                size: PillSize.small,
              ),
            },
            switch (storeCode) {
              true => StatusPill(
                label: context.intl.scannerStoreCode,
                tone: PillTone.error,
                icon: Icons.warning_amber_rounded,
                size: PillSize.small,
              ),
              false => StatusPill(
                label: context.intl.addEan(code),
                tone: PillTone.muted,
                size: PillSize.small,
              ),
            },
          ],
        ),
        for (final detail in details)
          Text(
            detail,
            style: FujinText.inter15Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        const SizedBox(height: FujinSpace.s1),
        FilledButton(
          onPressed: onConfirm,
          child: Text(context.intl.scannerThisProduct),
        ),
        TextButton(
          onPressed: onSearch,
          child: Text(context.intl.scannerWrongProduct),
        ),
      ],
    );
  }
}
