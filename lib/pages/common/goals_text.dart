import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/goals/goal_amounts.dart';
import 'package:fujin/domain/goals/macro_energy.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/sending/send_text.dart';

abstract final class GoalsText {
  static const List<Nutrient> _summarized = [
    Nutrient.protein,
    Nutrient.carbohydrates,
    Nutrient.fat,
    Nutrient.fiber,
  ];

  static String summary(AppLocalizations intl, Goals? goals) => switch (goals) {
    final goals? => [
      intl.kilocalories(goals.kilocalories),
      for (final nutrient in _summarized)
        if (goals.amount(nutrient) case final amount?)
          intl.goalsSummaryPart(
            SendText.nutrient(intl, nutrient),
            intl.macroValue(amount),
          ),
    ].join(intl.summarySeparator),
    null => intl.goalsNone,
  };

  static String label(AppLocalizations intl, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => intl.goalKilocalories,
        Nutrient.protein => intl.goalProtein,
        Nutrient.carbohydrates => intl.goalCarbohydrates,
        Nutrient.fat => intl.goalFat,
        Nutrient.fiber => intl.goalFiber,
      };

  static String unit(AppLocalizations intl, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => intl.nutrientKilocalories,
        Nutrient.protein ||
        Nutrient.carbohydrates ||
        Nutrient.fat ||
        Nutrient.fiber => intl.gramsSuffix,
      };

  static String? hint(AppLocalizations intl, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => null,
        Nutrient.protein ||
        Nutrient.carbohydrates ||
        Nutrient.fat ||
        Nutrient.fiber => intl.goalOptional,
      };

  static (String, String?) energyNote(
    AppLocalizations intl,
    MacroEnergy energy,
    double? kilocalories,
  ) => switch ((energy.missing, kilocalories)) {
    ([], final goal?) => (
      intl.macrosTotal(energy.kilocalories),
      intl.macrosGoal(goal),
    ),
    ([], null) => (intl.macrosTotal(energy.kilocalories), null),
    (final missing, _) => (
      intl.macrosPartial(
        energy.counted.length,
        _list(intl, [
          for (final nutrient in energy.counted)
            SendText.nutrient(intl, nutrient),
        ]),
        energy.kilocalories,
      ),
      intl.macrosMissing(
        TitleText.capitalized(
          _list(intl, [for (final nutrient in missing) _name(intl, nutrient)]),
        ),
      ),
    ),
  };

  static String _name(AppLocalizations intl, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.protein => intl.macroNameProtein,
        Nutrient.carbohydrates => intl.macroNameCarbohydrates,
        Nutrient.fat => intl.macroNameFat,
        Nutrient.kilocalories || Nutrient.fiber => label(intl, nutrient),
      };

  static String _list(AppLocalizations intl, List<String> items) =>
      switch (items) {
        [...final first, final last] when first.isNotEmpty =>
          '${first.join(intl.listSeparator)}${intl.listLastSeparator}$last',
        _ => items.join(),
      };
}
