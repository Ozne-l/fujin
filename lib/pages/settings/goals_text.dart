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

  static String summary(AppLocalizations l10n, Goals? goals) => switch (goals) {
    final goals? => [
      l10n.kilocalories(goals.kilocalories),
      for (final nutrient in _summarized)
        if (goals.amount(nutrient) case final amount?)
          l10n.goalsSummaryPart(
            SendText.nutrient(l10n, nutrient),
            l10n.macroValue(amount),
          ),
    ].join(l10n.summarySeparator),
    null => l10n.goalsNone,
  };

  static String label(AppLocalizations l10n, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => l10n.goalKilocalories,
        Nutrient.protein => l10n.goalProtein,
        Nutrient.carbohydrates => l10n.goalCarbohydrates,
        Nutrient.fat => l10n.goalFat,
        Nutrient.fiber => l10n.goalFiber,
      };

  static String unit(AppLocalizations l10n, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => l10n.nutrientKilocalories,
        Nutrient.protein ||
        Nutrient.carbohydrates ||
        Nutrient.fat ||
        Nutrient.fiber => l10n.gramsSuffix,
      };

  static String? hint(AppLocalizations l10n, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => null,
        Nutrient.protein ||
        Nutrient.carbohydrates ||
        Nutrient.fat ||
        Nutrient.fiber => l10n.goalOptional,
      };

  static (String, String?) energyNote(
    AppLocalizations l10n,
    MacroEnergy energy,
    double? kilocalories,
  ) => switch ((energy.missing, kilocalories)) {
    ([], final goal?) => (
      l10n.macrosTotal(energy.kilocalories),
      l10n.macrosGoal(goal),
    ),
    ([], null) => (l10n.macrosTotal(energy.kilocalories), null),
    (final missing, _) => (
      l10n.macrosPartial(
        energy.counted.length,
        _list(l10n, [
          for (final nutrient in energy.counted)
            SendText.nutrient(l10n, nutrient),
        ]),
        energy.kilocalories,
      ),
      l10n.macrosMissing(
        TitleText.capitalized(
          _list(l10n, [for (final nutrient in missing) _name(l10n, nutrient)]),
        ),
      ),
    ),
  };

  static String _name(AppLocalizations l10n, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.protein => l10n.macroNameProtein,
        Nutrient.carbohydrates => l10n.macroNameCarbohydrates,
        Nutrient.fat => l10n.macroNameFat,
        Nutrient.kilocalories || Nutrient.fiber => label(l10n, nutrient),
      };

  static String _list(AppLocalizations l10n, List<String> items) =>
      switch (items) {
        [...final first, final last] when first.isNotEmpty =>
          '${first.join(l10n.listSeparator)}${l10n.listLastSeparator}$last',
        _ => items.join(),
      };
}
