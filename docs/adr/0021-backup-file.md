# 21. Backup file

Date: 2026-10-10

## Status

Accepted. Implements part C of [0005](0005-backup.md), with the format changes below.

## Context

[0005](0005-backup.md) planned a manual JSON file as the fallback for Auto Backup, whose restore of a sideloaded app is still unverified. Screens O6 (export) and O7 (import, with a confirmation) are reached from the Réglages tab. Since 0005, own copies moved to their own table ([0018](0018-send-flow.md)) and goals were added ([0020](0020-goals.md)). Fūjin needs the system document picker to write and read a file the owner chooses, and tests cannot drive that picker ([0012](0012-test-doubles-at-process-edges.md)).

## Decision

- Package: `file_picker` 13.1.0 (pub.dev/packages/file_picker, `FilePicker.saveFile` with `bytes`, which on Android opens the system "create document" dialog, and `FilePicker.pickFile`). It sits behind the `BackupFiles` interface (`lib/data/backup/backup_files.dart`: `save({name, bytes})` returns whether a file was written, `open()` returns the bytes or null when cancelled), implemented by `PickerBackupFiles` (`lib/data/backup/picker_backup_files.dart`, MIME type `application/json`) and provided by `backupFilesProvider` (`lib/app/providers.dart`). The picker is a process edge, so tests replace it with `FakeBackupFiles` (`test/support/fake_backup_files.dart`) and everything else runs for real.
- File name `fujin-backup-YYYY-MM-DD.json`, the export date in the owner's calendar (`BackupService.fileName`, `lib/domain/backup/backup_service.dart`, through `CalendarDateHook.format`).
- Format version 1 is `Backup` (`lib/data/backup/backup.dart`, dart_mappable): `format: "fujin-backup"`, `version: 1`, `exported_at`, `matches`, `own_copies`, `units`, `meals`, `links`, and `goals` (omitted when no goals are set). JSON keys are snake case, as for the database rows. The 0005 sketch (`exportedAt`, `foods`) is replaced: matched foods and own copies are separate lists because they are separate tables.
- No credentials: sessions live in secure storage ([0011](0011-sessions-in-secure-storage.md)) and `BackupRepository.snapshot` (`lib/data/backup/backup_repository.dart`) reads only Memory (`MemoryRepository.load`), links (`SentLinkRepository.all`) and goals (`GoalsRepository.load`).
- Strict decode: `BackupCodec.decode` (`lib/data/backup/backup_codec.dart`) returns null unless the bytes are UTF-8 JSON with `format` "fujin-backup" and `version` 1 that dart_mappable decodes completely. Null shows "Fichier illisible, rien n'a changé" and touches nothing. A file that cannot be written shows "Fichier non écrit, rien n'a changé" (`BackupFailure`, `lib/pages/settings/backup_failure.dart`).
- Import asks first: the confirmation sheet (`lib/pages/settings/sheets/confirm_sheet.dart`, "Importer cette sauvegarde ?") shows the export date and the counts of foods, meals and links, then "Importer et remplacer".
- Replace, never merge, in one transaction: `BackupRepository.restore` runs `MemoryRepository.replace` (`memory_food`, `memory_own_copy`, `memory_unit`, `memory_meal`), `SentLinkRepository.replaceAll` (`sent_link`) and `GoalsRepository.replace` (`goals`) inside `FujinDatabase.transaction`. A file without `goals` deletes the stored goals, so the phone matches the file. Any failure rolls all six tables back.
- Presenter: `BackupNotifier` (`lib/pages/settings/backup_notifier.dart`) with states in `lib/pages/settings/backup_state.dart`; after an import it invalidates `memoryProvider`, `goalsProvider` and `journalProvider` so every tab shows the restored data. Cancelling either picker returns to idle with no message.

## Consequences

- A manual move between phones, or a restore when Auto Backup does not work for the sideloaded app, takes a few taps and one confirmation.
- Auto Backup ([0005](0005-backup.md) B) still covers the silent case: it copies `fujin.db` whole, goals included, with no action from the owner.
- Sessions are never in the file; after an import on a new phone the owner signs in again.
- An import discards anything recorded after the export, including goals set since.
- A new table or field means deciding whether it belongs in the file; a breaking change needs version 2 and a decoder that still reads 1.
