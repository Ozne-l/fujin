# 8. Theme from design tokens

Date: 2026-10-07

## Status

Accepted

## Context

The mockups in the Figma file "Fūjin · Maquettes" use named variables (for example `role/texte/principal`). The same values are exported to `design/tokens/fujin.tokens.json`. Hand-copying colours and sizes into widgets would drift from the design. Motion should feel consistent and stay out of the way of Android's own behaviour.

## Decision

- `tool/generate_tokens.dart` reads `design/tokens/fujin.tokens.json`, resolves aliases, and writes `lib/app/theme/fujin_tokens.g.dart` with `FujinColor`, `FujinRole`, `FujinSpace`, `FujinRadius`, `FujinStroke`, `FujinSize`, `FujinFont` and `FujinText`. The output is committed and marked as generated; run `dart run tool/generate_tokens.dart` after the token file changes.
- `FujinTheme.light()` (`lib/app/theme/fujin_theme.dart`) maps roles to the Material `ColorScheme`, text theme, snackbar and progress indicator themes.
- Widgets use no colour, size, spacing or text-style literals: they read `FujinRole`, `FujinSpace`, `FujinSize`, `FujinText` and friends (for example `lib/pages/journal/journal_page.dart`).
- Fonts: Inter (variable) and Hina Mincho from Google Fonts, SIL Open Font License, in `assets/fonts/` with their `OFL.txt`, declared in `pubspec.yaml`.
- Motion: every animation Fūjin writes itself uses `motor` 1.1.0 (MIT): springs by default, a duration only where the design asks for one. Presets live in `lib/app/theme/fujin_motion.dart` (`FujinMotion.progress`). First user: `ProgressBar` in `lib/pages/common/progress_bar.dart` (`SingleMotionBuilder`). Planned users: day rings, status pill changes, send progress (screen 14), custom sheet or snackbar motion.
- No hand-written `AnimationController`, `Tween` or `Animated*` widgets.
- Platform motion stays stock: route transitions, the Android pull-to-refresh indicator, scroll physics.

## Consequences

- A design change is one token edit plus one generator run.
- Widgets read like the mockup annotations, since names match the Figma variables.
- Motion has one source of tuning.
