# 1. Recompute statuses from both sides

Date: 2026-10-07

## Status

Accepted

## Context

The Journal shows, for each MyFitnessPal entry of a day, one of three statuses: "Dans Ekklo", "À envoyer", "À mettre à jour". Both services change behind Fūjin's back: the owner edits or deletes entries in the MyFitnessPal phone app, and he or his coach can delete items in Ekklo. Probes showed that editing the servings or the meal of a MyFitnessPal entry gives it a new entry id. Ekklo items have no free field where Fūjin could store the id of the entry they came from.

A local queue of "things to send" would drift from both services as soon as either side changes without Fūjin knowing.

## Decision

Statuses are never stored. They are recomputed on every read of a day from three inputs: the MyFitnessPal diary, the Ekklo meals of that day, and a local registry of send links. There is no queue.

A send link (`SentLink`, `lib/data/links/sent_link.dart`, table `sent_link`) records what Fūjin knows about one entry it put in Ekklo: MyFitnessPal entry id, date, food id, meal name, servings, serving value and unit, Ekklo meal id, Ekklo item id, and when it was sent. `mfp_serving_value` is stored so the row "Dans Ekklo : 1 × 100 g" (`inEkkloAs` in `lib/l10n/app_fr.arb`, built in `lib/pages/journal/widgets/meal_card.dart`) can be shown from the link alone.

The rules live in one pure function, `compareDay` (`lib/domain/comparison/compare_day.dart`). It takes the entries, the Ekklo meals, the day's links, the Memory and `now`, and returns a `DayComparison` (`lib/domain/comparison/day_comparison.dart`): one `ComparedEntry` per entry, plus `linksToAdopt` and `linksToDrop`.

1. Links first. A link whose Ekklo item is gone is dropped, and its entry falls through to the next rules. A link whose item exists and whose entry still exists gives `InEkklo`. A link whose item exists but whose entry id vanished becomes an orphan. Either way the item is claimed.
2. Adoption. For each remaining entry with an id, in MyFitnessPal order, `ExpectedItem.forEntry` (`lib/domain/comparison/expected_item.dart`) derives the Ekklo item Memory expects. The first unclaimed Ekklo item that matches it is adopted: a new link is created and the entry is `InEkklo`. Each item is claimed at most once.
3. Orphan pairing, in two passes: first an orphan of the same MyFitnessPal food in the same MyFitnessPal meal, then one of the same food in any meal. If the orphan's Ekklo item already matches the new entry's expected item, the link moves to the new entry id (the old link is dropped and a new one adopted, `InEkklo`), so Fūjin never plans an update that changes nothing. Otherwise the entry is `ToUpdate` with an `UpdateKind` (`lib/domain/comparison/update_kind.dart`): `quantityOnly` when Memory maps the entry's meal to the Ekklo meal holding the item, `mealChanged` otherwise.
4. Everything else is `ToSend`, including entries without an id. Orphans left unpaired (entry deleted in MyFitnessPal) keep their link and produce nothing in v1; the Ekklo total still counts their item.

Expected item details (`lib/domain/comparison/expected_item.dart`):

- A matched food (`MatchedFood`) expects grams. A gram serving unit (`isGramUnit`, `lib/domain/comparison/gram_unit.dart`) counts as 1 g per unit; any other unit needs its grams in Memory (`memory_unit.grams`), otherwise there is no expected item.
- An own copy (`OwnCopy`) expects `servings` portions. This is an assumption to confirm once the send flow creates own copies.
- The quantity is rounded to 0.1 and matched within 0.1 (`ExpectedItem.quantityTolerance`).
- The entry's meal needs a meal mapping in Memory; without one there is no expected item and no adoption.

An adopted link takes `sentAt` from the Ekklo item's `createdAt`, or `now` when Ekklo gives none.

`JournalService.readDay` (`lib/domain/journal/journal_service.dart`) does the I/O around `compareDay`: it reads both sides in parallel, loads links and Memory, calls `compareDay`, then persists drops and adoptions in one transaction through `SentLinkRepository.replace` (`lib/data/links/sent_link_repository.dart`). Ekklo items added by hand get no status.

## Consequences

- A send interrupted after Ekklo was written but before the link was stored is adopted on the next read instead of being sent twice (`test/domain/journal/journal_service_test.dart`, "keeps the item of an interrupted send instead of sending it ...").
- An entry re-saved in MyFitnessPal with nothing that matters to Ekklo keeps its "Dans Ekklo" status under its new id (same test file, "moves a link to the new id of an entry re-saved in ...").
- Reading a day writes to the database. That is acceptable because the writes only reconcile the registry with what both services show.
- Every rule is tested as a pure function in `test/domain/comparison/compare_day_test.dart`, with no doubles at all.
- Updates (`ToUpdate`) will skip the matching screens 10 to 13 and go straight to screen 14 once the send flow exists (planned, see [0002](0002-write-ordering.md)).
- Adoption depends on Memory: a day sent before Memory knew a food or meal is not adopted until Memory learns it.
