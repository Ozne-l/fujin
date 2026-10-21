# 36. Glass on buttons, the search field and filters

Date: 2026-10-21

## Status

Proposed (to be checked by the owner on his phone). Extends [0033](0033-liquid-glass-and-fade-through.md).

## Context

[0033](0033-liquid-glass-and-fade-through.md) put liquid glass on the tab bar, the Scanner and the day/night toggle. Every other control stayed matte: card-coloured round buttons, a sumi primary button, coloured pills. The owner tried a rule in Figma ("Expérience 4 · Règle : du verre sur les boutons, la recherche et les filtres", node `396:37173`, screens 10, 02b, 04a, 06b, K1 and O1 before and after) and asked for it in the app.

## Decision

- Glass goes on buttons, search fields and filters only. Status pills, cards, list rows, text links (`TextButton`), the switch, the days of the band, the drop-down menus (`FujinMenuButton`: serving size, meal, date) and the serving steps stay matte: they are not buttons.
- A control's glass is a `GlassFill` (`lib/pages/common/glass_fill.dart`): a stadium of liquid glass on its own layer, with the `FujinGlass.control` preset, a fill laid inside it and a `GlassRim`. `GlassFill` and the tab plate's `GlassSurface` draw through one `GlassBody` (`lib/pages/common/glass_body.dart`): the rim over the fill, the light under the finger (`GlassTouchGlow`: over the fill for a control, under it and clipped to the plate for the tab plate), the press swell, the shadow and the opaque fallback. `GlassBody.ownLayer` takes the control's own `LiquidGlassLayer`, `GlassBody.grouped` joins the tab bar's `GlassLayer`. The look comes from a `GlassFinish` (`lib/pages/common/glass_finish.dart`), one of three recipes:
  - white or transparent controls take `clear`, the neutral glass of the glass button: `backgroundGlass` fill and the white `borderGlassHighlight` / `borderGlassShade` rim;
  - black controls, cream in dark, take `ink`: `backgroundGlassInk` (the primary button colour at 80%) with a white rim (`borderGlassInkHighlight` / `borderGlassInkShade`: white at 35% and 5% in light, 50% and 5% in dark);
  - coloured controls take their colour as a tint (`validated`, `attention`, `info`, `alert`, `muted`): the tint at 14% in light and 24% in dark (`muted` at 4% and 20%, as the frames draw "4 déjà dans Ekklo"), a rim in the tint at 75% / 15% in light and 90% / 25% in dark, and the text in the tint. The alphas are `FujinGlass.tint`, `faintTint`, `tintRimHighlight` and `tintRimShade`.
- The theme applies it: every `FilledButton` is `ink`, every `OutlinedButton` and `FujinIconButton` is `clear`, `FujinTheme.alertButtonStyle` is `alert`, through `GlassFill.style`, which sets the button's `backgroundBuilder`, a transparent Material and the finish's text colour. A disabled button is `clear` with `buttonDisabledText`. A change of finish (a filter chosen, a button enabled) cross-fades on `FujinMotion.pill`.
- Only what floats over content has the floating shadow (`GlassFill(floating: true)`, `GlassFill.style(…, floating: true)`): the header buttons (`FlowHeader`, `TopBar`, the Mémoire fiche, the MyFitnessPal sign-in), the add search field and its filter chip, the Mémoire search field, and the buttons pinned at the bottom (send review footer, sent and storm footers, the add fiche, Objectifs, the welcome screen, the Ekklo sign-in). The pinned `ink` buttons take `FujinTheme.floatingButtonStyle`. Both search fields are a `GlassSearchField` (`lib/pages/common/glass_search_field.dart`): `clear` floating glass around a search `TextField` with the search icon, no fill, no border at rest and the focused pill outline; each screen gives its hint, text styles, padding and clear button. Inside a page, a card or a sheet, the glass has its rim and no shadow, as Figma draws it.
- Per screen, as in the Figma rule: the send review's filters are glass `StatusPill`s (`glass: true`, the chosen one `ink`, the others tinted by their tone, `PillTone.glass`); "Confirmer" is `validated` with a 1.5 rim (`FujinStroke.glassTintRim`); the add search's "Vérifiés uniquement" and barcode chips are `clear`, `validated` when chosen; "Oublier" on a Mémoire fiche is `alert`; the active pill of `FujinSegments` (Apparence, Mémoire) is `clear`.
- A pressed glass control lights under the finger (`GlassGlow`) and swells a little (`LiquidStretch`, `FujinMotion.glassPress`), like the glass buttons; the Material press overlay stays.
- With Reduce Transparency or high contrast, a `GlassFill` becomes opaque: its fill laid over `backgroundCard`, with a `borderCard` outline, and it no longer swells when pressed. The tab plate turns plain `backgroundCard` with the same outline and still swells.

## Consequences

- The Figma frames give the Figma glass effect (refraction 80, depth 12, dispersion 35, frost 10); the app does not use them. Controls take `FujinGlass.control`, the tab bar's light and colour with a thinner glass (thickness 12 instead of 28) and more frost (blur 4 instead of 2), matched to the owner's recordings of the iOS search bar: the refraction stays in a thin edge and the content behind is frosted. With the bar's thickness, a control 44 to 48 px tall was lens from edge to edge and drew white strips along its bottom. The neutral fill is the app's `backgroundGlass` (25% light, 45% dark), not the 40% and 55% of the Figma variable, for the same reason.
- In the Figma rule frames, the "Repas" and "Date" menus of screen 04a have their card fill at 20%; the notes say these menus stay matte, so the app leaves them as they are.
- The review filters have no shadow, as in the frames, though the rule's text counts header filters as floating.
- Glass can no longer sit under a layer that redraws its content offscreen: the backdrop it refracts is then that layer's own, half-empty picture, and the glass came out as a white and rainbow band (Mémoire search field on the owner's phone) or black (emulator). The top edge of a list is therefore never a mask: it is now a backdrop blur laid over the list ([ADR 0037](0037-progressive-blur-under-fixed-headers.md)). A fade-through also draws its views through an opacity layer while it runs; whether glass shows the artefact during that time has not been checked.
- Each glass control has its own `LiquidGlassLayer`. On the send review a card with "Confirmer" adds one layer per visible card; this has not been measured on a low-end phone.
- `buttonDisabledBackground` no longer drives anything: a disabled button is clear glass.
- The camera buttons of the scanner keep their own dark style: the rule's frames do not show the scanner.
- Tests run on `FakeGlass` (no Impeller); the look was checked on the Android emulator only.
