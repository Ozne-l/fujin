# 37. Progressive blur under fixed headers

Date: 2026-10-21

## Status

Proposed (to be checked by the owner on his phone). Replaces the top fade of [0033](0033-liquid-glass-and-fade-through.md). Amends [0019](0019-tab-shell.md): the tab pages drop their top `SafeArea`.

## Context

A list scrolling under a fixed header used to end in a 24 px gradient of the page colour (`ScrollEdgeFade`). The owner wanted the iOS look instead (his recording of the iOS Settings): the content goes on under the bar, blurred more and more towards the top, and the large title gives way to a small centred one. Another of the owner's apps already does this with a fork of `progressive_blur` (`ProgressiveBackdropBlur`, a two-pass shader over the backdrop, run only inside given bands). He also asked for three page changes: the Journal title and week band stay at the top, the Mémoire search field stays in place, and the Réglages title moves to the middle when it scrolls away.

## Decision

- `progressive_blur` comes from the same fork and commit as that app (`T-moz/progressive_blur`, `bb1fd7b`), and `main` precaches its shader before the app starts.
- `EdgeBlur` (`lib/pages/common/edge_blur.dart`) covers its own bounds: the backdrop blur at full strength, then fading to none over the last `scroll-edge-fade` (32 px), with a wash of the page colour following the same curve. The wash is a separate gradient: the shader mixes its tint without premultiplying it, which turned a cream tint white. Without shader filters (Skia) or with Reduce Transparency or high contrast, it is the page colour alone, opaque.
- The blur spans the whole width of the screen and runs from the top edge of the screen, status bar included, down to the bottom of the fixed widget the list scrolls under. A list therefore fills the screen from its top edge, starts below its header at rest, and stays visible, blurred, all the way up to the top edge. Nothing clips it at the status bar or at the header. The pages drop their top `SafeArea`; whatever sits at the top adds `MediaQuery.paddingOf(context).top` itself (the header, the day/night toggle in `AppearanceCorner`, the pull-to-refresh disc).
- `HeaderLayout` (`lib/pages/common/header_layout.dart`) lays a header over a full-screen body. It measures the header at its natural height during layout and builds the body with that height, so the list's resting top follows the header (text size, wrapped subtitle) without waiting a frame.
- A pointer on the header reaches both the header and the list under it. A vertical drag that starts on the header therefore scrolls the list, or pulls it to refresh, as it did when the Journal header was part of the list. `HeaderLayout.shield` wraps the header's content with a tap that does nothing. A tap on a blank part of the header, or on its text, never reaches a row blurred under it, while the header's own buttons still win their taps.
- `ScrollEdgeBlur` (`lib/pages/common/scroll_edge_blur.dart`) lays an `EdgeBlur` over a list from the top of the screen. `top` is where the list rests and `cover` is how much of the fixed area the content rests under (Réglages: the toggle's line). The blur exists only once the list has scrolled, and its lower edge goes from `top` to `top + cover + fade` as the content moves up. Nothing is blurred at rest.
- Journal: `JournalHeader` overlays the list and holds the title row and the week band. They rise with the list while "Fūjin" (`JournalBrand`, in the list) scrolls away, then stay put once the title's centre is on the toggle's line. Before that point, the blur covers the status bar and the brand passing under it. After it, the blur reaches the bottom of the band plus one fade as the meals pass under. "Aujourd'hui ›" or "Définir mes objectifs ›" fades out as the title rises, since the toggle takes that end of the line.
- Mémoire: the title, the subtitle and the segments are the header, and both pages fill the screen under it. The search field of the Aliments page stays fixed below the segments, and the list starts below the field.
- Réglages: the large title scrolls with the list; as it leaves, a small "Réglages" (Hina 22) fades in at the centre of the toggle's line, as in iOS.
- Add search and send review: the flow header, the search field and chip, or the review filters are the header.
- `ScrollExtentListener` (`lib/pages/common/scroll_extent_listener.dart`) reports how far the list below it has scrolled, negative while it is pulled down, so the Journal header follows the pull.

## Consequences

- On the Android emulator, Impeller runs on OpenGL ES, and the shader flips its y axis there: the horizontal pass falls outside its band and only the vertical pass blurs, which draws vertical streaks. Impeller on Vulkan cannot run in this emulator (it crashes it). The look was checked on the iOS simulator (Metal), light and dark, on the four pages. An Android phone on Vulkan, like the owner's, should render as on iOS; this has not been seen. A phone that falls back to OpenGL ES would show the streaks.
- The fork's commit sits on a branch (`perf/edge-strips`), not on `main`; if the branch goes, the commit can go with it.
- `flutter test` runs on Skia, so tests see the opaque fallback.
- `tester.ensureVisible` aligns its target to the top of the list, which is now under the header. `test/pages/send_page_test.dart` scrolls with `Scrollable.ensureVisible(..., alignment: 0.5)` so its target sits mid-list, clear of the blurred header; the other page tests still use `tester.ensureVisible`.
- The blur covers more of the screen than before (the whole header area), so it costs more GPU per frame while a list is scrolled.
