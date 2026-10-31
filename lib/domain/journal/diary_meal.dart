import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';

part 'diary_meal.mapper.dart';

@MappableClass()
final class DiaryMeal with DiaryMealMappable {
  const DiaryMeal({
    required this.name,
    this.entries = const [],
    this.leaving = const [],
  });

  final String name;
  final List<LoggedEntry> entries;
  final List<LoggedEntry> leaving;

  double get kilocalories =>
      DayNutrients.ofEntries(entries).amount(Nutrient.kilocalories);
}
