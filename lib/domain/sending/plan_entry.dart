import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/entry_planning.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

const _searchResultsKept = 8;

EntryPlanning planEntry({
  required MfpFoodEntry entry,
  required String entryId,
  required Memory memory,
  SentLink? replacing,
  EkkloFood? rememberedFood,
  List<EkkloFood>? searchResults,
}) {
  final remembered = memory.food(entry.food.id);
  final gramsPerUnit = memory.gramsPerUnit(
    entry.food.id,
    entry.servingSize.unit,
  );
  final base = PlannedEntry(
    entry: entry,
    entryId: entryId,
    ekkloMealName: memory.ekkloMealName(entry.mealName) ?? entry.mealName,
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
    null => NeedsSearch(searchTerms(entry.food)),
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
    OwnCopy() => Planned(base),
    MatchedFood(:final ekkloFoodId, :final ekkloFoodName) => switch ((
      entryGrams(entry, gramsPerUnit: gramsPerUnit),
      rememberedFood,
    )) {
      (final grams?, _) => Planned(
        base.copyWith(
          choice: SendToEkkloFood(
            ekkloFoodId: ekkloFoodId,
            ekkloFoodName: ekkloFoodName,
            grams: grams,
            remembered: true,
            weight: switch (isGramUnit(entry.servingSize.unit)) {
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
    null => search(),
  };
}

bool isFresh(OwnCopy copy, MfpFoodEntry entry) =>
    copy.mfpUnit == entry.servingSize.unit &&
    switch ((copy.mfpFoodVersion, entry.food.version)) {
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
