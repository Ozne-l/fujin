# 51. Worktrees, pull requests and releases

Date: 2026-11-21

## Status

Accepted (worktree script, CI and release workflows built; ruleset on `main`, release key and first release not done yet).

## Context

The owner wants several agents working on Fūjin at once, each on its own task. One checkout cannot hold several branches, and two agents editing the same files would step on each other. Nothing checked `main` from a clean machine: `.omp/extensions/dart-checks/` checks an agent's turn on the files it changed, not a rebase resolved by hand nor the whole suite. Builds for the owner's Pixel 8 were made on his Mac and installed with `adb`; the production app (0.5.0 on 2026-11-21) is signed with the Mac's debug key, the same one that signs Fūjin DEV. The project is personal: the whole setup must cost nothing.

`Ozne-l/fujin` and its git dependencies are public. GitHub Actions is free on standard GitHub-hosted runners for public repositories (docs.github.com, "Billing and usage"), and GitHub Releases have no storage charge. A pull request that is up to date and passes the required checks can also be merged locally and pushed (docs.github.com, "Troubleshooting required status checks").

## Decision

- **One task, one worktree.** `tool/worktree.sh new <task>` creates the branch `<task>` from `origin/main` in `~/Dev/fujin.worktrees/<task>`, outside the repo so that `dart analyze`, `flutter test` and `dart-checks` in the main checkout never walk into it. It then links `.fvm/flutter_sdk` to the SDK pinned in `.fvmrc` ([ADR 0040](0040-flutter-sdk-per-project.md)), runs `direnv allow`, `flutter pub get` and `bun install` for the pair programmer. `tool/worktree.sh rm <task>` revokes direnv, removes the worktree (refusing one with uncommitted changes) and deletes the local branch once its pull request is merged; GitHub deletes the pushed branch at the merge.
- **Changes reach `main` through a pull request.** A ruleset on `main` requires the CI checks, a branch up to date with `main`, a linear history and rebase merges only, with no bypass, the owner included. Agents push and open a pull request only when the owner asks, as for commits. Pull requests carry code, not specs: specs stay ADRs.
- **CI** (`.github/workflows/ci.yml`) runs on every pull request to `main` and every push to `main`, on `ubuntu-latest` with the SDK read from `.fvmrc`:
  - `checks`: `flutter pub get --enforce-lockfile`, the generators (`build_runner`, `gen-l10n`, `tool/generate_tokens.dart`) followed by a check that nothing changed, `dart analyze --fatal-infos`, `dart format --set-exit-if-changed` on the folders `AGENTS.md` lists, `flutter test`.
  - `android`: a debug APK of each flavor, for the Gradle, manifest and plugin changes the tests cannot see.
  - Both workflows set `GIT_LFS_SKIP_SMUDGE=1`, as on the owner's Mac, which has no git-lfs: the fork of `liquid_glass_renderer` keeps example images in Git LFS that the package does not use, and their download fails on the runners with an authorization error.
  - The glass benchmark (it needs the owner's phone) and the overlap check (it reads a folder on the owner's Mac) stay local. No `--dart-define`, no credentials: the tests use `FakeBackends`.
- **A version bump on `main` publishes a release.** `.github/workflows/release.yml` runs when `pubspec.yaml` changes on `main`; if the tag `v<MAJOR.MINOR.PATCH>` does not exist yet, it builds `flutter build apk --release --flavor production`, checks that the APK is signed with the release certificate, and publishes the GitHub Release `v<version>` with `fujin-<version>.apk`. The bump keeps its own commit ([ADR 0039](0039-app-version.md)), now in its own pull request.
- **The production release has its own key.** A new keystore, kept by the owner outside GitHub and given to the release workflow through secrets (`ANDROID_RELEASE_KEYSTORE` in base64, `ANDROID_RELEASE_STORE_PASSWORD`, `ANDROID_RELEASE_KEY_ALIAS`, `ANDROID_RELEASE_KEY_PASSWORD`) and the repository variable `ANDROID_RELEASE_CERT_SHA256`. Gradle reads it from `android/key.properties` (ignored by git), which the workflow writes. Without that file the production flavor signs with the debug key, so `flutter run --release` keeps working locally. Fūjin DEV and every debug and profile build keep the debug key.
- **The Pixel installs releases with Obtainium**, an open-source Android app that follows the GitHub Releases of `Ozne-l/fujin`.
- **Cost stays at zero.** The repository stays public; the owner sets a $0 Actions budget that stops usage at the limit.

## Consequences

- Several agents work side by side, each in its own worktree with its own `build/` and `.dart_tool/`; a worktree is removed once its pull request is merged, for disk space.
- With branches required to be up to date, the second of two parallel pull requests is rebased and checked again before it merges: two branches green on their own cannot break `main` together. The rebase is where clashes show: a second migration appended to `schemaMigrations`, two ADRs with the same number, `GLOSSARY.md`, the `.arb` files, `pubspec.lock`. Generated files in conflict are regenerated, never merged by hand.
- The release APK is public: anyone can download and install it with their own accounts. It holds no credential (`lib/app/config.dart` holds URIs only); updating the owner's app needs the release key.
- Moving the Pixel to the release key is a one-off: Android refuses an update signed with another key. The owner exports the backup file from the 0.5.0 app ([ADR 0021](0021-backup-file.md)) and copies it to the Mac, uninstalls the app, installs the first release through Obtainium, imports the file and compares a new export with the first. The backup file brings back Memory, entries with their links, waiting send links and goals; settings, both sign-ins, waiting unattended items and recent foods are lost, which the owner accepted. Auto Backup cannot help: on the emulator (2026-11-21), a backup of the debug-signed app restored into the same app signed with another key was refused with "Restore manifest signatures do not match installed application".
- Losing the release key means another uninstall: the owner keeps a copy outside GitHub, which never shows a secret again.
