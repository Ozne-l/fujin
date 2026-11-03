import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/entry_planning.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/own_copy_renewal.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';

const _searchResultsKept = 8;

EntryPlanning planEntry({
  required LoggedEntry entry,
  required Memory memory,
  EkkloLink? replacing,
  EkkloFood? rememberedFood,
  List<EkkloFood>? searchResults,
}) {
  final unit = entry.entry.servingUnit;
  final mfpFoodId = entry.mfpFoodId;
  final remembered = switch (mfpFoodId) {
    final id? => memory.food(id, unit),
    null => null,
  };
  final gramsPerUnit = switch (mfpFoodId) {
    final id? => memory.gramsPerUnit(id, unit),
    null => null,
  };
  final base = PlannedEntry(
    entry: entry,
    ekkloMealName: ekkloMealFor(entry, memory),
    choice: const SendAsOwnCopy(),
    reviewed: false,
    rememberedEkkloFoodId: switch (remembered) {
      MatchedFood(:final ekkloFoodId) => ekkloFoodId,
      OwnCopy() || null => null,
    },
    rememberedGramsPerUnit: gramsPerUnit,
    replacing: replacing,
  );

  EntryPlanning search() => switch (searchResults) {
    null => NeedsSearch(searchTerms(entry)),
    final results => Planned(
      _fromCandidates(
        base,
        rankCandidates(
          results.take(_searchResultsKept),
          entry,
          gramsPerUnit: gramsPerUnit,
        ),
      ),
    ),
  };

  return switch (remembered) {
    final OwnCopy copy when isFresh(copy, entry) => Planned(
      base.copyWith(choice: SendAsOwnCopy(reuse: copy)),
    ),
    OwnCopy() => Planned(
      base.copyWith(
        choice: const SendAsOwnCopy(renewal: OwnCopyRenewal.foodChanged),
      ),
    ),
    MatchedFood(:final ekkloFoodId, :final ekkloFoodName) => switch ((
      entryGrams(entry.entry, gramsPerUnit: gramsPerUnit),
      rememberedFood,
    )) {
      (final grams?, _) => Planned(
        base.copyWith(
          choice: SendToEkkloFood(
            ekkloFoodId: ekkloFoodId,
            ekkloFoodName: ekkloFoodName,
            grams: grams,
            remembered: true,
            weight: switch (isGramUnit(unit)) {
              true => UnitWeight.notNeeded,
              false => UnitWeight.remembered,
            },
            gramsPerUnit: gramsPerUnit,
          ),
        ),
      ),
      (null, null) => NeedsEkkloFood(ekkloFoodId),
      (null, final food?) => switch (evaluateCandidate(food, entry)) {
        final candidate? => Planned(
          base.copyWith(reviewed: true).choose(candidate, confirmed: false),
        ),
        null => search(),
      },
    },
    null when mfpFoodId != null && memory.hasOwnCopy(mfpFoodId) => Planned(
      base.copyWith(
        choice: const SendAsOwnCopy(renewal: OwnCopyRenewal.newUnit),
      ),
    ),
    null => search(),
  };
}

String ekkloMealFor(LoggedEntry entry, Memory memory) =>
    memory.ekkloMealName(entry.mealName) ?? entry.mealName;

bool isFresh(OwnCopy copy, LoggedEntry entry) =>
    switch ((copy.mfpFoodVersion, entry.mfpLink?.foodVersion)) {
      (final copied?, final logged?) => copied == logged,
      _ => true,
    };

PlannedEntry _fromCandidates(
  PlannedEntry base,
  List<EkkloCandidate> candidates,
) {
  final planned = base.copyWith(reviewed: true, candidates: candidates);
  return switch (candidates
      .where((candidate) => candidate.acceptable)
      .firstOrNull) {
    final best? => planned.choose(best, confirmed: false),
    null => planned,
  };
}
