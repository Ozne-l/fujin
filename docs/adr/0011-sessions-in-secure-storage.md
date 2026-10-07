# 11. Sessions in secure storage

Date: 2026-10-07

## Status

Accepted. Stores implemented; sign-in screens planned.

## Context

Both client packages take a pluggable credential store (`EkkloTokenStore` in `~/Dev/ekklo_client`, `MfpSessionStore` in `~/Dev/myfitnesspal_client`), in memory by default. Fūjin must keep sessions across restarts without letting them reach a backup ([0005](0005-backup.md)) or a log.

## Decision

- Ekklo tokens and MyFitnessPal session cookies persist in `flutter_secure_storage` 11.2.0: `SecureEkkloTokenStore` (`lib/data/sessions/secure_ekklo_token_store.dart`) and `SecureMfpSessionStore` (`lib/data/sessions/secure_mfp_session_store.dart`), each storing the client's own JSON form under one key from `SessionKey` (`lib/data/sessions/session_key.dart`).
- `lib/app/providers.dart` wires both stores into the clients through `secureStorageProvider`.
- They are outside Auto Backup by construction: the backup rules include only `fujin.db`.
- Planned: the Ekklo login screen and the MyFitnessPal web view sign-in that captures cookies (as the POC did with `flutter_inappwebview`).
- Open point: the MyFitnessPal web view's User-Agent is not persisted yet.

## Consequences

- After a reinstall or restore the owner signs in again.
- Session expiry surfaces as `MfpAuthException` or `EkkloAuthException`, shown as "Déconnecté" in `lib/pages/journal/widgets/journal_problem_card.dart`.
- Credentials never appear in the database, the backup file, or test fixtures (tests use fake values in `test/support/fake_backends.dart`).
