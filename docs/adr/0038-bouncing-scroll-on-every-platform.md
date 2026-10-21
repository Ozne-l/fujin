# 38. Bouncing scroll on every platform

Date: 2026-10-21

## Status

Proposed (to be checked by the owner on his phone). Replaces Android's stretch overscroll, which [0028](0028-fujin-drawn-controls.md) relied on for the pull to refresh.

## Context

The owner recorded his Android phone pulling a Mémoire fiche down: "Ajouter" and "Oublier cet aliment" turned partly black while the finger held the pull, and the back button lost a corner. On Impeller, Flutter draws Android's stretch overscroll by running the whole list through a shader image filter (`StretchEffect`). Glass inside the list (`LiquidGlass`) reads the backdrop, and inside that filter's layer the backdrop is not the page: the glass draws black where it should bend the page. Painting the page colour inside the stretched layer removed the black but left a light band across the button, since the stretch then shifts the glass away from where it sampled. Every list with a glass control has the bug: the fiches, the Journal's "À envoyer" pills, the send review's cards and filters, the Réglages switch and segments.

## Decision

- `FujinScrollBehavior` (`lib/app/theme/fujin_scroll_behavior.dart`), set on `FujinApp`, gives every scrollable the iOS bounce (`BouncingScrollPhysics` over `RangeMaintainingScrollPhysics`) and no overscroll indicator, on Android as on iOS. The content itself moves past the edge and springs back, so nothing is filtered and the glass keeps bending the page under it. This matches the iOS look the app follows ([0033](0033-liquid-glass-and-fade-through.md), [0037](0037-progressive-blur-under-fixed-headers.md)).
- The pull to refresh keeps `SouffleRefresh`. With the bounce, the Journal moves down with the finger, and its header follows through the signed scroll offset of [0037](0037-progressive-blur-under-fixed-headers.md). The disc arms at the same point as before: a sixth of the screen of content pulled past the top.
- The tab bar counts only the part of a scroll inside the list's range. Bouncing back from the bottom edge no longer reads as a scroll up that brings the bar back to full size.

## Consequences

- On Android, the pull to refresh needs a longer swipe: the bounce resists, so the finger travels about 40% of the screen before the disc arms, against a sixth of the screen with the stretch.
- Android loses its native edge stretch; every list ends with the iOS bounce.
- The black glass was reproduced on the Android emulator (Impeller, OpenGL ES) with a glass button in a list, and the bounce was checked there. It has not been seen on the owner's phone.
