import 'package:myfitnesspal_client/myfitnesspal_client.dart';

double? loggedKilocalories(MfpDiaryDay diary) => switch (diary.entries) {
  [] => null,
  final entries => entries.fold<double>(
    0,
    (total, entry) => total + (entry.nutrients.energy?.kilocalories ?? 0),
  ),
};
