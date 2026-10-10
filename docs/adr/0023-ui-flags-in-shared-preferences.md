# 23. UI flags in shared preferences

Date: 2026-10-10

## Status

Accepted. Narrows [0004](0004-one-sqlite-file.md): `fujin.db` holds the owner's data; UI flags live beside it, in shared preferences. Builds the hint S5 that [0022](0022-journal-states-and-goal-rings.md) left out.

## Context

Screen S5 of the Figma section "Bandeau · montrer qu'il défile" (file "Fūjin · Maquettes") is a hint played on the first Journal display: the week band slides 44 px towards past weeks and back ("600 ms, ressort"), and the bubble "Glisse pour voir les semaines passées" stays "jusqu'au premier glissement ou 4 s". The note says it "ne sert qu'une fois (drapeau local)". Fūjin needs to remember, across launches, that the hint has played. That flag is not the owner's work: losing it replays a hint once, while restoring it from an old backup is harmless either way. It has no place in the backup file or in the tables a backup replaces.

## Decision

- UI flags such as "this hint was shown" live in shared preferences, not in `fujin.db`. Package: `shared_preferences` 2.5.6 (pub.dev/packages/shared_preferences), through its `SharedPreferencesWithCache` API: one async load at startup, then synchronous reads.
- `Hint` (`lib/data/hints/hint.dart`) names each flag with its preference key (`hint_week_band_swipe`); `HintRepository` (`lib/data/hints/hint_repository.dart`) reads `wasShown` and writes `markShown`, and `HintRepository.openPreferences` limits the cache to the keys of `Hint.values`.
- `lib/main.dart` opens the preferences and overrides `preferencesProvider`, whose default throws like `databaseProvider`; `hintRepositoryProvider` (`lib/app/providers.dart`) builds the repository.
- `WeekBand` (`lib/pages/journal/widgets/week_band.dart`) reads the flag once when it is built. Unseen, it marks the hint shown at once, before anything plays, so a swipe, a tab change or a crash during the hint never replays it; then it plays the nudge (`FujinMotion.bandNudge`, a spring of 300 ms out and 300 ms back, `FujinSize.bandNudge`) and shows `WeekBandHint` (`lib/pages/journal/widgets/week_band_hint.dart`) in an overlay under the band until the first drag on the band or 4 s.
- Android Auto Backup does not carry these flags. With the `SharedPreferencesWithCache` API, `shared_preferences_android` stores them through Jetpack DataStore in `files/datastore/FlutterSharedPreferences.preferences_pb`, in the `file` domain, and the backup rules (`android/app/src/main/res/xml/data_extraction_rules.xml`, `full_backup_content.xml`, named by `android/app/src/main/AndroidManifest.xml`) include only `fujin.db` there. A restored or transferred phone shows the hint once more.
- The backup file ([0021](0021-backup-file.md)) does not include them: `BackupRepository.snapshot` reads Memory, links and goals only, and an import leaves the flags as they are.
- Tests replace the platform store with `InMemorySharedPreferencesAsync` from `shared_preferences_platform_interface` (dev dependency), through `inMemoryPreferences` (`test/support/in_memory_preferences.dart`). `pumpFujin` gives each test a fresh store with every hint already shown, so no test sees a hint it did not ask for; a test passes `preferences: await inMemoryPreferences(shown: const [])` to see one.

## Consequences

- A new one-time hint is a `Hint` value and a `wasShown`/`markShown` pair at its screen; no migration, nothing to add to the backup.
- Shared preferences are for flags the owner would not miss. Anything the owner builds or would want back on a new phone still goes in `fujin.db`.
- On iOS, `shared_preferences` uses `NSUserDefaults`, which iCloud and device backups include [INFERENCE: not checked on a device]; the hint may then not replay after a restore there.
