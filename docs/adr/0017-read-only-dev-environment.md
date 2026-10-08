# 17. Read-only dev environment

Date: 2026-10-08

## Status

Accepted

## Context

The owner wants to try new screens on his own MyFitnessPal diary and Ekklo account, to judge them with real data. Reads are harmless. Any write (a send, an update, an undo, an own copy, a diary change) would change his real accounts. The local fake servers described in `AGENTS.md` protect the accounts but show made-up data.

## Decision

- `--dart-define=FUJIN_ENV=dev` selects `AppEnvironment.dev` (`lib/app/app_environment.dart`, read once as `Config.environment` in `lib/app/config.dart`). No value means `production`. An unknown value throws (`AppEnvironment.values.byName`) on the first request instead of falling back to production.
- In dev, `httpClientProvider` (`lib/app/providers.dart`) wraps the shared `http.Client` in `ReadOnlyHttpClient` (`lib/data/http/read_only_http_client.dart`). Both client packages send through that one client, so the guard covers every call, present and future, and the domain does not know it exists.
- The guard lets `GET` and `HEAD` through, plus the two Ekklo session writes: login (`/api/v1/auth/login`) and refresh (`/api/v1/auth/login/refresh_token`), matched on origin and path against `Config.ekkloBaseUri`. MyFitnessPal needs no exception: its token exchange `/user/auth_token` is a `GET`.
- Every other request throws `http.ClientException` before it leaves the phone. The clients turn it into `EkkloNetworkException` or `MfpNetworkException`, so a page shows its "unreachable" state.
- The rule is an allowlist: a new write endpoint is blocked until this record and the guard say otherwise.

## Consequences

- `flutter run --dart-define=FUJIN_ENV=dev` on the owner's phone shows his real diary and Ekklo meals with no risk to either account.
- A send in dev fails as unreachable instead of pretending to succeed. When the send flow is built ([ADR 0002](0002-write-ordering.md)), seeing its success screens in dev needs a simulated executor in `lib/domain/sending/`; until then dev shows reads only.
- MyFitnessPal sync (`/iphone_api/synchronize`) is a `POST` and is blocked, so the planned barcode scanner will fail in dev until its lookup is allowed explicitly.
- The MyFitnessPal sign-in web view does not use the guard. It opens the login page only, but anything the owner does inside it reaches the real site.
- The Ekklo session paths are copied from `package:ekklo_client`'s transport. If the client changes them, dev sign-in fails closed; it never opens a write.
- Local storage still works as usual in dev: secure storage keeps both sessions, and the SQLite file keeps memory and send links on the device.
- Agents still run against local fake servers only; dev mode does not relax that rule.
