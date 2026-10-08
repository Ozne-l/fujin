# 17. Read-only dev environment

Date: 2026-10-08

## Status

Accepted

## Context

The owner wants to try new screens on his own MyFitnessPal diary and Ekklo account, to judge them with real data. Reads are harmless. Any write (a send, an update, an undo, an own copy, a diary change) would change his real accounts. The local fake servers described in `AGENTS.md` protect the accounts but show made-up data.

## Decision

- Dev is a second app, built from the same code with `--flavor dev`; the real app is `--flavor production`. Each flavor has its own app id, so Android and iOS give each app its own data, sessions and backup, and both install side by side:

  | Flavor | App id (Android and iOS) | Name | Icon |
  | --- | --- | --- | --- |
  | `production` | `dev.oznel.fujin` | Fūjin | standard |
  | `dev` | `dev.oznel.fujin.dev` | Fūjin DEV | with a red "DEV" band |

  Android: `productFlavors` in `android/app/build.gradle.kts`, with the dev name and icon in `android/app/src/dev/res/`. iOS: the `production` and `dev` schemes with their `Debug-`, `Profile-` and `Release-` configurations in `ios/Runner.xcodeproj`; each sets `PRODUCT_BUNDLE_IDENTIFIER`, `APP_DISPLAY_NAME` and the icon set (`AppIcon` or `AppIcon-dev`).
- The environment comes from the flavor itself: `Config.environment` is `AppEnvironment.fromFlavor(appFlavor)` (`lib/app/app_environment.dart`, `lib/app/config.dart`), and `main` hands it to `appEnvironmentProvider`. The build tool sets `appFlavor` from the same flavor that picks the app id, so the dev app cannot run without the guard. A build without a flavor, or with an unknown one, throws at startup instead of running as production; the Flutter tool already refuses such a build on iOS.
- In dev, `httpClientProvider` (`lib/app/providers.dart`) wraps the shared `http.Client` in `ReadOnlyHttpClient` (`lib/data/http/read_only_http_client.dart`). Both client packages send through that one client, so the guard covers every call, present and future, and the domain does not know it exists.
- The guard lets `GET` and `HEAD` through, plus the two Ekklo session writes: login (`/api/v1/auth/login`) and refresh (`/api/v1/auth/login/refresh_token`), matched on origin and path against `Config.ekkloBaseUri`. MyFitnessPal needs no exception: its token exchange `/user/auth_token` is a `GET`.
- Every other request throws `http.ClientException` before it leaves the phone. The clients turn it into `EkkloNetworkException` or `MfpNetworkException`, so a page shows its "unreachable" state.
- The rule is an allowlist: a new write endpoint is blocked until this record and the guard say otherwise.
- In dev, `FujinApp` (`lib/app/fujin_app.dart`) wraps every screen in a Flutter `Banner` at the top-end corner reading "DEV" (`devEnvironmentBanner`), on the alert button colours, so the mode is visible on every screen. The banner does not catch taps.

## Consequences

- `flutter run --flavor dev` on the owner's phone shows his real diary and Ekklo meals with no risk to either account, and without touching the production app's data or sessions.
- Every build and run names its flavor: `flutter run --flavor production` for the real app.
- The dev app starts empty: the owner signs in again, and its Memory and send links are its own. It cannot read the production app's database.
- A send in dev fails as unreachable instead of pretending to succeed. When the send flow is built ([ADR 0002](0002-write-ordering.md)), seeing its success screens in dev needs a simulated executor in `lib/domain/sending/`; until then dev shows reads only.
- MyFitnessPal sync (`/iphone_api/synchronize`) is a `POST` and is blocked, so the planned barcode scanner will fail in dev until its lookup is allowed explicitly.
- The MyFitnessPal sign-in web view does not use the guard. It opens the login page only, but anything the owner does inside it reaches the real site.
- The Ekklo session paths are copied from `package:ekklo_client`'s transport. If the client changes them, dev sign-in fails closed; it never opens a write.
- Local storage works as usual inside the dev app: its secure storage keeps both sessions, and its own `fujin.db` keeps memory and send links.
- The iOS project is generated and both schemes build and run on the iOS simulator; nothing has been installed on an iPhone yet, which needs the owner's Apple signing team.
- Agents still run against local fake servers only; dev mode does not relax that rule.
