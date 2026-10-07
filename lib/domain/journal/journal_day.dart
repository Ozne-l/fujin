import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/journal/ekklo_energy.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/status_counts.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'journal_day.mapper.dart';

@MappableClass()
final class JournalDay with JournalDayMappable {
  const JournalDay({
    required this.diary,
    required this.comparison,
    this.mealNames = const [],
    this.ekkloMeals = const [],
  });

  final MfpDiaryDay diary;
  final List<String> mealNames;
  final List<EkkloDailyMeal> ekkloMeals;
  final DayComparison comparison;

  DateTime get date => diary.date;

  StatusCounts get counts => StatusCounts.of(comparison.entries);

  List<JournalMeal> get meals {
    final names = {
      ...mealNames,
      for (final compared in comparison.entries) compared.entry.mealName,
    };
    return [
      for (final name in names)
        JournalMeal(
          name: name,
          entries: [
            for (final compared in comparison.entries)
              if (compared.entry.mealName == name) compared,
          ],
        ),
    ];
  }

  double get kilocalories =>
      meals.fold(0, (total, meal) => total + meal.kilocalories);

  double get ekkloKilocalories => ekkloKilocaloriesOf(ekkloMeals);
}
