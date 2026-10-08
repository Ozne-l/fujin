import 'package:flutter/widgets.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class EntryText {
  static String serving(AppLocalizations l10n, MfpFoodEntry entry) =>
      l10n.servingLine(
        entry.servings,
        entry.servingSize.value,
        entry.servingSize.unit,
      );

  static String brandedServing(AppLocalizations l10n, MfpFoodEntry entry) =>
      switch (entry.food.brandName) {
        null || '' => serving(l10n, entry),
        final brand => l10n.brandedServingLine(brand, serving(l10n, entry)),
      };

  static String energy(AppLocalizations l10n, MfpFoodEntry entry) =>
      l10n.kilocalories(entry.nutrients.energy?.kilocalories ?? 0);

  static String macros(AppLocalizations l10n, MfpNutrients nutrients) {
    String amount(double? grams) => switch (grams) {
      null => l10n.macroUnknown,
      final grams => l10n.macroValue(grams),
    };
    return l10n.macros(
      amount(nutrients.protein),
      amount(nutrients.carbohydrates),
      amount(nutrients.fat),
      amount(nutrients.fiber),
    );
  }

  static String capitalized(String text) => switch (text) {
    '' => text,
    _ => '${text.characters.first.toUpperCase()}${text.characters.skip(1)}',
  };
}
