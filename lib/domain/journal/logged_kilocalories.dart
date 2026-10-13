import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

double? loggedKilocalories(MfpDiaryDay diary) => switch (diary.entries) {
  [] => null,
  final entries => DayNutrients.ofEntries(
    entries,
  ).amount(Nutrient.kilocalories),
};
