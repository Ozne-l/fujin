# 41. Liquid glass on liquid_glass_renderer 1.0

Date: 2026-10-26

## Status

Proposed (the owner signs off the look after a few days of Fūjin DEV next to production). Supersedes the glass settings of [0033](0033-liquid-glass-and-fade-through.md), the rims of [0033](0033-liquid-glass-and-fade-through.md), [0035](0035-dark-theme-and-appearance-setting.md) and [0036](0036-glass-on-buttons-search-and-filters.md), and how [0036](0036-glass-on-buttons-search-and-filters.md) lays a finish's fill over the glass and colours the text of a tinted control.

## Context

[0033](0033-liquid-glass-and-fade-through.md) and [0036](0036-glass-on-buttons-search-and-filters.md) drew the glass with `liquid_glass_renderer` 0.2.0-dev.4. Its 1.0 prerelease, `1.0.0-dev.1`, is a new renderer on Flutter GPU, fitted to iOS 27 Liquid Glass: almost every setting is renamed or changes meaning, the tint moves to a per-shape appearance, and every shape gets a rim of its own. It needs Flutter 3.47, which [0040](0040-flutter-sdk-per-project.md) made Fūjin's own SDK. The owner asked for the move with performance first and the iOS 27 look second.

On the owner's Pixel 8 (Mali GPU, Vulkan) the 1.0 filled each shape's whole bounding rectangle with tint, contour and shadow: a ternary in the shader decodes the edge distance outside the shape as 0 on that GPU. The fix, selecting with `step` and `mix`, is upstream pull request #246, not merged yet.

## Decision

- `liquid_glass_renderer` is pinned exactly to `1.0.0-dev.2` on pub.dev, the first release that carries the Mali fix (#246). Until then it came from the owner's fork, `Ozne-l/flutter_liquid_glass`, at commit `c7ec9d22e4c458da5594c44c107738afb51fbd09`: `1.0.0-dev.1` plus that fix.
- Flutter GPU is turned on in the app, not on the machine: `io.flutter.embedding.android.EnableFlutterGPU` in `AndroidManifest.xml`, `FLTEnableFlutterGPU` in `Info.plist`. Without it, or without Impeller, the package falls back to its `FakeGlass`.
- Every glass shape takes the package's iOS 27 regular appearance for the theme's brightness, not the phone's, so the day/night toggle in "Sombre" on a light phone gets the dark wash: `FujinGlass.appearance(brightness, tint:, visibility:)`, the `defaultAppearance` of `GlassLayer` and the appearance of each own-layer shape. A finish's fill ([0036](0036-glass-on-buttons-search-and-filters.md): `backgroundGlass`, `backgroundGlassInk`, the tints) is that appearance's `tint`; the fill painted above the glass is gone. The package's "appearance" is not the Apparence setting of the glossary.
- The rim is the package's: a glint on the top and bottom walls, a dark contour outside the silhouette, an inner shadow under the top wall, the light fixed from above. `GlassRim` is deleted, with what only fed it (`GlassFinish.rimHighlight` and `rimShade`, `FujinGlass.tintRimHighlight` and `tintRimShade`, the rim parameters of `GlassBody` and `GlassFill`) and the tokens `border/glass-highlight`, `border/glass-shade`, `border/glass-ink-highlight`, `border/glass-ink-shade`, `border/lens-edge` (both themes) and `stroke/glass-tint-rim`. Ink and tinted controls lose their white and coloured rims; "Confirmer" loses its 1.5 rim. The glint takes the colour of what is behind the glass. The green active-tab pill is not glass and still has no rim.
- `FujinGlass` presets, tuned by eye on the Pixel 8 in light and dark against the owner's Instagram and iOS Settings recordings ([0033](0033-liquid-glass-and-fade-through.md)); what is not listed keeps the package default:

  | Preset | Used by | Settings |
  |---|---|---|
  | `floating(brightness)` | tab plate, glass buttons, day/night toggle | `refractionHeight` 28, `frost` 2.25 |
  | `control(brightness)` | buttons, search fields, filters | `refractionHeight` 12, `frost` 4 |
  | `lens` | tab and segment lens | `frost` 0 |
  | `switchLens(visibility)` | switch lens | `refractionHeight` 10, `frost` 0, `backdropShrink` 0.24 × visibility |

  The dark `floating` and `control` take a stronger, more directional contour (`contourStrength` 0.88, `contourDirectionality` 1), so the glass keeps an edge on a dark page; light keeps the package's. Every preset keeps the package's `highlight` (0.6) and `dispersion` (0): the 0.2 values carried over drew rainbow fringes and mirrored text at the edges, and 0 is the cheapest setting. `frost` 2.25 rather than 2 because the blur is downsampled only from about 5.8 device pixels, and 2 is 5.25 on the Pixel 8. The tints keep [0036](0036-glass-on-buttons-search-and-filters.md)'s alphas (`FujinGlass.tint` 0.14 / 0.24, `faintTint` 0.04 / 0.2).
- Text on a tinted control has its own roles, `text/glass-link`, `glass-gold`, `glass-info`, `glass-alert` and `glass-secondary` (`GlassFinish.foreground`; the tint stays `text/link`, `gold`, `info`, `alert`, `secondary` through `GlassFinish.fill`). In light they are the same colours as their text roles. In dark they are the same hues made lighter, until the text reaches 4.8:1 on the tinted face over the page and a card (over the alert card too for `glass-alert`), with the face modelled as the tint over that surface plus the lift measured on the Pixel 8: #B1D5AE, #E5C78B, #B2CEDC, #F6BEB2, #C9C2AE. A matte status pill keeps its text role (`PillTone.foreground`); a glass one takes the finish's (`StatusPill(glass: true)`).
- The switch lens shrinks what it shows through `backdropShrink` instead of a `RawMagnifier` (the same 76% at full swell, one backdrop copy fewer). It strokes no outline of its own: `_ReflectionPainter` keeps the top and bottom reflection (`backgroundLensReflection`, to 20% and from 88% of the height), and its shadow is a `GlassShadow`.
- Each glass keeps its own full-screen backdrop copy. Two ways to share or shrink it were rejected:
  - `LiquidGlassCapture` around each glass, made to copy only the region it covers, measured slower on every scenario on the Pixel 8 (settings switch: frames over budget 5 → 20) [inference: on Mali the extra render pass of each capture costs more than the smaller copy saves].
  - A shared `BackdropGroup` was not measured: the engine takes the copy at the first filter of the group, so during the tab fade-through the bar would have shown the outgoing page.

## Consequences

- The glass is the iOS 27 glass of the package, not [0033](0033-liquid-glass-and-fade-through.md)'s: no `lightAngle` or ambient light any more, and every shape has the same rim. Its look is the owner's call; the presets stay in `FujinGlass`.
- Frame times on the Pixel 8, glass benchmark, medians of three runs, raster milliseconds: the 0.2 on 2026-10-22 against the 1.0 on 2026-10-26.

  | Scenario | Average | p90 | Frames over budget |
  |---|---|---|---|
  | tab switch | 10.0 → 10.7 | 15.2 → 15.3 | 12 → 14 |
  | send review | 6.8 → 6.9 | 8.5 → 9.1 | 1 → 0 |
  | Journal scroll | 7.6 → 8.4 | 11.1 → 10.4 | 2 → 0 |
  | settings switch | 8.6 → 9.5 | 11.2 → 13.4 | 2 → 3 |

  The settings switch's average and p90 are outside the 0.2's run-to-run range (8.3–8.6 and 10.9–12.0). The two sides were measured on different days, and the owner chose not to measure them again side by side; the migration is kept with this cost.
- `1.0.0-dev.2` also reworks how the glass is drawn (blurs cropped to each glass, a low-resolution geometry matte, shadow bounds on pixel buckets). The frame times above and the presets' look were measured on the fork's `1.0.0-dev.1`; the glass benchmark has not run on `1.0.0-dev.2`.
- The package bounds Dart to `>=3.13.0 <3.14.0`, so the next Dart upgrade waits for it.
- A debug build warns of three to five independent backdrop copies in a frame; this is the cost above, not an error.
- A control's colour on screen is the tint through the appearance's wash, no longer the token over what is behind. Measured on Pixel 8 screenshots (2026-10-26, Journal and send review on fake data), the median colour of each face against its text role, with the 0.2 estimated as the fill laid over the colour around the control:

  | Finish, where | Light | Dark | 0.2 estimate, light / dark |
  |---|---|---|---|
  | `ink`, Journal and review footer | #312F2B, 13.0:1 | #DAD4C3, 11.8:1 | 13:1 / – |
  | `clear`, review close button | #FDF7E7, 16.3:1 | #2E2C29, 11.5:1 | – |
  | `validated`, "Confirmer" on a review card | #DFE4D6, 5.8:1 | #4B5646, 4.8:1 (3.8:1 with `text/link`) | 6.0:1 / 4.8:1 |
  | `validated`, "automatiques" filter on the page | #DEDEC8, 5.6:1 | #465142, 5.2:1 | – |
  | `alert`, "Réessayer" on the alert card | #F3D2C8, 4.2:1 | #6F473E, 4.9:1 (3.1:1 with `text/alert`) | 3.8:1 / 3.9:1 |

  The dark wash lifts the tinted faces; with the dark text of `text/link` and `text/alert`, "Confirmer" and "Réessayer" fell below the 4.5:1 of [0032](0032-text-contrast.md), hence the glass text roles. "Réessayer" in light stays at 4.2:1, as it was below on the 0.2. The dark "Réessayer" figure is its new text against the face measured before the change, since the tint behind it did not change. [0032](0032-text-contrast.md) checks text roles on page and card, not on glass, so no test covers these figures.
- Figma still has the six deleted variables and has none of the five `text/glass-*` roles.
- Tests run on `FakeGlass` and say nothing about the look. Checked on the Pixel 8 only; iOS and a release build have not run on 1.0.
