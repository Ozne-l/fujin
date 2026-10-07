# 13. Layers

Date: 2026-10-07

## Status

Accepted

## Context

Fūjin will grow from one screen to about a dozen plus a send flow. Without a fixed place for each kind of code, comparison rules would leak into widgets and SQL into notifiers.

## Decision

Four layers under `lib/`, dependencies pointing down only:

```
lib/app/      bootstrap, router, injection providers, theme      (lib/app/providers.dart, lib/app/router.dart)
lib/pages/    screens, their notifiers, widgets                  (lib/pages/journal/)
lib/domain/   rules and use cases, pure where possible           (lib/domain/comparison/, lib/domain/journal/)
lib/data/     SQLite, repositories, persistent session stores    (lib/data/database/, lib/data/memory/, lib/data/links/, lib/data/sessions/)
clients       package:ekklo_client, package:myfitnesspal_client
```

- `pages` may import `domain` and `app`; `domain` may import `data` and the clients; `data` may import the clients; nothing imports `pages` except `app` (the router).
- `lib/main.dart` is the bootstrap: it opens the database and overrides `databaseProvider`.
- `lib/domain/comparison/` holds pure functions only (no I/O, time passed in). I/O around them lives in a service, `JournalService` (`lib/domain/journal/journal_service.dart`).
- One public type per file, file named after it in snake_case (`lib/domain/comparison/expected_item.dart` holds `ExpectedItem`). Sealed families stay in one file with their subtypes (`lib/domain/comparison/entry_status.dart`).
- Planned folders: `lib/domain/sending/` (planner and executor), `lib/data/backup/` (JSON v1), `lib/pages/` for sending, memory, settings, add_food and scanner.

## Consequences

- A rule change touches `domain` and its pure tests, rarely a widget.
- Domain types reuse client models (`MfpFoodEntry`, `EkkloDailyMeal`) instead of copying them, so the clients are a real dependency of the domain.
- `lib/app/providers.dart` sees every layer, by design: it is the composition root.
