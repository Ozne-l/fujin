# Fūjin

Fūjin is a personal Android app, built with Flutter, that copies its owner's MyFitnessPal food diary into Ekklo, the nutrition app his coach follows. For each day it reads both services, shows which MyFitnessPal entries are already in Ekklo ("Dans Ekklo"), which still have to go ("À envoyer") and which changed after being sent ("À mettre à jour"), and, once the send flow exists, writes them to Ekklo. The interface is in French, with an English translation for English devices.

## Status

Works today:

- The Journal (`lib/pages/journal/journal_page.dart`): week band, day card with MyFitnessPal and Ekklo energy and the Ekklo progress bar, meals with a status per entry and "N/M dans Ekklo", pull to refresh with the "Rien de nouveau" snackbar, re-read on return to the foreground.
- The day comparison (`lib/domain/comparison/compare_day.dart`): statuses recomputed from both services, adoption of items already in Ekklo, edited entries detected through orphan links.
- The welcome screen (`lib/pages/welcome/welcome_page.dart`), shown instead of the Journal until both accounts are signed in.
- MyFitnessPal sign-in in a web view (`lib/pages/mfp_sign_in/mfp_sign_in_page.dart`) and Ekklo sign-in (`lib/pages/ekklo_sign_in/ekklo_sign_in_page.dart`), opened from the welcome screen or from the Journal when a session has expired; the Journal reads the day again after a successful sign-in.
- Local storage in one SQLite file, `fujin.db` (Memory and send links), Android Auto Backup limited to that file, sessions in secure storage.
- Theme generated from design tokens, French and English copy through gen-l10n, tests for the comparison, storage, the Journal, the welcome screen and both sign-ins.

Planned: the splash screen, the send flow and updates (the send button is shown disabled with its label), undo, Mémoire, Réglages, Scanner, the manual backup file, and the partial Journal that keeps MyFitnessPal readable when only the Ekklo read fails (today a failure on either side shows the problem card).

## Build and run

Requires Flutter 3.44.9 (Dart 3.12.2) and an Android device or emulator.

```sh
flutter pub get
flutter test
flutter run
```

Base URIs can be redirected to local fake servers with `--dart-define`; see [AGENTS.md](AGENTS.md#running-without-real-accounts).

To try the app on your own accounts without changing them, run it read-only:

```sh
flutter run --dart-define=FUJIN_ENV=dev
```

Reads and sign-in work; every other request to MyFitnessPal or Ekklo is stopped on the phone ([ADR 0017](docs/adr/0017-read-only-dev-environment.md)).

## Documentation

- [AGENTS.md](AGENTS.md): commands, layers, where code goes, working rules.
- [GLOSSARY.md](GLOSSARY.md): glossary of domain terms and screen codes.
- [docs/adr/](docs/adr/README.md): architecture decision records.

## Third-party notices

- Fonts: Inter and Hina Mincho, from Google Fonts, under the SIL Open Font License; see `assets/fonts/inter/OFL.txt` and `assets/fonts/hinamincho/OFL.txt`.
- Agent skills vendored from Matt Pocock's skills repository (github.com/mattpocock/skills) under the MIT license; see `.agents/skills/THIRD_PARTY.md`.
