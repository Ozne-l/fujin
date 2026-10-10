import 'package:fujin/domain/sending/nutrient.dart';

final class MacroEnergy {
  const MacroEnergy({
    required this.counted,
    required this.missing,
    required this.kilocalories,
  });

  static const List<Nutrient> macros = [
    Nutrient.protein,
    Nutrient.carbohydrates,
    Nutrient.fat,
  ];

  final List<Nutrient> counted;
  final List<Nutrient> missing;
  final double kilocalories;

  static MacroEnergy? of(double? Function(Nutrient nutrient) amountOf) {
    final counted = <Nutrient>[];
    final missing = <Nutrient>[];
    var kilocalories = 0.0;
    for (final nutrient in macros) {
      switch ((amountOf(nutrient), nutrient.kilocaloriesPerGram)) {
        case (final grams?, final perGram?):
          counted.add(nutrient);
          kilocalories += grams * perGram;
        case (null, _) || (_, null):
          missing.add(nutrient);
      }
    }
    return switch (counted) {
      [] => null,
      _ => MacroEnergy(
        counted: counted,
        missing: missing,
        kilocalories: kilocalories,
      ),
    };
  }
}
