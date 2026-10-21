# Working in Fūjin

Fūjin is a Flutter app, tested on Android with an iOS project ready, that copies the owner's MyFitnessPal diary into Ekklo. Read `GLOSSARY.md` for the vocabulary and `docs/adr/` for the decisions before changing behaviour. This file is for coding agents.

## Commands

Run `flutter` and `dart` directly (Flutter 3.44.9, Dart 3.12.2).

| When | Command |
| --- | --- |
| After a pubspec change | `flutter pub get` |
| After changing a `@MappableClass` / `@MappableEnum` | `dart run build_runner build` |
| After editing `lib/l10n/app_fr.arb` | `flutter gen-l10n` |
| After editing a file in `design/tokens/` | `dart run tool/generate_tokens.dart` |
| Before handing work back | `dart analyze --fatal-infos` |
| Before handing work back | `dart format lib test tool` |
| Before handing work back | `flutter test` |

Generated files (`*.mapper.dart`, `lib/l10n/generated/`, `lib/app/theme/fujin_tokens.g.dart`) are committed; regenerate, never hand-edit.

## Running without real accounts

Never point a run or a test at the owner's real MyFitnessPal or Ekklo accounts. The base URIs come from `--dart-define` (`lib/app/config.dart`) and default to the real services:

```sh
flutter run --flavor production \
  --dart-define=MFP_WEB_URI=http://10.0.2.2:<port> \
  --dart-define=MFP_API_URI=http://10.0.2.2:<port> \
  --dart-define=MFP_SYNC_URI=http://10.0.2.2:<port> \
  --dart-define=EKKLO_BASE_URI=http://10.0.2.2:<port>
```

Every build and run names a flavor, `production` or `dev`; a build without one throws at startup. The dev flavor is a second app (`dev.oznel.fujin.dev`, "Fūjin DEV") that the owner runs on his real accounts in read-only mode ([ADR 0017](docs/adr/0017-read-only-dev-environment.md)): reads, sign-in and the barcode lookup go through, every other write is stopped in `ReadOnlyHttpClient` (`lib/data/http/read_only_http_client.dart`). That app is for the owner; agents still use fake servers, and may run `--flavor dev` against them to check the guard.

`10.0.2.2` is the host machine as seen from the Android emulator; on the iOS simulator use `127.0.0.1`. Debug builds allow cleartext HTTP (`android/app/src/debug/AndroidManifest.xml`); release builds do not. Tests never need a server: they use `FakeBackends` (`test/support/fake_backends.dart`).

## Layers

Dependencies point down only ([ADR 0013](docs/adr/0013-layers.md)):

```
lib/app/      bootstrap, router, providers, theme
lib/pages/    screens, notifiers (presenters), widgets
lib/domain/   rules (pure) and services (I/O around them)
lib/data/     SQLite, repositories, session stores, the dev write guard
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
| Colour, size, text style | design tokens (light and dark), then the generator; colours read from the theme | `context.colors.textPrimary` |
| Animation | `motor` preset in `lib/app/theme/fujin_motion.dart` | `FujinMotion.progress` |
| Liquid glass look | the `FujinGlass` presets in `lib/app/theme/fujin_glass.dart` (`floating` for the plate and drops, `lens` for the tab lens, `control` for buttons, search fields and filters), matched to the owner's Instagram recordings ([ADR 0033](docs/adr/0033-liquid-glass-and-fade-through.md)); a glass control is a `FujinGlassButton` inside a `GlassLayer`; a text button, search field or filter takes a `GlassFill` with a `GlassFinish` (`clear`, `ink` or a tint), which the theme already gives every `FilledButton` and `OutlinedButton` (`FujinTheme.floatingButtonStyle` for a pinned ink button, `GlassSearchField` for a search field; `GlassBody` draws the glass of both `GlassFill` and `GlassSurface`, and `LensSwell` swells the lens of the tab bar, switch and segments) ([ADR 0036](docs/adr/0036-glass-on-buttons-search-and-filters.md)) | `FujinGlass.floating`, `GlassFill.style` |
| List scrolling under a fixed header | `ScrollEdgeBlur` around the list (`cover` = what stays fixed over it), or an `EdgeBlur` behind a pinned header; never a `ShaderMask` over glass ([ADR 0037](docs/adr/0037-progressive-blur-under-fixed-headers.md)) | `ScrollEdgeBlur(cover: …)` |
| Icon or image exported from Figma | `assets/icons/` (SVG, `currentColor`) or `assets/images/` with `2.0x/` to `4.0x/` variants | `volute.svg`, `seigaiha.png` |
| App icon | the Figma component "Logo · Fūjin", rendered to `android/app/src/{main,dev}/res/mipmap-*/` (legacy icon and adaptive layers, `mipmap-anydpi-v26/ic_launcher.xml`) and `ios/Runner/Assets.xcassets/AppIcon{,-dev}.appiconset/` | `ic_launcher_foreground.png` |
| Test helpers | `test/support/` | `fixtures.dart`, `fake_backends.dart` |

One public type per file, named after the file. Code style: no comments, no `!`, no magic strings, `switch` over if-chains (exhaustive on sealed types), `null` for absence ([ADR 0014](docs/adr/0014-lints-and-code-style.md)).

## Skills

Project skills in `.agents/skills/` (also reachable as `.claude/skills/`):

- `fujin-dialect`: Dart and Flutter house style, models, theme tokens, app copy. Load before writing any Dart.
- `fujin-state`: Riverpod providers, notifiers as presenters, injection, one-shot UI effects, hooks.
- `fujin-storage`: `fujin.db`, migrations, repositories, Auto Backup, where sessions live.
- `fujin-tests`: what to test and what to fake, fixtures, `FakeBackends`, `package:checks`.
- `fujin-review`: the owner's review before a push (regressions against `origin/main`, bugs, duplication, AI slop, divergence, conventions), run only when he types `/fujin-review` (`.agents/commands/fujin-review.md` gives omp the same name).

The other skills in `.agents/skills/` are vendored from a third party under MIT; `.agents/skills/THIRD_PARTY.md` lists them with source and commit. Do not edit them.

## Agent skills

### Issue tracker

No issue tracker: specs are ADRs in `docs/adr/`, and no GitHub issue is opened. See `docs/agents/issue-tracker.md`.

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
