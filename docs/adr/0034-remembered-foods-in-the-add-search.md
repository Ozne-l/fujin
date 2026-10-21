# 34. Remembered foods in the add search, and "Ajouter" on screen 19

Date: 2026-10-16

## Status

Accepted. Amends the search of [0026](0026-adding-a-food.md) (02a, 02b) and adds an entry point to it from screen 19.

## Context

Memory holds every MyFitnessPal food the owner has tied to an Ekklo food: matched foods and own copies, one own copy per serving unit ([0018](0018-send-flow.md)). Fūjin sends those to Ekklo without asking. The add search only offered the foods added through Fūjin (Récents) and MyFitnessPal's results, so a remembered food added from the MyFitnessPal app or before the add flow existed had to be searched again, with a MyFitnessPal round trip, and was mixed with results Fūjin knows nothing about.

The owner validated three Figma proposals in "Fūjin · Maquettes": 02a and 02b with a "MÉMORISÉS" section (nodes `351:14270`, `351:14293`) and screen 19 with an "Ajouter" button (`351:14321`).

## Decision

Search before typing (02a):

- "RÉCENTS" as before, then "MÉMORISÉS" with the Ekklo source dot, the trailing "liés à Ekklo" and the note "Fūjin les envoie vers Ekklo sans rien te demander.".
- The section lists every remembered food (`Memory.matches` and `Memory.ownCopies`) in the order of `rememberedFoods` (`lib/domain/memory/memory_rules.dart`): accent-folded MyFitnessPal name. An own copy kept in two units is two rows, one per unit.
- A remembered food already in Récents is not listed again (`AddSearchState.rememberedBesideRecents`, `recentOf` in `lib/domain/adding/recent_of.dart`): a matched food by its MyFitnessPal id, an own copy by its id and unit.

Search while typing (02b):

- "MÉMORISÉS" with "{count} trouvés" comes first, filtered on the phone by `rememberedFoods(memory, query)` (MyFitnessPal and Ekklo names, accent-folded). It shows as soon as the query changes, without waiting for MyFitnessPal, and is hidden when nothing matches. Memory is read once when the search opens and again each time it comes back from the fiche (`AddSearchNotifier.refreshRecents`).
- "RÉSULTATS MYFITNESSPAL" drops the foods listed under "MÉMORISÉS", by MyFitnessPal id (`AddSearchResults.foodsBesideRemembered`). It is hidden when every result was dropped. "Aucun résultat" and its suggestions show only when neither MyFitnessPal nor "MÉMORISÉS" has a row.
- "25 premiers" is decided on the count MyFitnessPal returned, before the drop: a full page (`MfpFoods.defaultMaxResults`) reads "25 premiers" even when 23 rows remain. Otherwise the label counts the rows shown.
- Back from a fiche opened from a row returns to the results as they were, without searching again (`AddSearchNotifier._fetch` keeps the results it replaced). Touching a row while MyFitnessPal is still searching wins over that search, whose answer is dropped.
- When MyFitnessPal fails (offline, session expired, server error), its message comes first, then Récents where they were shown before, then the remembered foods. Touching one still reads MyFitnessPal, and a failure is shown as for a recent food.

Rows and touch:

- A row shows the MyFitnessPal name and "→ <Ekklo food>", or "→ Aliment perso · « <unit> »" for an own copy. It shows no kilocalories: Memory does not keep the MyFitnessPal values, and reading each food from MyFitnessPal to list it would cost one request per row.
- Touching a row reads the food with `foods.byId` (`AddFoodService.openRemembered`) and opens the fiche (A04). The serving is chosen by unit only, since Memory keeps the unit and not the amount (`rememberedServing`, `lib/domain/adding/remembered_serving.dart`), the first that MyFitnessPal still serves among: the unit of the recent food of that row, the unit of the own copy, a remembered unit weight of the food (`Memory.unitsOf`). When MyFitnessPal serves none of them, the rule finds nothing and `AddDraft.of` opens the first MyFitnessPal serving, as for any food. Units are compared as `AddDraft` compares them, by equal text. The servings start at 1. The fiche then behaves as for any food: an own copy in another unit, an estimated unit weight to choose, a food changed in MyFitnessPal.

"Ajouter" on screen 19 (`MemoryFoodPage`):

- A full-width primary button, 16 px under the unit weights (or the Ekklo card), 12 px above "Oublier cet aliment". It is greyed when adding is not possible (`addingPossible`, as the Scanner button).
- It opens the fiche directly through a variant of the add route, `FujinRoute.addFood.forRemembered(date, meal, food)`: the remembered food's MyFitnessPal id and, for an own copy, its unit ride as query parameters, `AddFoodPage` finds the food in Memory and opens it as a row of the search would, with the same serving rule. While MyFitnessPal is read, and if it fails, the search screen shows its usual state. Back from the fiche returns to screen 19.
- Day: the one selected in the Journal (`selectedDayProvider`). Meal: the meal of the hour (`mealOfTheHour`), else the first meal. Both stay editable in the fiche.
- After an add, screen 19 stays on screen and shows K16 with "Annuler", Memory is read again, and the day's MyFitnessPal and Ekklo reads are invalidated. When the add replaced the remembered food (a matched food added as an own copy, which drops the match), screen 19 has nothing left to show and returns to the Mémoire list, where K16 stays. The default meal, the "adding possible" check and this confirmation are shared with the Scanner button in `AddShortcut` (`lib/pages/adding/add_shortcut.dart`); only the Scanner also switches to the Journal on the added day. An add opened from a Journal meal confirms through the same `AddShortcut.added`: K16 shows as soon as the fiche closes, and only the added day is read again. The undo outcome (K17, K18) is still reported by the Journal, which stays mounted in its branch.

Rendering: the search list is a `CustomScrollView`; `FoodList` is a sliver (`DecoratedSliver` around `SliverList.separated`), so only the rows on screen are built, however long Memory is.

## Consequences

- No migration: everything comes from the Memory tables and `recent_food`.
- The serving rule matches by unit, so a food served in "100 g" and "1 g" opens on the first gram serving MyFitnessPal lists; the owner changes it in the fiche.
- "25 premiers" can sit above fewer than 25 rows. The owner accepted it: the label says MyFitnessPal cut its answer, not how many rows follow.
- A remembered food MyFitnessPal deleted stays listed; touching it fails like a recent food MyFitnessPal no longer has.
- "Ajouter" on screen 19 briefly shows the search screen while MyFitnessPal is read. When the read fails, the owner is left on the search with its failure message and the remembered foods, and can retry from there; back returns to screen 19.
