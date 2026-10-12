import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_size.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class FoodIdentity extends StatelessWidget {
  const FoodIdentity({required this.food, this.barcode, super.key});

  final MfpFood food;
  final String? barcode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final secondary = FujinText.inter13Regular.copyWith(
      color: FujinColorRole.textSecondary,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.textInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s2,
        children: [
          Row(
            spacing: FujinSpace.s2,
            children: [
              const SourceDot(color: FujinColorRole.sourceMfp),
              Text(
                l10n.sourceMyFitnessPal,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            food.description,
            style: FujinText.hina28.copyWith(color: FujinColorRole.textPrimary),
          ),
          Wrap(
            spacing: FujinSpace.s2,
            runSpacing: FujinSpace.s1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (food.brandName case final brand? when brand.isNotEmpty)
                Text(brand, style: secondary),
              switch (food.verified ?? false) {
                true => StatusPill(
                  label: l10n.addVerified,
                  tone: PillTone.validated,
                  icon: Icons.check,
                  size: PillSize.small,
                ),
                false => StatusPill(
                  label: l10n.addUnverified,
                  tone: PillTone.muted,
                  size: PillSize.small,
                ),
              },
              if (barcode case final barcode?)
                Text(l10n.addEan(barcode), style: secondary),
            ],
          ),
        ],
      ),
    );
  }
}
