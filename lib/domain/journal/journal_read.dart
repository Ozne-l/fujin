import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/read_problem.dart';

part 'journal_read.mapper.dart';

@MappableClass(discriminatorKey: 'sides')
sealed class JournalRead with JournalReadMappable {
  const JournalRead({required this.readAt});

  final DateTime readAt;

  List<DiaryMeal> get diaryMeals;

  DayNutrients get diaryNutrients => DayNutrients.ofEntries([
    for (final meal in diaryMeals) ...meal.entries,
  ]);
}

@MappableClass(discriminatorValue: 'both')
final class BothSides extends JournalRead with BothSidesMappable {
  const BothSides({required this.day, required super.readAt});

  final JournalDay day;

  @override
  List<DiaryMeal> get diaryMeals => [
    for (final meal in day.meals)
      DiaryMeal(
        name: meal.name,
        entries: [for (final compared in meal.entries) compared.logged],
        mfpPending: {
          for (final compared in meal.entries)
            if (compared.mfpPending) compared.logged.entry.id,
        },
      ),
  ];
}

@MappableClass(discriminatorValue: 'mfp_only')
final class MfpOnly extends JournalRead with MfpOnlyMappable {
  const MfpOnly({
    required this.ekkloProblem,
    required super.readAt,
    this.meals = const [],
  });

  final List<DiaryMeal> meals;
  final ReadProblem ekkloProblem;

  @override
  List<DiaryMeal> get diaryMeals => meals;
}

@MappableClass(discriminatorValue: 'fujin_only')
final class FujinOnly extends JournalRead with FujinOnlyMappable {
  const FujinOnly({required super.readAt, this.meals = const []});

  final List<DiaryMeal> meals;

  @override
  List<DiaryMeal> get diaryMeals => meals;
}

@MappableClass(discriminatorValue: 'ekklo_only')
final class EkkloOnly extends JournalRead with EkkloOnlyMappable {
  const EkkloOnly({
    required this.mfpProblem,
    required super.readAt,
    this.ekkloMeals = const [],
  });

  final List<EkkloDailyMeal> ekkloMeals;
  final ReadProblem mfpProblem;

  @override
  List<DiaryMeal> get diaryMeals => const [];

  DayNutrients get ekkloNutrients => DayNutrients.ofEkklo(ekkloMeals);
}
