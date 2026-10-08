# Working in Fūjin

Fūjin is a Flutter Android app that copies the owner's MyFitnessPal diary into Ekklo. Read `GLOSSARY.md` for the vocabulary and `docs/adr/` for the decisions before changing behaviour. This file is for coding agents.

## Commands

Run `flutter` and `dart` directly (Flutter 3.44.9, Dart 3.12.2).

| When | Command |
| --- | --- |
| After a pubspec change | `flutter pub get` |
| After changing a `@MappableClass` / `@MappableEnum` | `dart run build_runner build` |
| After editing `lib/l10n/app_fr.arb` | `flutter gen-l10n` |
| After editing `design/tokens/fujin.tokens.json` | `dart run tool/generate_tokens.dart` |
| Before handing work back | `dart analyze --fatal-infos` |
| Before handing work back | `dart format lib test tool` |
| Before handing work back | `flutter test` |

Generated files (`*.mapper.dart`, `lib/l10n/generated/`, `lib/app/theme/fujin_tokens.g.dart`) are committed; regenerate, never hand-edit.

## Running without real accounts

Never point a run or a test at the owner's real MyFitnessPal or Ekklo accounts. The base URIs come from `--dart-define` (`lib/app/config.dart`) and default to the real services:

```sh
flutter run \
  --dart-define=MFP_WEB_URI=http://10.0.2.2:<port> \
  --dart-define=MFP_API_URI=http://10.0.2.2:<port> \
  --dart-define=EKKLO_BASE_URI=http://10.0.2.2:<port>
```

`10.0.2.2` is the host machine as seen from the Android emulator. Debug builds allow cleartext HTTP (`android/app/src/debug/AndroidManifest.xml`); release builds do not. Tests never need a server: they use `FakeBackends` (`test/support/fake_backends.dart`).

## Layers

Dependencies point down only ([ADR 0013](docs/adr/0013-layers.md)):

```
lib/app/      bootstrap, router, providers, theme
lib/pages/    screens, notifiers (presenters), widgets
lib/domain/   rules (pure) and services (I/O around them)
lib/data/     SQLite, repositories, session stores
clients       package:ekklo_client, package:myfitnesspal_client
```

## Where things go

| Thing | Place | Example |
| --- | --- | --- |
| Injection provider | `lib/app/providers.dart` | `journalServiceProvider` |
| Route | `FujinRoute` + `lib/app/router.dart` | `FujinRoute.journal` |
| Screen and its presenter | `lib/pages/<screen>/` | `journal_page.dart`, `journal_notifier.dart` |
| Widget shared by screens | `lib/pages/common/` | `progress_bar.dart` |
| Pure rule | `lib/domain/<area>/` | `compare_day.dart` |
| Use case doing I/O | `lib/domain/<area>/*_service.dart` | `journal_service.dart` |
| Table change | append a script to `schemaMigrations` | `lib/data/database/schema.dart` |
| Repository (one per aggregate) | `lib/data/<aggregate>/` | `sent_link_repository.dart` |
| User-facing text | `lib/l10n/app_fr.arb` (template, Figma wording) and `lib/l10n/app_en.arb` | `nothingNewTitle` |
| Colour, size, text style | design tokens, then the generator | `FujinColorRole.textPrimary` |
| Animation | `motor` preset in `lib/app/theme/fujin_motion.dart` | `FujinMotion.progress` |
| Icon or image exported from Figma | `assets/icons/` (SVG, `currentColor`) or `assets/images/` with `2.0x/` to `4.0x/` variants | `volute.svg`, `seigaiha.png` |
| Test helpers | `test/support/` | `fixtures.dart`, `fake_backends.dart` |

One public type per file, named after the file. Code style: no comments, no `!`, no magic strings, `switch` over if-chains (exhaustive on sealed types), `null` for absence ([ADR 0014](docs/adr/0014-lints-and-code-style.md)).

## Skills

Project skills in `.agents/skills/` (also reachable as `.claude/skills/`):

- `fujin-dialect`: Dart and Flutter house style, models, theme tokens, app copy. Load before writing any Dart.
- `fujin-state`: Riverpod providers, notifiers as presenters, injection, one-shot UI effects, hooks.
- `fujin-storage`: `fujin.db`, migrations, repositories, Auto Backup, where sessions live.
- `fujin-tests`: what to test and what to fake, fixtures, `FakeBackends`, `package:checks`.

The other skills in `.agents/skills/` are vendored from a third party under MIT; `.agents/skills/THIRD_PARTY.md` lists them with source and commit. Do not edit them.

## Agent skills

### Issue tracker

Issues and specs are GitHub issues on `Ozne-l/fujin`, handled with `gh`. See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: `GLOSSARY.md` and `docs/adr/` at the root. See `docs/agents/domain.md`.

## Agent harness (`.omp/`)

- `.omp/extensions/dart-checks/`: when a turn ends after any `.dart` file under `lib/`, `test/` or `tool/` changed, runs `dart analyze --fatal-infos`, `dart format --set-exit-if-changed` on the changed files and `flutter test` on every test whose imports reach them, reports each result, and refuses to end the turn until all pass.
- `.omp/extensions/pair-programmer/`: pins `pi-pair-programmer`; run `bun install` in that folder once.
- `.omp/WATCHDOG.yml`: an optional advisor that reviews each finished run against ADRs 0001, 0004, 0013 (repository per aggregate, pure domain functions, no duplication).

## Working rules

- Talk to the owner in French by default; follow him if he switches to English. Conclusion first, then evidence; mark anything unverified.
- Code, file names, docs, issues and commits are in English; French appears only in `lib/l10n/app_fr.arb` and in verbatim quotes of the app copy ([ADR 0016](docs/adr/0016-english-in-code-and-tokens.md)). If you find French anywhere else, tell the owner and let him decide; do not rename on your own.
- Never call the real MyFitnessPal or Ekklo accounts. When a question needs the real APIs, write a read-only probe and let the owner run it and paste the output.
- Never print, log, commit or paste credentials, tokens or cookies.
- Commit only when asked. Conventional Commits, no emoji, no AI attribution.
- Commit hooks block commit, push and rebase Monday to Friday, 09:30 to 18:30. Never bypass a hook with `--no-verify`.
- The pre-commit hook runs a local overlap check; reword anything it flags in text you wrote.
- Scratch files go in `/tmp`, never in the repo.
- Update `GLOSSARY.md` when a domain word changes, and add an ADR in `docs/adr/` for a new decision.
