import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

const gramsPerOwnCopyPortion = 100.0;

EkkloQuantityType ownCopyQuantityType(String mfpUnit) =>
    switch (isGramUnit(mfpUnit)) {
      true => EkkloQuantityType.grams,
      false => EkkloQuantityType.portion,
    };

EkkloFoodDraft ownCopyDraft(MfpFoodEntry entry) {
  final units = entry.servingSize.value * entry.servings;
  final quantityType = ownCopyQuantityType(entry.servingSize.unit);
  final portion = switch (quantityType) {
    EkkloQuantityType.grams => gramsPerOwnCopyPortion,
    _ => 1.0,
  };
  final scale = portion / units;
  final nutrients = entry.nutrients;
  return EkkloFoodDraft(
    name: productName(entry.food),
    category: EkkloFoodCategory.other,
    portion: portion,
    quantityType: quantityType,
    calories: (nutrients.energy?.kilocalories ?? 0) * scale,
    proteins: (nutrients.protein ?? 0) * scale,
    carbs: (nutrients.carbohydrates ?? 0) * scale,
    fats: (nutrients.fat ?? 0) * scale,
    sugar: (nutrients.sugar ?? 0) * scale,
    sodiumMilligrams: (nutrients.sodiumMilligrams ?? 0) * scale,
    fiber: switch (nutrients.fiber) {
      final fiber? => fiber * scale,
      null => null,
    },
    brands: entry.food.brandName,
  );
}
