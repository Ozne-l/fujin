# 28. Fūjin-drawn controls instead of stock Material

Date: 2026-10-13

## Status

Accepted. Supersedes the stock pull-to-refresh of [0003](0003-refresh-on-foreground-and-pull.md) and the "Android pull-to-refresh indicator" in the stock platform motion of [0008](0008-theme-from-design-tokens.md).

## Context

Several controls still rendered as stock Material 3 and looked foreign to Fūjin's art direction: the Journal's pull-to-refresh disc, the popup menus of screen 20 and of the A04 food card, the serving dropdown, the Material date picker dialog, `CircularProgressIndicator` in seven places, the `ListTile` suggestion rows, grey tooltips, the grainy `InkSparkle` ripple with tinted overlays, and an unthemed `TextButton`. The Figma file draws the closed menus, the A04 pills, the serving field, two small spinners (component "Indicateur d'état par côté" and A06a), the focused search field with its cursor, the suggestion rows and the "Discret" button. It draws no open menu, no date picker, no pull loader and no spinner for the other waits; those designs below are Fūjin's own, built from existing tokens and components.

## Decision

- Theme (`lib/app/theme/fujin_theme.dart`): cursor in fujin, 1.5 px wide (`FujinTheme.cursorWidth`, passed by each `TextField`, since Flutter has no theme slot); selection in matcha; tooltips drawn like the S5 hint bubble; `InkRipple` with the new role `backgroundPressed` (sumi at 6 %) for splash, highlight, hover and focus; `textButtonTheme` from Figma "Discret / Moyen"; the same pressed overlay (`FujinTheme.pressedOverlay`) on filled, outlined and text buttons through their themes, and on `FujinIconButton` and `CameraIconButton` in their own styles, since `IconButton.styleFrom(foregroundColor:)` derives an overlay that would hide a theme one; one floating shadow, `FujinTheme.floatingShadow`, under the tab plate, the open menu and the Souffle disc; `searchFieldFocusedBorder` (1.5 px fujin pill).
- Tokens: `FujinStroke.spinner` 2.5, `FujinSize.spinner` 22, `FujinSize.spinnerSmall` 18, `FujinSize.field` 52, `FujinColorRole.backgroundPressed`. The serving field keeps `FujinRadius.field` (16) where Figma has an unbound 14.
- Motion: `FujinMotion.spin` (linear 1200 ms) and `FujinMotion.spinTurns`, a seamless motor loop, for every endless rotation; `FujinMotion.driftCycle` (linear 2800 ms, with `driftPhase` and `driftFade`) for every drift, the `BreezeIndicator` streaks and the food names of the transit card. Still motor only, as [0008](0008-theme-from-design-tokens.md) requires.
- Pull to refresh: `SouffleRefresh` (`lib/pages/common/souffle_refresh.dart`) keeps the gesture through `RefreshIndicator.noSpinner` and draws a 40 px kinu disc with the gold volute that follows the finger down from the top of the Journal (the pull distance is read from the scroll notifications, since Android's stretch does not move the content), turns with the pull and a quarter more when armed, rests 40 px below the top while refreshing, above the week band, spins, and leaves when done. Flutter reports `snap` through `onStatusChange` but neither `refresh` nor the final `null`, so the disc spins from `snap` until `done` and returns to its empty state once its exit has played. The K20 snackbar gets its refresh glyph (`SnackBarGlyph.refresh`, `assets/icons/refresh.svg`, redrawn from the Figma icon `Nom=refresh` because the plugin exports PNG only).
- Spinners: `FujinSpinner` (`lib/pages/common/fujin_spinner.dart`) on `ProgressRing`, moved to `lib/pages/common/`: a 220° flat arc, card tone 22 px (kinari / fujin), button tone 18 px (usuzumi / hai), camera tone 18 px (usuzumi / washi). The two "searching Ekklo" waits (A04 summary, sheets 11 and 19) show the drifting `BreezeIndicator` instead. The side glyphs of A06a follow "Indicateur d'état par côté".
- Menus: `FujinMenu` (`lib/pages/common/fujin_menu.dart`) on the widgets layer's `RawMenuAnchor`, with `FujinMenuButton` as the shared closed trigger: a kinu panel under the trigger, kinari border, menu radius, floating shadow, 48 px items with hairlines, the selected item in fujin with a check, opening with `FujinMotion.mealFold`; Android back closes an open menu before the page. Used by screen 20 and the A04 meal and serving fields.
- Day picker: `DayPickerSheet` (`lib/pages/common/day_picker_sheet.dart`) replaces `showDatePicker` on A04: a sheet with the month in Hina Mincho, the gold separator, a Monday-first grid in the week band's style, drawing each day with the week band's `DayPill` (`lib/pages/common/day_pill.dart`); tapping a day chooses it.
- Suggestion rows (A07b) are a 52 px stadium row instead of `ListTile`.
- Memory segments (screens 18 and 20): Foods and Meals are two pages of a `PageView` that the finger swipes between, each with its own scroll. The title stays fixed and `MemorySegments` floats over the pages, which scroll under it. One kinu pill slides under the labels at the page's position and the labels blend from hai to sumi as it passes; a tap turns the page with `FujinMotion.pageTurn` (formerly `weekTurn`, shared with the week band and the day picker) and a selection haptic. A `PageController` stands in for `TabController`, which would bring an `AnimationController`.

## Consequences

- No `PopupMenuButton`, `DropdownButton`, `showDatePicker`, `CircularProgressIndicator` or stock `RefreshIndicator` spinner is left in `lib/`.
- Looping motions never settle: a test must not `pumpAndSettle` while a spinner, the Souffle disc or a drifting breeze is showing.
- The open menu, the day picker, the pull loader and the undrawn spinner sites are not in Figma; drawing them there would make Figma the source again.
- The new tokens exist in `design/tokens/fujin.tokens.json` but not yet as Figma variables.
