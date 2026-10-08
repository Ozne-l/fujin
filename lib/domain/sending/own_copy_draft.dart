import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

const _gramsPerOwnCopyPortion = 100.0;
const _portionPerUnit = 1.0;

EkkloQuantityType ownCopyQuantityType(String mfpUnit) =>
    switch (isGramUnit(mfpUnit)) {
      true => EkkloQuantityType.grams,
      false => EkkloQuantityType.portion,
    };

EkkloFoodDraft ownCopyDraft(MfpFoodEntry entry) {
  final (portion, quantityType) = switch (isGramUnit(entry.servingSize.unit)) {
    true => (_gramsPerOwnCopyPortion, EkkloQuantityType.grams),
    false => (_portionPerUnit, EkkloQuantityType.portion),
  };
  final scale = portion / entryUnits(entry);
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
