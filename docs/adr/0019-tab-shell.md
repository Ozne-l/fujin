# 19. Tab shell

Date: 2026-10-10

## Status

Accepted. Supersedes the "Planned" and "No tab bar" bullets of [0010](0010-go-router-navigation.md) and the `lib/pages/` memory and settings items in the planned folders of [0013](0013-layers.md).

## Context

The Mémoire screens (18 to 21 in the Figma file "Fūjin · Maquettes") are the second tab screen, which [0010](0010-go-router-navigation.md) set as the condition for showing a tab bar. The mockups draw a floating bar: a frosted plate with Journal, Mémoire and Réglages, and a separate round Scanner button beside it, over a fade of the page background. Each tab keeps its own place (a Memory food screen stays open when the owner looks at the Journal and comes back). The scanner (chapter 5) is not built.

## Decision

- The tabs are a `StatefulShellRoute.indexedStack` in `routerProvider` (`lib/app/router.dart`), one `StatefulShellBranch` per `FujinTab` value (`lib/pages/tabs/fujin_tab.dart`), built with an exhaustive `switch` so a new tab cannot miss its branch. Each branch keeps its own navigator and stack.
- The accounts redirect of [0010](0010-go-router-navigation.md) moves from the Journal route to the shell route, so every tab needs both sessions.
- The welcome screen, both sign-ins and the send flow stay top-level routes above the shell: they cover the tab bar, and back from them returns to the tab that opened them.
- `TabShell` (`lib/pages/tabs/tab_shell.dart`) is a `Scaffold` with `extendBody: true` and `FloatingTabBar` (`lib/pages/tabs/floating_tab_bar.dart`) as its bottom bar, so pages scroll under the glass. Each tab page keeps `SafeArea(bottom: false)` and ends its scroll with the bottom padding the bar reports. Tapping the current tab returns its branch to its first screen (`goBranch(index, initialLocation: true)`).
- The Scanner button is drawn and announced as disabled until the scanner exists; it is not a branch.
- Memory routes: `FujinRoute.memory` (`/memory`) and `FujinRoute.memoryFood` (`/memory/food/:food`, with `?unit=` for an own copy, built by `FujinRoute.memoryFood.forFood`), both in the Memory branch. The change of Ekklo food ("Changer ›") is a sheet, not a route.
- A tab exists only once its screen exists: Réglages joins `FujinTab` together with its page.

Source: go_router docs (pub.dev/packages/go_router, `StatefulShellRoute.indexedStack`, `StatefulNavigationShell.goBranch`).

## Consequences

- Adding a tab is one `FujinTab` value, its icon and label, and one branch case; the compiler points at the missing case.
- The Memory page is built once and kept alive by the indexed stack, so the Journal invalidates `memoryProvider` after a send to show what the send remembered.
- Every navigation into the shell costs the two secure storage reads of the accounts check, as the Journal did before.
