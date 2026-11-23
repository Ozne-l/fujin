# 52. Dated goals

Date: 2026-11-22

## Status

Accepted. Amends [0020](0020-goals.md) (one row, the same goals every day) and [0021](0021-backup-file.md) (backup version 5).

## Context

[0020](0020-goals.md) kept one set of goals for every day. When the owner lowers his kilocalorie goal for a cut, every past day of the week band is compared with the new goal, so days that met the old goal turn red. The goals of a day should be the ones in force on that day.

The owner chose, in this order: the goals saved before this change keep covering every past day, so nothing turns red after the update; a new set of goals always starts today, with no date to pick; no visible history for now; goals still cannot be deleted. The Figma file "Fūjin · Maquettes" carries the copy: the Réglages row reads "Depuis le 6 oct." with the summary (O1, O6, O7), "Aucun objectif" with "À définir" (O2); the editing page reads "Les jours passés gardent leurs objectifs.\nFūjin les compare à ton journal MyFitnessPal." above the section "À PARTIR D’AUJOURD’HUI" (O3 to O5).

## Decision

- The `goals` table holds one row per start day: `starts_on TEXT PRIMARY KEY` (a `YYYY-MM-DD` calendar date, skill `fujin-storage` rule 12), the same nutrient columns and checks, and `updated_at`. Migration 10 in `schemaMigrations` (`lib/data/database/schema.dart`) rebuilds the table and gives the existing row `starts_on = date(updated_at)`.
- The model is `GoalPeriod` (`lib/data/goals/goal_period.dart`): `startsOn` and `Goals`, laid flat into the row and the JSON by `FlatFieldHook` (`lib/data/database/flat_field_hook.dart`), the hook that also flattens the nutrients of `Food` and `Entry`.
- The goals of a day are those of the period with the latest start on or before it. The earliest period also covers every day before it: the goals saved before this change keep holding for the past, and "Depuis le" stays true for everything shown since. No period means no goals. The rule is `GoalTimeline` (`lib/domain/goals/goal_timeline.dart`): `periodOn(day)` and `on(day)`.
- `GoalsRepository` (`lib/data/goals/goals_repository.dart`): `periods` reads them by start day; `saveFrom(day)` upserts the period starting on that day and drops any period starting after it, in one transaction, so saving twice in a day keeps only the last; `GoalsNotifier.save` passes `todayProvider`, the day the screens show, so a save after midnight with the app left open still lands on the day the Réglages row reads; `replaceAll` is the backup import.
- `goalsProvider` (`lib/pages/common/goals_notifier.dart`) exposes the `GoalTimeline`. The Journal summary, the header link and each ring of the week band read the goals of their own day; the food card reads those of the entry's date; the Réglages row and the editing page read today's.
- The backup file moves to version 5 (`BackupV5`): `goal_periods` replaces `goals`. A version 4, 3, 2 or 1 file still imports; its single `goals` becomes one period starting on the local date of `exported_at`, the date in the file name (`BackupCodec._upgrade`), which covers every earlier day by the rule above.

## Consequences

- Lowering or raising a goal changes today and the days after it only, unless the period it replaces is the earliest one, whose goals also cover every day before it (goals saved for the first time today, then changed); the week band keeps the colours past days had.
- A goal saved today also covers tomorrow and later until the next save. A future start date, a history page and deleting a period are left for later.
- The migrated period starts on the day of its `updated_at`, which migration 8 stamped with the migration time unless the owner saved later, and `date(updated_at)` is the UTC day. East of UTC, as in France, it can be the day before the local one: being the earliest period, it covers every past day either way, and only the "Depuis le" label shows it. West of UTC it can be the day after; a save that same day then drops it, and the new goals cover the past days.
