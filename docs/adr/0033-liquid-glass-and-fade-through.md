# 33. Liquid glass tab bar and fade-through navigation

Date: 2026-10-14

## Status

Proposed (first draft, to be tuned by the owner on his phone). Amends [0019](0019-tab-shell.md) and the motion part of [0008](0008-theme-from-design-tokens.md).

## Context

The tab bar drew its frosted plate with a `BackdropFilter` blur. The owner wants a liquid glass bar, drawn with `liquid_glass_renderer`, the package his other app already uses. He also found the navigation abrupt: switching tabs swapped the indexed stack at once, the send flow swapped its views (search, review, sending, sent) at once, and a pushed route faded over `ColorScheme.surface` (kinu, the card colour) instead of the page background (washi).

## Decision

- `liquid_glass_renderer` is pinned at `0.2.0-dev.4`. `GlassLayer` (`lib/pages/common/glass_layer.dart`) holds one `LiquidGlassLayer` and one `LiquidGlassBlendGroup` with Fūjin's settings: the `backgroundGlass` tint and the `glassBlur` token. `GlassSurface` (`lib/pages/common/glass_surface.dart`) is a `LiquidGlass.grouped` superellipse with a `GlassGlow` and a `LiquidStretch`. It keeps the outer floating shadow. The tab plate and the Scanner button share one layer in `FloatingTabBar`; the Scanner button of the search screen has its own.
- The active tab is a single pill that slides between tabs on the `FujinMotion.tabSlide` spring and widens a little with its speed. It no longer belongs to each tab.
- Tabs switch with a fade-through. `TabSwitcher` (`lib/pages/tabs/tab_switcher.dart`) is the shell's `navigatorContainerBuilder`. Each branch keeps its navigator and state, as before. A hidden branch is offstage, out of the semantics tree and has its tickers stopped.
- Within a screen, `FadeThrough` (`lib/pages/common/fade_through.dart`) cross-fades views that replace each other. The send flow uses it between its phases. Searching and review are one view (`ReviewView`, `searching: true` while the plan is built): the header and the footer with the send button stay in place, and only the body cross-fades, without the scale, when the plan is ready. The owner found that swapping the whole screen there felt like a pop.
- Pushed routes keep the platform transitions, with predictive back on Android and the swipe on iOS. On Android the fade runs over the page background.
- Every one of these animations follows the reduced-motion setting of [0031](0031-reduced-motion.md): `FujinMotion.of` for the motor builders, a zero duration for `FadeThrough`, and no stretch or press scale on the glass.

## Consequences

- The package only renders on Impeller. Without Impeller, as in `flutter test`, it falls back to its `FakeGlass` (a backdrop blur). Every build prints SkSL warnings for its shaders; they do not affect Impeller builds.
- The package is a pre-release, marked experimental by its author. Moving glass is redrawn every frame, so the effect has a cost on low-end phones that the emulator does not show.
- The bar's look on the phone is the owner's call; the settings, the blend and the slide spring are named constants in `GlassLayer` and `FujinMotion`.
