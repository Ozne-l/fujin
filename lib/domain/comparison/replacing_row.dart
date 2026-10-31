import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

MfpFoodEntry? replacingRow(
  MfpLink link, {
  required String? mfpFoodId,
  required List<MfpFoodEntry> diary,
  required Set<String> held,
  required bool sameMeal,
}) => diary
    .where(
      (row) => switch (row.id) {
        final id? =>
          !held.contains(id) &&
              sameDay(row.date, link.date) &&
              (row.food.id == link.foodId || row.food.id == mfpFoodId) &&
              (!sameMeal || row.mealName == link.mealName),
        null => false,
      },
    )
    .firstOrNull;

MfpFoodEntry? replacingRowAnyMeal(
  MfpLink link, {
  required String? mfpFoodId,
  required List<MfpFoodEntry> diary,
  required Set<String> held,
}) =>
    replacingRow(
      link,
      mfpFoodId: mfpFoodId,
      diary: diary,
      held: held,
      sameMeal: true,
    ) ??
    replacingRow(
      link,
      mfpFoodId: mfpFoodId,
      diary: diary,
      held: held,
      sameMeal: false,
    );
