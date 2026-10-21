# 35. Dark theme and the "Apparence" setting

Date: 2026-10-20

## Status

Accepted. Amends [0008](0008-theme-from-design-tokens.md): colours are read from the theme instead of static constants.

## Context

The Figma file "Fūjin · Maquettes" now has a dark theme: the page "Thème sombre" (spec node `385:24868`) gives every `role/*` variable a dark value and shows nine reference screens in dark. The light tokens stay in `design/tokens/fujin.tokens.json`. The dark values are exported to `design/tokens/fujin.dark.tokens.json`, which holds the same `role/*` paths as raw colours, without aliases. Réglages gets an "APPARENCE" card (`384:22566`) with three choices: "Système", "Clair", "Sombre".

Until now widgets read `FujinColorRole.x` and sometimes a primitive (`FujinColor.x`) as compile-time constants. Constants cannot follow a theme switch.

## Decision

Colours:

- `tool/generate_tokens.dart` reads both token files and writes one `FujinColors` class into `lib/app/theme/fujin_tokens.g.dart`. `FujinColors` is a `ThemeExtension` with one field per role and two instances, `FujinColors.light` (aliases resolved) and `FujinColors.dark`. The generator stops with a `FormatException` when the two files do not hold the same roles or a dark value is not a colour. `generateTokens` is a pure function, tested in `test/tool/generate_tokens_test.dart`.
- `FujinColor` and `FujinColorRole` are no longer generated. Primitives stay in the JSON only. Every widget that read a primitive now reads the role Figma binds at that spot, with the same light value, with three exceptions kept as in code: the sheet drag handle went from kinari (#E3DAC0) to `borderControl` (usuzumi, #BDB49C, `lib/app/theme/fujin_theme.dart`); `DayShareBar` follows the food sheet's `GoalStatus`, its logged share in `goalInProgressLogged`, `goalReachedLogged` or `goalExceededLogged`; and the to-choose Ekklo card is outlined in `borderWarning` (kin) instead of `textGold`.
- Widgets read `context.colors.x` (`FujinColorsContext`). Code without a `BuildContext` takes a `FujinColors`: `PillTone.background(colors)`, `FujinWeather.foreground(colors)`, the `FujinTheme` field and button helpers, `FujinSystemBars.of(colors, brightness)`. Painters get their colours from `build` and compare them in `shouldRepaint`. No colour is kept in a static or in widget state.
- `FujinTheme.light()` and `FujinTheme.dark()` are built by one function from a `FujinColors`; the `ColorScheme`, the Cupertino brightness and the keyboard appearance follow it.
- The system bars are set inside `MaterialApp.builder` from the theme's brightness, so they follow the theme in use rather than the phone. The camera keeps light icons in both themes (`FujinSystemBars.camera`) and fixed roles in both themes, including `cameraTextSecondary` (`role/camera/text-secondary`, usuzumi) for the scanner subtitle and the camera spinner track.
- The liquid glass tint is the theme's `backgroundGlass`, painted inside the glass by `GlassBody` (for `GlassSurface` and every `GlassFill`), and its rim comes from `borderGlassHighlight` and `borderGlassShade`; the glass has a lighter, whiter light in light and a dimmer one in dark (`FujinGlass.floating(brightness)`, [0033](0033-liquid-glass-and-fade-through.md)).
- `SeigaihaBand` draws `seigaiha_dark.png` in dark.
- `test/app/theme/fujin_colors_contrast_test.dart` checks the text roles of [0032](0032-text-contrast.md) at 4.5:1 on page and card in both themes, and the fixed pairs `cameraTextSecondary` on `cameraBackground` and `buttonAlertText` on `buttonAlertBackground` (the alert snackbar glyph, `SnackBarGlyph.foreground`).

The setting:

- "Apparence" stores one of `system`, `light`, `dark` under `setting_appearance` in the app preferences. Absent or unknown reads as "Système". `FujinApp` passes `theme`, `darkTheme` and the chosen `themeMode`.
- It is not in the backup file: it belongs to the phone, like the reduced motion setting of [0031](0031-reduced-motion.md).
- The three-way control is the segmented control Mémoire already used, moved to `lib/pages/common/`; Mémoire drives it from its page view, Apparence with a `FujinMotion` spring.
- A shortcut, the day/night toggle (Figma component "Bascule jour/nuit", `389:25532`), is pinned at the top right of the Journal, Mémoire and Réglages, just under the status bar, and stays there while the page scrolls under it, like an iOS 26 bar button; at rest the first line of the header is centred on it. It reads the theme on screen (`Theme.of(context).brightness`), not the phone: a moon on light, a sun on dark. A tap sets Apparence to "Sombre" on light and to "Clair" on dark, so it always leaves "Système"; going back to "Système" is done in Réglages. It writes the same value as the Réglages card, which follows without any state of its own. The toggle is `AppearanceToggle`, pinned by `AppearanceCorner` around each page body, and `AppearanceHeader` lines the header up with it (`lib/pages/common/`); the drop is a small `FujinGlassButton` (Figma "Bouton verre", Petit), 40 in a 48 touch target. On a theme change the moon and the sun cross-fade with a quarter turn (`FujinMotion.iconTurn`).
- A theme change is revealed by a circle. `ThemeReveal` (`lib/pages/common/theme_reveal.dart`), in `MaterialApp.builder` around every screen and the DEV banner, takes a picture of the screen in the old theme (`RenderRepaintBoundary.toImageSync`) just before the change, then paints it over the live screen, already in the new theme, with a hole that grows until it reaches the farthest corner (`FujinMotion.themeReveal`, 675 ms, ease-out cubic, crisp edge; 450 ms felt too fast). The hole starts growing after the first frame in the new theme, so the time that full rebuild takes is not taken out of the motion. The circle starts at the centre of what was touched: the day/night toggle or the Apparence segment (`ThemeReveal.choose`). With "Système", a phone that switches theme is revealed from the centre of the screen. A choice that leaves the theme on screen as it is ("Système" on a phone in the same theme) has no circle. Taps are absorbed while the circle grows; the old-theme part is a still picture for that time. With reduced motion ([0031](0031-reduced-motion.md)) the theme changes at once. `MaterialApp`'s own colour cross-fade is off (`AnimationStyle.noAnimation`) so the revealed part is the new theme from the first frame. The system bars follow the theme at the start of the circle. A real per-element switch would need two live copies of the app, router and state included; the picture gives the same pixels for 675 ms. No package: those on pub.dev own the `ThemeData` or drive their own `AnimationController` outside `FujinMotion`.

Launch:

- The native launch screen follows the phone, not the setting, since it shows before Flutter runs: `values-night/colors.xml` on Android, the `LaunchBackground` colour set with a dark variant on iOS.
- `main` opens the preferences before the first frame, so `SplashApp` already follows the setting; the theme changes at most once, between the native launch screen and Flutter's splash.

## Consequences

- A dark value change is one edit of `fujin.dark.tokens.json` and one generator run; a role added in one theme only fails the generator.
- No colour can be `const` in a widget any more.
- With "Clair" or "Sombre" on a phone set the other way, the native launch screen shows the phone's theme for a moment before Flutter's splash shows the app's.
- The system's Reduce Transparency setting turns the tab bar and the day/night toggle into opaque cards ([0033](0033-liquid-glass-and-fade-through.md)).
