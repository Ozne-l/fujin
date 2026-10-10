# Fūjin glossary

The words below have one meaning in Fūjin's code, docs and conversations. French terms are the ones shown in the app.

## Domain terms

**Journal.** The main screen: one day of the owner's MyFitnessPal diary, with, for each entry, whether it is in Ekklo. Code: `JournalPage` (`lib/pages/journal/journal_page.dart`), presenter `JournalNotifier` (`lib/pages/journal/journal_notifier.dart`).

**Day.** A calendar date with no time zone, stored as midnight UTC in memory and as `YYYY-MM-DD` in SQLite. The selected day defaults to today. Code: `SelectedDay`, `selectedDayProvider`, `todayProvider` (`lib/pages/journal/selected_day.dart`); `CalendarDateHook` (`lib/data/database/calendar_date_hook.dart`).

**Entry (MyFitnessPal).** One food logged in a MyFitnessPal meal: food, servings, serving size, nutrients, and an entry id that changes whenever the entry is edited in MyFitnessPal. Entries without an id cannot be linked. Code: `MfpFoodEntry` from `package:myfitnesspal_client`.

**Item (Ekklo).** One food inside an Ekklo meal: Ekklo food id, quantity, quantity type (grams or portion), creation date. Ekklo stores no free text on it, so Fūjin cannot tag it. Code: `EkkloDailyMealItem` inside `EkkloDailyMeal` from `package:ekklo_client`.

**Memory (Mémoire).** What Fūjin has learned about how MyFitnessPal maps to Ekklo: remembered foods, remembered units and meal mappings. Built by the owner, kept in SQLite, backed up. Shown on the Mémoire tab, where the owner changes the Ekklo food of a remembered food, edits unit weights, changes meal mappings, or forgets a food so the next send asks again. Code: `Memory` (`lib/data/memory/memory.dart`), `MemoryRepository` (`lib/data/memory/memory_repository.dart`), `MemoryService` (`lib/domain/memory/memory_service.dart`).

**Remembered food.** The Ekklo food that stands for a MyFitnessPal food. Either a matched food, an existing Ekklo food counted in grams, or an own copy ("aliment perso"), a food Fūjin created in Ekklo as an exact copy of a MyFitnessPal entry's values, tied to the serving unit and the MyFitnessPal food version it was copied from: per 100 g for a gram serving, one portion per unit otherwise. Code: sealed `RememberedFood` with `MatchedFood` and `OwnCopy` (`OwnCopy.mfpUnit`, `OwnCopy.mfpFoodVersion`) (`lib/data/memory/remembered_food.dart`), tables `memory_food` (matched foods) and `memory_own_copy` (own copies, one per food and serving unit).

**Remembered unit.** How many grams one MyFitnessPal serving unit of a given food weighs, for matched foods logged in a unit other than grams. Code: `RememberedUnit` (`lib/data/memory/remembered_unit.dart`), table `memory_unit`.

**Meal mapping.** Which Ekklo meal receives a given MyFitnessPal meal. Without one, an entry of that meal has no expected item; the first send of that meal keeps its name in Ekklo and records the mapping. Code: `MealMapping` (`lib/data/memory/meal_mapping.dart`), table `memory_meal`.

**Send link.** Fūjin's record that one MyFitnessPal entry is represented by one Ekklo item: entry id, date, food, meal, servings, serving value and unit, Ekklo meal and item ids, send time. The only state Fūjin keeps about sending. Code: `SentLink` (`lib/data/links/sent_link.dart`), `SentLinkRepository` (`lib/data/links/sent_link_repository.dart`), table `sent_link`.

**Orphan link.** A send link whose Ekklo item still exists but whose MyFitnessPal entry id no longer appears in the day, usually because the entry was edited and got a new id. Code: `_Orphan` in `lib/domain/comparison/compare_day.dart`.

**Adoption.** Creating a send link for an unlinked entry because an unclaimed Ekklo item already matches its expected item, for example after a send interrupted before its link was written. Code: `adopt` inside `compareDay`, result in `DayComparison.linksToAdopt`.

**Relink.** Moving an orphan link to the new id of an edited entry when the orphan's Ekklo item still matches what the edited entry expects: the old link is dropped and a new one adopted, and the entry stays "Dans Ekklo". Code: the `(true, _)` case of the orphan pass in `compareDay` (`adopt(..., replacing: link)`).

**Status.** Where an entry stands, recomputed on every read: "Dans Ekklo" (`InEkklo`, carries its link), "À envoyer" (`ToSend`), "À mettre à jour" (`ToUpdate`, carries the orphan link and an `UpdateKind`: `quantityOnly` when the Ekklo meal is unchanged, `mealChanged` otherwise). Code: sealed `EntryStatus` (`lib/domain/comparison/entry_status.dart`), `UpdateKind` (`lib/domain/comparison/update_kind.dart`).

**Expected item.** The Ekklo item Memory predicts for an entry: Ekklo meal name, Ekklo food id, quantity rounded to 0.1, quantity type. Null when Memory lacks the food, the meal mapping, or the grams of a non-gram unit. Matches an item within 0.1. Code: `ExpectedItem.forEntry` and `ExpectedItem.matches` (`lib/domain/comparison/expected_item.dart`).

**Day comparison.** The result of comparing one day: each entry with its status, plus the links to adopt and the links to drop. Produced by the pure function `compareDay`. Code: `DayComparison` (`lib/domain/comparison/day_comparison.dart`), `ComparedEntry` (`lib/domain/comparison/compared_entry.dart`), `compareDay` (`lib/domain/comparison/compare_day.dart`).

**Journal day.** Everything the Journal shows for one day: the MyFitnessPal diary, its meal names, the Ekklo meals and the day comparison, with derived meals, counts and energy totals. Code: `JournalDay` (`lib/domain/journal/journal_day.dart`), `JournalMeal` (`lib/domain/journal/journal_meal.dart`), built by `JournalService.readDay` (`lib/domain/journal/journal_service.dart`).

**Status counts.** How many entries of a day or meal are in Ekklo, to send and to update; `pending` is the last two. They feed "N/M dans Ekklo" and the send button label. Code: `StatusCounts` (`lib/domain/journal/status_counts.dart`).

**Refresh outcome.** What a pull to refresh found: `changed`, or `nothingNew` when the MyFitnessPal diary is identical before and after, which triggers the "Rien de nouveau" snackbar. Code: `RefreshOutcome` (`lib/pages/journal/refresh_outcome.dart`).

**Send plan.** What a send will do for one day, built before anything is written: one planned entry per entry "À envoyer" or "À mettre à jour" with a MyFitnessPal id, the entries still being searched, and the entries already in Ekklo. Code: `SendPlan` (`lib/domain/sending/send_plan.dart`), built by `SendService.plan` (`lib/domain/sending/send_service.dart`) from the pure rules in `planEntry` (`lib/domain/sending/plan_entry.dart`).

**Planned entry.** One entry of a send plan: its Ekklo meal, its choice (an Ekklo food with grams, an own copy to reuse or create, or skipped), its ranked candidates, whether it is reviewed and confirmed, and the link of the item it updates. Code: `PlannedEntry` (`lib/domain/sending/planned_entry.dart`), sealed `SendChoice` (`SendToEkkloFood`, `SendAsOwnCopy`, `SkipEntry`, `lib/domain/sending/send_choice.dart`).

**Automatic / to review.** A planned entry is automatic ("Mémorisé") when Memory fully decides it; an automatic new own copy says why instead: "Nouvelle unité" when the food has an own copy only in another unit, "Aliment modifié" when its own copy is stale (`OwnCopyRenewal`, `lib/domain/sending/own_copy_renewal.dart`); every other one is to review ("à vérifier") on screen 10 and shows why: "Poids à confirmer", "Nouvelle association", "Aucun aliment proche", then "Confirmé" or "Sauté". Code: `PlannedEntry.reviewed`, `ReviewReason` (`lib/domain/sending/review_reason.dart`).

**Candidate.** An Ekklo food proposed for a MyFitnessPal entry, with the grams to send, whether they were estimated from the kilocalories, the nutrient gaps and how the names match. Acceptable when a name or brand word is shared and the gaps are within tolerance (kcal 12 %, each macro 10 % or 5 kcal). Code: `EkkloCandidate` (`lib/domain/sending/ekklo_candidate.dart`), `NutrientDeltas` (`lib/domain/sending/nutrient_deltas.dart`), `NameMatch`, `rankCandidates` (`lib/domain/sending/rank_candidates.dart`).

**Unit weight.** How a planned Ekklo food got the grams of a non-gram serving: remembered, estimated from the kilocalories, or confirmed by the owner (screen 12). Estimated and confirmed weights become remembered units when the send runs. Code: `UnitWeight` (`lib/domain/sending/unit_weight.dart`).

**Send step.** One write of a send, shown on screens 14 and 16: create an own copy, update a quantity in place, or send one Ekklo meal. Code: sealed `SendStep` (`OwnCopyStep`, `QuantityUpdateStep`, `MealStep`, `lib/domain/sending/send_step.dart`), `SendProgress`, `StepState`.

**Send report.** What screen 15 sums up: foods sent, remembered foods reused, new associations, retained unit weights, own copies created, updates. Code: `SendReport` (`lib/domain/sending/send_report.dart`).

**Session.** The credentials a client needs: Ekklo tokens or MyFitnessPal session cookies, kept in secure storage, never backed up. Code: `SecureEkkloTokenStore`, `SecureMfpSessionStore`, `SessionKey` (`lib/data/sessions/`).

**Connected accounts.** Whether a session is stored for MyFitnessPal and for Ekklo; it does not ask either service whether the session still works. It decides between the welcome screen and the Journal. Code: `ConnectedAccounts`, `AccountsService` (`lib/domain/accounts/`).

**Goals.** The owner's daily nutrition targets, the same every day: kilocalories (required) and optionally protein, carbohydrates, fat and fiber, all above zero. Stored by Fūjin, not MyFitnessPal, in one row of the `goals` table. The kilocalories of the macros (P×4 + C×4 + F×9) are compared with the kilocalorie goal for information only. Code: `Goals` (`lib/data/goals/goals.dart`), `GoalsRepository` (`lib/data/goals/goals_repository.dart`), `MacroEnergy` (`lib/domain/goals/macro_energy.dart`), `goalsProvider` (`lib/pages/settings/goals_notifier.dart`). ADR 0020.

**Backup file.** A JSON file `fujin-backup-YYYY-MM-DD.json` the owner exports and imports from Réglages: format `fujin-backup` version 1 with Memory, send links and goals, never sessions. Import is strict and replaces everything in one transaction after a confirmation. Code: `Backup` (`lib/data/backup/backup.dart`), `BackupCodec` (`lib/data/backup/backup_codec.dart`), `BackupRepository` (`lib/data/backup/backup_repository.dart`), `BackupService` (`lib/domain/backup/backup_service.dart`), `BackupFiles` (`lib/data/backup/backup_files.dart`). ADR 0021.

**Fake backends.** The test stand-in for both services: an `http` `MockClient` that serves MyFitnessPal and Ekklo routes from in-memory data and records requests. For runs on a device, separate local fake servers play the same role through `--dart-define`. Code: `FakeBackends` (`test/support/fake_backends.dart`).

## Screens

Codes from the Figma file "Fūjin · Maquettes", as used in the docs.

| Code | Meaning |
| --- | --- |
| 00 | Splash (planned) |
| 01 | Welcome: one card per account, MyFitnessPal and Ekklo, each with "Se connecter"; "Continuer" stays disabled until both are signed in. Shown instead of the Journal while either session is missing. Code: `WelcomePage` (`lib/pages/welcome/welcome_page.dart`) |
| 02 | MyFitnessPal sign-in in a web view: Fūjin reads the session cookies after each page load and closes the page once MyFitnessPal accepts them. Code: `MfpSignInPage` (`lib/pages/mfp_sign_in/mfp_sign_in_page.dart`), reached from 01 and from "Se reconnecter à MyFitnessPal" on the Journal problem card |
| 03 | Ekklo sign-in: email, password, "Se connecter". Code: `EkkloSignInPage` (`lib/pages/ekklo_sign_in/ekklo_sign_in_page.dart`), reached from 01 and from "Se reconnecter à Ekklo" on the Journal problem card |
| 03b | Ekklo sign-in refused: banner "Ekklo a refusé la connexion" with Ekklo's own message in quotes, password field outlined in red until edited |
| 03c | Ekklo sign-in with no answer from Ekklo (network, server error, unreadable reply): banner "Ekklo ne répond pas" |
| 04 | Both accounts connected: 01 with a "Connecté" pill and "Session active" on each card, "Continuer" opens the Journal. The mockup shows the Ekklo email; Fūjin keeps no email, so the Ekklo card says "Session active" too |
| K1 | Reference Journal: week band with rings, day card, meals |
| K7 | Journal with the MyFitnessPal session expired ("Session MyFitnessPal expirée" in the Figma file) |
| K12 | Journal with the Ekklo session expired: MyFitnessPal stays readable (planned; today any failure shows the problem card, which already offers "Se reconnecter à Ekklo") |
| K14 | Access blocked by MyFitnessPal's anti-bot check (out of v1) |
| K15 | Generic MyFitnessPal error banner |
| K19 | Journal with entries "À mettre à jour" |
| K20 | "Rien de nouveau" snackbar after a pull that changed nothing |
| 09 | "Recherche en cours": Fūjin plans the send, one Ekklo search per unknown food. Code: `SearchingView` (`lib/pages/sending/widgets/searching_view.dart`) |
| 10 | "À vérifier": the plan, filtered by "à vérifier", "automatiques" and "déjà dans Ekklo", and the send button. Code: `ReviewView` (`lib/pages/sending/widgets/review_view.dart`) |
| 11 | Sheet "Choisir l'aliment Ekklo": candidates, Ekklo search, own copy or skip. Code: `showMatchSheet` (`lib/pages/sending/sheets/match_sheet.dart`) |
| 12 | Sheet "Poids d'une unité". Code: `showWeightSheet` (`lib/pages/sending/sheets/weight_sheet.dart`) |
| 13 | Sheet "Aucune correspondance": own copy preselected, rejected candidates listed. Code: `showOwnCopySheet` (`lib/pages/sending/sheets/own_copy_sheet.dart`) |
| 14 | "Envoi en cours", send progress per step. Code: `SendingView` (`lib/pages/sending/widgets/sending_view.dart`) |
| 15 | "Envoi terminé", the send report. Code: `SentView` (`lib/pages/sending/widgets/sent_view.dart`) |
| 16 | "Envoi interrompu": why, what is already in Ekklo, "Envoyer les N aliments restants". Code: `InterruptedView` (`lib/pages/sending/widgets/interrupted_view.dart`) |
| 17 | Result of a send in "Mode automatique", a Réglages setting (planned) |
| 18 | Mémoire tab, the second tab: remembered foods with their Ekklo food and unit weights, searchable without accents. Code: `MemoryPage` (`lib/pages/memory/memory_page.dart`) |
| 19 | A remembered food: its MyFitnessPal and Ekklo sides, "Changer ›" (Ekklo search sheet, `showChangeFoodSheet`), unit weights, "Oublier cet aliment". Code: `MemoryFoodPage` (`lib/pages/memory/memory_food_page.dart`) |
| 20 | Mémoire, "Repas": one row per meal mapping with a menu of Ekklo meal names. Code: `MealMappingsCard` (`lib/pages/memory/widgets/meal_mappings_card.dart`) |
| 21 | Mémoire with nothing remembered yet. Code: `MemoryEmptyView` (`lib/pages/memory/widgets/memory_empty_view.dart`) |
| 06e | Own copy whose MyFitnessPal food changed version since it was copied (planned) |
| O1, O2 | Réglages tab, the third tab: "objectifs définis" (O1) and "aucun objectif" (O2): accounts, goals, backup, data on this phone, app version. Code: `SettingsPage` (`lib/pages/settings/settings_page.dart`) |
| O3, O4, O5 | Goal editing: complete goals, empty fields, just saved. Code: `GoalsPage` (`lib/pages/settings/goals_page.dart`), `GoalsNotifier` (`lib/pages/settings/goals_notifier.dart`) |
| O6, O7 | Backup file exported (O6) and imported (O7), reached from Réglages; the import replaces everything after a confirmation. Code: `BackupNotifier` (`lib/pages/settings/backup_notifier.dart`), confirmation sheet (`lib/pages/settings/sheets/confirm_sheet.dart`) |
