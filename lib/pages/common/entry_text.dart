import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/foods/food_nutrients.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class EntryText {
  static const _macroDecimals = 1;

  static String serving(AppLocalizations intl, LoggedEntry logged) =>
      intl.servingLine(
        logged.entry.servings,
        logged.entry.servingValue,
        logged.entry.servingUnit,
      );

  static String brandedServing(AppLocalizations intl, LoggedEntry logged) =>
      branded(intl, logged.brand, serving(intl, logged));

  static String branded(
    AppLocalizations intl,
    String? brand,
    String serving,
  ) => switch (brand?.trim()) {
    null || '' => serving,
    final brand => intl.brandedServingLine(brand, serving),
  };

  static String linkServing(AppLocalizations intl, LinkedItem item) =>
      intl.servingLine(item.servings, item.servingValue, item.servingUnit);

  static String linkedServing(AppLocalizations intl, LinkedItem item) =>
      intl.inEkkloAs(linkServing(intl, item));

  static String energy(AppLocalizations intl, LoggedEntry logged) =>
      intl.kilocalories(logged.entry.nutrients.kilocalories ?? 0);

  static String macro(AppLocalizations intl, double grams) =>
      intl.macroValue(double.parse(grams.toStringAsFixed(_macroDecimals)));

  static String macros(AppLocalizations intl, FoodNutrients nutrients) {
    String amount(double? grams) => switch (grams) {
      null => intl.macroUnknown,
      final grams => macro(intl, grams),
    };
    return intl.macros(
      amount(nutrients.protein),
      amount(nutrients.carbohydrates),
      amount(nutrients.fat),
      amount(nutrients.fiber),
    );
  }
}
