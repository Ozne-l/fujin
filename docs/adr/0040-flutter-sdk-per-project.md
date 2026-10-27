# 40. Flutter SDK per project

Date: 2026-10-22

## Status

Accepted.

## Context

Fūjin moves to Flutter 3.47.7 ahead of `liquid_glass_renderer` 1.0, which needs Flutter 3.47 and Dart `>=3.13.0 <3.14.0`. The owner's machine has one Flutter SDK, `/usr/local/flutter`, on the `PATH`, and another of his projects builds with it. That project pins Flutter 3.44.9 in its CI and runs plain `flutter`, but its pubspec only bounds Dart: moving the shared SDK to 3.47.7 would put it on a Flutter its CI does not build, with no error. Fūjin pins Flutter exactly in `pubspec.yaml`, so a wrong SDK fails at `flutter pub get`.

## Decision

- `/usr/local/flutter` stays on the version that other project pins; Fūjin never checks out, upgrades or switches channel there.
- Fūjin pins its SDK in `.fvmrc`; fvm installs it in `~/fvm/versions/` and links it as `.fvm/flutter_sdk` (ignored by git).
- `.envrc` puts `.fvm/flutter_sdk/bin` first on the `PATH` through direnv, so plain `flutter` and `dart` inside the repo run Fūjin's SDK; the commands in `AGENTS.md` stay as they are.
- `.omp/extensions/dart-checks/` runs its checks through `direnv exec`, so they use Fūjin's SDK whatever `PATH` omp started with.
- `.vscode/settings.json` points `dart.flutterSdkPath` at the fvm SDK; Android Studio's Flutter SDK path (in the untracked `.idea/`) is set by hand to `.fvm/flutter_sdk`.
- Nothing goes through `flutter config`: its settings file is shared by every SDK on the machine. Engine flags such as Flutter GPU go in `AndroidManifest.xml` and `Info.plist`.
- A Flutter upgrade changes `.fvmrc` (`fvm use <version>`) and the `flutter:` pin in `pubspec.yaml` together.

## Consequences

- Fūjin and the owner's other projects change Flutter version independently.
- After cloning: `brew install fvm direnv`, the direnv hook in the shell, `fvm install`, `direnv allow`.
- Tools that read `PATH` at launch (the Dart MCP server, an IDE started from the Dock) get Fūjin's SDK only when started from a shell inside the repo; otherwise they get `/usr/local/flutter` and `flutter pub get` fails on the pin.
- `~/.pub-cache` and `~/.gradle` stay shared; both key their content by version.
