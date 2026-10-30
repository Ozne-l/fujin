import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

MfpFoodEntry? writtenRow(
  LoggedEntry logged,
  List<MfpFoodEntry> diary,
  Set<String> held,
) {
  final entry = logged.entry;
  return diary
      .where(
        (row) => switch (row.id) {
          final id? =>
            !held.contains(id) &&
                sameDay(row.date, entry.date) &&
                row.mealName == logged.mealName &&
                row.food.id == logged.mfpFoodId &&
                row.servings == entry.servings &&
                row.servingSize.value == entry.servingValue &&
                row.servingSize.unit == entry.servingUnit,
          null => false,
        },
      )
      .firstOrNull;
}
