# 56. App-wide motion: one scale, framework animations everywhere, shared primitives

Date: 2026-11-23

## Status

Accepted; steps 1 (the scale, the rules and the shared primitives), 2 (touch and haptics) and 3 (no state that snaps) built. Amends [0008](0008-theme-from-design-tokens.md) (framework animations and custom routes allowed outside the chat), [0031](0031-reduced-motion.md) and [0049](0049-chat-motion.md) (their rules apply to every screen; the chat presets are renamed into the scale).

## Context

The chat got its motion pass in [0049](0049-chat-motion.md): entrances, flights, a shared-element viewer, haptics. The rest of the app stayed on the rule of [0008](0008-theme-from-design-tokens.md): no `Animated*` widget, stock route transitions. So outside the chat, states switch at once (the Journal's loading, data and error states, the add search and the fiche, the scanner's sheets), `Hero` is used nowhere, and only five calls reach `FujinHaptics`. On 2026-11-23 the owner asked for the polish of a finished store app across the whole app, after a review of Apple's zoom transitions (iOS 18), Material's transition patterns and its Expressive motion physics, and Emil Kowalski's rule that a frequent gesture gets a short animation and a rare moment may get more.

`FujinMotion` had grown one preset per feature, about sixty constants, some identical under different names: `mealFold` and `rowRemoval` (250 ms, ease-out cubic), `messageIn`, `rotate` and `scrollSettle` (250 ms, M3 standard curve), `release` and `lensFollow` (the interactive Cupertino spring). Nothing told a new screen which timing to take.

## Decision

- **A scale of roles.** `FujinMotion` opens with the roles every new animation picks from; a feature preset remains only where a role cannot carry it (the glass and tab springs tuned on the owner's recordings, loops, the theme reveal, the sheet and snackbar styles, the send and reaction flights, the shake).

|Role|Motion|Use|
|---|---|---|
|`effectsFast`|150 ms, ease-out|a fade that only confirms (a chip, a mark), and the reduced-motion dissolve|
|`effects`|300 ms, ease-out|opacity and colour of a view that replaces another (`FadeThrough`, the tabs)|
|`effectsSlow`|600 ms, ease-out|a glow that fades after the eye found it (`ArrivalHighlight`)|
|`spatialFast`|200 ms, M3 standard|a slot or switcher that grows or shrinks|
|`spatial`|250 ms, M3 standard|a fold, a row that rises or leaves, a menu, a short scroll|
|`spatialSlow`|400 ms, M3 standard|a page turn, a long scroll|
|`flight`|300 ms, fast-out-slow-in|a shared element and the custom route that carries it|
|`gesture`|Cupertino interactive spring|whatever follows a finger and is released with its velocity|
|`emphasis`|Cupertino bouncy spring, 350 ms, with `emphasisSwell` 1.2|a confirmation that pops|

- **What moved.** `dissolve` → `effectsFast`; `fadeThrough` → `effects` (280 ms ease-out cubic → 300 ms ease-out); `highlight` → `effectsSlow`; `grow` → `spatialFast`; `messageIn`, `rotate`, `scrollSettle`, `mealFold` and `rowRemoval` → `spatial` (the last two from ease-out cubic to the M3 standard curve); `scrollGlide` and `pageTurn` → `spatialSlow` (page turns from 350 ms ease-out cubic to 400 ms standard); `mediaFlight` → `flight`; `release` and `lensFollow` → `gesture`; `pop` and `popSwell` → `emphasis` and `emphasisSwell`. Every other preset keeps its value.
- **Framework animations everywhere.** What [0049](0049-chat-motion.md) allowed in the chat holds on every screen: `Hero`, `AnimatedSwitcher`, `AnimatedSize` and custom route transitions, when a `FujinMotion` role or preset times them; a `Tween` may shape the animation such a widget hands its builder. Hand-written `AnimationController` stays out; motor drives everything else. Pushed routes keep the platform transition (predictive back on Android, the swipe on iOS) unless a later step of this record says otherwise.
- **Reduced motion everywhere.** The rules of [0031](0031-reduced-motion.md) as amended by [0049](0049-chat-motion.md) apply to every screen: `FujinMotion.of` lands at once, `FujinMotion.dissolveOf` turns an entrance that carries meaning into an `effectsFast` fade, Hero flights are skipped, activity indicators keep moving.
- **Shared primitives in `lib/pages/common/`.** The chat's generic motion widgets move there so other screens reuse them instead of writing their own: `BottomSwitcher` (a footer that swaps its content and resizes), `FailureShake` (the decaying shake, with `FujinHaptics.error` when asked), `ImageArrival` (an image that fades in once its first frame is there), `RisingSlot` (a slot whose content rises in and sinks out, the reply card's motion, now generic; `ReplySlot` is built on it) and `ArrivalHighlight` (the glow on what just arrived). The thread's row presence (rise, leave by collapsing) stays in `ThreadList` until the Journal needs it, since its entrance is tied to the send flight.
- **Haptics everywhere.** The grammar of [0049](0049-chat-motion.md) holds on every screen and only `FujinHaptics` calls `HapticFeedback`: `select` when a value changes, `threshold` when a gesture crosses its commit point, `press` for a long press or a destructive sheet, `error` when something fails. `success` (notification success) marks a finished task the owner asked for: an add, a save (an edited food, a weigh-in, the goals) and a finished send; an undo stays silent. A plain tap has no haptic.
- **Planned steps**, chosen by the owner on 2026-11-23, each its own pull request, run in the order 1, 2, 3, 6, 4, 5, 7:
  - step 1, this scale and the shared primitives (built);
  - step 2, touch and haptics (built): one `Pressable` with three levels, `row` (a `backgroundPressed` tint on `effectsFast`), `card` (a scale to `cardShrink` on `lift`) and `glass` (a scale to `pressShrink` on `lift`, for a glyph control drawn on glass such as the chat's media button; glass surfaces keep their own stretch and swell); the silent `GestureDetector`s of `DaySummaryCard`, `MealCard` and `MealRows` moved onto it; `select` when the tab or the band's day changes, `threshold` when a swipe passes the point where letting go removes the row and when a pull arms the Souffle; `success` on an add, a save and a finished send; `error` with `FailureShake` on a refused sign-in (the Ekklo fields, the MyFitnessPal toast);
  - step 3, no state that snaps (built):
    - the Journal's day is three slots in one box: the problem card (`FadeThrough` keyed by the problem, its height on `spatial`), the summary (`FadeThrough` between the reading card and `DaySummaryCard`, which keeps its place across kinds and days so its rings and bars spring from the old value) and the meals; the "Repas du jour" heading fades in and out with the meals and stays still on a day change;
    - the meals go through `DaySwitcher` (`lib/pages/journal/widgets/day_switcher.dart`): a change of state on the same day fades, a change of day slides by `FujinMotion.daySlide` (8 % of the width) on `spatial` along the band's axis, an earlier day in from the start side and the shown one out to the other, mirrored in right-to-left; each child keeps the direction it entered or left with when a second switch comes mid-slide;
    - Mémoire fades between its empty pages and its searched list, and between a search with no match and its results; Pesées between its empty text and its list; Bienvenue fades each account's subtitle and its pill or sign-in button once the sessions are read; their states are read synchronously or in a few milliseconds, so only the Journal has a skeleton;
    - the Journal's skeleton bars breathe on the Souffle's `driftCycle` (2.8 s), their alpha following a cosine from 1 down to 0.45 (`FujinMotion.skeletonBreath`), and keep breathing under reduced motion as an activity indicator; no shimmer;
    - `RollingNumber` (`lib/pages/common/rolling_number.dart`) rolls a number from its old value to its new one on `spatialSlow`, with tabular figures so the width holds, and shows the first value at once; it carries the kcal of the summary (MyFitnessPal, Ekklo, the compact line), the values of the nutrient rings and the kcal of each meal; the macro line of the compact summary stays still;
    - back on the Journal after an add or a saved edit, `arrivalProvider` (`lib/pages/journal/arrival_notifier.dart`) holds the entry until its row is built; the row then rises (`RisingSlot` with `appear`, on `spatialFast`, a fade only under reduced motion) over an `ArrivalHighlight`, and the provider clears; an undo does not glow;
    - every message is a notice with a glyph by meaning: `done` for a finished export or import, `alert` (`showAlert`) for a problem, a refused write in Fūjin DEV, an unreadable backup and a kept choice that failed (with "Se reconnecter" when the Ekklo session expired), `sending` (the paper plane, accent colours) for "the send continues"; `showFujinSnackBar` is gone;
  - step 6, sheets and swipes: `InPageSheet` rises on `sheetIn` with a dissolving scrim, the scanner's frame sweeps while aiming and its corners snap to a read code, the unread badge pops;
  - step 4, navigation: tasks (add, edit, send, scan, sign-in) rise as full-screen modals and close by a drag down unless work is running; descents keep the platform push; the add search and the fiche share a depth axis; predictive back checked on Android 13 to 15;
  - step 5, shared elements, after a spike on go_router's nested navigators, on a sheet as destination and on a `context.go`: the Scanner drop opening into the camera as a circular reveal, the Messages item into the conversation, the day rings into "Détail du jour", the search field into the add page;
  - step 7, three signature moments at most: a finished Ekklo send, a goal ring closing, the splash logo landing on `JournalBrand`.
- **Not done**: a Hero from a row of text alone (a full-width row zooms badly and its type changes in flight), a staggered entrance of lists opened many times a day, particles, confetti or Lottie.

## Consequences

- A new animation picks a role first; a new feature preset needs a reason the scale cannot carry.
- Fades between views are 20 ms longer and softer; meal folds, row removals, the chat's leaving rows and menus use the M3 standard curve; page turns take 400 ms instead of 350 ms. The glass and tab springs are unchanged.
- The `fujin-dialect` skill states the scale and the app-wide rules.
- Each later step runs the glass benchmark before and after when it moves glass.
