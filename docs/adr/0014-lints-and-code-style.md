# 14. Lints and code style

Date: 2026-10-07

## Status

Accepted

## Context

The owner writes his Dart packages (`~/Dev/ekklo_client`, `~/Dev/myfitnesspal_client`) in a consistent style, and wants Fūjin to read the same. Style rules that a tool can check should be checked by the tool.

## Decision

Tools:

- `very_good_analysis` 10.3.0 (`analysis_options.yaml`), with `public_member_api_docs` off and generated files excluded.
- `dart analyze --fatal-infos` must be clean: infos fail too.
- `dart format` on `lib`, `test` and `tool`; `dart format --set-exit-if-changed` must report no change.
- No DCM (Dart Code Metrics).

Owner style (checked in review):

- No comments. Names and small functions carry the meaning.
- No `!` null assertion. Use patterns instead, for example `if (match case final _Placement placement)` in `lib/domain/comparison/compare_day.dart`.
- No magic strings or numbers: enums or named constants (`FujinTable` in `lib/data/database/fujin_table.dart`, `SessionKey` in `lib/data/sessions/session_key.dart`, `ExpectedItem.quantityTolerance`, `JournalPage._nothingNewDuration`).
- `switch` over if-chains, exhaustive on sealed types and enums without a default where possible (`StatusCounts.of` in `lib/domain/journal/status_counts.dart`, the lifecycle switch in `lib/pages/journal/journal_page.dart`).
- `null` for absence, not sentinel values (`Memory.gramsPerUnit` returns `double?`, `ExpectedItem.forEntry` returns `ExpectedItem?`).
- One public type per file ([0013](0013-layers.md)).

## Consequences

- Adding a case to a sealed type or enum breaks every switch that must handle it, at compile time.
- Code review focuses on behaviour; layout and most style questions are settled by the tools.
