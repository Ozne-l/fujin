import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'journal_read.mapper.dart';

@MappableClass(discriminatorKey: 'sides')
sealed class JournalRead with JournalReadMappable {
  const JournalRead({required this.readAt});

  final DateTime readAt;

  MfpDiaryDay? get diary;

  List<DiaryMeal> get diaryMeals;
}

@MappableClass(discriminatorValue: 'both')
final class BothSides extends JournalRead with BothSidesMappable {
  const BothSides({required this.day, required super.readAt});

  final JournalDay day;

  @override
  MfpDiaryDay get diary => day.diary;

  @override
  List<DiaryMeal> get diaryMeals => [
    for (final meal in day.meals)
      DiaryMeal(
        name: meal.name,
        entries: [for (final compared in meal.entries) compared.entry],
      ),
  ];
}

@MappableClass(discriminatorValue: 'mfp_only')
final class MfpOnly extends JournalRead with MfpOnlyMappable {
  const MfpOnly({
    required this.diary,
    required this.ekkloProblem,
    required super.readAt,
    this.mealNames = const [],
  });

  @override
  final MfpDiaryDay diary;

  final List<String> mealNames;
  final ReadProblem ekkloProblem;

  DayNutrients get nutrients => DayNutrients.ofEntries(diary.entries);

  @override
  List<DiaryMeal> get diaryMeals => DiaryMeal.of(mealNames, diary.entries);
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
  MfpDiaryDay? get diary => null;

  @override
  List<DiaryMeal> get diaryMeals => const [];

  DayNutrients get ekkloNutrients => DayNutrients.ofEkklo(ekkloMeals);
}
