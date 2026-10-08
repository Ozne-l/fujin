# 18. Send flow: matching, review and execution

Date: 2026-10-08

## Status

Accepted. Settles the own-copy expectation left open in [0001](0001-recompute-statuses-from-both-sides.md) and implements the sending part of [0002](0002-write-ordering.md).

## Context

"Envoyer vers Ekklo" on the Journal's day card has to turn the day's entries "À envoyer" and "À mettre à jour" into Ekklo items, learn from the owner's choices so the next day needs fewer of them, and survive a stop at any point without sending twice. The Figma file "Fūjin · Maquettes" draws the flow as screens 09 (search), 10 (review), the sheets 11 (choose the Ekklo food), 12 (weight of a unit) and 13 (no close food), 14 (sending), 15 (done) and 16 (interrupted). Screen 17 belongs to the "Mode automatique" setting of the Réglages tab, which does not exist yet. The matching rules come from the proof of concept in `~/Dev/bridge_poc` (`lib/src/matching.dart`).

## Decision

Planning, per entry "À envoyer" or "À mettre à jour" that has a MyFitnessPal id, in MyFitnessPal order (`planEntry`, `lib/domain/sending/plan_entry.dart`, driven by `SendService.plan`, `lib/domain/sending/send_service.dart`):

- The Ekklo meal is the one Memory maps, else the MyFitnessPal meal name unchanged ("Un repas MyFitnessPal sans correspondance garde son nom dans Ekklo", screen 20).
- A remembered matched food whose grams are known (gram serving, or a remembered unit) is sent without review ("Mémorisé").
- A remembered matched food logged in a new unit is reviewed: Fūjin reads the Ekklo food (`foods.byId`) and estimates the unit's weight from the kilocalories ("Poids à confirmer").
- A remembered own copy is reused when it was made for the same serving unit and, when both are known, the same MyFitnessPal food version as the entry (`isFresh`); otherwise a new own copy is made without review.
- Any other food is searched in Ekklo with the first three meaningful words of its product name (`searchTerms`, `lib/domain/sending/food_words.dart`); the first 8 results are ranked (`rankCandidates`, `lib/domain/sending/rank_candidates.dart`). The best acceptable candidate is proposed ("Nouvelle association"); with none, an own copy is proposed ("Aucun aliment proche") and the rejected candidates stay listed.

Ranking and acceptance (`EkkloCandidate`, `NutrientDeltas`):

- Only Ekklo foods counted in grams with positive energy qualify. The grams are the entry's grams, or the remembered weight of its unit, or the energy divided by the food's kcal per gram (estimated).
- Gaps are signed and measured on the MyFitnessPal portion: kcal as a share of the entry's kcal, each macro as its energy difference (4, 4, 9, 2 kcal per gram for protein, carbs, fat, fiber) over the entry's kcal. A missing MyFitnessPal value, or an Ekklo fiber of 0, gives no gap ("n.c.").
- A candidate is acceptable when it shares a word of the product name or of the brand, kcal is within 12 % and each macro within 10 %, or within 5 kcal for small entries. Ranking puts product-name matches first, then brand matches, then the smallest total gap.

Review (screen 10): every planned entry that is not fully remembered is "à vérifier". "Sans changement de ta part, les propositions sont utilisées": sending uses the proposals as they are. The owner can confirm, choose another candidate or search Ekklo (11), set a unit's weight (12), choose an own copy (13) or skip an entry. Updates whose quantity is known skip the review; a plan made only of such updates starts sending at once (screen 14).

Own copies: one Ekklo food per MyFitnessPal food and serving unit, an exact copy of the entry's values. For a gram serving it is counted in grams per 100 g; for any other unit it is one portion per unit, and the item quantity is servings × serving value. `OwnCopy.mfpUnit` (column `memory_food.mfp_unit`, migration 2) records the unit, and `ExpectedItem.forEntry` expects nothing for an entry logged in another unit.

Execution (`SendService.send`), in this order:

1. Read the day again through `JournalService.readDay`, which adopts items an earlier interrupted send already wrote, and keep only the planned entries still "À envoyer" or "À mettre à jour".
2. Write Memory before Ekklo: missing meal mappings, new associations, retained unit weights. Adoption on a later read needs them.
3. Create own copies (one step each), saving each in Memory as soon as Ekklo returns it.
4. Update in place (`updateItemQuantity`) an entry whose item is in the right Ekklo meal with the right food and quantity type, moving its link to the new entry id.
5. Send one `appendItems` per Ekklo meal, after removing the old item of every other update; new items are found by diffing the meal's item ids against the read of step 1, matched to entries with `ExpectedItem.matches`, and linked.

Progress is reported per step (`SendProgress`, `SendStep`). A failing step stops the send with `SendInterruption`; "Envoyer les N aliments restants" runs the same plan again, and step 1 makes sure only what is missing goes.

The entry's own food version (`MfpFoodEntry.food.version`) decides whether an own copy is stale during a send: the copy mirrors the logged entry, so the version that matters is the one the entry was logged with. Re-reading `foods.byId` stays the rule of [0002](0002-write-ordering.md) for adding a food from Fūjin.

## Consequences

- An interrupted send never duplicates an item: tests cover a reply lost after Ekklo wrote the meal and a meal refused outright (`test/domain/sending/send_service_test.dart`).
- Every choice made while sending is remembered, so a day of known foods is sent from screen 10 with nothing to review.
- An estimated weight is retained even when the owner does not open sheet 12; screen 15 lists it ("poids retenu") so it can be corrected later in Mémoire.
- Entries without a MyFitnessPal id cannot be linked and are left out of the send.
- Two own copies of the same food exist in Ekklo after a food changes version in MyFitnessPal; the older one stays because items may still use it.
- The quantity type `portion` for own copies, and Ekklo merging an `appendItems` into the existing meal of the same name and date, come from the proof of concept; neither has been checked against the real Ekklo by Fūjin itself.
- In the dev flavor the read-only guard stops the first write, and screen 16 says that Fūjin DEV does not write to Ekklo.
