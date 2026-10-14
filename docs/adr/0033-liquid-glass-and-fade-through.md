# 33. Liquid glass tab bar

Date: 2026-10-14

## Status

Proposed (first draft, to be tuned by the owner on his phone). Amends [0019](0019-tab-shell.md).

## Context

The tab bar drew its frosted plate with a `BackdropFilter` blur. The owner wants a liquid glass bar, drawn with `liquid_glass_renderer`, the package his other app already uses.

## Decision

- `liquid_glass_renderer` is pinned at `0.2.0-dev.4`. `GlassLayer` (`lib/pages/common/glass_layer.dart`) holds one `LiquidGlassLayer` and one `LiquidGlassBlendGroup` with Fūjin's settings: the `backgroundGlass` tint and the `glassBlur` token. `GlassSurface` (`lib/pages/common/glass_surface.dart`) is a `LiquidGlass.grouped` superellipse with a `GlassGlow` and a `LiquidStretch`. It keeps the outer floating shadow. The tab plate and the Scanner button share one layer in `FloatingTabBar`; the Scanner button of the search screen has its own.
- The active tab is a single pill that slides between tabs on the `FujinMotion.tabSlide` spring and widens a little with its speed. It no longer belongs to each tab.
- Both follow the reduced-motion setting of [0031](0031-reduced-motion.md): the slide goes through `FujinMotion.of`, and the glass has no stretch or press scale.

## Consequences

- The package only renders on Impeller. Without Impeller, as in `flutter test`, it falls back to its `FakeGlass` (a backdrop blur). Every build prints SkSL warnings for its shaders; they do not affect Impeller builds.
- The package is a pre-release, marked experimental by its author. Moving glass is redrawn every frame, so the effect has a cost on low-end phones that the emulator does not show.
- The bar's look on the phone is the owner's call; the settings, the blend and the slide spring are named constants in `GlassLayer` and `FujinMotion`.
