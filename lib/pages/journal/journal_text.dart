import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/read_problem.dart';
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

  static String name(AppLocalizations intl, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => intl.goalKilocalories,
        Nutrient.protein => TitleText.capitalized(intl.macroNameProtein),
        Nutrient.carbohydrates => TitleText.capitalized(
          intl.macroNameCarbohydrates,
        ),
        Nutrient.fat => TitleText.capitalized(intl.macroNameFat),
        Nutrient.fiber => TitleText.capitalized(intl.macroNameFiber),
      };

  static String problemHeadline(AppLocalizations intl, ReadProblem problem) =>
      switch (problem) {
        ReadProblem.mfpSessionExpired => intl.mfpSessionExpired,
        ReadProblem.ekkloSessionExpired => intl.ekkloSessionExpired,
        ReadProblem.offline => intl.offlineHeadline,
        ReadProblem.mfpUnavailable => intl.serviceNotResponding(
          intl.sourceMyFitnessPal,
        ),
        ReadProblem.ekkloUnavailable => intl.serviceNotResponding(
          intl.sourceEkklo,
        ),
        ReadProblem.unknown => intl.readFailed,
      };

  static String macroLine(AppLocalizations intl, DayNutrients nutrients) {
    String amount(Nutrient nutrient) => _atLeast(
      intl,
      nutrients,
      nutrient,
      intl.macroValue(nutrients.amount(nutrient)),
    );
    return intl.macros(
      amount(Nutrient.protein),
      amount(Nutrient.carbohydrates),
      amount(Nutrient.fat),
      amount(Nutrient.fiber),
    );
  }

  static String amount(
    AppLocalizations intl,
    DayNutrients nutrients,
    Nutrient nutrient,
  ) => _atLeast(intl, nutrients, nutrient, switch (nutrient) {
    Nutrient.kilocalories => intl.kilocalories(nutrients.amount(nutrient)),
    Nutrient.protein ||
    Nutrient.carbohydrates ||
    Nutrient.fat ||
    Nutrient.fiber => intl.gramsValue(nutrients.amount(nutrient)),
  });

  static String _atLeast(
    AppLocalizations intl,
    DayNutrients nutrients,
    Nutrient nutrient,
    String value,
  ) => switch (nutrients.isPartial(nutrient)) {
    true => intl.atLeast(value),
    false => value,
  };
}
