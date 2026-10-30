import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/journal/status_counts.dart';

part 'journal_meal.mapper.dart';

@MappableClass()
final class JournalMeal with JournalMealMappable {
  const JournalMeal({
    required this.name,
    this.entries = const [],
    this.leaving = const [],
  });

  final String name;
  final List<ComparedEntry> entries;
  final List<LoggedEntry> leaving;

  StatusCounts counts({Set<String> sending = const {}}) =>
      StatusCounts.of(entries, sending: sending);

  double get kilocalories => entries.fold(
    0,
    (total, compared) =>
        total + (compared.logged.entry.nutrients.kilocalories ?? 0),
  );
}
