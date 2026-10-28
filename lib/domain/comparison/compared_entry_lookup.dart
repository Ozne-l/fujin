import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';

extension ComparedEntryLookup on DayComparison {
  ComparedEntry? entryWithId(String entryId) =>
      entries.where((compared) => compared.entry.id == entryId).firstOrNull;
}
