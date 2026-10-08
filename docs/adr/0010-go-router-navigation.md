# 10. go_router navigation

Date: 2026-10-07

## Status

Accepted. Four routes exist: the Journal, the welcome screen, and the MyFitnessPal and Ekklo sign-ins pushed above either of them.

## Context

The mockups show tabs (Journal, Mémoire, Réglages, plus Scanner), a send flow of several screens (10 to 14), and confirmations in bottom sheets. Back navigation and the Android back gesture must behave predictably in each.

## Decision

- `go_router` 18 (`pubspec.yaml`), configured in `routerProvider` (`lib/app/router.dart`) and passed to `MaterialApp.router` (`lib/app/fujin_app.dart`).
- Route paths come from the `FujinRoute` enum (`lib/app/fujin_route.dart`), never from string literals at call sites. Today it has `journal`, `welcome`, `mfpSignIn`, `ekkloSignIn` and `send` (`/send/:date`, built with `FujinRoute.send.forDate`).
- The Journal route redirects to the welcome screen while either session is missing (`AccountsService.read`, `lib/domain/accounts/accounts_service.dart`). The check reads secure storage only; an expired session still reaches the Journal, whose problem card offers the sign-in again.
- A sign-in is pushed with `context.push<bool>` and pops with `true` once the session is stored. The Journal then reads the day again; the welcome screen reads the connected accounts again. "Continuer" on the welcome screen uses `context.go`, so the Journal replaces it.
- The send flow is one route, `SendPage` (`lib/pages/sending/send_page.dart`), pushed from the Journal; screens 09 to 16 are states of that page, and 11 to 13 are modal bottom sheets. The Journal reads the day again when it pops. Back is blocked while a send runs.
- Planned: a shell route for the tabs Journal, Mémoire, Réglages and Scanner, below the send route; confirmations as sheets, not routes.
- No tab bar is shown until a second tab screen exists.

Source: go_router docs (pub.dev/packages/go_router, `ShellRoute` / `StatefulShellRoute`, route-level `redirect`).

## Consequences

- Adding a screen is one enum value and one route.
- Every navigation to the Journal costs two secure storage reads.
