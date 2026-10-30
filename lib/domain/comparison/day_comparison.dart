import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';

part 'day_comparison.mapper.dart';

@MappableClass()
final class DayComparison with DayComparisonMappable {
  const DayComparison({
    required this.changes,
    this.entries = const [],
    this.leaving = const [],
  });

  final List<ComparedEntry> entries;
  final List<LoggedEntry> leaving;
  final DayChanges changes;

  DayComparison held() {
    final copied = {for (final entry in changes.addedEntries) entry.id};
    return copyWith(
      entries: [
        for (final compared in entries)
          switch (copied.contains(compared.logged.entry.id)) {
            true => compared.copyWith(stored: false),
            false => compared,
          },
      ],
    );
  }
}
