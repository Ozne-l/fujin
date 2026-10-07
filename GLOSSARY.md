# Fūjin glossary

The words below have one meaning in Fūjin's code, docs and conversations. French terms are the ones shown in the app.

## Domain terms

**Journal.** The main screen: one day of the owner's MyFitnessPal diary, with, for each entry, whether it is in Ekklo. Code: `JournalPage` (`lib/pages/journal/journal_page.dart`), presenter `JournalNotifier` (`lib/pages/journal/journal_notifier.dart`).

**Day.** A calendar date with no time zone, stored as midnight UTC in memory and as `YYYY-MM-DD` in SQLite. The selected day defaults to today. Code: `SelectedDay`, `selectedDayProvider`, `todayProvider` (`lib/pages/journal/selected_day.dart`); `CalendarDateHook` (`lib/data/database/calendar_date_hook.dart`).

**Entry (MyFitnessPal).** One food logged in a MyFitnessPal meal: food, servings, serving size, nutrients, and an entry id that changes whenever the entry is edited in MyFitnessPal. Entries without an id cannot be linked. Code: `MfpFoodEntry` from `package:myfitnesspal_client`.

**Item (Ekklo).** One food inside an Ekklo meal: Ekklo food id, quantity, quantity type (grams or portion), creation date. Ekklo stores no free text on it, so Fūjin cannot tag it. Code: `EkkloDailyMealItem` inside `EkkloDailyMeal` from `package:ekklo_client`.

**Memory (Mémoire).** What Fūjin has learned about how MyFitnessPal maps to Ekklo: remembered foods, remembered units and meal mappings. Built by the owner, kept in SQLite, backed up. Code: `Memory` (`lib/data/memory/memory.dart`), `MemoryRepository` (`lib/data/memory/memory_repository.dart`).

**Remembered food.** The Ekklo food that stands for a MyFitnessPal food. Either a matched food, an existing Ekklo food counted in grams, or an own copy ("aliment perso"), a food Fūjin created in Ekklo from the MyFitnessPal one, counted in portions and tied to the MyFitnessPal food version it was copied from. Code: sealed `RememberedFood` with `MatchedFood` and `OwnCopy` (`lib/data/memory/remembered_food.dart`), table `memory_food`.

**Remembered unit.** How many grams one MyFitnessPal serving unit of a given food weighs, for matched foods logged in a unit other than grams. Code: `RememberedUnit` (`lib/data/memory/remembered_unit.dart`), table `memory_unit`.

**Meal mapping.** Which Ekklo meal receives a given MyFitnessPal meal. Without one, an entry of that meal has no expected item. Code: `MealMapping` (`lib/data/memory/meal_mapping.dart`), table `memory_meal`.

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

**Session.** The credentials a client needs: Ekklo tokens or MyFitnessPal session cookies, kept in secure storage, never backed up. Code: `SecureEkkloTokenStore`, `SecureMfpSessionStore`, `SessionKey` (`lib/data/sessions/`).

**Fake backends.** The test stand-in for both services: an `http` `MockClient` that serves MyFitnessPal and Ekklo routes from in-memory data and records requests. For runs on a device, separate local fake servers play the same role through `--dart-define`. Code: `FakeBackends` (`test/support/fake_backends.dart`).

## Screens

Codes from the Figma file "Fūjin · Maquettes", as used in the docs.

| Code | Meaning |
| --- | --- |
| K1 | Reference Journal: week band with rings, day card, meals |
| K7 | A Journal screen in the Figma file; its role is not described in the decision record |
| K12 | Journal with the Ekklo session expired: MyFitnessPal stays readable (planned; today any failure shows the problem card) |
| K14 | Scanner: barcode not found (out of v1) |
| K15 | Generic MyFitnessPal error banner |
| K19 | Journal with entries "À mettre à jour" |
| K20 | "Rien de nouveau" snackbar after a pull that changed nothing |
| 10 to 13 | Send flow: matching MyFitnessPal foods to Ekklo foods (planned) |
| 14 | "Envoi en cours", send progress (planned) |
| 06e | Own copy whose MyFitnessPal food changed version since it was copied (planned) |
| O1, O6 | Backup screens (Auto Backup and manual file); the decision record names them without detailing each (planned) |
| O7 | Confirmation before importing a backup file, which replaces everything (planned) |
