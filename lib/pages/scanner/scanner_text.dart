import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class ScannerText {
  static const _referenceGrams = 100;

  static String foodLine(AppLocalizations intl, MfpFood food) =>
      EntryText.branded(intl, food.brandName, _energy(intl, food));

  static String _energy(AppLocalizations intl, MfpFood food) => switch ((
    food.nutrients?.energy?.kilocalories,
    food.servingSizes
        .where((serving) => isGramUnit(serving.unit) && serving.value > 0)
        .firstOrNull,
    food.servingSizes.firstOrNull,
    AddText.kilocalories(food),
  )) {
    (final energy?, final grams?, _, _) => intl.scannerPer100Grams(
      energy *
          (grams.nutritionMultiplier ?? AddText.baseMultiplier) /
          grams.value *
          _referenceGrams,
    ),
    (_, null, final first?, final kilocalories?) => intl.scannerServingEnergy(
      AddText.serving(intl, first),
      intl.kilocalories(kilocalories),
    ),
    (_, _, final first?, _) => AddText.serving(intl, first),
    (_, _, null, _) => '',
  };
}
