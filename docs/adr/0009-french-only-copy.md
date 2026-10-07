# 9. French-only copy

Date: 2026-10-07

## Status

Accepted

## Context

Fūjin has one user, who reads French, and the Figma texts are written in French. Strings must still stay out of widgets so they can be checked against the mockups in one place, and plurals ("1 aliment", "9 aliments") must be correct.

## Decision

- All user-facing text lives in `lib/l10n/app_fr.arb`, the only ARB file, and matches the Figma texts word for word.
- Flutter gen-l10n (`l10n.yaml`, `generate: true` in `pubspec.yaml`) writes `AppLocalizations` into `lib/l10n/generated/`, committed. `preferred-supported-locales: [fr]` and `nullable-getter: false`.
- Plurals and number or date formats use ICU messages in the ARB (`sendAndUpdateFoods`, `kilocalories`, `journalDay`).
- Widgets call `AppLocalizations.of(context)`; notifiers never do ([0006](0006-riverpod-notifiers-as-presenters.md)).
- Run `flutter gen-l10n` (or any `flutter run` / `flutter test`) after editing the ARB.

Source: Flutter docs (docs.flutter.dev), "Internationalizing Flutter apps".

## Consequences

- Adding a language later is one more ARB file, no widget change.
- Docs and code are in English while the UI is French; docs quote French strings verbatim.
