# 8. Theme from design tokens

Date: 2026-10-07

## Status

Accepted, amended by [0035](0035-dark-theme-and-appearance-setting.md) (colours from the theme, light and dark) and by [0043](0043-edit-and-delete-a-logged-food.md) (the Journal row's swipe is `flutter_slidable`'s motion, not motor). All the planned motion users are built: the goal rings (`ProgressRing`, [0022](0022-journal-states-and-goal-rings.md)), the send progress of screen 14 (`ProgressCard`, [0018](0018-send-flow.md)), status pill changes (`StatusPill` in `lib/pages/common/status_pill.dart`: colours with `FujinMotion.pill`, a new label cross-fades and settles with `FujinMotion.pillSettle`), sheet motion (`SheetFrame.show` passes `FujinMotion.sheet`, built from the springs `sheetIn` and `sheetOut` through `MotionCurve`) and snackbar motion (every snackbar goes through `showFujinSnackBar` in `lib/pages/common/fujin_snack_bar.dart` with `FujinMotion.snackBar`; Flutter only lets a snackbar's durations change, not its curves). The Android pull-to-refresh indicator is no longer stock: [0028](0028-fujin-drawn-controls.md) draws it and adds `FujinMotion.spin` for endless rotations.

## Context

The mockups in the Figma file "Fūjin · Maquettes" use named variables (for example `role/texte/principal`). The same values are exported to `design/tokens/fujin.tokens.json`. Hand-copying colours and sizes into widgets would drift from the design. Motion should feel consistent and stay out of the way of Android's own behaviour.

## Decision

- `tool/generate_tokens.dart` reads `design/tokens/fujin.tokens.json` and `design/tokens/fujin.dark.tokens.json`, resolves aliases, and writes `lib/app/theme/fujin_tokens.g.dart` with `FujinColors`, `FujinSpace`, `FujinRadius`, `FujinStroke`, `FujinSize`, `FujinFont` and `FujinText` ([0035](0035-dark-theme-and-appearance-setting.md)). The output is committed and marked as generated; run `dart run tool/generate_tokens.dart` after a token file changes.
- `FujinTheme.light()` and `FujinTheme.dark()` (`lib/app/theme/fujin_theme.dart`) map roles to the Material `ColorScheme`, text theme, snackbar and progress indicator themes, and carry `FujinColors` as a theme extension.
- Widgets use no colour, size, spacing or text-style literals: they read `context.colors`, `FujinSpace`, `FujinSize`, `FujinText` and friends (for example `lib/pages/journal/journal_page.dart`).
- Fonts: Inter (variable) and Hina Mincho from Google Fonts, SIL Open Font License, in `assets/fonts/` with their `OFL.txt`, declared in `pubspec.yaml`.
- Motion: every animation Fūjin writes itself uses `motor` 1.1.0 (MIT): springs by default, a duration only where the design asks for one. Presets live in `lib/app/theme/fujin_motion.dart` (`FujinMotion.progress`). First user: `ProgressBar` in `lib/pages/common/progress_bar.dart` (`SingleMotionBuilder`). Planned users: day rings, status pill changes, send progress (screen 14), custom sheet or snackbar motion.
- No hand-written `AnimationController`, `Tween` or `Animated*` widgets.
- Platform motion stays stock: route transitions, the Android pull-to-refresh indicator, scroll physics.

## Consequences

- A design change is one token edit plus one generator run.
- Widgets read like the mockup annotations, since names match the Figma variables.
- Motion has one source of tuning.
