import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/domain/weighing/kilograms.dart';

List<({DateTime date, double kilograms})> importedWeights(
  List<EkkloWeightEntry> history, {
  required Set<String> taken,
}) {
  final latest = <String, EkkloWeightEntry>{};
  for (final entry in history) {
    final day = CalendarDateHook.format(entry.date);
    if (taken.contains(day) || Kilograms.rounded(entry.kilograms) <= 0) {
      continue;
    }
    if (latest[day] case final kept?
        when !entry.updatedAt.isAfter(kept.updatedAt)) {
      continue;
    }
    latest[day] = entry;
  }
  final days = latest.keys.toList()..sort();
  return [
    for (final day in days)
      if (latest[day] case final entry?)
        (date: entry.date, kilograms: Kilograms.rounded(entry.kilograms)),
  ];
}
