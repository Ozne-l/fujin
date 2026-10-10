---
name: fujin-storage
description: Local persistence in Fūjin: the SQLite file fujin.db, FujinDatabase, migrations, repositories, row mapping, dates, what Android Auto Backup keeps, and where sessions live. Load when touching lib/data/, adding a table or column, writing SQL, adding a migration, changing schema.dart, saving Memory or send links, or when asked about "database", "sqlite", "migration", "upsert", "transaction", "backup", "tokens", "cookies", "secure storage".
---

# Fūjin storage

Everything Fūjin remembers lives in one SQLite file, `fujin.db`, opened through `FujinDatabase` (`lib/data/database/fujin_database.dart`) with the `sqlite3` package. SQL is hand-written; rows are written from and decoded by the `dart_mappable` mappers. Only that file is backed up. Credentials live elsewhere, in `flutter_secure_storage`.

The database runs synchronously on the UI isolate: the tables are tiny (a few hundred rows of Memory and links), and `sqlite3` 3.5.2 is pinned because 3.6+ needs a newer `meta` than Flutter 3.44 allows (`pubspec.yaml`).

## Rules

1. **Reach SQLite only through `FujinDatabase`; never import `package:sqlite3` elsewhere.**
   Why: the connection settings (rules 5 and 6) and migrations are applied once, in its private constructor, for every way of opening it.
   Example: `FujinDatabase.open(path)` in `lib/main.dart`, `FujinDatabase.inMemory()` in the tests; the constructor in `lib/data/database/fujin_database.dart`:
   ```dart
   FujinDatabase._(this._db) {
     _db
       ..execute('PRAGMA journal_mode = DELETE')
       ..execute('PRAGMA foreign_keys = ON');
     _migrate();
   }
   ```

2. **Write rows with `insert` or `upsert` from the model's `toMap()`; do not list columns by hand.**
   Why: column names come from the mapper (snake_case set in `build.yaml`), so a field rename cannot leave SQL behind.
   Example: `SentLinkRepository.add` (`lib/data/links/sent_link_repository.dart`):
   ```dart
   void add(SentLink link) =>
       _database.insert(FujinTable.sentLink, link.toMap());
   ```
   Tables are named through `FujinTable` (`lib/data/database/fujin_table.dart`); conflict keys are `static const` column names (`MemoryRepository._mfpFoodId` in `lib/data/memory/memory_repository.dart`).

3. **Upsert with `ON CONFLICT ... DO UPDATE`; never use `INSERT OR REPLACE`.**
   Why: on a conflict, `REPLACE` deletes the existing row before inserting, so the `ON DELETE CASCADE` on `memory_unit` would wipe a food's remembered units each time the food is saved again (sqlite.org, "UPSERT" and "The ON CONFLICT Clause").
   Example: `FujinDatabase.upsert` builds `ON CONFLICT (key) DO UPDATE SET column = excluded.column` (`lib/data/database/fujin_database.dart`). Pinned by the test "keeps the units of a food saved again" in `test/data/database_test.dart`.

4. **Write whole rows: a field missing from `toMap()` is written as `NULL`.**
   Why: `build.yaml` sets `ignoreNull: true`, so `toMap()` omits null fields. `FujinDatabase` binds every column of the table (read once from `pragma_table_info`), so saving an `OwnCopy` with `mfpFoodVersion: null` over a stored one clears the old version instead of keeping it. Pinned by "forgets the version of an own copy saved again without one" in `test/data/database_test.dart`.

5. **Keep foreign keys on and declare the cascade in the schema.**
   Why: SQLite enforces foreign keys only when each connection turns them on (sqlite.org, "SQLite Foreign Key Support").
   Example: `PRAGMA foreign_keys = ON` in the `FujinDatabase` constructor; `memory_unit.mfp_food_id REFERENCES memory_food ON DELETE CASCADE` in `lib/data/database/schema.dart`.

6. **Keep the rollback journal (`journal_mode = DELETE`), not WAL.**
   Why: in WAL mode committed data can sit in a `-wal` file next to the database, while the backup copies one file only (rule 13); the rollback journal leaves everything in `fujin.db` between transactions (sqlite.org, "PRAGMA journal_mode" and "Write-Ahead Logging").
   Example: the constructor in `lib/data/database/fujin_database.dart`.

7. **Group writes that belong together in `FujinDatabase.transaction`; nested calls join the outer transaction.**
   Why: a failure halfway rolls everything back. `transaction` opens `BEGIN IMMEDIATE` only when the connection is in autocommit, so a repository method can be transactional on its own and still be part of a larger one.
   Example: `MemoryRepository.saveFood` deletes the food's other kind of memory (an own copy drops the match and its units; a match drops the own copies) and upserts the food in one transaction (`lib/data/memory/memory_repository.dart`); `MemoryRepository.remember` writes the meal mappings, associations and unit weights of one send in one; `SentLinkRepository.replace` drops and adopts links in one (`lib/data/links/sent_link_repository.dart`). Pinned by "are all kept when one adoption is refused" and "keeps nothing of a send whose unit weight is refused" in `test/data/database_test.dart`.

8. **Persist the adoptions and drops found while reading a day, in one transaction, during that read.**
   Why: statuses are always recomputed from both apps, so the link registry is the only local truth; an interrupted send (Ekklo written, link not yet) is adopted on the next read instead of being sent twice.
   Example: `JournalService.readDay` calls `compareDay`, then `_links.replace(dropped: comparison.linksToDrop, adopted: comparison.linksToAdopt)` (`lib/domain/journal/journal_service.dart`). Pinned by "keeps the item of an interrupted send instead of sending it twice" in `test/domain/journal/journal_service_test.dart`.

9. **Change the schema by appending a script to `schemaMigrations`; never edit a script that has shipped.**
   Why: `PRAGMA user_version` records how many scripts a device has run; `_migrate` runs only the ones after it, each in its own transaction, then sets `user_version` to its position (sqlite.org, "PRAGMA user_version"). Editing an applied script never reaches existing installs.
   Example: `lib/data/database/schema.dart` and `FujinDatabase._migrate` (`lib/data/database/fujin_database.dart`); the second script adds `memory_food.mfp_unit`; the third moves own copies to `memory_own_copy`, one row per food and unit, then drops the columns `memory_food` no longer needs (ADR 0018). A new table also gets a `FujinTable` value. The test "reopening a database file keeps its rows and runs no migration twice" (`test/data/database_test.dart`) checks `schemaVersion` against `schemaMigrations.length`; a script that moves rows gets a test that rebuilds the older schema from the earlier scripts, sets `user_version`, and reopens the file ("moves the own copies of a version 2 database to one row per unit").
   Status: the first script is installed on the owner's phone (dev app) and on the emulator, so scripts are append only.

10. **Give each aggregate one repository that owns its SQL and returns models.**
    Why: callers think in Memory and send links, not tables; a table belongs to exactly one repository.
    Examples: `MemoryRepository` reads `memory_food`, `memory_own_copy`, `memory_unit`, `memory_meal` into one `Memory` (`lib/data/memory/memory_repository.dart`, `lib/data/memory/memory.dart`); `SentLinkRepository` owns `sent_link` (`lib/data/links/sent_link_repository.dart`). Both take the database as a private initializing formal and expose synchronous methods. They are provided in `lib/app/providers.dart`.

11. **Decode rows with the generated mapper; let a discriminator column pick the subtype.**
    Why: a result row is already a `Map<String, Object?>` with snake_case keys, so decoding is one call and stays in step with the model.
    Example: `SentLinkMapper.fromMap(row)` in `SentLinkRepository.forDate`; `MatchedFoodMapper.fromMap(row)` and `OwnCopyMapper.fromMap(row)` in `MemoryRepository.load`, one per table. Each subtype of `RememberedFood` writes its discriminator into the `kind` column of its table (`lib/data/memory/remembered_food.dart`), and `lib/data/database/schema.dart` checks it: `CHECK (kind = 'own_copy')` on `memory_own_copy`, `CHECK (kind IN ('ekklo', 'own_copy'))` on `memory_food`, from the first script, when both kinds shared that table.

12. **Store calendar dates as `YYYY-MM-DD` text through `CalendarDateHook`, and query them with `CalendarDateHook.format`.**
    Why: a diary day has no time of day; the short text form sorts correctly and backs the `sent_link_date` index. Instants such as `sent_at` keep the mapper's ISO 8601 encoding.
    Example: `@MappableField(hook: CalendarDateHook())` on `SentLink.date` (`lib/data/links/sent_link.dart`), the hook in `lib/data/database/calendar_date_hook.dart`, and `SentLinkRepository.forDate`:
    ```dart
    'SELECT * FROM sent_link WHERE date = ? ORDER BY sent_at, mfp_entry_id',
    [CalendarDateHook.format(date)],
    ```

13. **Back up `fujin.db` and nothing else.**
    Why: Memory and links are the owner's work and worth restoring; sessions and web view cookies must never leave the device. A whitelist keeps new files out by default (Android developers docs, developer.android.com, "Back up user data with Auto Backup").
    Example: `android/app/src/main/res/xml/data_extraction_rules.xml` (Android 12 and later, `cloud-backup` and `device-transfer`) and `android/app/src/main/res/xml/full_backup_content.xml` (older versions) both contain only `<include domain="file" path="fujin.db"/>`; `android/app/src/main/AndroidManifest.xml` points at both. `lib/main.dart` opens the file in `getApplicationSupportDirectory()`, which `path_provider` maps to the app's files directory on Android, the `file` domain.
    Status: restore of a sideloaded build is not verified yet (`adb shell bmgr backupnow`, uninstall, reinstall).

14. **Keep Ekklo tokens and MyFitnessPal cookies in `flutter_secure_storage`, never in SQLite.**
    Why: they are credentials; secure storage is encrypted by the platform and sits outside the backup whitelist by construction.
    Example: `SecureEkkloTokenStore` and `SecureMfpSessionStore` implement the client packages' `EkkloTokenStore` and `MfpSessionStore` (`lib/data/sessions/secure_ekklo_token_store.dart`, `lib/data/sessions/secure_mfp_session_store.dart`), keyed by `SessionKey` (`lib/data/sessions/session_key.dart`), wired in `mfpClientProvider` and `ekkloClientProvider` (`lib/app/providers.dart`).
    Status: both sign-ins are built (`lib/pages/ekklo_sign_in/`, `lib/pages/mfp_sign_in/`). The MyFitnessPal User-Agent is not stored: `lib/main.dart` reads the web view's at each launch ([ADR 0011](../../../docs/adr/0011-sessions-in-secure-storage.md)).

15. **Planned: export the five tables to `fujin-backup-YYYY-MM-DD.json` (`format: "fujin-backup"`, `version: 1`, no credentials) and import such a file by replacing all five tables in one transaction.**
    Why: Auto Backup restore is unverified for a sideloaded app; a file the owner keeps is the fallback. Import is strict and never merges.
    Status: not built; nothing under `lib/data/` handles it yet. It will reuse `FujinDatabase.transaction` (rule 7) and the mappers (rule 11).
