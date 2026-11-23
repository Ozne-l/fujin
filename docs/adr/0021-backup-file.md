# 21. Backup file

Date: 2026-10-10

## Status

Accepted. Implements part C of [0005](0005-backup.md), with the format changes below. [0027](0027-barcode-scanner.md) adds version 2 with the barcode links; version 1 still imports. [0044](0044-connector-model.md) adds version 3 for the connector model (step 1, 2026-10-29); versions 1 and 2 are converted on import. Its step 2 (2026-10-30) writes version 4, adding the entries, MyFitnessPal links and Ekklo links; versions 3, 2 and 1 still import, their send links waiting in `sent_link` until each day is read. [0052](0052-dated-goals.md) writes version 5, with `goal_periods` in place of `goals`; older files still import, their goals starting on the export date. 2026-11-23: the Decision below describes version 5 and the tables of the connector model; a version 1 or 2 file that both matches a food and keeps an own copy of it is refused, since its unit weights would make the import throw.

## Context

[0005](0005-backup.md) planned a manual JSON file as the fallback for Auto Backup, whose restore of a sideloaded app is still unverified. Screens O6 (export) and O7 (import, with a confirmation) are reached from the Réglages tab. Since 0005, own copies moved to their own table ([0018](0018-send-flow.md)) and goals were added ([0020](0020-goals.md)). Fūjin needs the system document picker to write and read a file the owner chooses, and tests cannot drive that picker ([0012](0012-test-doubles-at-process-edges.md)).

## Decision

- Package: `file_picker` 13.1.0 (pub.dev/packages/file_picker, `FilePicker.saveFile` with `bytes`, which on Android opens the system "create document" dialog, and `FilePicker.pickFile`). It sits behind the `BackupFiles` interface (`lib/data/backup/backup_files.dart`: `save({name, bytes})` returns whether a file was written, `open()` returns the bytes or null when cancelled), implemented by `PickerBackupFiles` (`lib/data/backup/picker_backup_files.dart`, MIME type `application/json`) and provided by `backupFilesProvider` (`lib/app/providers.dart`). The picker is a process edge, so tests replace it with `FakeBackupFiles` (`test/support/fake_backup_files.dart`) and everything else runs for real.
- File name `fujin-backup-YYYY-MM-DD.json`, the export date in the owner's calendar (`BackupService.fileName`, `lib/domain/backup/backup_service.dart`, through `CalendarDateHook.format`).
- The file is the sealed `Backup` (`lib/data/backup/backup.dart`, dart_mappable, one subtype per `version`), with `format: "fujin-backup"`, `exported_at`, the waiting send `links` and `goal_periods`, the dated goals (a version 4 or older file has a single `goals`, turned on import into one period starting on its export date). Fūjin writes `BackupV5`, which also reads version 4: the rows of `food`, `food_serving`, `food_unit`, `food_reference`, `barcode_link`, `meal`, `meal_mapping`, `entry`, `mfp_link` and `ekklo_link`. `BackupV3` has the same rows without entries and their links. `BackupV2` reads versions 2 and 1, the Memory of before the connector model: `matches`, `own_copies`, `units`, `meals` and `barcode_links` (absent from version 1). JSON keys are snake case, as for the database rows.
- No credentials: sessions live in secure storage ([0011](0011-sessions-in-secure-storage.md)) and `BackupRepository.snapshot` (`lib/data/backup/backup_repository.dart`) reads only the rows above, the waiting send links (`SentLinkRepository.all`) and the goal periods (`GoalsRepository.periods`).
- Strict decode: `BackupCodec.decode` (`lib/data/backup/backup_codec.dart`) returns null unless the bytes are UTF-8 JSON with `format` "fujin-backup" and a version from 1 to 5 that dart_mappable decodes completely. A version 1 or 2 file must also be importable as Memory: every unit weight names a matched food, and no food is both matched and kept as an own copy. Null shows "Fichier illisible, rien n'a changé" and touches nothing. A file that cannot be written shows "Fichier non écrit, rien n'a changé" (`BackupFailure`, `lib/pages/settings/backup_failure.dart`).
- Import asks first: the confirmation sheet (`lib/pages/common/confirm_sheet.dart`, "Importer cette sauvegarde ?") shows the export date and the counts of foods, meals and links, then "Importer et remplacer".
- Replace, never merge, in one transaction: `BackupRepository.restore` deletes the foods and meals, writes the rows of a version 5, 4 or 3 file through `FoodRepository.restore`, `MealRepository.restore` and, for versions 5 and 4, `EntryRepository.restore`, or turns a version 2 or 1 file into rows through `MemoryRepository.restore`; then `SentLinkRepository.replaceAll` (`sent_link`) and `GoalsRepository.replaceAll` (`goals`), all inside `FujinDatabase.transaction`. The recent foods are read first and recorded again after. A file without goals deletes the stored goals, so the phone matches the file. Any failure rolls every table back.
- Presenter: `BackupNotifier` (`lib/pages/settings/backup_notifier.dart`) with states in `lib/pages/settings/backup_state.dart`; after an import it invalidates `memoryProvider`, `goalsProvider` and `journalProvider` so every tab shows the restored data. Cancelling either picker returns to idle with no message.

## Consequences

- A manual move between phones, or a restore when Auto Backup does not work for the sideloaded app, takes a few taps and one confirmation.
- Auto Backup ([0005](0005-backup.md) B) still covers the silent case: it copies `fujin.db` whole, goals included, with no action from the owner.
- Sessions are never in the file; after an import on a new phone the owner signs in again.
- An import discards anything recorded after the export, including goals set since.
- A new table or field means deciding whether it belongs in the file; a breaking change needs a new version and a decoder that still reads the earlier ones.
