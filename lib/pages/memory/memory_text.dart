import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class MemoryText {
  static String target(AppLocalizations l10n, RememberedFood food) =>
      switch (food) {
        MatchedFood(:final ekkloFoodName) => l10n.memoryTarget(ekkloFoodName),
        OwnCopy() => l10n.memoryOwnCopyTarget,
      };

  static String quotedUnits(AppLocalizations l10n, Iterable<String> units) =>
      units.map(l10n.memoryUnitQuoted).join(l10n.listSeparator);

  static String macros(AppLocalizations l10n, EkkloFood food) => l10n.macros(
    l10n.macroValue(food.proteins),
    l10n.macroValue(food.carbs),
    l10n.macroValue(food.fats),
    l10n.macroValue(food.fiber),
  );

  static String portion(AppLocalizations l10n, EkkloFood food) =>
      switch (food.quantityType) {
        EkkloQuantityType.grams => l10n.memoryPerGrams(food.portion),
        EkkloQuantityType.ml => l10n.memoryPerMilliliters(food.portion),
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
        EkkloQuantityType.unknown => l10n.memoryPerPortion,
      };
}
