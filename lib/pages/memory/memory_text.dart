import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class MemoryText {
  static String target(AppLocalizations intl, RememberedFood food) =>
      switch (food) {
        MatchedFood(:final ekkloFoodName) => intl.memoryTarget(ekkloFoodName),
        OwnCopy() => intl.memoryOwnCopyTarget,
      };

  static String quotedUnits(AppLocalizations intl, Iterable<String> units) =>
      units.map(intl.memoryUnitQuoted).join(intl.listSeparator);

  static String macros(AppLocalizations intl, EkkloFood food) => intl.macros(
    intl.macroValue(food.proteins),
    intl.macroValue(food.carbs),
    intl.macroValue(food.fats),
    intl.macroValue(food.fiber),
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
