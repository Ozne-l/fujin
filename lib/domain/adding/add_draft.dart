import 'package:dart_mappable/dart_mappable.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'add_draft.mapper.dart';

@MappableClass()
final class AddDraft with AddDraftMappable {
  const AddDraft({
    required this.food,
    required this.servingSize,
    required this.servings,
    required this.mfpMealName,
    required this.date,
  });

  static const pendingEntryId = '';
  static const oneServing = 1.0;
  static const _baseMultiplier = 1.0;
  static const _mealPosition = 0;

  final MfpFood food;
  final MfpServingSize servingSize;
  final double servings;
  final String mfpMealName;
  final DateTime date;

  static AddDraft? of(
    MfpFood food, {
    required String mfpMealName,
    required DateTime date,
    MfpServingSize? servingSize,
    double servings = oneServing,
  }) => switch (_servingLike(food, servingSize)) {
    final serving? => AddDraft(
      food: food,
      servingSize: serving,
      servings: servings,
      mfpMealName: mfpMealName,
      date: date,
    ),
    null => null,
  };

  MfpFoodEntry get entry => MfpFoodEntry(
    date: date,
    mealName: mfpMealName,
    mealPosition: _mealPosition,
    servings: servings,
    servingSize: servingSize,
    food: MfpEntryFood(
      id: food.id,
      description: food.description,
      version: food.version,
      brandName: food.brandName,
    ),
    nutrients: _scaled(
      food.nutrients ?? const MfpNutrients(),
      (servingSize.nutritionMultiplier ?? _baseMultiplier) * servings,
    ),
  );

  AddDraft withFood(MfpFood food) => copyWith(
    food: food,
    servingSize: _servingLike(food, servingSize) ?? servingSize,
  );

  static MfpServingSize? _servingLike(MfpFood food, MfpServingSize? like) =>
      food.servingSizes
          .where(
            (serving) =>
                serving.unit == like?.unit && serving.value == like?.value,
          )
          .firstOrNull ??
      food.servingSizes.firstOrNull;

  static MfpNutrients _scaled(MfpNutrients nutrients, double factor) {
    double? scale(double? amount) => switch (amount) {
      final amount? => amount * factor,
      null => null,
    };
    return MfpNutrients(
      energy: switch (nutrients.energy) {
        final energy? => MfpEnergy(
          unit: energy.unit,
          value: energy.value * factor,
        ),
        null => null,
      },
      protein: scale(nutrients.protein),
      carbohydrates: scale(nutrients.carbohydrates),
      netCarbs: scale(nutrients.netCarbs),
      fiber: scale(nutrients.fiber),
      sugar: scale(nutrients.sugar),
      addedSugars: scale(nutrients.addedSugars),
      sugarAlcohols: scale(nutrients.sugarAlcohols),
      fat: scale(nutrients.fat),
      saturatedFat: scale(nutrients.saturatedFat),
      monounsaturatedFat: scale(nutrients.monounsaturatedFat),
      polyunsaturatedFat: scale(nutrients.polyunsaturatedFat),
      transFat: scale(nutrients.transFat),
      cholesterolMilligrams: scale(nutrients.cholesterolMilligrams),
      sodiumMilligrams: scale(nutrients.sodiumMilligrams),
      potassiumMilligrams: scale(nutrients.potassiumMilligrams),
      vitaminA: scale(nutrients.vitaminA),
      vitaminC: scale(nutrients.vitaminC),
      vitaminD: scale(nutrients.vitaminD),
      calcium: scale(nutrients.calcium),
      iron: scale(nutrients.iron),
    );
  }
}
