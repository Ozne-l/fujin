import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';

abstract final class MemoryText {
  static String target(AppLocalizations intl, RememberedFood food) =>
      switch (food) {
        MatchedFood(:final ekkloFoodName) => intl.memoryTarget(ekkloFoodName),
        OwnCopy() => intl.memoryOwnCopyTarget,
      };

  static String quotedUnits(AppLocalizations intl, Iterable<String> units) =>
      units.map(intl.memoryUnitQuoted).join(intl.listSeparator);

  static String macros(AppLocalizations intl, EkkloFood food) => intl.macros(
    EntryText.macro(intl, food.proteins),
    EntryText.macro(intl, food.carbs),
    EntryText.macro(intl, food.fats),
    EntryText.macro(intl, food.fiber),
  );

  static String portion(AppLocalizations intl, EkkloFood food) =>
      switch (food.quantityType) {
        EkkloQuantityType.grams => intl.memoryPerGrams(food.portion),
        EkkloQuantityType.ml => intl.memoryPerMilliliters(food.portion),
        EkkloQuantityType.cup ||
        EkkloQuantityType.halfCup ||
        EkkloQuantityType.thirdCup ||
        EkkloQuantityType.quarterCup ||
        EkkloQuantityType.tablespoon ||
        EkkloQuantityType.teaspoon ||
        EkkloQuantityType.pieces ||
        EkkloQuantityType.kilograms ||
        EkkloQuantityType.liters ||
        EkkloQuantityType.centiliters ||
        EkkloQuantityType.whole ||
        EkkloQuantityType.slice ||
        EkkloQuantityType.portion ||
        EkkloQuantityType.can ||
        EkkloQuantityType.glass ||
        EkkloQuantityType.unknown => intl.memoryPerPortion,
      };
}
