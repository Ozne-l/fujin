# Fūjin

Fūjin is a personal Android app, built with Flutter, that copies its owner's MyFitnessPal food diary into Ekklo, the nutrition app his coach follows. For each day it reads both services, shows which MyFitnessPal entries are already in Ekklo ("Dans Ekklo"), which still have to go ("À envoyer") and which changed after being sent ("À mettre à jour"), and writes them to Ekklo. The interface is in French, with an English translation for English devices.

## Status

Works today:

- The Journal (`lib/pages/journal/journal_page.dart`): a swipeable week band with one goal ring per day, a day card with the MyFitnessPal kilocalories and macros against the goals, the Ekklo progress and a detail sheet, meals with a status per entry and "N/M dans Ekklo", pull to refresh with the "Rien de nouveau" snackbar, re-read on return to the foreground. When one app fails, the other stays readable; offline, the last figures stay on screen and the day is read again every 15 s ([ADR 0022](docs/adr/0022-journal-states-and-goal-rings.md)).
- The day comparison (`lib/domain/comparison/compare_day.dart`): statuses recomputed from both services, adoption of items already in Ekklo, edited entries detected through orphan links.
- The splash screen (`lib/pages/splash/splash_page.dart`), shown at startup while the sessions are read, then the welcome screen (`lib/pages/welcome/welcome_page.dart`), shown instead of the Journal until both accounts are signed in.
- The Mémoire tab (`lib/pages/memory/`) and the Réglages tab (`lib/pages/settings/`) with the daily goals and the backup file ([ADR 0019](docs/adr/0019-tab-shell.md), [ADR 0020](docs/adr/0020-goals.md), [ADR 0021](docs/adr/0021-backup-file.md)).
- MyFitnessPal sign-in in a web view (`lib/pages/mfp_sign_in/mfp_sign_in_page.dart`) and Ekklo sign-in (`lib/pages/ekklo_sign_in/ekklo_sign_in_page.dart`), opened from the welcome screen or from the Journal when a session has expired; the Journal reads the day again after a successful sign-in.
- The send flow (`lib/pages/sending/send_page.dart`, `lib/domain/sending/`): Ekklo search and ranking of candidates, review with the sheets to choose a food, set a unit's weight or create an own copy, then sending per Ekklo meal with progress, a summary and the interrupted state; updates of entries changed in MyFitnessPal; every choice remembered in Memory ([ADR 0018](docs/adr/0018-send-flow.md)).
- Local storage in one SQLite file, `fujin.db` (Memory and send links), Android Auto Backup limited to that file, sessions in secure storage.
- Theme generated from design tokens, French and English copy through gen-l10n, tests for the comparison, storage, the Journal, the welcome screen, both sign-ins, the send planning and execution, and the send flow.

Planned: undo, the "Mode automatique" setting, Scanner and adding a food from the Journal.

## Build and run

Requires Flutter 3.44.9 (Dart 3.12.2) and an Android device or emulator. The iOS project builds and runs on the iOS simulator (Xcode 26); it has not been installed on an iPhone yet.

```sh
flutter pub get
flutter test
flutter run --flavor production
```

Base URIs can be redirected to local fake servers with `--dart-define`; see [AGENTS.md](AGENTS.md#running-without-real-accounts).

To try the app on your own accounts without changing them, run the dev app:

```sh
flutter run --flavor dev
```

It installs next to the real app as "Fūjin DEV", with its own data and sessions, and shows a red "DEV" ribbon in the top-right corner. Reads and sign-in work; every other request to MyFitnessPal or Ekklo is stopped on the phone ([ADR 0017](docs/adr/0017-read-only-dev-environment.md)).

In VS Code or Cursor, the Run and Debug panel offers both apps from `.vscode/launch.json`: "Fūjin" (`--flavor production`) and "Fūjin DEV" (`--flavor dev`), on the device picked in the status bar.

## Documentation

- [AGENTS.md](AGENTS.md): commands, layers, where code goes, working rules.
- [GLOSSARY.md](GLOSSARY.md): glossary of domain terms and screen codes.
- [docs/adr/](docs/adr/README.md): architecture decision records.

## Third-party notices

- Fonts: Inter and Hina Mincho, from Google Fonts, under the SIL Open Font License; see `assets/fonts/inter/OFL.txt` and `assets/fonts/hinamincho/OFL.txt`.
- Agent skills vendored from Matt Pocock's skills repository (github.com/mattpocock/skills) under the MIT license; see `.agents/skills/THIRD_PARTY.md`.
