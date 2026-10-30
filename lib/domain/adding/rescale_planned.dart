import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/sending/plan_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/send_choice.dart';

PlannedEntry rescalePlanned(
  PlannedEntry planned,
  LoggedEntry entry,
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
          entryGrams(entry.entry, gramsPerUnit: choice.gramsPerUnit) ??
          choice.grams,
    ),
    final SendAsOwnCopy choice => choice,
    final SkipEntry choice => choice,
  },
);
