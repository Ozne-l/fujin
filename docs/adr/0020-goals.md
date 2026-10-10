# 20. Goals

Date: 2026-10-10

## Status

Accepted.

## Context

Screens O1 to O5 in the Figma file "Fūjin · Maquettes" show daily nutrition goals on the Réglages tab: a summary row (O1, or "Aucun objectif" in O2) and an editing page with kilocalories, protein, carbohydrates, fat and fiber (O3 to O5). The page subtitle reads "Les mêmes chaque jour. Fūjin les compare\nà ton journal MyFitnessPal." MyFitnessPal has its own goals, but `package:myfitnesspal_client` does not read or write them, and Fūjin only reads the MyFitnessPal diary. Ekklo has no goals Fūjin uses. The owner wants one set of numbers that survives a phone change like the Memory does ([0005](0005-backup.md)).

## Decision

- Goals are stored by Fūjin in its SQLite file ([0004](0004-one-sqlite-file.md)), not in MyFitnessPal or Ekklo. Migration 4 in `schemaMigrations` (`lib/data/database/schema.dart`) creates the `goals` table, named by `FujinTable.goals` (`lib/data/database/fujin_table.dart`).
- One row, the same goals every day: `id INTEGER PRIMARY KEY CHECK (id = 1)`. No per-day or per-weekday goals.
- Kilocalories are required (`REAL NOT NULL CHECK (kilocalories > 0)`); protein, carbohydrates, fat and fiber are optional, each `CHECK (... > 0)` when present. The model is `Goals` (`lib/data/goals/goals.dart`, dart_mappable, [0007](0007-dart-mappable-models.md)) with `kilocalories` required and the four others nullable.
- `GoalsRepository` (`lib/data/goals/goals_repository.dart`) owns the table: `load` returns the row or null, `save` upserts row 1 (null fields clear their column, skill `fujin-storage` rule 6), `replace` saves or deletes, used by the backup import.
- The editing page parses each field with `GramsInput.parse` (`lib/pages/common/grams_input.dart`): a finite number above zero, in the locale's decimal format, or nothing. `GoalAmounts.from` (`lib/domain/goals/goal_amounts.dart`) builds `Goals` only when kilocalories are set; an empty kilocalories field means nothing can be saved.
- Macro coherence is informational only. `MacroEnergy.of` (`lib/domain/goals/macro_energy.dart`) adds the kilocalories of the macros present (protein and carbohydrates at 4 kcal per gram, fat at 9, from `Nutrient.kilocaloriesPerGram`) and lists the missing ones; the page shows it next to the kilocalorie goal ("Pour un objectif de {energy} kcal. À titre indicatif.") and never blocks saving when they disagree. Fiber is not counted.
- Presenter: `GoalsNotifier` and `goalsProvider` (`lib/pages/settings/goals_notifier.dart`, [0006](0006-riverpod-notifiers-as-presenters.md)). Page: `GoalsPage` (`lib/pages/settings/goals_page.dart`), summary text in `GoalsText` (`lib/pages/settings/goals_text.dart`). Route `FujinRoute.goals` (`/settings/goals`, `lib/app/fujin_route.dart`), a child of `FujinRoute.settings` in the Réglages branch (`lib/app/router.dart`).
- Goals are part of the backup file, version 1, as an optional `goals` field ([0021](0021-backup-file.md)).

## Consequences

- Changing goals in MyFitnessPal does not change them in Fūjin, and the other way round; the owner keeps them in one place on purpose.
- The single row needs no date logic: whatever day the Journal shows, the goals are the same.
- Auto Backup carries goals with `fujin.db` ([0005](0005-backup.md) B) and the backup file carries them too.
- The model rejects nothing the owner might reasonably type: incoherent macros are shown, not refused.
