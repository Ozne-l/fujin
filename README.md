# Fūjin

Fūjin is a personal Android app, built with Flutter, that copies its owner's MyFitnessPal food diary into Ekklo, the nutrition app his coach follows. For each day it reads both services, shows which MyFitnessPal entries are already in Ekklo ("Dans Ekklo"), which still have to go ("À envoyer") and which changed after being sent ("À mettre à jour"), and, once the send flow exists, writes them to Ekklo. The interface is in French.

## Status

Works today:

- The Journal (`lib/pages/journal/journal_page.dart`): week band, day card with MyFitnessPal and Ekklo energy and the Ekklo progress bar, meals with a status per entry and "N/M dans Ekklo", pull to refresh with the "Rien de nouveau" snackbar, re-read on return to the foreground.
- The day comparison (`lib/domain/comparison/compare_day.dart`): statuses recomputed from both services, adoption of items already in Ekklo, edited entries detected through orphan links.
- Local storage in one SQLite file, `fujin.db` (Memory and send links), Android Auto Backup limited to that file, sessions in secure storage.
- Theme generated from design tokens, French copy through gen-l10n, tests for the comparison, storage and Journal screen.

Planned: sign-in screens (Ekklo login, MyFitnessPal web view), the send flow and updates (the send button is shown disabled with its label), undo, Mémoire, Réglages, Scanner, the manual backup file, and the partial Journal that keeps MyFitnessPal readable when only the Ekklo read fails (today a failure on either side shows the problem card).

## Build and run

Requires Flutter 3.44.9 (Dart 3.12.2) and an Android device or emulator.

```sh
flutter pub get
flutter test
flutter run
```

Base URIs can be redirected to local fake servers with `--dart-define`; see [AGENTS.md](AGENTS.md#running-without-real-accounts).

## Documentation

- [AGENTS.md](AGENTS.md): commands, layers, where code goes, working rules.
- [GLOSSARY.md](GLOSSARY.md): glossary of domain terms and screen codes.
- [docs/adr/](docs/adr/README.md): architecture decision records.

## Third-party notices

- Fonts: Inter and Hina Mincho, from Google Fonts, under the SIL Open Font License; see `assets/fonts/inter/OFL.txt` and `assets/fonts/hinamincho/OFL.txt`.
- Agent skills vendored from Matt Pocock's skills repository (github.com/mattpocock/skills) under the MIT license; see `.agents/skills/THIRD_PARTY.md`.
