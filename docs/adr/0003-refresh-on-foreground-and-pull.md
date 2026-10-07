# 3. Refresh on foreground return and pull to refresh

Date: 2026-10-07

## Status

Accepted

## Context

Statuses are recomputed from both services ([0001](0001-recompute-statuses-from-both-sides.md)), so a Journal is only as fresh as its last read. The owner typically logs food in the MyFitnessPal phone app, then switches to Fūjin. Probes showed that the phone app keeps local edits until it syncs (its sync button, or a kill and relaunch); once synced, the API showed the change within 0 to 16 s. A pull that shows nothing new is therefore usually a MyFitnessPal app that has not synced yet.

## Decision

- The Journal re-reads both sides when the app returns to the foreground: `useOnAppLifecycleStateChange` in `lib/pages/journal/journal_page.dart` calls `JournalNotifier.reload()` on `AppLifecycleState.resumed`.
- Pull to refresh uses the stock Android `RefreshIndicator` (same file) and calls `JournalNotifier.refresh()` (`lib/pages/journal/journal_notifier.dart`).
- `refresh()` returns a `RefreshOutcome` (`lib/pages/journal/refresh_outcome.dart`): `nothingNew` when the MyFitnessPal diary (`MfpDiaryDay`) is equal before and after the read, `changed` otherwise, including after a failed read.
- Only `nothingNew` shows the info snackbar of screen K20 for 6 s: "Rien de nouveau" / "Modifié dans MyFitnessPal ? Synchronise l'app" (`nothingNewTitle`, `nothingNewDetail` in `lib/l10n/app_fr.arb`). The first display and foreground returns never show it.
- No polling and no background refresh.
- The journal provider does not retry failed reads (`retry: _noRetry` in `lib/pages/journal/journal_notifier.dart`); the problem card asks for a pull instead ("Tire vers le bas pour réessayer.", `lib/pages/journal/widgets/journal_problem_card.dart`).

## Consequences

- Fresh data costs one read of each service per foreground return, which is cheap for one day.
- The snackbar teaches the owner to sync the MyFitnessPal app instead of blaming Fūjin.
- Only the MyFitnessPal side decides "nothing new": a pull that changes only Ekklo still updates the screen but shows the snackbar.
- `test/pages/journal_page_test.dart` ("says nothing is new only after a pull that changed nothing") pins the snackbar rule.
