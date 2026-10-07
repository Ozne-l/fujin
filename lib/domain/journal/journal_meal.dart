import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/journal/status_counts.dart';

part 'journal_meal.mapper.dart';

@MappableClass()
final class JournalMeal with JournalMealMappable {
  const JournalMeal({required this.name, this.entries = const []});

  final String name;
  final List<ComparedEntry> entries;

  StatusCounts get counts => StatusCounts.of(entries);

  double get kilocalories => entries.fold(
    0,
    (total, compared) =>
        total + (compared.entry.nutrients.energy?.kilocalories ?? 0),
  );
}
