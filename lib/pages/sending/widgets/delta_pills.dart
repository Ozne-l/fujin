import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/nutrient_deltas.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/sending/send_text.dart';

class DeltaPills extends StatelessWidget {
  const DeltaPills({required this.deltas, super.key});

  final NutrientDeltas deltas;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: FujinSpace.s1,
      runSpacing: FujinSpace.s1,
      children: [
        for (final nutrient in Nutrient.values)
          StatusPill(
            label: SendText.delta(l10n, deltas, nutrient),
            tone: SendText.deltaTone(deltas, nutrient),
            small: true,
          ),
      ],
    );
  }
}
