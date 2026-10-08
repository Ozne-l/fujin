import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/nutrient_deltas.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

List<EkkloCandidate> rankCandidates(
  Iterable<EkkloFood> foods,
  MfpFoodEntry entry, {
  double? gramsPerUnit,
}) =>
    [
      for (final food in foods)
        ?evaluateCandidate(food, entry, gramsPerUnit: gramsPerUnit),
    ]..sort(
      (a, b) => switch (a.nameMatch.index.compareTo(b.nameMatch.index)) {
        0 => a.deltas.total.compareTo(b.deltas.total),
        final order => order,
      },
    );

EkkloCandidate? evaluateCandidate(
  EkkloFood food,
  MfpFoodEntry entry, {
  double? gramsPerUnit,
}) {
  final nutrients = entry.nutrients;
  final kilocalories = nutrients.energy?.kilocalories;
  final knownGrams = entryGrams(entry, gramsPerUnit: gramsPerUnit);
  final macrosKnown =
      nutrients.protein != null ||
      nutrients.carbohydrates != null ||
      nutrients.fat != null;
  return switch ((kilocalories, food.quantityType, knownGrams)) {
    (_?, EkkloQuantityType.grams, null) when !macrosKnown => null,
    (final kcal?, EkkloQuantityType.grams, final grams)
        when kcal > 0 && food.portion > 0 && food.calories > 0 =>
      _candidate(
        food,
        entry,
        kcal,
        grams ?? kcal * food.portion / food.calories,
        gramsInferred: grams == null,
      ),
    _ => null,
  };
}

EkkloCandidate _candidate(
  EkkloFood food,
  MfpFoodEntry entry,
  double kilocalories,
  double grams, {
  required bool gramsInferred,
}) {
  final scale = grams / food.portion;
  final nutrients = entry.nutrients;
  double? macro(Nutrient nutrient, double ekklo, double? mfp) =>
      switch ((mfp, nutrient.kilocaloriesPerGram)) {
        (final mfp?, final perGram?) =>
          (ekklo * scale - mfp) * perGram / kilocalories,
        _ => null,
      };
  return EkkloCandidate(
    food: food,
    grams: grams,
    gramsInferred: gramsInferred,
    nameMatch: nameMatchOf(food, entry.food),
    deltas: NutrientDeltas(
      entryKilocalories: kilocalories,
      kilocalories: (food.calories * scale - kilocalories) / kilocalories,
      protein: macro(Nutrient.protein, food.proteins, nutrients.protein),
      carbohydrates: macro(
        Nutrient.carbohydrates,
        food.carbs,
        nutrients.carbohydrates,
      ),
      fat: macro(Nutrient.fat, food.fats, nutrients.fat),
      fiber: switch (food.fiber) {
        0 => null,
        _ => macro(Nutrient.fiber, food.fiber, nutrients.fiber),
      },
    ),
  );
}
