# 4. One SQLite file

Date: 2026-10-07

## Status

Accepted

## Context

Fūjin keeps two kinds of local data: the Memory (which Ekklo food and grams stand for a MyFitnessPal food, which Ekklo meal stands for a MyFitnessPal meal) and the send links ([0001](0001-recompute-statuses-from-both-sides.md)). Both are small: a few hundred rows after months of use. They need atomic multi-row writes (drops and adoptions together), referential cleanup (units of a food), and a backup story ([0005](0005-backup.md)) that is simplest with a single file.

## Decision

- One SQLite file, `fujin.db` (`FujinDatabase.fileName`), opened in `getApplicationSupportDirectory()` by `lib/main.dart`. On Android that directory is the app's `files` directory, which the backup rules name.
- Package `sqlite3` pinned at 3.5.2 (`pubspec.yaml`, `pubspec.lock`). It bundles the native library, so the end-of-life `sqlite3_flutter_libs` is not needed. 3.6 and later require a newer `meta` than the one Flutter 3.44 pins (1.18.0 in `pubspec.lock`), so the pin stays until Flutter moves.
- Queries run synchronously on the UI isolate. The tables are tiny and every query reads one day or the whole Memory, so a background isolate would add message passing for no measurable gain. Revisit if a frame ever drops on a query.
- `FujinDatabase` (`lib/data/database/fujin_database.dart`) is the only class that touches `package:sqlite3`:
  - `PRAGMA journal_mode = DELETE` (rollback journal, not WAL) so the database at rest is one file, with no `-wal` or `-shm` companion to back up (sqlite.org, "Write-Ahead Logging" and "PRAGMA journal_mode").
  - `PRAGMA foreign_keys = ON`, needed on every connection for `ON DELETE CASCADE` to run (sqlite.org, "SQLite Foreign Key Support").
  - Migrations: `schemaMigrations` in `lib/data/database/schema.dart` is an ordered list of scripts. On open, every script past `PRAGMA user_version` runs in its own transaction and bumps `user_version` to its position. A schema change appends a script; existing scripts never change.
  - `insert` and `upsert` take the mapper's `toMap()`, whose keys are snake_case column names because of `caseStyle: snakeCase` in `build.yaml`, and bind every column of the table (read once from `pragma_table_info`). `ignoreNull: true` drops null fields from `toMap()`, so a missing key is written as `NULL`; a stored value is never kept by accident. Table names come from the `FujinTable` enum (`lib/data/database/fujin_table.dart`).
  - `upsert` writes `INSERT ... ON CONFLICT (key) DO UPDATE SET ...` (or `DO NOTHING` when every column is part of the key), never `INSERT OR REPLACE`. REPLACE deletes the existing row before inserting, and that delete would cascade to `memory_unit` (sqlite.org, "The ON CONFLICT Clause" and "UPSERT"). `test/data/database_test.dart` ("keeps the units of a food saved again") pins this.
  - `transaction` opens `BEGIN IMMEDIATE`, commits, or rolls back and rethrows. Called inside another transaction, it simply runs its body as part of the outer one.
- Hand-written SQL in repositories, one per aggregate: `MemoryRepository` (`lib/data/memory/memory_repository.dart`) and `SentLinkRepository` (`lib/data/links/sent_link_repository.dart`). Rows are decoded with `dart_mappable` mappers ([0007](0007-dart-mappable-models.md)); calendar dates are stored as `YYYY-MM-DD` through `CalendarDateHook` (`lib/data/database/calendar_date_hook.dart`).

Schema version 1 (`lib/data/database/schema.dart`):

| Table | Key | Holds |
| --- | --- | --- |
| `memory_food` | `mfp_food_id` | `kind` (`ekklo` or `own_copy`), Ekklo food id and name, `mfp_food_version` for own copies |
| `memory_unit` | `mfp_food_id`, `mfp_unit` | grams per MyFitnessPal unit; `ON DELETE CASCADE` from `memory_food` |
| `memory_meal` | `mfp_meal_name` | `ekklo_meal_name` |
| `sent_link` | `mfp_entry_id` | date, food, meal, servings, `mfp_serving_value`, unit, Ekklo meal id, `ekklo_item_id` (`UNIQUE`), `sent_at`; index on `date` |

## Consequences

- No ORM and no code generation for SQL; the schema is readable in one file.
- Saving a food as an own copy deletes its units in the same transaction (`MemoryRepository.saveFood`), since an own copy is counted in portions.
- `UNIQUE (ekklo_item_id)` makes a double adoption fail loudly; `test/data/database_test.dart` ("are all kept when one adoption is refused") shows the whole replace rolls back.
- Tests open the real engine, in memory or on a temporary file ([0012](0012-test-doubles-at-process-edges.md)).
- A slow query would block frames; the size of the data makes that unlikely today.
