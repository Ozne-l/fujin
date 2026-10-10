import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/sending/food_words.dart';

List<RememberedFood> rememberedFoods(Memory memory, String query) {
  final wanted = folded(query.trim());
  return [...memory.matches, ...memory.ownCopies]
      .where(
        (food) =>
            folded(food.mfpDescription).contains(wanted) ||
            folded(food.ekkloFoodName).contains(wanted),
      )
      .toList()
    ..sort(
      (a, b) => folded(a.mfpDescription).compareTo(folded(b.mfpDescription)),
    );
}

List<String> mealChoices(Memory memory, Iterable<String> ekkloMealNames) => {
  for (final meal in memory.meals) ...[
    meal.mfpMealName,
    meal.ekkloMealName,
  ],
  ...ekkloMealNames,
}.toList()..sort((a, b) => folded(a).compareTo(folded(b)));
