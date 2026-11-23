# 54. A dropped write waits, like a failed read

Date: 2026-11-23

## Status

Accepted (the owner's choice, 2026-11-23). Amends the "offline is waiting" rule of [0044](0044-connector-model.md) for the background writer.

## Context

Two rules said what "offline" means for a background write. The writer stopped its run only on a network error of a read (`networkDown` kept GET and HEAD alone, because in Fūjin DEV `ReadOnlyHttpClient` refuses every other request with the same network error, [0017](0017-read-only-dev-environment.md)); a write that dropped was recorded as a write failure and the run went on to the next entry. The pages hid every network error in production (`SendFailure.network`), so that failure was recorded but never shown. The rules for "stopped" sat in an extension under `lib/pages/journal/`, and the writer's own test imported `lib/pages/sending/send_failure.dart` to check a failure blocked in DEV.

## Decision

- A network error on any request of a background write, read or write, means the network is down: the run stops and records no failure; the entry stays pending and the next run (back to the foreground, the network back, a pull) tries it again. A write that landed before its answer was lost is found by the existing guards: the writer reads the diary before an add, and a send keeps an interrupted Ekklo item instead of sending it twice.
- In Fūjin DEV a network error on a write is the read-only guard, not the network: it stays a write failure, shown as blocked. `networkDown(error, readOnly:)` (`lib/domain/writing/network_down.dart`) is the one predicate; the writer takes `readOnly` from `AppEnvironment.readOnly` at injection, and `SendFailure.of` asks the same predicate.
- `WriterState` answers per entry in the domain: `stopped` (every failure but that of the entry being written), `mfpFailedIds`, `failedIds`, `ekkloSendIds`, `ekkloRemovalIds`. `lib/pages/journal/writer_state_ids.dart` is gone.

## Consequences

- One definition of "offline is waiting" for the writer and the pages.
- A write that times out on a flaky connection no longer lets the run go on with the next entries; they wait for the next run.
- The pages still listen to the writer's state with `ref.listen`, as fujin-state rule 12 asks, but the meaning of a transition is the domain's: `WriterState.writtenSince(previous)` names the entry whose write just ended (`JournalPage` re-reads its days), `WriterState.runEndedSince(previous)` the end of a run (`JournalPage` shows the snackbar, `MemoryNotifier` reloads).
