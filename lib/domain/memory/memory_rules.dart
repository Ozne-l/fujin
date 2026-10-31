import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

List<RememberedFood> rememberedFoods(Memory memory, String query) => _matching(
  [...memory.matches, ...memory.ownCopies],
  query,
  name: (food) => food.mfpDescription,
  other: (food) => food.ekkloFoodName,
);

List<MfpFood> foodsOnPhone(List<MfpFood> foods, String query) => _matching(
  foods,
  query,
  name: (food) => food.description,
  other: (food) => food.brandName,
);

List<String> mealChoices(Memory memory, Iterable<String> ekkloMealNames) => {
  for (final meal in memory.meals) ...[
    meal.mfpMealName,
    meal.ekkloMealName,
  ],
  ...ekkloMealNames,
}.toList()..sort((a, b) => folded(a).compareTo(folded(b)));

List<T> _matching<T>(
  List<T> foods,
  String query, {
  required String Function(T food) name,
  required String? Function(T food) other,
}) {
  final wanted = folded(query.trim());
  bool matches(String? text) => switch (text) {
    final text? => folded(text).contains(wanted),
    null => false,
  };
  return foods
      .where((food) => matches(name(food)) || matches(other(food)))
      .toList()
    ..sort((a, b) => folded(name(a)).compareTo(folded(name(b))));
}
