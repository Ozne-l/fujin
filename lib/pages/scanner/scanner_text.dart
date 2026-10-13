import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class ScannerText {
  static const _referenceGrams = 100;

  static String foodLine(AppLocalizations l10n, MfpFood food) =>
      EntryText.branded(l10n, food.brandName, _energy(l10n, food));

  static String _energy(AppLocalizations l10n, MfpFood food) => switch ((
    food.nutrients?.energy?.kilocalories,
    food.servingSizes
        .where((serving) => isGramUnit(serving.unit) && serving.value > 0)
        .firstOrNull,
    food.servingSizes.firstOrNull,
    AddText.kilocalories(food),
  )) {
    (final energy?, final grams?, _, _) => l10n.scannerPer100Grams(
      energy *
          (grams.nutritionMultiplier ?? AddText.baseMultiplier) /
          grams.value *
          _referenceGrams,
    ),
    (_, null, final first?, final kilocalories?) => l10n.scannerServingEnergy(
      AddText.serving(l10n, first),
      l10n.kilocalories(kilocalories),
    ),
    (_, _, final first?, _) => AddText.serving(l10n, first),
    (_, _, null, _) => '',
  };
}
