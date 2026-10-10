# 24. Splash from the first frame

Date: 2026-10-10

## Status

Accepted.

## Context

Screen 00 (Figma `13:2566`) is meant to be what the owner sees during the whole start. `lib/main.dart` awaits the app support directory, opens `fujin.db`, reads the web view User-Agent ([0011](0011-sessions-in-secure-storage.md)) and the app version before it can build the `ProviderScope`, since `databaseProvider` is overridden there ([0013](0013-layers.md)). Until then only the native launch window shows: washi, and on Android 12+ the system splash with the app icon in the middle. The drawn 00 covered only the accounts redirect, so on a fast device it was never seen.

## Decision

- `main` calls `runApp` twice. First `SplashApp` (`lib/app/splash_app.dart`): a `MaterialApp` with the theme, the copy and the dev banner of `FujinApp`, and `SplashView` (`lib/pages/splash/splash_view.dart`) as its only screen, no `ProviderScope`. Then, once the database, User-Agent and version are ready, the `ProviderScope` with its overrides around `FujinApp`, whose first route (`FujinRoute.splash`, `SplashPage`) draws the same `SplashView`. The second tree replaces the first; the splash keeps the same size and place, so the handover does not show. There is no minimum duration.
- `SplashPage` is `SplashView` plus the jump to the Journal; the view itself knows nothing of routing.
- The native launch windows are plain washi (`@color/splash_background`, `#F7F1E0`) with no icon: on Android 12+ `values-v31` and `values-night-v31` set `android:windowSplashScreenBackground` to washi and `android:windowSplashScreenAnimatedIcon` to a transparent drawable (`drawable/splash_icon.xml`), shared by both flavors; on iOS `LaunchScreen.storyboard` is a washi view without an image.
- A failure while opening the database still throws out of `main`, as before; the splash simply stays on screen instead of the launch window. No error screen is added.

Rejected: a bootstrap `FutureProvider` that the splash waits on. It would make `databaseProvider` depend on an async provider, change the "overridden in bootstrap" rule of the fujin-state skill and turn a startup failure into provider state.

## Consequences

- Any change to `FujinApp`'s theme, copy or banner must reach `SplashApp` too; the banner comes from `FujinApp.bannerFor`, the theme and copy are repeated. The test "hands over to the splash route without moving the logo, the title or the tagline" (`test/pages/splash_page_test.dart`) fails if the two splashes drift apart.
- The logo and band images are decoded during the first phase; the image cache serves them at once after the handover.
