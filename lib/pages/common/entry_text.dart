import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class EntryText {
  static String serving(AppLocalizations intl, MfpFoodEntry entry) =>
      intl.servingLine(
        entry.servings,
        entry.servingSize.value,
        entry.servingSize.unit,
      );

  static String brandedServing(AppLocalizations intl, MfpFoodEntry entry) =>
      branded(intl, entry.food.brandName, serving(intl, entry));

  static String branded(
    AppLocalizations intl,
    String? brand,
    String serving,
  ) => switch (brand?.trim()) {
    null || '' => serving,
    final brand => intl.brandedServingLine(brand, serving),
  };

  static String linkedServing(AppLocalizations intl, SentLink link) =>
      intl.inEkkloAs(
        intl.servingLine(
          link.mfpServings,
          link.mfpServingValue,
          link.mfpServingUnit,
        ),
      );

  static String energy(AppLocalizations intl, MfpFoodEntry entry) =>
      intl.kilocalories(entry.nutrients.energy?.kilocalories ?? 0);

  static String macros(AppLocalizations intl, MfpNutrients nutrients) {
    String amount(double? grams) => switch (grams) {
      null => intl.macroUnknown,
      final grams => intl.macroValue(grams),
    };
    return intl.macros(
      amount(nutrients.protein),
      amount(nutrients.carbohydrates),
      amount(nutrients.fat),
      amount(nutrients.fiber),
    );
  }
}
