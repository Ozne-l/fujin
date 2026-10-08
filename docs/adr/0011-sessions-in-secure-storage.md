# 11. Sessions in secure storage

Date: 2026-10-07

## Status

Accepted. Stores and both sign-ins implemented.

## Context

Both client packages take a pluggable credential store (`EkkloTokenStore` in `~/Dev/ekklo_client`, `MfpSessionStore` in `~/Dev/myfitnesspal_client`), in memory by default. Fūjin must keep sessions across restarts without letting them reach a backup ([0005](0005-backup.md)) or a log.

## Decision

- Ekklo tokens and MyFitnessPal session cookies persist in `flutter_secure_storage` 11.2.0: `SecureEkkloTokenStore` (`lib/data/sessions/secure_ekklo_token_store.dart`) and `SecureMfpSessionStore` (`lib/data/sessions/secure_mfp_session_store.dart`), each storing the client's own JSON form under one key from `SessionKey` (`lib/data/sessions/session_key.dart`).
- `lib/app/providers.dart` wires both stores into the clients through `secureStorageProvider`.
- They are outside Auto Backup by construction: the backup rules include only `fujin.db`.
- The Ekklo sign-in screen (`lib/pages/ekklo_sign_in/ekklo_sign_in_page.dart`) calls `EkkloClient.login` on the app's client, which writes the tokens through `SecureEkkloTokenStore`. Fūjin keeps no email or password.
- The MyFitnessPal sign-in screen (`lib/pages/mfp_sign_in/mfp_sign_in_page.dart`) opens `Config.mfpSignInUri` in a web view (`flutter_inappwebview` 6.2.0-beta.3, MIT; the 6.1 Android plugin does not build with Android Gradle Plugin 9). After each page load it reads the cookies of `Config.mfpWebUri`, including the HttpOnly session cookie, through `CookieManager`, and hands them to `MfpSignInNotifier`, which calls `MyFitnessPalClient.signIn` once they hold a session. The client writes them through `SecureMfpSessionStore`.
- The MyFitnessPal client sends the web view's own User-Agent, read once at bootstrap with `InAppWebViewController.getDefaultUserAgent()` (`lib/main.dart`, `mfpUserAgentProvider`), because the website's bot protection may refuse `/user/auth_token` from another agent (`~/Dev/myfitnesspal_client/README.md`). It is not stored: it changes with each Android System WebView update, and the next launch reads the new one.

## Consequences

- After a reinstall or restore the owner signs in again.
- Session expiry surfaces as `MfpAuthException` or `EkkloAuthException`, shown as "Déconnecté" in `lib/pages/journal/widgets/journal_problem_card.dart`.
- Credentials never appear in the database, the backup file, or test fixtures (tests use fake values in `test/support/fake_backends.dart`).
