# 15. French and English copy

Date: 2026-10-07

## Status

Accepted. Supersedes [0009](0009-french-only-copy.md).

## Context

[0009](0009-french-only-copy.md) kept one French ARB file because the only user reads French. The repository is public and part of the owner's portfolio, so a reader running the app on an English device should see English. The Figma texts stay in French and remain the reference wording.

## Decision

- User-facing text lives in two ARB files: `lib/l10n/app_fr.arb`, the template, which matches the Figma texts word for word and carries every placeholder definition, and `lib/l10n/app_en.arb`, its English translation with the same keys.
- The app follows the device language. `preferred-supported-locales: [fr]` in `l10n.yaml` makes French the fallback for any other language.
- A new string is added to both files in the same change; both files keep the same keys.
- Everything else from [0009](0009-french-only-copy.md) still holds: gen-l10n output in `lib/l10n/generated/`, ICU plurals and formats, `AppLocalizations` called from widgets only.
- Widget tests pin the French locale (`localesTestValue` in `test/pages/journal_page_test.dart`) and assert on French text, the language the owner uses.

Source: Flutter docs (docs.flutter.dev), "Internationalizing Flutter apps".

## Consequences

- Every copy change costs a translation. English wording is Fūjin's own; it has no Figma reference.
- Abbreviations differ per language: the macro line reads "P · G · L · F" in French and "P · C · F · Fi" in English.
