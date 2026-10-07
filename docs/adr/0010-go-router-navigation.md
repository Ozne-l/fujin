# 10. go_router navigation

Date: 2026-10-07

## Status

Accepted. Only the Journal route exists today.

## Context

The mockups show tabs (Journal, Mémoire, Réglages, plus Scanner), a send flow of several screens (10 to 14), and confirmations in bottom sheets. Back navigation and the Android back gesture must behave predictably in each.

## Decision

- `go_router` 18 (`pubspec.yaml`), configured in `routerProvider` (`lib/app/router.dart`) and passed to `MaterialApp.router` (`lib/app/fujin_app.dart`).
- Route paths come from the `FujinRoute` enum (`lib/app/fujin_route.dart`), never from string literals at call sites. Today it has one value, `journal`.
- Planned: a shell route for the tabs Journal, Mémoire, Réglages and Scanner; the send flow 10 to 14 as its own stack above the shell; confirmations as sheets, not routes.
- No tab bar is shown until a second tab screen exists.

Source: go_router docs (pub.dev/packages/go_router, `ShellRoute` / `StatefulShellRoute`).

## Consequences

- Adding a screen is one enum value and one route.
- The router is a provider, so it can read session state for redirects once sign-in exists.
