# 53. One rule for the held Ekklo job

Date: 2026-11-23

## Status

Accepted. Amends the sentence of [0002](0002-write-ordering.md) that gives each write use case its own service, for the undo and the delete of [0043](0043-edit-and-delete-a-logged-food.md); the write order is unchanged.

## Context

Since [0044](0044-connector-model.md) an add, an edit, the revert of an edit and a removal are stored in `fujin.db` first, and the background writer writes the apps afterwards with a held Ekklo job. Each of the four paths decided that job itself, with three rules: an add held any plan that sends, an edit and a revert held it only when the entry already had an Ekklo item or a held send, and never a unit weight still to choose, and a removal held the removal of a live item. An add whose weight was still to choose was kept off Ekklo only because the fiche asks to choose before adding. `d0e238e` had to fix the edit's rule in the service and the fiche at once. The rescale of the planned entry to the stored entry was written three times.

## Decision

- `BackgroundWriter` decides every held Ekklo job. `saved(stored, planned, added:)` rescales the planned entry to the stored entry, holds it when it sends, its Ekklo side is not "à choisir", and the entry is new, has an Ekklo item or already has a held send, and otherwise drops a held send; `removed(logged)` drops any held job and holds the removal of a live item. Both start a run. The derived Ekklo send stays in the writer as before. `hold` and `drop` are private and `heldFor` is gone; tests read the held jobs from `BackgroundWriter.state.held`.
- `AddFoodService.add`, `EditEntryService.save` and `EditEntryService.revert` store the entry, then call `saved`. The delete and the undo of an add are `EditEntryService.remove`, which soft-deletes the entry and calls `removed`; `RemoveEntryService` is gone and `RemoveEntryNotifier` calls `EditEntryService`.
- An own copy is not renewed at store time. `saved` only rescales; the writer renews a stale own copy when it writes (`_renewed`), after the MyFitnessPal write has moved the entry's food version. Renewing at store time would compare the new version's own copy with the old link of an edit opened on a newer food version, and create a copy the owner does not need.

## Consequences

- An add whose Ekklo food is still to choose is no longer held, whatever the caller.
- One place to change when a held job's rule changes; the fiche still reads the held sends from the writer's state to name its button.
- `rescalePlanned` is called by the add fiche's re-plan (`AddFoodService.plan`), `saved` and the writer's renewal.
