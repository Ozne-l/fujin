# 26. Adding a food: one draft, the send flow's Ekklo half, undo

Date: 2026-10-10

## Status

Accepted. Implements the adding and undo parts of [0002](0002-write-ordering.md). The scanner (Figma section 03) and the search prefilled after a scan (02d) are built by [0027](0027-barcode-scanner.md). [0034](0034-remembered-foods-in-the-add-search.md) adds the remembered foods to the search and "Ajouter" to screen 19.

## Context

Chapter 5 "Ajout d'aliment" of the Figma file "Fūjin · Maquettes" adds a food to the owner's MyFitnessPal diary and writes it to Ekklo at the same time: search (02a to 02c), fiche (04a to 04h) with a one-line summary of the Ekklo side, Ekklo matching (05a to 05d), writing (06a, 06b, 06d, 06e) and the cross-cutting states (07a to 07f). The Journal opens it from "Ajouter un aliment" on a meal and shows the result on return (K16), with "Annuler" (K17, K18).

Client capabilities (`~/Dev/myfitnesspal_client`, `~/Dev/ekklo_client`):

- `foods.search(query, maxResults: 25, verifiedOnly)` and `foods.byId(id)` return `MfpFood` with its `version`, its serving sizes and the nutrients of the serving whose `nutritionMultiplier` is 1.
- `foods.byBarcode(barcode)` goes through MyFitnessPal sync (`POST /iphone_api/synchronize`) and answers found, unresolved (known code, no food) or unknown.
- `diary.addFood` takes the food id and version, the serving size and the servings, and returns the new entry id (nullable); `diary.remove(entryId)` deletes it. MyFitnessPal computes the entry's nutrients.
- There is no "recent foods" call in MyFitnessPal's API as the client knows it.

## Decision

Draft and Ekklo side:

- What the fiche edits is an `AddDraft` (`lib/domain/adding/add_draft.dart`): MyFitnessPal food, serving size, servings, MyFitnessPal meal, date. `AddDraft.entry` is the `MfpFoodEntry` it would log, nutrients = food nutrients × `nutritionMultiplier` (1 when absent) × servings, which feeds the fiche and "Ma journée".
- The Ekklo side is planned by the send flow's own rules: `AddFoodService.plan` calls `SendService.planOne`, which runs `planEntry` with the same Ekklo reads as a send ([0018](0018-send-flow.md)), on the draft's entry with the id `AddDraft.pendingEntryId`. The result is a `PlannedEntry`, so the sending sheets 11, 12 and 13 serve screen 05 unchanged.
- `EkkloSide.of(planned)` (`lib/domain/adding/ekklo_side.dart`) names the summary line: `remembered` (04a, a remembered matched food or own copy), `foundAutomatically` (04b, an acceptable candidate), `willBeCreated` (04c, an own copy to create), `toChoose` (04d, an estimated unit weight not yet confirmed; the fiche asks to choose before adding), `chosen` (04e, the owner's choice).
- Changing only the servings does not search Ekklo again: `rescalePlanned` (`lib/domain/adding/rescale_planned.dart`) re-ranks the same candidates for the new entry and rescales the grams of the choice from its weight per unit, keeping the owner's choice; candidate gaps are shares of the entry's energy, so they do not move. A new food, version or serving size is planned again.

Writing (`AddFoodService.add`, `lib/domain/adding/add_food_service.dart`), in this order:

1. Re-read the MyFitnessPal food (`foods.byId`). This checks the MyFitnessPal session and is the version re-read of [0002](0002-write-ordering.md).
2. Read the day's Ekklo meals. This checks the Ekklo session before anything is written (07e: "MyFitnessPal reste connecté").
3. If the food's version differs from the draft's, stop with `FoodChanged(before, after)` (06e); nothing is written. The page reloads the fiche with `AddDraft.withFood(after)`, which keeps the serving, plans again, and "Confirmer et ajouter" calls `add` again.
4. `diary.addFood`, then record the recent food.
5. The Ekklo half is `SendService.send` with a one-entry `SendPlan` in reviewed mode: it re-reads the day, writes Memory, creates or reuses the own copy (fresh when its version equals the re-read one), appends to the Ekklo meal and writes the send link. The add counts as written to Ekklo when a link exists for the new entry id.

Outcomes (`AddOutcome`, `lib/domain/adding/add_outcome.dart`): `Added`, `FoodChanged`, `NotAdded(error)` when nothing was written (session expired 07d/07e, offline 07c, MyFitnessPal refusing 06d; the page maps the error with `ReadProblem.of`), `EkkloFailed(added, error)` when MyFitnessPal has the entry and Ekklo does not (06b). The entry is then a normal "À envoyer" entry: `retryEkklo` runs step 5 again and never writes MyFitnessPal again, a send from the Journal sends it too, and a reply lost after Ekklo wrote the meal is adopted by the re-read instead of being sent twice.

- No double add: `add` and `retryEkklo` share one write in flight; a call made while it runs returns the same future. The page also keeps its button disabled while it runs (06a).
- Every choice is remembered as in a reviewed send: the fiche is the review. The automatic mode ([0025](0025-automatic-mode.md)) does not apply to adding, and screen 05's "Retenir ce choix" switch is not offered.
- The add flow returns an `AddedFood` (`lib/domain/adding/added_food.dart`: the planned entry with the MyFitnessPal entry id, and whether Ekklo was written) to the Journal, which shows K16.

Undo (`AddFoodService.undo`), Ekklo first then MyFitnessPal ([0002](0002-write-ordering.md)):

1. Read the day through `JournalService.readDay`, which checks both sessions and adopts an item an interrupted write left unlinked.
2. If the entry is linked, remove its Ekklo item and drop the link.
3. Remove the MyFitnessPal entry, unless the entry is no longer in the day.

Outcomes (`UndoOutcome`, `lib/domain/adding/undo_outcome.dart`): `Undone` (K17), `StillInMfp(error)` when the Ekklo item is gone and the MyFitnessPal entry stayed (K18; the entry shows "À envoyer"), `NotUndone(error)` when nothing was removed. Undo is single-flight and safe to repeat: "Réessayer" on K18 calls it again with the same `AddedFood`, and step 2 has nothing left to do. Memory, own copies and recent foods are kept.

On the Journal (`JournalPage`, `UndoAddNotifier` in `lib/pages/journal/undo_add_notifier.dart`): K16 stays 8 s with "Annuler" and says "MyFitnessPal et Ekklo · <repas>", or "MyFitnessPal seulement · <repas>" when Ekklo was not written; `NotUndone` shows "Ajout non annulé" with the read problem and "Réessayer". The Journal re-reads the day after the add route returns and after every undo outcome.

Recent foods (02a, "ajoutés depuis Fūjin"):

- The list is the foods Fūjin added, newest first, one row per MyFitnessPal food with its last serving, servings, kilocalories and time, at most 20. A row is written as soon as MyFitnessPal accepts the entry, Ekklo or not, and stays after an undo. The time reads as in 02a: a food added today says "ce matin" before noon, "cet après-midi" until 18:00, "ce soir" after; then "hier", the weekday within the week, the short date beyond. The search screen reads the list again each time it comes back from the fiche.
- Table `recent_food` (migration 6, `RecentFood` and `RecentFoodRepository` in `lib/data/recents/`). It is in `fujin.db`, so Auto Backup carries it, but not in the backup file: it is a convenience rebuilt by use, and an import leaves it as it is.
- `AddFoodService.reopen` re-reads the food with `foods.byId` and drafts it with the recent serving and servings.

Search and barcode: `AddFoodService.search` drops foods without a serving size, which cannot be logged; `byBarcode` returns the client's result as is. `Config.mfpSyncUri` (`--dart-define=MFP_SYNC_URI`) points the sync host at a fake server like the other base URIs.

## Consequences

- An add costs a food read and an Ekklo read before the MyFitnessPal write, then the send's read of both sides; the writes themselves are the send flow's, so own copies, Memory and links behave as in a send (`test/domain/adding/add_food_service_test.dart`).
- A MyFitnessPal reply lost after the entry was written, or a reply without an entry id, gives `NotAdded` although the entry exists; the Journal then shows it "À envoyer", as for any entry logged outside Fūjin.
- An Ekklo item already in the meal without a link that matches what Memory expects is adopted by the re-read instead of written again ([0001](0001-recompute-statuses-from-both-sides.md)); undo then removes that item.
- Two own copies of a food can exist in Ekklo after its MyFitnessPal version changes, as in [0018](0018-send-flow.md).
- In the dev flavor the read-only guard stops the MyFitnessPal write, so an add ends in `NotAdded` with nothing written; a barcode lookup is a sync `POST` and is stopped too ([0017](0017-read-only-dev-environment.md)).
- The scanner stays planned: the Scanner tab button is unchanged.
