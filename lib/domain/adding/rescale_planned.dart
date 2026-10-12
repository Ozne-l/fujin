import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/sending/plan_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

PlannedEntry rescalePlanned(
  PlannedEntry planned,
  MfpFoodEntry entry,
  Memory memory,
) => planned.copyWith(
  entry: entry,
  ekkloMealName: ekkloMealFor(entry, memory),
  candidates: rankCandidates(
    [for (final candidate in planned.candidates) candidate.food],
    entry,
    gramsPerUnit: planned.rememberedGramsPerUnit,
  ),
  choice: switch (planned.choice) {
    final SendToEkkloFood choice => choice.copyWith(
      grams:
          entryGrams(entry, gramsPerUnit: choice.gramsPerUnit) ?? choice.grams,
    ),
    final SendAsOwnCopy choice => choice,
    final SkipEntry choice => choice,
  },
);
