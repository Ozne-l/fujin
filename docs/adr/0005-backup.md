# 5. Backup

Date: 2026-10-07

## Status

Accepted. B (Android Auto Backup) is implemented; C (manual file) is planned.

## Context

The Memory takes weeks of matching to build and the send links prevent double sends. Losing them on a phone change would be costly. Sessions (Ekklo tokens, MyFitnessPal cookies) must never leave the phone ([0011](0011-sessions-in-secure-storage.md)). Fūjin is sideloaded, not installed from the Play Store. The screens are O1, O6 and O7 in the Figma file.

## Decision

B, Android Auto Backup (implemented):

- `android/app/src/main/AndroidManifest.xml` sets `allowBackup`, `dataExtractionRules` and `fullBackupContent`.
- `android/app/src/main/res/xml/data_extraction_rules.xml` (Android 12 and later, cloud backup and device transfer) and `android/app/src/main/res/xml/full_backup_content.xml` (older versions) each include one path: `fujin.db` in the `file` domain. Android backs up only what an include rule names, so everything else (secure storage, web view cookies) stays out by construction (docs: developer.android.com, "Back up user data with Auto Backup").
- The rollback journal ([0004](0004-one-sqlite-file.md)) keeps the database in that one file at rest.

Not verified: whether Auto Backup restores a sideloaded app. Procedure for the owner, package `dev.oznel.fujin`:

```sh
adb shell bmgr enable true
adb shell bmgr backupnow dev.oznel.fujin
adb uninstall dev.oznel.fujin
flutter install
```

Then open the app and check that Memory and links came back.

C, manual file (planned, not built):

- Export `fujin-backup-YYYY-MM-DD.json` through the system document picker.
- Format version 1: `{format: "fujin-backup", version: 1, exportedAt, foods, meals, links}`. No credentials.
- Import decodes strictly: an unknown `format` or `version` shows "Fichier illisible, rien n'a changé" and touches nothing. After a confirmation (O7), it replaces all four tables (`memory_food`, `memory_unit`, `memory_meal`, `sent_link`) in one transaction. Replace, never merge.
- It will live in `lib/data/backup/`, with its own notifier ([0006](0006-riverpod-notifiers-as-presenters.md)).

## Consequences

- A phone change with Google backup on should carry the Memory over with no action, if restore works for sideloaded apps.
- C covers the case where it does not, and a manual move between phones.
- Replace-only import keeps the file format simple and avoids conflict rules between two registries; the cost is that an import discards anything recorded after the export.
- Sessions are never restored: after a restore the owner signs in again.
