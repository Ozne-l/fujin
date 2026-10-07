# 7. dart_mappable models

Date: 2026-10-07

## Status

Accepted

## Context

Fūjin models need value equality (the refresh rule compares two `MfpDiaryDay` values, [0003](0003-refresh-on-foreground-and-pull.md)), `copyWith`, readable `toString` for test failures, maps for SQLite rows ([0004](0004-one-sqlite-file.md)) and JSON for the planned backup file ([0005](0005-backup.md)). Sealed unions need a discriminator when stored. Both client packages already use `dart_mappable`.

## Decision

- Every model and every sealed union is a `dart_mappable` class (`dart_mappable` 4.10.0, builder `dart_mappable_builder`), one public type per file, with its generated `*.mapper.dart` part committed next to it.
- `build.yaml` sets `caseStyle: snakeCase` (map keys equal SQL column names) and `ignoreNull: true`.
- Sealed unions use a discriminator: `RememberedFood` with `discriminatorKey: 'kind'`, values `ekklo` and `own_copy`, which is also the SQL `CHECK` on `memory_food.kind` (`lib/data/memory/remembered_food.dart`); `EntryStatus` with key `status` (`lib/domain/comparison/entry_status.dart`).
- Enums use `@MappableEnum()` (`lib/domain/comparison/update_kind.dart`).
- Field-level encoding goes through hooks: `CalendarDateHook` stores a calendar date as `YYYY-MM-DD` (`lib/data/database/calendar_date_hook.dart`, used on `SentLink.date`).
- Decoding is strict: a missing required key throws instead of producing a default.
- Regenerate with `dart run build_runner build` after changing a model.

## Consequences

- Repositories decode a row with `XMapper.fromMap(row)` and encode with `toMap()`, so a column name exists once, as a field name.
- Generated files are excluded from analysis (`analysis_options.yaml`).
- A model whose `part` file was never generated does not compile, so a missing run of the builder shows up at once.
