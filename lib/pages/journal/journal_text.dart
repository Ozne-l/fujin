import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/title_text.dart';

abstract final class JournalText {
  static const List<Nutrient> macros = [
    Nutrient.protein,
    Nutrient.carbohydrates,
    Nutrient.fat,
    Nutrient.fiber,
  ];

  static String name(AppLocalizations l10n, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => l10n.goalKilocalories,
        Nutrient.protein => TitleText.capitalized(l10n.macroNameProtein),
        Nutrient.carbohydrates => TitleText.capitalized(
          l10n.macroNameCarbohydrates,
        ),
        Nutrient.fat => TitleText.capitalized(l10n.macroNameFat),
        Nutrient.fiber => TitleText.capitalized(l10n.macroNameFiber),
      };

  static String macroLine(AppLocalizations l10n, DayNutrients nutrients) {
    String amount(Nutrient nutrient) => _atLeast(
      l10n,
      nutrients,
      nutrient,
      l10n.macroValue(nutrients.amount(nutrient)),
    );
    return l10n.macros(
      amount(Nutrient.protein),
      amount(Nutrient.carbohydrates),
      amount(Nutrient.fat),
      amount(Nutrient.fiber),
    );
  }

  static String amount(
    AppLocalizations l10n,
    DayNutrients nutrients,
    Nutrient nutrient,
  ) => _atLeast(l10n, nutrients, nutrient, switch (nutrient) {
    Nutrient.kilocalories => l10n.kilocalories(nutrients.amount(nutrient)),
    Nutrient.protein ||
    Nutrient.carbohydrates ||
    Nutrient.fat ||
    Nutrient.fiber => l10n.gramsValue(nutrients.amount(nutrient)),
  });

  static String _atLeast(
    AppLocalizations l10n,
    DayNutrients nutrients,
    Nutrient nutrient,
    String value,
  ) => switch (nutrients.isPartial(nutrient)) {
    true => l10n.atLeast(value),
    false => value,
  };
}
