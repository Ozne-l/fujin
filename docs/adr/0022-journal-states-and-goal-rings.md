# 22. Journal states and goal rings

Date: 2026-10-10

## Status

Accepted. Amends the "No polling" bullet of [0003](0003-refresh-on-foreground-and-pull.md) for the offline state only.

## Context

The Journal screens K1 to K13 in the Figma file "Fūjin · Maquettes" (section "4 · Journal", "la semaine en anneaux") replace the first Journal. The week band shows one ring per day comparing that day's MyFitnessPal kilocalories with the goal ([0020](0020-goals.md)); the day card shows the macros in rings; a failure on one side no longer hides the other (K7 MyFitnessPal session expired, K12 Ekklo session expired); offline (K13) keeps the last figures with their time and says "Fūjin réessaie dès que le réseau revient". Until now `JournalService.readDay` awaited both reads together and any failure showed the problem card alone. The component descriptions of "Anneau jour", "Anneau nutriment" and "Bandeau semaine" in the Figma file give the ring rule and the band behaviour. `package:myfitnesspal_client` reads one diary day per request; it has no range read.

## Decision

- Goal rule (`GoalStatus`, `lib/domain/goals/goal_status.dart`): under 98 % of a goal is below, within 2 % on either side is reached, beyond 102 % is exceeded. Fiber is a floor: above its goal it stays reached. A day of the band (`DayGoalState`, `lib/domain/goals/day_goal_state.dart`) is upcoming after today, without goal when no goals are set, nothing logged when a past day has no entry, in progress for today under the goal (even empty), missed for a past day under the goal, reached or exceeded otherwise.
- The band reads each day of the week shown, up to today, with `MfpDiary.forDate` (`JournalService.loggedKilocalories`, `weekKilocaloriesProvider` in `lib/pages/journal/journal_notifier.dart`): up to seven small reads per week, only for the week in the middle of the band; the half-visible neighbour weeks show bare rings until they are swiped to. A pull to refresh and a foreground return read that week again with the day.
- The band is a `PageView` with `reverse: true` and `viewportFraction: 7 / 8`, one page per week (`WeekBand`, `lib/pages/journal/widgets/week_band.dart`); swiping to another week selects the same weekday there, never after today. The first-display hint S5 ("Glisse pour voir les semaines passées") is not built: it needs a stored "already shown" flag.
- The Journal reads both apps side by side (`JournalService.readJournal`): both answered gives `BothSides` with the day comparison; only MyFitnessPal gives `MfpOnly` (meals without statuses, "Ekklo indisponible"); only Ekklo gives `EkkloOnly` (MyFitnessPal "indisponible" with the goals). Each failure is classified as a `ReadProblem` from the clients' exception types: session expired, offline (`MfpNetworkException`, `EkkloNetworkException`), service not responding, unknown. When MyFitnessPal fails offline, or both apps fail, the read throws and the notifier keeps the previous read on screen under the problem card, with the time it was read ("Les chiffres datent de 20:00"). The send button stays visible but disabled whenever a side is missing or the figures are old. `readDay`, used by the send flow, still needs both sides and throws otherwise.
- While the Journal shows the offline card and the app is in the foreground, `JournalPage` reads the day again every 15 s. Fūjin has no network-state plugin; a failed read offline costs nothing on the services' side. No retry happens for any other failure ([0003](0003-refresh-on-foreground-and-pull.md) still holds there).
- `goalsProvider` and `GoalsText` move to `lib/pages/common/`, as the Journal and the Réglages pages both use them.

## Consequences

- Opening a week costs up to eight MyFitnessPal reads (the day and the week) and one Ekklo read; acceptable for one person, to revisit if MyFitnessPal rate-limits.
- An Ekklo session expiry no longer blocks reading the diary; the owner signs in again from the card when he wants to send.
- The offline retry is the only periodic work in the app and stops as soon as the read succeeds or the app leaves the foreground.
- Tests cover the rules in `test/domain/goals/` and `test/domain/journal/`, and each Journal state in `test/pages/journal_page_test.dart`.
