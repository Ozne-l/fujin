# 30. MyFitnessPal foods shown when Ekklo or the network is missing

Date: 2026-10-14

## Status

Accepted. Amends the `MfpOnly` meals and the offline state of [0022](0022-journal-states-and-goal-rings.md).

## Context

The UI/UX audit of 2026-10-14 walked the Journal on the emulator with fake servers. With the Ekklo session expired (K12), each meal card showed only its name, its kilocalories and "Ekklo indisponible", while the problem card above says "Ton journal MyFitnessPal reste lisible": the foods were read but not shown, and a tap on a meal did nothing. Offline (K13), the Journal kept the day card with "Les chiffres datent de 14:54" and dropped the meals altogether, although the previous read still held them.

## Decision

- Every `JournalRead` gives its MyFitnessPal meals as `DiaryMeal`s (`lib/domain/journal/diary_meal.dart`): the meal name, its entries and their kilocalories, in the meal order of `JournalMeal.namesOf`. `BothSides` takes them from its journal day, `MfpOnly` from its diary, `EkkloOnly` has none. `MfpOnly.mealKilocalories` is removed.
- `DiaryMealCard` (`lib/pages/journal/widgets/diary_meal_card.dart`, formerly `UnavailableMealCard`) shows the meal title and kilocalories, an optional note, and each food with its serving and macros, without any status pill. A meal without food says "Rien pour l’instant". The card never folds and offers no add button.
- With Ekklo missing (`MfpOnly`), the note is "Ekklo indisponible". Offline, or whenever a read fails over a previous one, the Journal shows the previous read's meals under the day card, without a note: the problem card above already gives their time. A previous `EkkloOnly` read has no MyFitnessPal meals, so no meal section is shown.
- Statuses ("Dans Ekklo", "À envoyer", "À mettre à jour") are shown only from a fresh read of both sides; a held read never shows them under a problem card, since they could be out of date. The send button stays disabled in both states, as before.
- `MealCard` and `DiaryMealCard` share `EntryRow` and `SplitLine` (`lib/pages/journal/widgets/`).

## Consequences

- With Ekklo signed out or offline, the owner still sees what he logged in MyFitnessPal, food by food.
- The Figma frames K12 and K13 show meal cards without foods; they are to be updated to match.
- Tests: "keeps the MyFitnessPal foods readable, without statuses, when the Ekklo session expired" and "offline keeps the last figures and foods with their time and retries alone" in `test/pages/journal_page_test.dart`.
