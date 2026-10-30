import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/status_counts.dart';

part 'journal_day.mapper.dart';

@MappableClass()
final class JournalDay with JournalDayMappable {
  const JournalDay({
    required this.date,
    required this.comparison,
    this.meals = const [],
    this.ekkloMeals = const [],
  });

  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final DayComparison comparison;
  final List<JournalMeal> meals;
  final List<EkkloDailyMeal> ekkloMeals;

  List<ComparedEntry> get entries => comparison.entries;

  StatusCounts get counts => StatusCounts.of(entries);

  DayNutrients get nutrients => DayNutrients.ofEntries([
    for (final compared in entries) compared.logged,
  ]);

  DayNutrients get ekkloNutrients => DayNutrients.ofEkklo(ekkloMeals);
}
