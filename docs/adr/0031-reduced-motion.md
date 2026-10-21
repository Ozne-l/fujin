# 31. Reduced motion follows the phone setting

Date: 2026-10-14

## Status

Accepted. Extends the motion part of [0008](0008-theme-from-design-tokens.md).

## Context

Android's "Supprimer les animations" and iOS's "Réduire les animations" reach Flutter as `MediaQuery.disableAnimations`. Flutter already shortens every `AnimationController` with the default `AnimationBehavior.normal` to 5 % of its duration when it is set: route transitions, sheets, snackbars and `AnimatedSize` follow it with no code of ours. Two kinds of motion in Fūjin do not: the motor builders (`MotionController` keeps the behaviour without applying it, motor 1.1.0), and page turns, which run through `ScrollPosition.animateTo` on an unbounded controller that preserves its duration. The UI/UX audit of 2026-10-14 found that nothing in `lib/` read the setting.

## Decision

- `FujinMotion` (`lib/app/theme/fujin_motion.dart`) is the single entry point:
  - `FujinMotion.reduced(context)` reads the setting;
  - `FujinMotion.of(context, motion)` returns `InstantMotion` (`lib/app/theme/instant_motion.dart`) when it is set, else the preset. `InstantMotion` lands on the target on the first frame. motor's own `Motion.none()` is not used: it holds the current value and never reaches the target, which left the tabs and the Apparence choice where they were; every motor builder that animates a value (pills, progress rings and bars, the Souffle's settle and arming, menu folds) takes its motion from it;
  - `FujinMotion.turnPage(context, controller, page)` jumps to the page when it is set, else turns it with `FujinMotion.pageTurn` (week band, Mémoire segments, day picker).
- The week band's first-visit nudge does not play when the setting is on; the written hint still shows.
- Activity indicators keep moving: `FujinSpinner`, the Souffle's spin while a refresh runs and the breeze drift of searching and sending. They are the only sign that work is in progress, small, slow and without flashing (WCAG 2.2, 2.3.3, allows motion that is essential to the information).
- The Souffle disc still follows the finger during a pull: it is direct manipulation, not an animation.

## Consequences

- New motor code takes its motion through `FujinMotion.of`, and new page turns through `FujinMotion.turnPage`; the `fujin-dialect` skill says so.
- Tests: "turns back to this week at once when the phone asks for less motion" in `test/pages/journal_page_test.dart`, "shows Réglages and the chosen Apparence at once when the phone asks for less motion" in `test/pages/settings_page_test.dart`. The page tests were also run once with the setting forced on, and all passed; that run did not catch the frozen tabs, since no page test then checked what stayed on screen after a move.
