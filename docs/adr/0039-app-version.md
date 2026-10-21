# 39. App version

Date: 2026-10-22

## Status

Accepted.

## Context

`pubspec.yaml` stayed at `0.1.0+1` from the first commit, through the dark theme, the liquid glass and the barcode scanner. Réglages shows the version (`Fūjin · 0.1.0`, from `package_info_plus`), so two builds of very different code read the same, and Android cannot tell an update from a reinstall by its version code.

## Decision

- The version in `pubspec.yaml` is `MAJOR.MINOR.PATCH+BUILD`; Flutter turns it into `versionName` / `versionCode` on Android and `CFBundleShortVersionString` / `CFBundleVersion` on iOS.
- Before 1.0: a commit set that adds a feature raises MINOR and resets PATCH (`0.2.0`); one that only fixes raises PATCH (`0.2.1`).
- BUILD goes up by one with every version change and never goes down, so each installed build has a higher Android version code than the one before.
- The bump is its own commit, `chore(release): <version>`, on top of the commits it covers.
- `0.2.0+2` covers the dark theme and the Apparence setting, the liquid glass controls, the progressive blur and the bounce.

## Consequences

- Réglages tells two builds apart.
- `test/support/pump_fujin.dart` keeps its own `appVersion`: the tests check the "Fūjin · version" line, not the pubspec.
