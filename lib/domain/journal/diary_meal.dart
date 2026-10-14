import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'diary_meal.mapper.dart';

@MappableClass()
final class DiaryMeal with DiaryMealMappable {
  const DiaryMeal({required this.name, this.entries = const []});

  final String name;
  final List<MfpFoodEntry> entries;

  double get kilocalories =>
      DayNutrients.ofEntries(entries).amount(Nutrient.kilocalories);

  static List<DiaryMeal> of(
    List<String> mealNames,
    List<MfpFoodEntry> entries,
  ) => [
    for (final name in JournalMeal.namesOf(mealNames, entries))
      DiaryMeal(
        name: name,
        entries: [
          for (final entry in entries)
            if (entry.mealName == name) entry,
        ],
      ),
  ];
}
